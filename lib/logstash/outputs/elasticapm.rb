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

  config :otlp_type, :validate => :string, :requried => true

  config :api_key, :validate => :string, :required => true

  config :base64_encoded_proto_field, :validate => :string, :default => "$..data"

  public
  def register
   @uri = "#{@apm_server_uri}/v1/#{@otlp_type}"
  end # def register

  public
  def receive(event)
    begin
      json = event.to_json
      #puts json
      headers = {}
      headers['Content-Type'] = 'application/x-protobuf'
      headers['Authorization'] = "ApiKey #{@api_key}"
      #puts @uri
      #puts headers
      results = JsonPath.new(@base64_encoded_proto_field).on(json)
      #puts results
      results.each do |item|
        #puts item
        requestBody = Base64.decode64(item)
        #puts requestBody
        response = RestClient.post(@uri, requestBody, headers)
        #puts response.code
        #puts response.body
        #puts response.headers
        unless response.code == 200
          puts "Elastic APM request failure: error code: #{response.code}, data=>#{event}"
          @logger.error("Elastic APM request failure: error code: #{response.code}, data=>#{event}")
        end
      end
    rescue Exception => ex
      puts "Exception occurred in posting to Elastic APM Server: '#{ex}', data=>#{event}"
      @logger.error("Exception occurred in posting to Elastic APM Server: '#{ex}', data=>#{event}")
    end
  end # def event
end # class LogStash::Outputs::Elasticapm
