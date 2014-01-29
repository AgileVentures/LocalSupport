require 'spec_helper'

describe "orphans/index.html.erb" do

  it "should display a generate user button" do
    render
    rendered.should_have content "Generate User"
  end

end