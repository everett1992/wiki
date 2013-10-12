class Page < ActiveRecord::Base
  has_many :links, :foreign_key => 'from_id'

  validates_uniqueness_of :title
  validates_presence_of :title
end
