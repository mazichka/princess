class SchemeDecorator < PhotoDecorator

  def preview
    h.image_tag(object.attachment_url(:preview)) if object.attachment?
  end

  def preview_url
    object.attachment_url(:preview)
  end

  def pdf(version = :whole)
    h.image_tag(object.attachment_url(:"pdf_#{version}")) if object.attachment?
  end

  def pdf_url(version = :whole)
    object.attachment_url(:"pdf_#{version}")
  end

  def pdf_width(version = :whole)
    object.attachment.pdf_dimensions(:"pdf_#{version}")[0]
  end

  def pdf_height(version = :whole)
    object.attachment.pdf_dimensions(:"pdf_#{version}")[1]
  end

end
