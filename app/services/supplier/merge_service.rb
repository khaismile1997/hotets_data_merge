class Supplier::MergeService < Supplier::BaseService
  def initialize(supplier1_data, supplier2_data, supplier3_data)
    @supplier1_data = supplier1_data
    @supplier2_data = supplier2_data
    @supplier3_data = supplier3_data
  end

  def merge
    hotel_data_groups = group_hotel_data_by_id
    merged_data = []

    hotel_data_groups.each do |id, hotel_data_group|
      merged_hotel = response_struct
      sup1 = hotel_data_group[:supplier1] || OpenStruct.new
      sup2 = hotel_data_group[:supplier2] || OpenStruct.new
      sup3 = hotel_data_group[:supplier3] || OpenStruct.new
      
      merged_hotel[:id]                 = sup1.Id || sup2.id || sup3.hotel_id
      merged_hotel[:destination_id]     = sup1.DestinationId || sup2.description || sup3.destination_id
      merged_hotel[:name]               = sup1.Name || sup2.name || sup3.hotel_name
      merged_hotel[:location][:lat]     = sup1.Latitude.presence || sup2.lat.presence
      merged_hotel[:location][:lng]     = sup1.Longitude.presence || sup2.lng.presence
      merged_hotel[:location][:address] = sup2.address || format_location_address(sup1.Address, sup1.PostalCode)
      merged_hotel[:location][:city]    = sup1.City || sup3.location&.country
      merged_hotel[:location][:country] = sup1.Country
      merged_hotel[:description]        = sup3.details || sup1.Description
      merged_hotel[:amenities]          = sup3.amenities&.general + sup3.amenities&.room || sup2.amenities || sup1.Facilities

      handle_merge_images(merged_hotel, sup2.images, sup3.images)

      merged_hotel[:booking_conditions] = sup3.booking_conditions

      merged_data << merged_hotel
    end

    merged_data
  end

  private

  def response_struct
    {
      id: nil,
      destination_id: nil,
      name: nil,
      location: {
        lat: nil,
        lng: nil,
        address: nil,
        city: nil,
        country: nil
      },
      description: nil,
      amenities: [],
      images: {
        rooms: [],
        site: [],
        amenities: []
      },
      booking_conditions: []
    }
  end

  def img_struct
    { link: nil, description: nil }        
  end

  def group_hotel_data_by_id
    hotel_data_groups = {}

    [@supplier1_data, @supplier2_data, @supplier3_data].each_with_index do |supplier_data, index|
      supplier_data.each do |hotel_data|
        id = case index
             when 0
               hotel_data[:Id]
             when 1
               hotel_data[:id]
             when 2
               hotel_data[:hotel_id]
             end

        hotel_data_groups[id] ||= {}
        hotel_data_groups[id]["supplier#{index + 1}".to_sym] = hotel_data || {}
      end
    end

    hotel_data_groups
  end

  def format_location_address(address, postal_code)
    address.include?(postal_code) ? address : "#{address}, #{postal_code}"
  end

  def handle_merge_images(merged_hotel, sup2_imgs, sup3_imgs)
    return if sup2_imgs.blank? && sup3_imgs.blank?
    merge_rooms(merged_hotel, sup2_imgs, sup3_imgs)
    merge_amenities(merged_hotel, sup2_imgs)
    merge_site(merged_hotel, sup3_imgs)
  end

  def merge_rooms(merged_hotel, sup2_imgs, sup3_imgs)
    if sup2_imgs&.rooms.present?
      sup2_imgs.rooms.each do |room|
        img_room = img_struct
        img_room[:link] = room[:url]
        img_room[:description] = room[:description]
        merged_hotel[:images][:rooms] << img_room
      end
    end

    if sup3_imgs&.rooms.present?
      sup3_imgs.rooms.each do |room|
        img_room = img_struct
        img_room[:link] = room[:link]
        img_room[:description] = room[:caption]
        merged_hotel[:images][:rooms] << img_room
      end
    end

    merged_hotel[:images][:rooms].sort_by! { _1[:description] }.uniq!
  end

  def merge_amenities(merged_hotel, sup2_imgs)
    return if sup2_imgs&.amenities.blank?
    sup2_imgs.amenities.each do |room|
      img_amenity = img_struct
      img_amenity[:link] = room[:url]
      img_amenity[:description] = room[:description]
      merged_hotel[:images][:amenities] << img_amenity

      merged_hotel[:images][:amenities].sort_by! { _1[:description] }
    end
  end

  def merge_site(merged_hotel, sup3_imgs)
    return if sup3_imgs&.site.blank?
    sup3_imgs.site.each do |room|
      img_site = img_struct
      img_site[:link] = room[:link]
      img_site[:description] = room[:caption]
      merged_hotel[:images][:site] << img_site

      merged_hotel[:images][:site].sort_by! { _1[:description] }
    end
  end
end
