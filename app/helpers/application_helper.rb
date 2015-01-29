module ApplicationHelper
  def get_disp_type_name(target_object)
    return 'フォルダ' if target_object.kind_of?(Folder)
    return 'ファイル' if target_object.kind_of?(Upfile)
    '不明'
  end

  def get_disp_update_time(target_object)
    target_object.updated_at.in_time_zone('Tokyo').strftime("%Y-%m-%d %H:%M:%S")
  end

  def get_disp_own_user_name(target_object)
    target_object.own_user.try(:email).to_s
  end

  def family_folders_html(families)
    content_tag(:folder_tree) do
      unless families[:parent].blank?
        concat link_to(families[:parent][:name],
                       search_folder_path(families[:parent][:id]),
                       { class: 'search_folder',remote: true }
                      )
        concat tag(:br)
        concat '|-'
      end
      concat link_to(families[:self][:name],
                     search_folder_path(families[:self][:id]),
                     { class: 'search_folder',remote: true }
                    )
      unless families[:child].blank?
        families[:child].each do |sub_folder|
          concat tag(:br)
          concat raw('&nbsp')
          concat '|-'
          concat link_to(sub_folder[:name],
                         search_folder_path(sub_folder[:id]),
                         { class: 'search_folder',remote: true }
                        )
        end
      end

    end
  end


  def family_folders_selected_html(families)
    content_tag(:folder_selected) do
      concat label_tag(:選択フォルダ：)
      concat ' '
      concat link_to(families[:self][:name],
                     search_folder_path(families[:self][:id]),
                     { class: 'search_folder',remote: true }
                    )
      concat hidden_field_tag(:to_folder_id, families[:self][:id])
    end

  end

  def folder_parents_html(folder)
    parents ||= []
    folder.all_parents(parents)
    content_tag(:folders) do
      parents.each_with_index.reverse_each do |f,index|
        concat link_to(f.name, folder_path(f))
        concat '  ->  ' if index!=0
      end
    end
  end

end
