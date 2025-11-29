
module html_utils
    implicit none
contains
    function resolve_html_str() result(result_str)
        use file_utils, only: get_file_str
        use stdlib_strings, only: replace_all
        character(:), allocatable :: yaml_str, result_str, html_str

        html_str = get_file_str("./src/static/dist/index.html")
        yaml_str = get_file_str("./qualities.yaml")
        result_str = replace_all(html_str, "RAW_QUALITIES_YAML_STR", yaml_str)
    end function
end module html_utils
