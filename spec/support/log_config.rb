RSpec.configure do |config|

  def logger_with_no_output
    logger = double('Logger').as_null_object
    allow(Logger).to receive(:new).and_return(logger)
  end

  config.before do
    logger_with_no_output
  end
end
