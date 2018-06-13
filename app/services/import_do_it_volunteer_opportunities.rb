class ImportDoItVolunteerOpportunities

  def self.with(radius=0.5,
                http = HTTParty,
                model_klass = VolunteerOp,
                trace_handler = DoitTrace)
    new(http, model_klass, radius, trace_handler).send(:run)
  end

  private

  attr_reader :http, :model_klass, :radius, :trace_handler

  def initialize http, model_klass, radius, trace_handler
    @http = http
    @model_klass = model_klass
    @radius = radius
    @trace_handler = trace_handler
  end

  HOST = 'https://api.do-it.org'
  HREF = "/v1/opportunities?lat=51.5978&lng=-0.3370&miles="

  def run
    href = "#{HREF}#{radius}"
    model_klass.where(source: 'doit').delete_all
    while href = process_doit_json_page(http.get("#{HOST}#{href}"));
    end
  end

  def process_doit_json_page from_response
    return nil unless has_content? from_response
    persist_doit opportunities(from_response)
    parse(from_response)['links'].fetch('next', 'href' => nil)['href']
  end

  def parse response
    JSON.parse(response.body)
  end

  def opportunities response
    parse(response)['data']['items']
  end

  def persist_doit opportunities
    opportunities.each do |op|
      next if internally_generated_or_outside_harrow? op
      model_klass.find_or_create_by doit_op_id: op['id'] do |model|
        populate_vol_op_attributes model, op
      end
    end
  end

  def internally_generated_or_outside_harrow? op
    trace_handler.local_origin?(op['id']) || (op['location_name'] != 'Harrow')
  end

  def populate_vol_op_attributes model, op
    model.source        = 'doit'
    model.latitude      = op['lat']
    model.longitude     = op['lng']
    model.title         = op['title']
    model.description   = op['description']
    model.doit_op_id    = op['id']
    model.doit_org_name = op['for_recruiter']['name']
    model.doit_org_link = op['for_recruiter']['slug']
    model.updated_at    = op['updated']
    model.created_at    = op['created']
    model
  end

  def has_content? response
    response.body && response.body != '[]'
  end

end
