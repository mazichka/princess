class PhotoDecorator < Draper::Decorator
  delegate_all

  def photo
    h.image_tag(object.attachment_url) if object.attachment?
  end

  def photo_url
    object.attachment_url
  end

  def thumb
    h.image_tag(object.attachment_url(:thumb)) if object.attachment?
  end

  def thumb_url
    object.attachment_url(:thumb)
  end

end
