class CreateOrganizationFromArray

  def initialize(row, mappings)
    @row = row
    @mappings = mappings
  end

  def call(validate)
    check_columns_in
    return nil if @row[@mappings[:date_removed]]
    return nil if Organization.find_by_name(organization_name)

    org = build_organization(organization_name)

    org.save! validate: validate
    org
  end

  private
  def organization_name
    @organization_name ||= FirstCapitalsHumanizer.call(@row[@mappings[:name]])
  end

  def check_columns_in
    @mappings.each_value do |column_name|
      unless @row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

  def build_organization(organization_name)
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

