class Yacht < ActiveRecord::Base

  SHORT_INFO = [:name, :year, :length, :width, :weight, :draft, :fuel_tank,
                :water_tank, :engine, :engines_count, :capacity, :speed,
                :hours, :location, :color, :cabins, :bunks, :description,
                :customs, :price, :currency, :status, :cruising_speed]
  FULL_INFO  = [:equipment, :spare_parts, :comments, :options, :interiors]
  CURRENCIES = [:EUR, :GBP, :USD]

  attr_accessible *(SHORT_INFO + FULL_INFO)
  attr_accessible :cover_attributes
  attr_accessible :schemes_attributes
  attr_accessible :photos_attributes

  has_one  :cover,          dependent: :destroy, inverse_of: :yacht
  has_many :photos,         dependent: :destroy, inverse_of: :yacht
  has_many :schemes,        dependent: :destroy, inverse_of: :yacht

  accepts_nested_attributes_for :cover
  accepts_nested_attributes_for :schemes, allow_destroy: true
  accepts_nested_attributes_for :photos,  allow_destroy: true

  validates :name, :description, :currency, :equipment, :spare_parts, :comments,
            :options, :interiors, presence: true
  validates :cover, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1990,
                                   less_than_or_equal_to: Date.current.year },
                   allow_blank: true
  validates :length, :width, :weight, :draft, :capacity, numericality: true,
                                                         allow_blank: true
  validates :fuel_tank, :water_tank, :engines_count, :speed, :hours, :cruising_speed,
            numericality: { only_integer: true }, allow_blank: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :currency, inclusion: { in: CURRENCIES.map{ |v| v.to_s } }

  state_machine :status, initial: :not_published do
    event :publish do
      transition (all - :for_sale) => :for_sale
    end

    event :edit do
      transition (all - :not_published) => :not_published
    end

    event :sold do
      transition (all - :sold_out) => :sold_out
    end
  end

  scope :short_info,    -> { select(SHORT_INFO) }
  scope :full_info,     -> { select(SHORT_INFO + FULL_INFO) }
  scope :for_sale,      -> { where(status: 'for_sale') }
  scope :sold_out,      -> { where(status: 'sold_out') }
  scope :not_published, -> { where(status: 'not_published') }

end
