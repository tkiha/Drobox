ready = ->
  $("#showlogin").click ->
    $("#dialog").dialog("open")
  # 登録フォームとログインフォームが混在しているので
  # 「登録」押下でエラーが起きた後にログインを開くとログインフォームにもエラー色が付いてしまうので透過色にしておく
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

  # フォルダツリー
  $("#showtree").click ->
    $("#treedialog").dialog("open")
    $("#current_folder").click()
    return false

  $("#treedialog").dialog
    autoOpen: false,
    width: '350px',
    title: 'フォルダ選択',
    modal: true


$(document).ready(ready)
$(document).on('page:load', ready)