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

  def names
    @header_names
  end

  def method_missing(name, *args)
    return names[name.to_s] if names.key?(name.to_s)
    return names[name.to_sym] if names.key?(name.to_sym)
    super
  end
end
