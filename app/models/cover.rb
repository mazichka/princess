class Cover < BasePhoto
  belongs_to :yacht, inverse_of: :cover

  mount_uploader :attachment, CoverUploader

  validates :attachment, presence: true
end
