class CreateOrganizationFromArray

  def initialize(row, mappings)
    @row = row
    @mappings = normalize(mappings)
  end

  def call(validate)
    return nil if @row[@mappings[:date_removed]]
    return nil if Organization.find_by_name(organization_name)

    org = build_organization

    org.save! validate: validate
    org
  end

  private
  def organization_name
    @organization_name ||= FirstCapitalsHumanizer.call(@row[@mappings[:name]])
  end

  def normalize(mappings)
    mappings.each_value do |column_name|
      unless @row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

  def build_organization_from_array
    address = Address.new(@row[@mappings[:address]]).parse
    org = Organization.new({
      name:organization_name, 
      address: FirstCapitalsHumanizer.call(address[:address]),
      description: DescriptionHumanizer.call((@row[@mappings[:description]])),
      postcode: address[:postcode],
      website: @row[@mappings[:website]],
      telephone: @row[@mappings[:telephone]]
    })
  end

end

