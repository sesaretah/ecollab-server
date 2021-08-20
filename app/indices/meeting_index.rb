ThinkingSphinx::Index.define :meeting, :with => :real_time do
  indexes title, :sortable => true
  indexes info

  has tag_ids, :multi => true, :type => :integer
  has start_time, :type => :timestamp
  has end_time, :type => :timestamp
  has event_id, :type => :integer
  has id, :type => :integer, as: :id_number
end
