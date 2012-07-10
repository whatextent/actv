require 'spec_helper'

describe Active do

  after do
    Active.reset!
  end

  context "when delegating to a client" do
      
    before do
      stub_get("/v2/assets/BA288960-2718-4B20-B380-8F939596BB59.json").
      to_return(body: fixture("BA288960-2718-4B20-B380-8F939596BB59.json"), headers: { content_type: "application/json; charset=utf-8" })
    end

    it "requests the correct resource" do
      Active.asset('BA288960-2718-4B20-B380-8F939596BB59')
      a_get("/v2/assets/BA288960-2718-4B20-B380-8F939596BB59.json").should have_been_made
    end

    it "returns the same results as a client" do
      Active.asset('BA288960-2718-4B20-B380-8F939596BB59').should eq Active::Client.new.asset('BA288960-2718-4B20-B380-8F939596BB59')
    end

  end

  describe '.respond_to?' do
    it "delegates to Active::Client" do
      Active.respond_to?(:asset).should be_true
    end

    it "takes an optional argument" do
      Active.respond_to?(:asset, true).should be_true
    end
  end

  describe ".client" do
    it "returns a Active::Client" do
      Active.client.should be_a Active::Client
    end
  end

  describe ".configure" do
    Active::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Active.configure do |config|
          config.send("#{key}=", key)
        end
        Active.instance_variable_get("@#{key}").should eq key
      end
    end
  end

  Active::Configurable::CONFIG_KEYS.each do |key|
    it "has a default #{key.to_s.gsub('_', ' ')}" do
      Active.send(key).should eq Active::Default.options[key]
    end
  end

end