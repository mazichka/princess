contact = Contact.new do |c|
  c.first_name = 'Александр'
  c.last_name = 'Галкин'
  c.email = 'galkin@nord-star.com'
  c.phone = '+7 (921) 857 81 81'
end
contact.save(validate: false)

contact.photo.store!(File.open(File.join(Rails.root, 'app', 'assets', 'images', 'manager.png')))
contact.save
