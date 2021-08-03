class AttendanceSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :profile, serializer: ProfileSerializer
end
