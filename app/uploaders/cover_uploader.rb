class CoverUploader < PhotoUploader

  version :preview do
    process resize_to_fill: [680, 383]
  end

end
