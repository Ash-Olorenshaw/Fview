program qualities_view
    use webview

    implicit none

    type(c_ptr) :: w
    integer :: io, file_size, iostat
    character(:), allocatable :: html_str

    call webview_create_f(.false., w)
    call webview_set_title_f(w, "Fview")
    call c_webview_set_size(w, 800_c_int, 600_c_int, WEBVIEW_HINT_NONE)

    inquire(file="./src/static/dist/index.html", SIZE=file_size)
    allocate(character(len=file_size)::html_str)

    open(newunit=io, file="./src/static/dist/index.html", access="stream", status="old", action="read", iostat=iostat)
        if (iostat /= 0) then
            error stop "Failed to open file 'index.html'."
        end if
        read(io) html_str
    close(io)

    print *, html_str

    call webview_set_html(w, html_str)
    call c_webview_run(w)
    call c_webview_destroy(w)
end program qualities_view

