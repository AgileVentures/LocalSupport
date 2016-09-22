RSpec::Matchers.define :match_instance_array do |expected|
  match do |actual|
    actual_instances = actual.map do |e|
      e.attributes.except('id').except('created_at').except('updated_at')
    end
    expected_instances = expected.map do |e|
      e.attributes.except('id').except('created_at').except('updated_at')
    end

    expect(actual_instances).to match_array(expected_instances)
  end

  failure_message do |actual|
    "expected that #{actual} would match the array #{expected}"
  end
end
