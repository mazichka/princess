class SchemeUploader < BaseUploader

  process convert: :png

  version :preview do
    process resize_and_pad: [920, 518, :transparent]
  end

  version :thumb do
    process resize_and_pad: [160, 90, :transparent]
  end

  version :pdf_whole do
    process resize_to_fit: [260, 310]
  end

  version :pdf_half do
    process resize_to_fit: [260, 150]
  end

  version :pdf_third do
    process resize_to_fit: [260, 95]
  end

  version :pdf_quarter do
    process resize_to_fit: [260, 70]
  end

  def pdf_dimensions(version = :pdf_whole)
    unless @pdf_dimensions
      version_path = versions[version].path

      @pdf_dimensions ||= `identify -format "%wx%h" #{version_path}`.split(/x/).map{ |d| d.to_i }
    end

    @pdf_dimensions
  end

end
