module WithoutTimestamps
  def self.run
    old = ActiveRecord::Base.record_timestamps
    ActiveRecord::Base.record_timestamps = false
    begin
      yield
    ensure
      ActiveRecord::Base.record_timestamps = old
    end
  end
end
