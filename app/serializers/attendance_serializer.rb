class AttendanceSerializer < ActiveModel::Serializer
  attributes :id, :duty
  belongs_to :profile, serializer: ProfileSerializer
end
