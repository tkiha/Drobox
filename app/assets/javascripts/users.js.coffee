$ ->
  $("#showlogin").click ->
    $("#dialog").dialog("open")
    return false
    # alert 'open'

  $("#dialog").dialog
    autoOpen: false
    modal: true
  # alert 'ready'

  $('#test_users').on 'ajax:success', (e, products) ->
    alert 'success'

  $('#test_users').on 'ajax:error', (xhr, data, status) ->
    alert status
