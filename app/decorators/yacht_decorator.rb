class YachtDecorator < Draper::Decorator
  delegate_all
  decorates_finders
  decorates_associations :cover, :photos, :schemes

  [:width, :weight, :draft, :fuel_tank, :water_tank, :engines_count, :capacity,
   :speed, :cruising_speed, :hours, :length].each do |metric|
    define_method :"#{metric}?" do
      object.public_send(metric).present? and object.public_send(metric) > 0
    end
  end

  [:engine, :location, :color, :cabins, :bunks].each do |metric|
    define_method :"#{metric}?" do
      object.public_send(metric).present?
    end
  end

  Yacht::FULL_INFO.each do |metric|
    define_method :"#{metric}?" do
      object.public_send(metric).present?
    end
  end

  def name
    object.name? ? object.name : 'Неизвестная яхта'
  end

  def year
    if object.year?
      "#{object.year} #{h.t('metrics.year')}"
    else
      h.t('metrics.unknown')
    end
  end

  [:length, :width, :draft].each do |metric|
    define_method metric do
      if object.public_send(:"#{metric}?")
        meters = object.public_send(metric)
        foots = meters / 0.3048
        result = "#{meters.round(2)} #{h.t('metrics.meter')} / #{foots.round(2)} #{h.t('metrics.foot')}"
      else
        h.t('metrics.unknown')
      end
    end
  end

  def weight
    if object.weight?
      "#{object.weight.round(1)} #{h.t('metrics.ton')}"
    else
      h.t('metrics.unknown')
    end
  end

  [:fuel_tank, :water_tank].each do |metric|
    define_method metric do
      if object.public_send(:"#{metric}?")
        "#{object.public_send(metric)} #{h.t('metrics.liter')}"
      else
        h.t('metrics.unknown')
      end
    end
  end

  def capacity
    if object.capacity?
      if engines_count?
        "#{object.engines_count} x #{object.capacity} #{h.t('metrics.horsepower')}"
      else
        "#{object.capacity} #{h.t('metrics.horsepower')}"
      end
    else
      h.t('metrics.unknown')
    end
  end

  def speed
    if object.speed?
      "#{object.speed} #{Russian.p(object.speed, h.t('metrics.knot.one'), h.t('metrics.knot.few'), h.t('metrics.knot.many'))}"
    else
      h.t('metrics.unknown')
    end
  end

  def cruising_speed
    if object.cruising_speed?
      "#{object.cruising_speed} #{Russian.p(object.cruising_speed, h.t('metrics.knot.one'), h.t('metrics.knot.few'), h.t('metrics.knot.many'))}"
    else
      h.t('metrics.unknown')
    end
  end

  def hours
    if object.hours?
      "#{object.hours}"
    else
      h.t('metrics.unknown')
    end
  end

  def currency
    case object.currency
    when 'EUR'
      '€'
    when 'GBP'
      '£'
    when 'USD'
      '$'
    end
  end

  def currency_html
    case object.currency
    when 'EUR'
      '&euro;'.html_safe
    when 'USD'
      '$'
    when 'GBP'
      '&pound;'.html_safe
    end
  end

  def price
    h.number_with_precision(object.price, precision: 0, separator: ',', delimiter: ' ')
  end

  def price_html
    currency_span = h.content_tag(:span, currency_html, data: { currency: object.currency.downcase })
    price_span    = h.content_tag(:span, price, data: { price: object.price} )

    h.content_tag(:p, "#{currency_span} #{price_span}".html_safe, class: 'price')
  end

  [:engine, :engines_count, :location, :color, :cabins, :bunks, :description].each do |metric|
    define_method metric do
      if object.public_send(metric).present?
        object.public_send(metric)
      else
        h.t('metrics.unknown')
      end
    end
  end

  def customs
    if object.customs?
      h.t('metrics.customs_yes')
    else
      h.t('metrics.customs_no')
    end
  end

  def status
    case object.status
    when 'draft'
      'Черновик'
    when 'for_sale'
      'На витрине'
    when 'sold_out'
      'Продана'
    end
  end

  (Yacht::FULL_INFO + [:description]).each do |text|
    define_method "#{text}_html" do
      if object.public_send(:"#{text}?")
        result = ""
        object.public_send(text).each_line do |line|
          result += h.content_tag(:p, line.html_safe)
        end
        result.html_safe
      else
        h.content_tag(:p, h.t('metrics.unknown'))
      end
    end
  end

  def all_photos
    @all_photos ||= ([object.cover] + object.photos).compact
  end

  def index_data
    {
      name: object.name,
      year: object.year,
      length: object.length || 0,
      price: object.price,
      currency: object.currency
    }.to_json
  end

end
