class PhotoUploader < BaseUploader

  process resize_to_fill: [920, 518]
  process convert: :png

  version :thumb do
    process resize_to_fill: [160, 90]
  end

end
