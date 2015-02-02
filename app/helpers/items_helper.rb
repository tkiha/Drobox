module ItemsHelper
  def item_link_tag(item)
    if item.kind_of?(Folder)
      return link_to item.name, folder_path(item)
    end

    if item.kind_of?(Upfile)
      return link_to item.name, folder_upfile_path(item.folder_id, item)
    end
  end

  def toshare_item_link_tag(item)
    if item.kind_of?(Folder)
      return link_to item.name, toshare_folder_path(item)
    end

    if item.kind_of?(Upfile)
      return link_to item.name, folder_toshare_upfile_path(item.folder_id, item)
    end
  end

  def item_view_tag(item)
    if item.kind_of?(Folder)
      return link_to '詳細', folder_folder_path(item.parent_folder_id, item)
    end

    if item.kind_of?(Upfile)
      return link_to '詳細', folder_upfile_path(item.folder_id, item)
    end
  end

  def toshare_item_view_tag(item)
    if item.kind_of?(Folder)
      return link_to '詳細', folder_toshare_folder_path(item.parent_folder, item)
    end

    if item.kind_of?(Upfile)
      return link_to '詳細', folder_toshare_upfile_path(item.folder_id, item)
    end
  end

  def item_edit_tag(item)
    if item.kind_of?(Folder)
      return link_to '編集', edit_folder_folder_path(item.parent_folder_id, item)
    end

    if item.kind_of?(Upfile)
      return link_to '編集', edit_folder_upfile_path(item.folder_id, item)
    end
  end

  def share_link_tag(item)
    if item.kind_of?(Folder)
      return link_to '共有', new_folder_foldershare_path(item.parent_folder_id, item)
    end

    if item.kind_of?(Upfile)
      return link_to '共有', new_folder_fileshare_path(item.folder_id, item)
    end
  end

  def destroy_share_link_tag(item)
    if item.kind_of?(Folder)
      return link_to '共有解除',folder_foldershare_path(item.parent_folder_id, item) , :method => :delete, :data => { :confirm => '共有解除してもよろしいですか？' }
    end

    if item.kind_of?(Upfile)
      return link_to '共有解除', folder_fileshare_path(item.folder_id, item), :method => :delete, :data => { :confirm => '共有解除してもよろしいですか？' }
    end
  end

  def shareitems_header_tag(field, orderby, link_path)
    field_name = get_item_header_title(field)
    now_orderby, next_orderby, arrow =
    get_item_header_orderby(field, orderby)

    field_name << arrow

    link_to field_name, "#{link_path}?f=#{field}&o=#{next_orderby}"
  end

  def items_header_tag(field, folder, orderby)
    field_name = get_item_header_title(field)
    now_orderby, next_orderby, arrow =
      get_item_header_orderby(field, orderby)

    field_name << arrow

    link_to field_name, folder_path(folder,
      f: field,
      o: next_orderby,
    )
  end

  def get_item_header_title(field)
    case field
      when Const.orderby.field.file
        'ファイル'
      when Const.orderby.field.type
        '種別'
      when Const.orderby.field.time
        '更新'
      when Const.orderby.field.owner
        '所有者'
    end
  end

  def get_item_header_orderby(field, orderby)
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

  def get_toshare_folder_items(folder, orderby)
    items = []
    add_items_upfiles(items, folder)
    items_orderby(items, orderby)
    items
  end

  def get_toshare_items(orderby)
    items = []
    add_items_toshare_folders(items)
    add_items_toshare_upfiles(items)
    items_orderby(items, orderby)
    items.uniq!
    items
  end

  def add_items_toshare_folders(items)
    # 共有されたフォルダを抽出
    current_user.to_share_folders.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        Const.orderby.field.owner => get_disp_own_user_name(f),
        object: f
      }
      items << rec
    end
  end

  def add_items_toshare_upfiles(items)
    # 共有されたファイルを抽出
    current_user.to_share_files.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        Const.orderby.field.owner => get_disp_own_user_name(f),
        object: f
      }
      items << rec
    end
  end

  def get_fromshare_items(orderby)
    items = []
    add_items_fromshare_folders(items)
    add_items_fromshare_upfiles(items)
    items_orderby(items, orderby)
    items.uniq!
    items
  end

  def add_items_fromshare_folders(items)
    # 共有したフォルダを抽出
    current_user.from_share_folders.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      items << rec
    end
  end

  def add_items_fromshare_upfiles(items)
    # 共有したファイルを抽出
    current_user.from_share_files.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      items << rec
    end
  end

  def get_folder_items(folder, orderby)
    items = []
    add_items_sub_folders(items, folder)
    add_items_upfiles(items, folder)
    items_orderby(items, orderby)
    items
  end

  def add_items_sub_folders(items, folder)
    # サブフォルダを抽出
    folder.sub_folders.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      items << rec
    end
  end

  def add_items_upfiles(items, folder)
    # フォルダ内のファイルを抽出
    folder.upfiles.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => get_disp_type_name(f),
        Const.orderby.field.time => get_disp_update_time(f),
        object: f
      }
      items << rec
    end
  end

  def items_orderby(items, orderby)
    orderby_item, orderby_value = get_orderby_params(orderby)
    if orderby_value != Const.orderby.none
      items.sort_by! { |item| item[orderby_item] }
      items.reverse! if orderby_value == Const.orderby.desc
    end
  end
end
