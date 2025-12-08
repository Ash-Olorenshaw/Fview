
module html_utils
    implicit none
contains
    function resolve_html_str() result(result_str)
        use file_utils, only: get_file_str
        use stdlib_strings, only: replace_all
        character(:), allocatable :: yaml_str, result_str, html_str
        logical :: io_success

        io_success = .true.

        html_str = get_file_str("./src/index.html", success = io_success)
        if (.not. io_success) then
            print *, "Err - unable to read file 'index.html' to launch program"
            call exit(1)
        end if
        yaml_str = get_file_str("./src/qualities.yaml", success = io_success)
        if (.not. io_success) then
            print *, "Err - unable to read file 'qualities.yaml' to launch program"
            call exit(1)
        end if

        result_str = replace_all(html_str, "RAW_QUALITIES_YAML_STR", yaml_str)
    end function
end module html_utils
