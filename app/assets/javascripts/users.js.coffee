$ ->
  $("#showlogin").click ->
    $("#dialog").dialog("open")
  #  「登録」押下でエラーが起きた後にログインを開くとエラー色が付いてしまうので透過色にしておく
    $('#loginform .field_with_errors').css('background-color','transparent')
    return false

  $("#dialog").dialog
    autoOpen: false,
    width: '350px',
    title: 'ログイン',
    modal: true

  # ログイン成功
  $('#loginform').on 'ajax:success', (e, products) ->
    location.reload true

  # ログイン失敗
  $('#loginform').on 'ajax:error', (e, xhr, status, error) ->
    res = xhr.responseJSON
    $('#errmsg').text(res.error)
