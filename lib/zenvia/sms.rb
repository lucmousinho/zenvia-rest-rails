module Zenvia
  class Sms
    include Base

    attr_accessor :id_sms, :msg, :cel_phone, :schedule_date, :aggregate_id, :status_code

    def initialize(id_sms, msg, cel_phone, schedule_date = "", aggregate_id = "")
      @id_sms    = id_sms
      @msg       = msg
      @cel_phone = cel_phone
      @aggregate_id = aggregate_id
      @schedule_date = schedule_date
      #Try to convert datetime to string
      begin
        @schedule_date = schedule_date.strftime("%Y-%m-%dT%H:%M:%S") if !schedule_date.blank?
      rescue
      end
    end

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

    def send
      response = send_to_zenvia(@id_sms, @cel_phone, @msg, @schedule_date, @aggregate_id)
      self.status_code = response["statusCode"].to_i
      response
    end

    def sent?
      status_code < 4
    end
  end
end
