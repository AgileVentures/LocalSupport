class ImportDoItVolunteerOpportunities

  def self.with(radius=0.5, http = HTTParty, model_klass = VolunteerOp)
    new(http, model_klass, radius).send(:run)
  end

  private

  attr_reader :http, :model_klass, :radius

  def initialize(http, model_klass, radius)
    @http = http
    @model_klass = model_klass
    @radius = radius
  end

  HOST = 'https://api.do-it.org'
  HREF = "/v1/opportunities?lat=51.5978&lng=-0.3370&miles="

  def run
    href = "#{HREF}#{radius}"
    model_klass.delete_all(source: 'doit')
    while href = process_doit_json_page(http.get("#{HOST}#{href}"));
    end
  end

  def process_doit_json_page(response)
    return nil unless has_content?(response)
    opportunities = JSON.parse(response.body)['data']['items']
    persist_doit_vol_ops(opportunities)
    JSON.parse(response.body)['links'].fetch('next', 'href' => nil)['href']
  end

  def persist_doit_vol_ops(opportunities)
    opportunities.each do |op|
      model_klass.find_or_create_by(doit_op_id: op['id']) do |model|
        model.source = 'doit'
        model.latitude = op['lat']
        model.longitude = op['lng']
        model.title = op['title']
        model.description = op['description']
        model.doit_op_id = op['id']
        model.doit_org_name = op['for_recruiter']['name']
        model.doit_org_link = op['for_recruiter']['slug']
        model.updated_at = op['updated']
      end
    end
  end

  def has_content?(response)
    response.body && response.body != '[]'
  end

end
