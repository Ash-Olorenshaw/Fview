program qualities_view
    use webview
    implicit none

    type(c_ptr) :: w
    character(:), allocatable :: generated_html

    call webview_create(.true., w) ! NOTE TO SELF: first arg is 'inspect element' on/off
    call webview_set_title(w, "Qualities")
    call c_webview_set_size(w, 800_c_int, 600_c_int, WEBVIEW_HINT_NONE)

    generated_html = get_html_str() 
    call webview_set_html(w, resolve_html_str(generated_html))
    call c_webview_run(w)
    call c_webview_destroy(w)
contains
    function get_html_str() result(html_str) 
        integer :: io, file_size, iostat
        character(:), allocatable :: html_str

        inquire(file="./src/static/dist/index.html", SIZE=file_size)
        allocate(character(len=file_size)::html_str)

        open(newunit=io, file="./src/static/dist/index.html", access="stream", status="old", action="read", iostat=iostat)
            if (iostat /= 0) then
                error stop "Failed to open file 'index.html'."
            end if
            read(io) html_str
        close(io)
    end function

    function resolve_html_str(input_str) result(result_str)
        use stdlib_strings, only: replace_all
        character(:), allocatable :: input_str
        character(:), allocatable :: yaml_str, result_str
        integer :: io, file_size, iostat

        inquire(file="./qualities.yaml", SIZE=file_size)
        allocate(character(len=file_size)::yaml_str)

        open(newunit=io, file="./qualities.yaml", access="stream", status="old", action="read", iostat=iostat)
            if (iostat /= 0) then
                error stop "Failed to open file 'qualities.yaml'."
            end if
            read(io) yaml_str
        close(io)

        print *, yaml_str

        result_str = replace_all(input_str, "RAW_QUALITIES_YAML_STR", yaml_str)
    end function
end program qualities_view

