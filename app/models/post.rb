class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => [:slugged]
  paginates_per 5
  attr_accessible :body, :title
end
