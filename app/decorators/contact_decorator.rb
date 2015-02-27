class ContactDecorator < Draper::Decorator
  delegate_all

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def small_photo
    object.photo_url(:small)
  end

  def large_photo
    object.photo_url(:large)
  end

end
