RSpec::Matchers.define :have_coordinates do |_expected|
  match do |actual|
    expect(actual.longitude).not_to be nil
    expect(actual.latitude).not_to be nil
  end

  failure_message do |actual|
    "expected that #{actual} would have longitude and latitude values"
  end
end
