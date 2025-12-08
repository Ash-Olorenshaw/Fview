program qualities_view
    use html_utils
    use webview
    use callback_bindings
    implicit none

    procedure(bind_callback), pointer :: get_quality_text_ptr
    get_quality_text_ptr => get_quality_text


    call webview_create(.true., w) ! NOTE TO SELF: first arg is 'inspect element' on/off
    call webview_set_title(w, "Qualities")
    call c_webview_set_size(w, 800_c_int, 600_c_int, WEBVIEW_HINT_NONE)

    call webview_bind(w, "getQualityText", c_funloc(get_quality_text_ptr), c_null_ptr)

    call webview_set_html(w, resolve_html_str())
    call c_webview_run(w)
    call c_webview_destroy(w)
end program qualities_view

