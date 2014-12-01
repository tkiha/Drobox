module ApplicationHelper
  def get_disp_type_name(target_object)
    return 'フォルダ' if target_object.kind_of?(Folder)
    return 'ファイル' if target_object.kind_of?(Upfile)
    '不明'
  end

  def get_disp_update_time(target_object)
    target_object.updated_at.to_s(:db)
  end

  def folder_parents_html(folder)
    parents ||= []
    folder_parents(folder,parents)
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

  private
  # 受け取ったフォルダの親を辿ってparents配列にセットする
  def folder_parents(folder,parents)
    parents << folder
    parent = folder.parent_folder
    folder_parents(parent,parents) if parent.present?

  end

end
