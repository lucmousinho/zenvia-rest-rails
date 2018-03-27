# encoding: UTF-8
require 'net/http'
require 'uri'

module Zenvia
  module Base
    ZENVIA_URL_BASE = 'https://api-rest.zenvia360.com.br/services'
    SEND_SMS = '/send-sms'
    LIST_SMS = '/received/list'

    def self.list_received
      url = URI.parse(ZENVIA_URL_BASE + LIST_SMS)

      request = Net::HTTP::Post.new(url.path, initheader =
          {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json'
          })

      request.basic_auth Zenvia.configuration.account, Zenvia.configuration.code

      response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        http.request(request)
      end

      case response
      when Net::HTTPSuccess, Net::HTTPRedirection, Net::HTTPOK
        response = JSON.parse(response.body)
        response["receivedResponse"]["receivedMessages"]
      else
        response.body
      end
    end

    private

    def send_to_zenvia(id_sms, cel_phone, msg, schedule_date, aggregate_id)
      url = URI.parse(ZENVIA_URL_BASE + SEND_SMS)
      
      req = Net::HTTP::Post.new(url.path, initheader = 
        {
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
        })

      req.basic_auth Zenvia.configuration.account, Zenvia.configuration.code

      req.body = {
          "sendSmsRequest":
          {
            "from": Zenvia.configuration.from,
            "to": cel_phone,
            "schedule": schedule_date,
            "msg": msg,
            "callbackOption": Zenvia.configuration.callback_option,
            "id": id_sms,
            "aggregateId": aggregate_id
          }
        }.to_json

      resp = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http| 
        http.request(req)
      end

      case resp
      when Net::HTTPSuccess, Net::HTTPRedirection, Net::HTTPOK
        response = JSON.parse(resp.body)
        response["sendSmsResponse"]
      else
        resp.body
      end
    end
  end
end
