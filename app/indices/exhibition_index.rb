ThinkingSphinx::Index.define :exhibition, :with => :real_time do
  indexes title, :sortable => true
  indexes info

  has tag_ids, :multi => true, :type => :integer
  has event_id, :type => :integer
  has is_active, :type => :boolean, as: :activated
  has id, :type => :integer, as: :id_number
end
