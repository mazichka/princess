class CoverDecorator < PhotoDecorator

  def preview
    h.image_tag(object.attachment_url(:preview)) if object.attachment?
  end

  def preview_url
    object.attachment_url(:preview)
  end

end
