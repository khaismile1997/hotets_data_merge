class Api::V1::HotelsController < Api::V1::BaseController
  def index
    supplier1_data = SupplierApi::Client.get_hotels_info_supplier_1
    supplier2_data = SupplierApi::Client.get_hotels_info_supplier_2
    supplier3_data = SupplierApi::Client.get_hotels_info_supplier_3

    merge_service = Supplier::MergeService.new(supplier1_data, supplier2_data, supplier3_data)

    merged_data = merge_service.merge

    render json: merged_data
  rescue SupplierApi::ApiError => e
    puts "[Info] #{e.message}"
    head :ok
  rescue StandardError => e
    puts "[Error] #{e.message}"
  end
end
