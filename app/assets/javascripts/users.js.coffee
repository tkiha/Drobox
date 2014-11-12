$ ->
  $("#showlogin").click ->
    $("#dialog").dialog("open")
    return false

  $("#dialog").dialog
    autoOpen: false
    modal: true

  $('#loginform').on 'ajax:success', (e, products) ->
    location.reload true

  $('#loginform').on 'ajax:error', (e, xhr, status, error) ->
    res = xhr.responseJSON
    alert res.error
