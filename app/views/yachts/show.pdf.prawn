# Helpers
#

# Image helpers

def asset_image(name)
  File.join(Rails.root, 'app', 'assets', 'images', name)
end

def attachment_image(name)
  File.join(Rails.root, 'public', name)
end

# Text helpers

def split_on_lines(source)
  result = []
  paragraphs = []

  source.each_line do |line|
    paragraph = []
    line.strip!

    # Если строка больше 75 символов - надо разрезать на подстроки
    if line.size > 90
      subresult = ""
      line.split.each do |word|
        # Если размер слова + пробел помещается в строку
        if word.size + 1 <= 90
          # Проверка на переполнение строки
          if subresult.size + word.size + 1 >= 90
            paragraph << subresult.strip
            subresult = ""
          end
          subresult += word + " "
        else
          # Отрезаем голову
          head = word.slice(0, 89 - subresult.size)
          word = word.slice(90 - subresult.size, word.size)
          subresult += head + "-"
          result << subresult
          subresult = ""
          # Режем тело на подстроки
          word.split(//).each_slice(89) do |subword|
            if subword.size == 89
              paragraph << subword.join('') + "-"
            else
              subresult = subword.join('') + " "
            end
          end
        end
      end
      paragraph << subresult
    else
      paragraph << line.strip
    end

    paragraph.select!{ |line| line.size > 9 }

    paragraphs << paragraph if paragraph.size > 0
  end

  paragraphs.size.times do |i|
    paragraphs[i][0] = "" + paragraphs[i][0]
  end

  paragraphs.flatten
end

def split_on_pages(source)
  pages = []

  lines = split_on_lines(source)

  pages << lines.slice(0, 42)

  if lines.size > 42
    lines.slice(42, lines.length).each_slice(44) do |page|
      pages << page
    end
  end

  pages
end

# Page helpers

def decorated_page_for(pdf, new_page = false)
  pdf.font "PT Sans", size: 12

  # Шапка страницы
  pdf.bounding_box [0, 841.89], width: 595.28, height: 50.89 do
    pdf.fill_color '461B49'
    pdf.fill_rectangle [0, 50.89], 595.28, 50.89

    pdf.image asset_image('logo.png'), position: :center, vposition: :center, width: 150
  end

  pdf.bounding_box [27.64, 771], width: 540, height: 691 do
    pdf.fill_color '000000'

    yield pdf if block_given?
  end

  pdf.font "PT Sans", size: 12

  # Подвал страницы
  pdf.bounding_box [0, 60], width: 595.28, height: 60 do
    pdf.fill_color '461B49'
    pdf.fill_rectangle [0, 60], 612, 60

    # Адрес
    pdf.bounding_box [10, 55], width: 250, height: 50 do
      pdf.text 'Россия, Санкт-Петербург,', color: '8C85BC'
      pdf.text 'наб. Мартынова 92', color: '8C85BC'
      pdf.text 'www.ibs-brokerage.com', color: '8C85BC'
    end

    # Фотография владельца
    pdf.image attachment_image(@contacts.photo_url(:small)), at: [382, 55], witdh: 50, height: 50

    # Контактные данные
    pdf.bounding_box [442, 55], width: 250, height: 50 do
      pdf.text @contacts.full_name, color: '8C85BC'
      pdf.text @contacts.phone, color: '8C85BC'
      pdf.text @contacts.email, color: '8C85BC'
    end
  end

  pdf.start_new_page(page_size: 'A4', layout: :portrait) if new_page
end

# Scheme helpers

def render_schemes(pdf, schemes)
  case schemes.count
  when 1
    pdf.bounding_box [280, 300], width: 260, height: 310 do
      render_scheme(pdf, schemes.first, :whole)
    end
  when 2
    pdf.bounding_box [280, 300], width: 260, height: 150 do
      render_scheme(pdf, schemes.first, :half)
    end

    pdf.bounding_box [280, 140], width: 260, height: 150 do
      render_scheme(pdf, schemes.second, :half)
    end
  when 3
    pdf.bounding_box [280, 300], width: 260, height: 95 do
      render_scheme(pdf, schemes.first, :third)
    end

    pdf.bounding_box [280, 195], width: 260, height: 95 do
      render_scheme(pdf, schemes.second, :third)
    end

    pdf.bounding_box [280, 90], width: 260, height: 95 do
      render_scheme(pdf, schemes.third, :third)
    end
  else
    pdf.bounding_box [280, 300], width: 260, height: 70 do
      render_scheme(pdf, schemes.first, :quarter)
    end

    pdf.bounding_box [280, 220], width: 260, height: 70 do
      render_scheme(pdf, schemes.second, :quarter)
    end

    pdf.bounding_box [280, 140], width: 260, height: 70 do
      render_scheme(pdf, schemes.third, :quarter)
    end

    pdf.bounding_box [280, 60], width: 260, height: 70 do
      render_scheme(pdf, schemes.fourth, :quarter)
    end
  end
end

def render_scheme(pdf, scheme, version = :whole)
  pdf.image attachment_image(scheme.pdf_url(version)),
    vposition: :center, position: :center
end

# Document
#

prawn_document page_size: 'A4', layout: :portrait, margin: 0 do |pdf|

  # Дозагрузка шрифтов

  pdf.font_families.update "PT Sans" => {
    normal:      File.join(Rails.root, 'app', 'assets', 'fonts', 'PT_Sans-Web-Regular.ttf'),
    bold:        File.join(Rails.root, 'app', 'assets', 'fonts', 'PT_Sans-Web-Bold.ttf'),
    italic:      File.join(Rails.root, 'app', 'assets', 'fonts', 'PT_Sans-Web-Italic.ttf'),
    bold_italic: File.join(Rails.root, 'app', 'assets', 'fonts', 'PT_Sans-Web-BoldItalic.ttf')
  }

  pdf.font "PT Sans", size: 12

  # Главная страница

  decorated_page_for pdf, true do |p|
    p.bounding_box [0, 691], width: 270, height: 20 do
      p.font "PT Sans", size: 14, style: :bold
      p.text @yacht.name
    end

    p.bounding_box [271, 691], width: 270, height: 20 do
      p.font "PT Sans", size: 14, style: :normal
      p.fill_color "7C7C7C"
      p.text "#{@yacht.currency} #{@yacht.price} / #{@yacht.customs}", align: :right
    end

    p.image attachment_image(@yacht.cover.photo_url), position: -27.64, vposition: 40, width: 595.28

    p.bounding_box [0, 305], width: 270, height: 335 do
      p.font "PT Sans", size: 11, style: :normal
      p.fill_color "7C7C7C"

      data = []

      data << ["Год выпуска     ",           @yacht.year]           if @yacht.year?
      data << ["Длина     ",                 @yacht.length]         if @yacht.length?
      data << ["Ширина     ",                @yacht.width]          if @yacht.width?
      data << ["Осадка     ",                @yacht.draft]          if @yacht.draft?
      data << ["Вес     ",                   @yacht.weight]         if @yacht.weight?
      data << ["Цвет корпуса     ",          @yacht.color]          if @yacht.color?
      data << ["Двигатель     ",             @yacht.engine]         if @yacht.engine?
      data << ["Мощность     ",              @yacht.capacity]       if @yacht.capacity?
      data << ["Моточасы     ",              @yacht.hours]          if @yacht.hours?
      data << ["Запас топлива     ",         @yacht.fuel_tank]      if @yacht.fuel_tank?
      data << ["Запас воды     ",            @yacht.water_tank]     if @yacht.water_tank?
      data << ["Круизная скорость",          @yacht.cruising_speed] if @yacht.cruising_speed?
      data << ["Максимальная скорость     ", @yacht.speed]          if @yacht.speed?
      data << ["Местоположение     ",        @yacht.location]       if @yacht.location?

      p.table(data, cell_style: { border_width: 0, padding: [3,4,5,4] }, position: :center, width: 270, row_colors: ['ffffff', 'f6f6f6'])
    end

    render_schemes(pdf, @yacht.schemes)
  end

  # Комментарии

  # Стандартная комплектация
  if @yacht.equipment?
    equipment = split_on_pages(@yacht.equipment)

    decorated_page_for pdf, true do |p|
      p.font "PT Sans", size: 16, style: :bold
      p.fill_color "4C4C4C"

      p.text "Стандартная комплектация #{@yacht.name}"

      p.font "PT Sans", size: 4, style: :normal
      p.text "   "

      p.font "PT Sans", size: 12, style: :normal
      p.fill_color "7C7C7C"

      equipment.first.each do |line|
        if line.start_with?("   ")
          p.indent(10) do
            p.text line
          end
        else
          p.text line
        end
      end
    end

    if equipment.length > 1
      equipment.slice(1, equipment.length).each do |lines|
        decorated_page_for pdf, true do |p|
          p.font "PT Sans", size: 12, style: :normal
          p.fill_color "7C7C7C"

          lines.each do |line|
            if line.start_with?("   ")
              p.indent(10) do
                p.text line
              end
            else
              p.text line
            end
          end
        end
      end
    end
  end

  if @yacht.spare_parts? or @yacht.interiors or @yacht.comments?
    decorated_page_for pdf, true do |p|
      # Запасные части
      if @yacht.spare_parts?
        p.font "PT Sans", size: 16, style: :bold
        p.fill_color "4C4C4C"

        p.text "Запасные части для #{@yacht.name}"

        p.font "PT Sans", size: 4, style: :normal
        p.text "   "

        p.font "PT Sans", size: 12, style: :normal
        p.fill_color "7C7C7C"

        @yacht.spare_parts.lines.each.with_index do |line, index|
          if index == 0
            p.indent(10) do
              p.text line
            end
          else
            p.text line
          end
        end
      end

      # Интерьер
      if @yacht.interiors?
        p.font "PT Sans", size: 16, style: :bold
        p.fill_color "4C4C4C"

        p.text " "
        p.text "Интерьеры"

        p.font "PT Sans", size: 4, style: :normal
        p.text "   "

        p.font "PT Sans", size: 12, style: :normal
        p.fill_color "7C7C7C"

        @yacht.interiors.lines.each.with_index do |line, index|
          if index == 0
            p.indent(10) do
              p.text line
            end
          else
            p.text line
          end
        end
      end

      # Комментарии
      if @yacht.comments?
        p.font "PT Sans", size: 16, style: :bold
        p.fill_color "4C4C4C"

        p.text " "
        p.text "Комментарии"

        p.font "PT Sans", size: 4, style: :normal
        p.text "   "

        p.font "PT Sans", size: 12, style: :normal
        p.fill_color "7C7C7C"

        @yacht.comments.lines.each.with_index do |line, index|
          if index == 0
            p.indent(10) do
              p.text line
            end
          else
            p.text line
          end
        end
      end

    end
  end

  if @yacht.options?
    options = split_on_pages(@yacht.options)

    decorated_page_for pdf, true do |p|
      p.font "PT Sans", size: 16, style: :bold
      p.fill_color "4C4C4C"

      p.text "Дополнительные опции #{@yacht.name}"

      p.font "PT Sans", size: 4, style: :normal
      p.text "   "

      p.font "PT Sans", size: 12, style: :normal
      p.fill_color "7C7C7C"

      options.first.each do |line|
        if line.start_with?("   ")
          p.indent(10) do
            p.text line
          end
        else
          p.text line
        end
      end
    end

    if options.length > 1
      options.slice(1, options.length).each do |lines|
        decorated_page_for pdf, true do |p|
          p.font "PT Sans", size: 12, style: :normal
          p.fill_color "7C7C7C"

          lines.each do |line|
            if line.start_with?("   ")
              p.indent(10) do
                p.text line
              end
            else
              p.text line
            end
          end
        end
      end
    end
  end

  # Фотогалерея

  @yacht.photos.each_slice(8).with_index do |slice, slice_index|
    if @yacht.all_photos.size < 8
      new_page = false
    else
      if @yacht.all_photos.size % 8 == 0
        new_page = (slice_index + 1) != (@yacht.all_photos.size / 8)
      else
        new_page = (slice_index + 1) != ((@yacht.all_photos.size / 8) + 1)
      end
    end

    decorated_page_for pdf, new_page do |p|
      slice.each_with_index do |photo, index|
        left = (index % 2) * 281
        top  = 691 - ((index / 2) * (147 + 34 + 1))
        p.bounding_box [left, top], width: 260, height: 147 do
          p.image attachment_image(photo.attachment_url), width: 260, height: 147
        end
      end
    end
  end

end
