module ApplicationHelper
  def get_disp_type_name(target_object)
    return 'フォルダ' if target_object.kind_of?(Folder)
    return 'ファイル' if target_object.kind_of?(Upfile)
    '不明'
  end

  def get_disp_update_time(target_object)
    target_object.updated_at.to_s(:db)
  end

  def family_folders_html(families)
    content_tag(:folder_tree) do
      unless families[:parent].blank?
        concat link_to(families[:parent][:name], 
                       search_folder_path(families[:parent][:id]),
                       {class: 'search_folder',remote: true}
                      )
        concat tag(:br)
        concat '|-'
      end
      concat link_to(families[:self][:name],
                     search_folder_path(families[:self][:id]),
                     {class: 'search_folder',remote: true}
                    )
      unless families[:child].blank?
        families[:child].each do |sub_folder|
          concat tag(:br)
          concat raw('&nbsp')
          concat '|-'
          concat link_to(sub_folder[:name],
                         search_folder_path(sub_folder[:id]),
                         {class: 'search_folder',remote: true}
                        )
        end
      end

    end
  end


  def family_folders_selected_html(families)
    content_tag(:folder_selected) do

      concat label_tag(:移動先フォルダ：)
      concat ' '
      concat link_to(families[:self][:name],
                     search_folder_path(families[:self][:id]),
                     {class: 'search_folder',remote: true}
                    )

      concat hidden_field_tag(:moveto_folder_id, families[:self][:id])
    end

  end

  def folder_parents_html(folder)
    parents ||= []
    folder.all_parents(parents)
    content_tag(:folders) do
      parents.each_with_index.reverse_each do |f,index|
        concat link_to(f.name,list_folder_path(f))
        concat '  ->  ' if index!=0
      end
    end
  end

  def get_orderby_params(orderby)
    orderby_item  = Const.orderby.field.file
    orderby_value = Const.orderby.none
    orderby.each do |key, value|
      if value != Const.orderby.none
        orderby_item  = key
        orderby_value = value
      end
    end

    return orderby_item,orderby_value.to_i
  end

end
