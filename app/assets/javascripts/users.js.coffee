$ ->
  $("#showlogin").click ->
    $("#dialog").dialog("open")
    return false
    # alert 'open'
$ ->
  $("#dialog").dialog
    autoOpen: false
    modal: true
  # alert 'ready'

