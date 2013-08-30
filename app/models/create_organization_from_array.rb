class CreateOrganizationFromArray

  def initialize(row, mappings)
    @row = row
    @mappings = mappings
  end

  def call(validate)
    check_columns_in
    organization_name = FirstCapitalsHumanizer.call(@row[@mappings[:name]])
    return nil if @row[@mappings[:date_removed]]
if Organization.find_by_name(organization_name)
  puts "here"
    return nil 
end

    org = build_organization_from_array(organization_name)

    org.save! validate: validate
    org
  end

  private
  def check_columns_in
    @mappings.each_value do |column_name|
      unless @row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end

  def build_organization_from_array(organization_name)
    org = Organization.new
    address = Address.new(@row[@mappings[:address]]).parse
    org.name = organization_name
    org.description = humanize_description(@row[@mappings[:description]])
    org.address = FirstCapitalsHumanizer.call(address[:address])
    org.postcode = address[:postcode]
    org.website = @row[@mappings[:website]]
    org.telephone = @row[@mappings[:telephone]]
    return org
  end

end

