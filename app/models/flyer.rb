class Flyer < ApplicationRecord
  belongs_to :advertisable, polymorphic: true

  before_save :fix_deafult
  before_destroy :change_default

  def fix_deafult
    if self.is_default
      if !self.id.blank?
        Flyer.where("advertisable_id = ? and advertisable_type = ? and id <> ?", self.advertisable, self.advertisable_type, self.id).update_all(is_default: false)
      else
        Flyer.where("advertisable_id = ? and advertisable_type = ?", self.advertisable, self.advertisable_type).update_all(is_default: false)
      end
    end

    if !self.is_default
      self.is_default = true if Flyer.where(advertisable_id: self.advertisable, advertisable_type: self.advertisable_type).count == 0
    end
  end

  def change_default
    if self.is_default
      Flyer.where(advertisable_id: self.advertisable, advertisable_type: self.advertisable_type).first.update(is_default: true)
    end
  end
end
