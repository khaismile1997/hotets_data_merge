# spec/requests/api/v1/hotels_spec.rb

require 'rails_helper'

RSpec.describe "Api::V1::Hotels", type: :request do
  describe "GET #index" do
    let!(:mock_data_path) { Rails.root.join('spec/support/supplier_api/mocks/supplier_data.yml') }

    let(:supplier1_data) { JSON.parse(YAML.load_file(mock_data_path)['supplier1_data'].to_json, object_class: OpenStruct) }
    let(:supplier2_data) { JSON.parse(YAML.load_file(mock_data_path)['supplier2_data'].to_json, object_class: OpenStruct) }
    let(:supplier3_data) { JSON.parse(YAML.load_file(mock_data_path)['supplier3_data'].to_json, object_class: OpenStruct) }

    context 'when SupplierApi::Client status OK' do
      before do
        allow(SupplierApi::Client).to receive(:get_hotels_info_supplier_1).and_return(supplier1_data)
        allow(SupplierApi::Client).to receive(:get_hotels_info_supplier_2).and_return(supplier2_data)
        allow(SupplierApi::Client).to receive(:get_hotels_info_supplier_3).and_return(supplier3_data)
      end
  
      it "returns the merged data as JSON" do
        get '/api/v1/hotels'
  
        json_response = JSON.parse(response.body)
  
        expect(response).to have_http_status(:ok)
        expect(json_response).to be_an(Array)
        expect(json_response.length).to eq(3)
        assert_response_schema_confirm(200)
      end
    end

    context 'when SupplierApi::Client.get_hotels_info_supplier_1 raises SupplierApi::ApiError' do
      before do
        allow(SupplierApi::Client).to receive(:get_hotels_info_supplier_1).and_raise(SupplierApi::ApiError, 'An error occurred in Supplier 1 API')
        get '/api/v1/hotels'
      end

      it 'returns HTTP status 200' do
        expect(response).to have_http_status(200)
      end

      it 'logs the error message with [Info] prefix in the output' do
        expect { get '/api/v1/hotels' }.to output(/\[Info\] An error occurred in Supplier 1 API/).to_stdout
      end
    end

    context 'when other StandardError is raised' do
      before do
        allow(SupplierApi::Client).to receive(:get_hotels_info_supplier_1).and_raise(StandardError, 'Something went wrong!')
        get '/api/v1/hotels'
      end

      it 'logs the error message with [Error] prefix in the output' do
        expect { get '/api/v1/hotels' }.to output(/\[Error\] Something went wrong\!/).to_stdout
      end
    end
  end
end
