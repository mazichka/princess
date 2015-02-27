class Contact < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :email, :phone, :photo

  mount_uploader :photo, ContactPhotoUploader

  validates :first_name, :last_name, :email, :phone, :photo, presence: true
end
