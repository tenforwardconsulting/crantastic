class Priority < Tag
  def self.find_by_param(id)
    self.find_by_name!(id)
  end
end
