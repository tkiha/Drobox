$ ->
  $("#showtree").click ->
    $("#treedialog").dialog("open")
    $("#current_folder").click()
    return false

  $("#treedialog").dialog
    autoOpen: false,
    width: '350px',
    title: 'フォルダ選択',
    modal: true

