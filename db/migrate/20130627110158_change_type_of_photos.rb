class ChangeTypeOfPhotos < ActiveRecord::Migration

  class Photo < ActiveRecord::Base
  end

  def up
    Photo.where(type: 'OutsidePhoto').update_all(type: 'Photo')
    Photo.where(type: 'InsidePhoto').update_all(type: 'Photo')
  end

end
