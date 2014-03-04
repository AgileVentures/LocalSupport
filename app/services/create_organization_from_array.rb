class CreateOrganizationFromArray

  def self.create(organization_repository, row, validate)
    new(organization_repository, row).create(validate)
  end

  def initialize(organization_repository, row)
    @organization_repository = organization_repository
    @row = row
    @csv_organization = CSVOrganization.new(row)
  end

  def create(validate)
    return nil if @csv_organization.is_organization_removed? 
    return nil if organization_already_exists?
    @organization_repository.create_and_validate(
      name:@csv_organization.organization_name,
      address: @csv_organization.capitalize_address,
      description: @csv_organization.description ,
      postcode: @csv_organization.postcode,
      website: @csv_organization.website ,
      telephone: @csv_organization.telephone)
  end

  private
  def organization_already_exists?
    @organization_repository.find_by_name(@csv_organization.organization_name) != nil
  end
end

class CSVOrganization
  def initialize(row)
    @row = row
  end

  def is_organization_removed?
    @row[mappings[:date_removed]] != nil
  end

  def organization_name
    FirstCapitalsHumanizer.call(@row[mappings[:name]])
  end

  def description 
    DescriptionHumanizer.call((@row[mappings[:description]]))
  end

  def website 
    @row[mappings[:website]]
  end

  def telephone 
    @row[mappings[:telephone]]
  end

  def capitalize_address 
    FirstCapitalsHumanizer.call(address[:address])
  end

  def postcode
    address[:postcode]
  end

  private 
  def address 
    Address.new(@row[mappings[:address]]).parse
  end

  def mappings
    CSVHeader.build.names.each_value do |column_name|
      unless @row.header?(column_name)
        raise CSV::MalformedCSVError, "No expected column with name #{column_name} in CSV file"
      end
    end
  end
end

