class Discussion < ApplicationRecord
  belongs_to :discussable, polymorphic: true
end
