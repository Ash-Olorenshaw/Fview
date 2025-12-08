module webview
    use, intrinsic :: iso_c_binding
    implicit none

    type(c_ptr) :: webview_t

    integer(c_int), parameter :: WEBVIEW_HINT_NONE  = 0
    integer(c_int), parameter :: WEBVIEW_HINT_MIN    = 1
    integer(c_int), parameter :: WEBVIEW_HINT_MAX    = 2
    integer(c_int), parameter :: WEBVIEW_HINT_FIXED= 3

    abstract interface
        subroutine c_bind_callback(seq, req, arg) bind(c)
            import :: c_char, c_ptr
            character(kind=c_char) :: seq(*), req(*)
            type(c_ptr), value     :: arg
        end subroutine
    end interface

    interface
        ! webview_t webview_create(int debug, void* window)
        function c_webview_create(debug, window) result(w) bind(c, name='webview_create')
            import :: c_ptr, c_int

            integer(c_int), value :: debug
            type(c_ptr), value :: window
            type(c_ptr) :: w
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

        ! void webview_set_html(webview_t w, const char* html)
        subroutine c_webview_set_html(w, html) bind(c, name='webview_set_html')
            import :: c_ptr, c_char

            type(c_ptr), value :: w
            character(kind=c_char) :: html(*)
        end subroutine

        ! void webview_set_title(webview_t w, const char* title)
        subroutine c_webview_set_title(w, title) bind(c, name='webview_set_title')
            import :: c_ptr, c_char

            type(c_ptr), value :: w
            character(kind=c_char) :: title(*)
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

            type(c_ptr), value :: w
            character(kind=c_char) :: url(*)
        end subroutine
        ! void webview_bind(webview_t w, const char* name,
        !                   void (*fn)(const char*, const char*, void*), void* arg)
        subroutine c_webview_bind(w, name, fn, arg) bind(c, name='webview_bind')
            import :: c_ptr, c_char, c_funptr
            type(c_ptr), value      :: w
            character(kind=c_char)  :: name(*)
            type(c_funptr), value   :: fn
            type(c_ptr), value      :: arg
        end subroutine

        ! void webview_return(webview_t w, const char* seq, int status, const char* result)
        subroutine c_webview_return(w, seq, status, result) bind(c, name='webview_return')
            import :: c_ptr, c_char, c_int
            type(c_ptr), value      :: w
            character(kind=c_char)  :: seq(*)
            integer(c_int), value  :: status
            character(kind=c_char)  :: result(*)
        end subroutine
    end interface
contains
    subroutine webview_create(debug, w)
        logical, intent(in) :: debug
        type(c_ptr), intent(out) :: w

        w = c_webview_create(merge(1, 0, debug), c_null_ptr)
    end subroutine

    subroutine webview_set_title(w, title)
        type(c_ptr), intent(in) :: w
        character(len=*), intent(in) :: title

        call c_webview_set_title(w, trim(title)//c_null_char)
    end subroutine

    subroutine webview_navigate(w, url)
        type(c_ptr), intent(in) :: w
        character(len=*), intent(in) :: url

        call c_webview_navigate(w, trim(url)//c_null_char)
    end subroutine

    subroutine webview_set_html(w, html)
        type(c_ptr), intent(in) :: w
        character(len=*), intent(in) :: html

        call c_webview_set_html(w, html//c_null_char)
    end subroutine
        
    ! Bind a Fortran procedure to a JavaScript function name.
    ! The callback must have the abstract interface c_bind_callback.
    subroutine webview_bind(w, name, callback, user_data)
        type(c_ptr), intent(in) :: w
        character(len=*), intent(in) :: name
        type(c_funptr), intent(in) :: callback
        type(c_ptr), intent(in), optional :: user_data
        call c_webview_bind(w, trim(name)//c_null_char, callback, merge(user_data, c_null_ptr, present(user_data)))
    end subroutine

    ! Return a value to JavaScript after processing a bound call.
    ! seq is the request identifier supplied to the callback.
    subroutine webview_return_result(w, seq, status, result)
        type(c_ptr), intent(in) :: w
        character(len=*), intent(in) :: seq
        integer(c_int), intent(in) :: status
        character(len=*), intent(in) :: result
        call c_webview_return(w, trim(seq)//c_null_char, status, trim(result)//c_null_char)
    end subroutine
end module webview
