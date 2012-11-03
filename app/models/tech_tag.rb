class TechTag < ActiveRecord::Base
  attr_accessible :name
  has_many :tagowners
  #has_many :projects, through: :tagowners


	def self.tokens(query)
		tech_tags = where("name like ?", "%#{query}%")
		if tech_tags.empty?
		  [{id: "<<<#{query}>>>", name: "New: \"#{query}\""}]
		else
		  tech_tags
		end
	end

	def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end
end


# == Schema Information
#
# Table name: tech_tags
#
#  id         :integer         not null, primary key
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  name       :string(255)
#  picture    :string(255)
#

