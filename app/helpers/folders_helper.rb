module FoldersHelper
  def file_link_tag(folder, target_object)
    if target_object.kind_of?(Folder)
      return link_to target_object.name, list_folder_path(target_object)
    end

    if target_object.kind_of?(Upfile)
      return link_to target_object.name, folder_upfile_path(folder, target_object)
    end
  end

  def file_view_tag(folder, target_object)
    if target_object.kind_of?(Folder)
      return link_to '詳細', folder_folder_path(folder, target_object)
    end

    if target_object.kind_of?(Upfile)
      return link_to '詳細', folder_upfile_path(folder, target_object)
    end
  end
  def file_edit_tag(folder, target_object)
    if target_object.kind_of?(Folder)
      return link_to '編集', edit_folder_folder_path(folder, target_object)
    end

    if target_object.kind_of?(Upfile)
      return link_to '編集', edit_folder_upfile_path(folder, target_object)
    end
  end

  def filelist_header_tag(field, folder, orderby)
    case field
      when Const.orderby.field.file
        field_name = 'ファイル'
      when Const.orderby.field.type
        field_name = '種別'
      when Const.orderby.field.time
        field_name = '更新'
    end


    orderby_item, orderby_value = get_orderby_params(orderby)
    now_orderby = orderby_value
    next_orderby = Const.orderby.asce
   
    if field == orderby_item
      case now_orderby
        when Const.orderby.asce
          next_orderby = Const.orderby.desc
          field_name << '↓'
        when Const.orderby.desc
          next_orderby = Const.orderby.asce
          field_name << '↑'
      end
    end
    # p "---> #{field_name} #{orderby_item} #{orderby_value} "
    link_to field_name, list_folder_path(folder,
      f: field,
      o: next_orderby,
    )

  end
end
