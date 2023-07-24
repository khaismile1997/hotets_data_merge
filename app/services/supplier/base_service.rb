class Supplier::BaseService
  def merge(hotel_data)
    raise NotImplementedError, "Subclasses must implement the 'merge' method"
  end
end