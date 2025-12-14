program qualities_view
    use html_utils
    use webview
    use callback_bindings
    implicit none

    procedure(bind_callback), pointer :: get_quality_text_ptr
    procedure(bind_callback), pointer :: system_open_callback_ptr
    procedure(bind_callback), pointer :: open_qualities_callback_ptr
    procedure(bind_callback), pointer :: open_quality_file_callback_ptr

    system_open_callback_ptr => system_open_callback
    get_quality_text_ptr => get_quality_text
    open_qualities_callback_ptr => open_qualities_callback
    open_quality_file_callback_ptr => open_quality_file_callback

    call webview_create(.true., w) ! NOTE TO SELF: first arg is 'inspect element' on/off
    call webview_set_title(w, "Qualities")
    call c_webview_set_size(w, 800_c_int, 600_c_int, WEBVIEW_HINT_NONE)

    call webview_bind(w, "getQualityText", c_funloc(get_quality_text_ptr), c_null_ptr)
    call webview_bind(w, "systemOpen", c_funloc(system_open_callback_ptr), c_null_ptr)
    call webview_bind(w, "openQualitiesDir", c_funloc(open_qualities_callback_ptr), c_null_ptr)
    call webview_bind(w, "openQualityFile", c_funloc(open_quality_file_callback_ptr), c_null_ptr)

    call webview_set_html(w, resolve_html_str())
    call c_webview_run(w)
    call c_webview_destroy(w)
end program qualities_view

