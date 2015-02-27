class Photo < BasePhoto
  attr_accessible :yacht_id, :attachment, :attachment_cache

  belongs_to :yacht, inverse_of: :photos

  mount_uploader :attachment, PhotoUploader
end
