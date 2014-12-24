module FoldersHelper
  def file_link_tag(target_object)
    if target_object.kind_of?(Folder)
      return link_to target_object.name, list_folder_path(target_object)
    end

    if target_object.kind_of?(Upfile)
      return link_to target_object.name, folder_upfile_path(target_object.folder_id, target_object)
    end
  end

  def file_view_tag(target_object)
    if target_object.kind_of?(Folder)
      return link_to '詳細', folder_folder_path(target_object.parent_folder_id, target_object)
    end

    if target_object.kind_of?(Upfile)
      return link_to '詳細', folder_upfile_path(target_object.folder_id, target_object)
    end
  end

  def file_edit_tag(target_object)
    if target_object.kind_of?(Folder)
      return link_to '編集', edit_folder_folder_path(target_object.parent_folder_id, target_object)
    end

    if target_object.kind_of?(Upfile)
      return link_to '編集', edit_folder_upfile_path(target_object.folder_id, target_object)
    end
  end

  def share_link_tag(target_object)
    if target_object.kind_of?(Folder)
      return link_to '共有', newshares_folder_folder_path(target_object.parent_folder_id, target_object)
    end

    if target_object.kind_of?(Upfile)
      return link_to '共有', newshares_folder_upfile_path(target_object.folder_id, target_object)
    end
  end

  def destroy_share_link_tag(target_object)
    if target_object.kind_of?(Folder)
      return link_to '共有解除',destroyshares_folder_folder_path(target_object.parent_folder_id, target_object) , :method => :delete, :data => { :confirm => '共有解除してもよろしいですか？' }
    end

    if target_object.kind_of?(Upfile)
      return link_to '共有解除',destroyshares_folder_upfile_path(target_object.folder_id, target_object) , :method => :delete, :data => { :confirm => '共有解除してもよろしいですか？' }
    end
  end

  def sharelist_header_tag(field, orderby, link_path)
    field_name = get_list_header_title(field)
    now_orderby, next_orderby, arrow =
      get_list_header_orderby(field, orderby)

    field_name << arrow

    link_to field_name, "#{link_path}?f=#{field}&o=#{next_orderby}"
  end

  def filelist_header_tag(field, folder, orderby)
    field_name = get_list_header_title(field)
    now_orderby, next_orderby, arrow =
      get_list_header_orderby(field, orderby)

    field_name << arrow

    link_to field_name, list_folder_path(folder,
      f: field,
      o: next_orderby,
    )
  end

  def get_list_header_title(field)
    case field
      when Const.orderby.field.file
        'ファイル'
      when Const.orderby.field.type
        '種別'
      when Const.orderby.field.time
        '更新'
    end
  end

  def get_list_header_orderby(field, orderby)
    orderby_item, orderby_value = get_orderby_params(orderby)
    now_orderby = orderby_value
    next_orderby = Const.orderby.asce
    arrow = ''
    if field == orderby_item
      case now_orderby
        when Const.orderby.asce
          next_orderby = Const.orderby.desc
          arrow = '↓'
        when Const.orderby.desc
          next_orderby = Const.orderby.asce
          arrow = '↑'
      end
    end
    # p "---> #{field_name} #{orderby_item} #{orderby_value} "
    return now_orderby, next_orderby, arrow
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

  def get_list_fromshare_source(orderby)
    itemlist = []
    add_itemlist_fromshare_folders(itemlist)
    add_itemlist_fromshare_upfiles(itemlist)
    itemlist_orderby(itemlist, orderby)
    itemlist.uniq!
    itemlist
  end

  def add_itemlist_fromshare_folders(itemlist)
    # 共有したフォルダを抽出
    current_user.from_share_folders.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      itemlist << rec
    end
  end

  def add_itemlist_fromshare_upfiles(itemlist)
    # 共有したファイルを抽出
    current_user.from_share_files.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      itemlist << rec
    end
  end

  def get_list_folder_source(folder, orderby)
    itemlist = []
    add_itemlist_sub_folders(itemlist, folder)
    add_itemlist_upfiles(itemlist, folder)
    itemlist_orderby(itemlist, orderby)
    itemlist
  end

  def add_itemlist_sub_folders(itemlist, folder)
    # サブフォルダを抽出
    folder.sub_folders.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      itemlist << rec
    end
  end

  def add_itemlist_upfiles(itemlist, folder)
    # フォルダ内のファイルを抽出
    folder.upfiles.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      itemlist << rec
    end
  end

  def itemlist_orderby(itemlist, orderby)
    orderby_item, orderby_value = get_orderby_params(orderby)
    if orderby_value != Const.orderby.none
      itemlist.sort_by! { |item| item[orderby_item] }
      itemlist.reverse! if orderby_value == Const.orderby.desc
    end
  end
end
