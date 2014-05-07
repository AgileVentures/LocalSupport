require_relative '../../lib/local_support/route_collector'

describe RouteCollector, :helpers => :route_collector do

  # Demo the module in the context of a contrived controller and route
  let(:actions) { collect_actions_for(FakeController) }

  class FakeController < ApplicationController
    def custom
      render :text => 'custom called'
    end
  end

  before { Rails.application.routes.draw { post 'custom/:id' => 'fake#custom' } }
  after { Rails.application.reload_routes! } # https://github.com/rspec/rspec-rails/issues/817



  describe '#collect_actions_for' do
    subject { actions }

    it { should be_a Hash }

    describe 'info collected for FakeController#custom' do
      subject { actions[:custom] }

      it { should be_a(RouteCollector::Request) }

      it { should respond_to(:controller, :action, :verb, :parts, :params, :add_params) }

      it '#controller is the controller name' do
        subject.controller.should eq FakeController.controller_name
      end

      it '#action is the collected action' do
        subject.action.should eq 'custom'
      end

      it '#verb is the required HTTP verb' do
        subject.verb.should eq 'post'
      end

      it '#parts are any variables required for the URL' do
        subject.parts.should eq [:id]
      end

      it '#params are a merger of any user-defined params added with #add_params' do
        subject.params.should eq({})
        subject.add_params({hello: 'world'}, {merge: 'me'})
        subject.params.should eq({:hello => 'world', :merge => 'me'})
      end
    end
  end

  describe '#route_request_for' do
    let(:fake) { double :fake_object, id: -1 }
    subject { route_request_for(actions[:custom], fake)}

    it { should be_a RouteCollector::Routable }

    it { should respond_to :verb, :url}

    it '#verb defaults to "get" if nil' do
      actions[:custom].should_receive(:verb) { nil }
      subject.verb.should eq 'get'
    end

    it '#url is a relative url with the necessary parts and params' do
      subject.url.should eq '/custom/-1'
      actions[:custom].add_params({this: 'rocks'})
      subject = route_request_for(actions[:custom], fake)
      subject.url.should eq '/custom/-1?this=rocks'
    end
  end
end
