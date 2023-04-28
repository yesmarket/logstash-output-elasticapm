# encoding: utf-8
require "logstash/devutils/rspec/spec_helper"
require "logstash/outputs/elasticapm"
require "logstash/codecs/plain"


describe LogStash::Outputs::Elasticapm do
  let(:sample_event) { LogStash::Event.new }
  let(:output) { LogStash::Outputs::Elasticapm.new }

  before do
    output.register
  end

  describe "receive message" do
    subject { output.receive(sample_event) }

    it "returns a string" do
      expect(subject).to eq("Event received")
    end
  end
end
