Given("the following services exist:") do |table|
  table.hashes.each do |service|
    service["organisation"] = Organisation.find_by_name(service["organisation"])
    Service.create! service
  end
end
