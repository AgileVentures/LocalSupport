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
    return nil unless content? from_response
    persist_doit opportunities(from_response)
    request_next_page from_response
  end

  def parse response
    JSON.parse(response.body)
  end

  def opportunities response
    parse(response)['data']['items']
  end

  def request_next_page response
    parse(response)['links'].fetch('next', 'href' => nil)['href']
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
    trace_handler.local_origin?(op['id']) || outside_harrow?(op)
  end

  def outside_harrow? op
    !op['locations'][0]['local_authority']['name'].downcase.include? 'harrow'
  end

  def populate_vol_op_attributes model, op
    location = Location.new longitude: op['lng'], latitude: op['lat']
    model.source        = 'doit'
    model.latitude      = location.latitude
    model.longitude     = location.longitude
    model.title         = op['title']
    model.description   = op['description']
    model.doit_op_id    = op['id']
    model.doit_org_name = op['for_recruiter']['name']
    model.doit_org_link = op['for_recruiter']['slug']
    model.updated_at    = op['updated']
    model.created_at    = op['created']
    model.imported_at   = Time.current
    model
  end

  def content? response
    response.body && response.body != '[]'
  end

end
