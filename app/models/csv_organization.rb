class CSVOrganisation
  def initialize(row)
    @row = row
  end

  def is_organisation_removed?
    @row[mappings[:date_removed]] != nil
  end

  def organisation_name
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

