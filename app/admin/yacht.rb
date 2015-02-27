ActiveAdmin.register Yacht do
  decorate_with YachtDecorator

  menu label: 'Яхты', priority: 1

  scope 'Все',       :all
  scope 'Витрина',   :for_sale, default: true
  scope 'Проданные', :sold_out
  scope 'Черновики', :not_published

  member_action :publish, method: :put do
    if Yacht.find(params[:id]).publish
      flash[:notice] = 'Яхта помещена на витрину'
    else
      flash[:alert]  = 'Яхта не может быть помещена на витрину'
    end

    redirect_to action: :index
  end

  member_action :draft, method: :put do
    if Yacht.find(params[:id]).edit
      flash[:notice] = 'Яхта помещена в черновики'
    else
      flash[:alert]  = 'Яхта не может быть помещена в черновики'
    end

    redirect_to action: :index
  end

  member_action :sold, method: :put do
    if Yacht.find(params[:id]).sold
      flash[:notice] = 'Яхта помечена как проданная'
    else
      flash[:alert]  = 'Яхта не может быть помечена как проданная'
    end

    redirect_to action: :index
  end

  action_item only: :show do
    link_to 'На витрину', publish_admin_yacht_path(yacht), method: :put if yacht.can_publish?
  end

  action_item only: :show do
    link_to 'В черновики', edit_admin_yacht_path(yacht), method: :put if yacht.can_edit?
  end

  action_item only: :show do
    link_to 'Продана', sold_admin_yacht_path(yacht), method: :put if yacht.can_sold?
  end

  index do
    column :name
    column :price do |yacht|
      yacht.price_html
    end
    column :status
    default_actions
    unless current_scope.scope_method == :for_sale
      column do |yacht|
        link_to 'На витрину', publish_admin_yacht_path(yacht), method: :put if yacht.can_publish?
      end
    end
    unless current_scope.scope_method == :not_published
      column do |yacht|
        link_to 'В черновики', draft_admin_yacht_path(yacht), method: :put if yacht.can_edit?
      end
    end
    unless current_scope.scope_method == :sold_out
      column do |yacht|
        link_to 'Продана', sold_admin_yacht_path(yacht), method: :put if yacht.can_sold?
      end
    end
  end

  filter :name

  show do
    panel 'Краткая информация' do
      attributes_table_for resource do
        [:name, :year, :length, :width, :weight, :draft, :fuel_tank, :water_tank,
         :engine, :capacity, :cruising_speed, :speed, :hours, :location, :color,
         :cabins, :bunks].each do |attr|
          row attr
        end

        row :description do
          resource.description_html
        end

        row :customs
        row :price do
          resource.price_html
        end
      end
    end

    panel 'Обложка' do
      resource.cover.thumb
    end

    panel 'Схемы' do
      resource.schemes.map do |scheme|
        scheme.thumb
      end.join('<span>&nbsp;</span>').html_safe
    end

    panel 'Фотографии' do
      resource.photos.map do |photo|
        photo.thumb
      end.join('<span>&nbsp;</span>').html_safe
    end

    panel 'Стандартная комплектация' do
      resource.equipment_html
    end

    panel 'Запасные части' do
      resource.spare_parts_html
    end

    panel 'Комментарии к стандартной комплектации' do
      resource.comments_html
    end

    panel 'Дополнительные опции' do
      resource.options_html
    end

    panel 'Интерьеры' do
      resource.interiors_html
    end

    active_admin_comments
  end

  form html: { multipart: true } do |f|
    f.object = f.object.source if f.object.persisted?

    f.inputs 'Основная информация' do
      f.input :name
      f.input :description, hint: 'Главное о яхте. Отображается только на сайте, под фотогалереей яхты.'
      f.input :price
      f.input :currency, as: :radio, collection: Yacht::CURRENCIES
    end

    f.inputs 'Обложка', for: [:cover_attributes, f.object.cover || Cover.new] do |cover|
      hint = "Основная фотография яхты. Обрезается. Отображается и на сайте и в PDF файле. <br />Рекомендуемый размер: 920 x 518 (отношение сторон 16:9)<br />".html_safe
      if cover.object.attachment?
        cover.input :attachment, as: :file, hint: "#{hint}#{image_tag(cover.object.attachment.url(:thumb))}".html_safe
      else
        cover.input :attachment, as: :file, hint: hint
      end
      cover.input :attachment_cache, as: :hidden if cover.object.new_record?
    end

    f.inputs 'Схема', class: 'photos inputs' do
      hint = "Изображение с планом яхты. Оно не обрезается. Отображается и на сайте в в PDF файле на первой странице.<br />".html_safe
      f.has_many :schemes do |scheme|
        if scheme.object.attachment?
          scheme.input :attachment, as: :file, hint: "#{hint}#{image_tag(scheme.object.attachment.url(:thumb))}".html_safe
        else
          scheme.input :attachment, as: :file, hint: hint
        end
        scheme.input :attachment_cache, as: :hidden if scheme.object.new_record?
        if !scheme.object.nil?
          scheme.input :_destroy, as: :boolean, label: "Удалить?"
        end
      end
    end

    f.inputs 'Краткая информация' do
      f.input :year
      f.input :length
      f.input :width
      f.input :weight
      f.input :draft
      f.input :fuel_tank
      f.input :water_tank
      f.input :engine
      f.input :engines_count
      f.input :capacity
      f.input :cruising_speed
      f.input :speed
      f.input :hours
      f.input :location
      f.input :color
      f.input :cabins
      f.input :bunks
      f.input :customs
    end

    f.inputs 'Фотогалерея', class: 'photos inputs' do
      hint = "Фотография внешнего вида и интерьеров яхты. Отображается в фотогалерее на сайте и на последней странице PDF файла. <br />Рекомендуемый размер: 920 x 518 (отношение сторон 16:9)<br />"
      f.has_many :photos do |photo|
        if photo.object.attachment?
          photo.input :attachment, as: :file, hint: "#{hint}#{image_tag(photo.object.attachment.url(:thumb))}".html_safe
        else
          photo.input :attachment, as: :file, hint: hint
        end
        photo.input :attachment_cache, as: :hidden
        if !photo.object.nil?
          photo.input :_destroy, as: :boolean, label: "Удалить?"
        end
      end
    end

    f.inputs 'Стандартная комлплектация' do
      f.input :equipment, label: '&nbsp;', hint: "Информация о стандартной комплектации. Текст можно разделять пустыми строками. Отображается только в PDF файле. Может занимать 2 страницы."
    end

    f.inputs 'Запасные части' do
      f.input :spare_parts, label: '&nbsp;', hint: "Информация о запасных частях. Текст можно разделять пустыми строками. Отображается только в PDF файле. Занимает треть страницы или не более 12 строк."
    end

    f.inputs 'Комментарии к стандартной комлплектации' do
      f.input :comments, label: '&nbsp;', hint: "Текст можно разделять пустыми строками. Отображается на сайте во вкладке Комментарии и в PDF файле. Текст не должен занимать более 12 строк или 900 символов без абзацев."
    end

    f.inputs 'Дополнительные опции' do
      f.input :options, label: '&nbsp;', hint: "Информация о дополнительных опциях. Текст можно разделять пустыми строками. Отображается только в PDF файле. Может занимать 2 страницы."
    end

    f.inputs 'Интерьеры' do
      f.input :interiors, label: '&nbsp;', hint: 'Информация об интерьерах яхты. Отображается на сайте во вкладке Интерьеры и в PDF файле. Текст не должен занимать более 740 символов или 12 строк текста.'
    end

    f.inputs 'Статус' do
      f.input :status, label: '&nbsp;', as: :radio, collection: [['На витрину', 'for_sale'], ['Черновик', 'not_published'], ['Продана', 'sold_out']]
    end

    f.actions
  end
end
