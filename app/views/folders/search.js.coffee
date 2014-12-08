  $('.search_folder').on 'ajax:success', (e, data, status, xhr) ->
    $('.tree').html(
      "<%= escape_javascript(render 'search_result') %>"
    )
    $('.to_folder').html(
      "<%= escape_javascript(render 'search_result_selected') %>"
    )
