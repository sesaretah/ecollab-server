# == Schema Information
#
# Table name: roles
#
#  id           :bigint           not null, primary key
#  title        :string
#  ability      :json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  default_role :boolean
#
class Role < ApplicationRecord
    def users
        results = []
        for user in User.all
           results << user if user.assignments && user.assignments.include?(self.id)
        end
        return results
    end

    def add_ability(title, value)
        self.ability = [] if self.ability.blank?
        self.ability << {title: title, value: value} 
        self.save
    end

    def remove_ability(title)
        arr = []
        for a in self.ability
            arr << a if a['title'] != title
        end
        self.ability = arr
        self.save
    end
end
