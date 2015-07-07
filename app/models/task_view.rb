class TaskView < Tag

  def self.find_by_param(id)
    self.find_by_name!(id)
  end

  def update_version(version)
    self.update_attribute(:version, version)
    TimelineEvent.create!(:subject => self, :event_type => "updated_task_view")
  end

end
