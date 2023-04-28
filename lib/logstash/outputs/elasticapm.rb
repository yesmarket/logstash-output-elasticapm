# encoding: utf-8
require "logstash/outputs/base"

# An elasticapm output that does nothing.
class LogStash::Outputs::Elasticapm < LogStash::Outputs::Base
  config_name "elasticapm"

  public
  def register
  end # def register

  public
  def receive(event)
    return "Event received"
  end # def event
end # class LogStash::Outputs::Elasticapm
