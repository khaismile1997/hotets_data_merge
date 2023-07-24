module SupplierApi
  class Client
    BASE_URL = Settings.supplier_api.base_url
    SUPPLIERS_NAME = Settings.supplier.name
    class << self
      (1..3).each do |num|
        define_method "get_hotels_info_supplier_#{num}" do
          response = connection.get(SUPPLIERS_NAME[num-1])
          raise ApiError, "An error occurred in Supplier #{num} API" if response.status != 200
          handle_response(response)
        end
      end

      private

      def handle_response(response, is_json: true)
        begin
          body = response.body
          cleaned_data = clean_data(JSON.parse(body))
          result = if is_json
                    JSON.parse(cleaned_data.to_json, object_class: OpenStruct)
                  else
                    body
                  end
        rescue JSON::ParserError
          puts "[Error handle response] Failed! Not perform parse json action"
          nil
        end
      end

      def clean_data(data)
        case data
        when Hash
          data.transform_values { |v| clean_data(v) }
        when Array
          data.map { |v| clean_data(v) }
        when String
          data.strip
        else
          data
        end
      end

      def headers
        {
          "Content-Type" => "application/json",
        }
      end

      def connection
        Faraday.new(
          url: BASE_URL,
          headers: headers
        )
      end
    end
  end

  class ApiError < StandardError
    def initialize(message = 'An error occurred in SupplierApi')
      super(message)
    end
  end
end
