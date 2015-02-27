class ContactPhotoUploader < BaseUploader

  process convert: :png

  version :small do
    process resize_to_fill: [100, 100]
  end

  version :large do
    process resize_to_fill: [400, 400]
  end

end
