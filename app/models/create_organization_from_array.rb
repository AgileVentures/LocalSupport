class CreateOrganizationFromArray

  def initialize(row)
    @row = row
    @mappings = normalize(CSVHeader.build.names)
  end

  def call(validate)
    return nil if organization_is_removed?
    return nil if organization_already_exists?

    org = build_organization

    org.save! validate: validate
    org
  end

  private

  def organization_name
    @organization_name ||= FirstCapitalsHumanizer.call(@row[@mappings[:name]])
  end

  def organization_is_removed?
    @row[@mappings[:date_removed]] != nil
  end

  def organization_already_exists?
    Organization.find_by_name(organization_name) != nil
  end

  def normalize(mappings)
    mappings.each_value do |column_name|
      unless @row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

  def build_organization
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

