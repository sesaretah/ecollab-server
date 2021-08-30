class AttendanceSerializer < ActiveModel::Serializer
  attributes :id, :duty, :attendable_id, :attendable_type
  belongs_to :profile, serializer: ProfileSerializer
end
