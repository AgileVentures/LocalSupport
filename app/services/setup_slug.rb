class SetupSlug

  def self.run(name)
    return if name.nil?
    new(name).send(:candidates)
  end

  private

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def candidates
    [
        name.method(:short_name),
        name.method(:longer_name),
        name.method(:append_org),
        :name
    ]
  end

end