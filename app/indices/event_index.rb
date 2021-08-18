ThinkingSphinx::Index.define :event, :with => :real_time do
  indexes title, :sortable => true
  indexes info

  has tag_ids, :multi => true, :type => :integer
  has start_date, :type => :timestamp
  has end_date, :type => :timestamp
end
