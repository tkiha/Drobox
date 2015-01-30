module ApplicationHelper
  def get_disp_type_name(target_object)
    return 'フォルダ' if target_object.kind_of?(Folder)
    return 'ファイル' if target_object.kind_of?(Upfile)
    '不明'
  end

  def event_text(event)
    # 旧仕様ではevent.eventに情報が入っているので
    return event.event unless event.event.blank?

    event_name = get_event_name(event)


    content_tag(:folders) do
      if event.folder_id.blank?
        concat 'ファイル '
        if event.upfile.blank?
          # 該当のファイルが存在しない
          concat event.upfile_name
        elsif event.upfile.own_user.id == current_user.id
          # 自分のファイル
          concat item_link_tag(event.upfile)
        else
          # 自分以外のファイル（共有されたファイル）
          concat toshare_item_link_tag(event.upfile)
        end
        concat ' を'
      else
        concat 'フォルダ '
        concat event.folder.blank? ? event.folder_name : item_link_tag(event.folder)
        concat ' を'
      end
      concat "#{event_name}しました"
    end
  end

  def get_event_name(event)
    case event.event_type
    when Const.event_type.copy
      'コピー'
    when Const.event_type.create
      '作成'
    when Const.event_type.update
      '更新'
    when Const.event_type.destroy
      '削除'
    when Const.event_type.move
      '移動'
    when Const.event_type.fromshare
      '共有'
    when Const.event_type.fromshare_destroy
      '共有解除'
    when Const.event_type.download
      'ダウンロード'
    else
      ''
    end
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
