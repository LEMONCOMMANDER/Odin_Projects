module Haul
  def big_car
    @haul = true
    @towing = false
  end

  def haulable?
    return true if self.haul

    false
  end
  def tow(vehicle_object)
    @towing = true if self.haulable?
    @towed_obj = vehicle_object

    if self.frame.include?("SUV") && vehicle_object.frame == 'Truck'
      @towing = false
      @towed_obj = nil
    end

    puts "\e[32mtowing #{vehicle_object}, #{vehicle_object.frame}\e[0m" if self.towing
  end

  def drop
    return unless self.towing

    self.towing = false
    puts "\e[31mdropped #{self.towed_obj}, #{self.towed_obj.frame}\e[0m"
    self.towed_obj = nil
  end
end