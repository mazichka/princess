class Scheme < BasePhoto
  belongs_to :yacht, inverse_of: :schemes

  mount_uploader :attachment, SchemeUploader

  validates :attachment, presence: true
end
