program qualities_view
    use html_utils
    use webview
    implicit none

    type(c_ptr) :: w

    call webview_create(.true., w) ! NOTE TO SELF: first arg is 'inspect element' on/off
    call webview_set_title(w, "Qualities")
    call c_webview_set_size(w, 800_c_int, 600_c_int, WEBVIEW_HINT_NONE)
    call webview_set_html(w, resolve_html_str())
    call c_webview_run(w)
    call c_webview_destroy(w)
end program qualities_view

