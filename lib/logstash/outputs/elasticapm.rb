# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "rest-client"
require "json"
require "jsonpath"
require "base64"

# An elasticapm output that does nothing.
class LogStash::Outputs::Elasticapm < LogStash::Outputs::Base
  config_name "elasticapm"

  config :apm_server_uri, :validate => :string, :requried => true

  config :api_key, :validate => :password, :required => true

  config :base64_encoded_proto_field, :validate => :string, :default => "$..data"

  public
  def register
    @uri = "#{@apm_server_uri}/v1/traces"
  end # def register

  public
  def multi_receive(events)
    begin
      json = event.to_jsonx
      #puts jsonEvent
      headers = {}
      headers['Content-Type'] = 'application/x-protobuf'
      headers['Authorization'] = "ApiKey #{@api_key}"
      #puts path
      results = JsonPath.new(@base64_encoded_proto_field).on(json)
      #puts results
      results.each do |item|
        #puts item
        requestBody = Base64.decode64(item)
        response = RestClient.post(@uri, requestBody, headers)
        unless response.code == 200
          #puts "Elastic APM request failure: error code: #{response.code}, data=>#{event}"
          @logger.error("Elastic APM request failure: error code: #{response.code}, data=>#{event}")
        end
      end
    rescue Exception => ex
      #puts "Exception occurred in posting to Elastic APM Server: '#{ex}', data=>#{event}"
      @logger.error("Exception occurred in posting to Elastic APM Server: '#{ex}', data=>#{event}")
    end
  end # def event
end # class LogStash::Outputs::Elasticapm
