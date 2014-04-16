require_relative '../models/csv_organization'

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
