! webview.f90 – minimal ISO_C_BINDING interface to https://github.com/webview/webview
module webview
  use, intrinsic :: iso_c_binding
  implicit none

  ! opaque handle returned by the C library
  type(c_ptr) :: webview_t

  ! helper constant for window visibility
  integer(c_int), parameter :: WEBVIEW_HINT_NONE  = 0
  integer(c_int), parameter :: WEBVIEW_HINT_MIN    = 1
  integer(c_int), parameter :: WEBVIEW_HINT_MAX    = 2
  integer(c_int), parameter :: WEBVIEW_HINT_FIXED= 3

  !----------------------------------------------------------
  ! C function prototypes
  !----------------------------------------------------------
  interface
    ! webview_t webview_create(int debug, void* window)
    function c_webview_create(debug, window) result(w) bind(c, name='webview_create')
      import :: c_ptr, c_int
      integer(c_int), value :: debug
      type(c_ptr),    value :: window
      type(c_ptr)           :: w
    end function

    ! void webview_destroy(webview_t w)
    subroutine c_webview_destroy(w) bind(c, name='webview_destroy')
      import :: c_ptr
      type(c_ptr), value :: w
    end subroutine

    ! void webview_run(webview_t w)
    subroutine c_webview_run(w) bind(c, name='webview_run')
      import :: c_ptr
      type(c_ptr), value :: w
    end subroutine

    ! void webview_set_html(webview_t w, const char* title)
    subroutine c_webview_set_html(w, html) bind(c, name='webview_set_html')
      import :: c_ptr, c_char
      type(c_ptr),            value :: w
      character(kind=c_char)        :: html(*)
    end subroutine

    ! void webview_set_title(webview_t w, const char* title)
    subroutine c_webview_set_title(w, title) bind(c, name='webview_set_title')
      import :: c_ptr, c_char
      type(c_ptr),            value :: w
      character(kind=c_char)        :: title(*)
    end subroutine

    ! void webview_set_size(webview_t w, int width, int height, int hints)
    subroutine c_webview_set_size(w, width, height, hints) bind(c, name='webview_set_size')
      import :: c_ptr, c_int
      type(c_ptr), value :: w
      integer(c_int), value :: width, height, hints
    end subroutine

    ! void webview_navigate(webview_t w, const char* url)
    subroutine c_webview_navigate(w, url) bind(c, name='webview_navigate')
      import :: c_ptr, c_char
      type(c_ptr),            value :: w
      character(kind=c_char)        :: url(*)
    end subroutine
  end interface

contains
  !----------------------------------------------------------
  ! Convenience wrappers (optional)
  !----------------------------------------------------------
  subroutine webview_create_f(debug, w)
    logical,       intent(in)  :: debug
    type(c_ptr), intent(out) :: w
    w = c_webview_create(merge(1, 0, debug), c_null_ptr)
  end subroutine

  subroutine webview_set_title_f(w, title)
    type(c_ptr),      intent(in) :: w
    character(len=*), intent(in) :: title
    call c_webview_set_title(w, trim(title)//c_null_char)
  end subroutine

  subroutine webview_navigate_f(w, url)
    type(c_ptr),      intent(in) :: w
    character(len=*), intent(in) :: url
    call c_webview_navigate(w, trim(url)//c_null_char)
  end subroutine

  subroutine webview_set_html(w, html)
    type(c_ptr),      intent(in) :: w
    character(len=*), intent(in) :: html
    call c_webview_set_html(w, html//c_null_char)
  end subroutine
end module webview
