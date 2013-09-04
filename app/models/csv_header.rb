class CSVHeader

  def self.build
    new({
      name: 'Title',
      address: 'Contact Address',
      description: 'Activities',
      website: 'website',
      telephone: 'Contact Telephone',
      date_removed: 'date removed',
      cc_id: 'Charity Classification'
    })
  end

  def initialize(header_names)
    @header_names = header_names
  end

  def method_missing(name, *args)
    return @header_names[name.to_s] if @header_names.key?(name.to_s)
    return @header_names[name.to_sym] if @header_names.key?(name.to_sym)
    super
  end
end
