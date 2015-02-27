ActiveAdmin.register_page 'Contacts' do

  menu label: 'Контактные данные', priority: 2

  controller do

    layout 'active_admin'

    def resource
      @contacts ||= Contact.first
    end

    def index
      @page_title = 'Контактные данные'

      render 'admin/contacts/edit'
    end

  end

  page_action :update, method: :post do
    if resource.update_attributes(params[:contact])
      flash[:notice] = 'Контактные данные успешно обновлены'

      redirect_to admin_contacts_path
    else
      flash[:error] = 'Проверьте контактные данные на предмет ошибок'

      render 'admin/contacts/edit'
    end
  end

end
