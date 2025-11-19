program demo
  use webview
  implicit none
  type(c_ptr) :: w

  call webview_create_f(.false., w)
  call webview_set_title_f(w, "Fortran + Webview")
  call c_webview_set_size(w, 800_c_int, 600_c_int, WEBVIEW_HINT_NONE)
  call webview_navigate_f(w, "https://example.com")
  call c_webview_run(w)
  call c_webview_destroy(w)
end program demo

