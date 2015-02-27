class BasePhoto < ActiveRecord::Base
  abstract = true

  attr_accessible :yacht_id, :attachment, :attachment_cache

  set_table_name 'photos'
end
