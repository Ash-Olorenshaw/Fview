module callback_bindings 
    use webview
    use json_args
    implicit none

    type(c_ptr) :: w

    abstract interface
        subroutine bind_callback(seq, req, arg) bind(c)
            import :: c_char, c_ptr
            character(kind=c_char), intent(in) :: seq(*), req(*)
            type(c_ptr), intent(in), value     :: arg
        end subroutine
    end interface

contains

    subroutine get_quality_text(seq, req, arg) bind(c)
        use file_utils
        use json_file_module
        use json_module

        character(kind=c_char), intent(in) :: seq(*), req(*)
        type(c_ptr), intent(in), value :: arg
        character(len=:), allocatable :: md_str, file_str, json_str
        character(len=:), dimension(:), allocatable :: input_str_array
        integer, dimension(:), allocatable :: input_str_array_len
        type(json_core) :: json_out
        type(json_value), pointer :: root => null()
        logical :: md_str_success

        md_str_success = .true.

        call gather_args(req, input_str_array, input_str_array_len)

        file_str = get_sys_conf_folder() // "/qualities/" // input_str_array(1) // ".md"
        md_str = get_file_str(file_str, success = md_str_success)

        call json_out%create_object(root, "")
        call json_out%add(root, "result", md_str)
        call json_out%add(root, "success", md_str_success)
        call json_out%serialize(root, json_str)
        call json_out%destroy(root)
        call webview_return_result(w, c_string_to_f_string(seq), 0, json_str)
    end subroutine get_quality_text

    subroutine open_external_link(seq, req, arg) bind(c)
        use file_utils, only: get_file_str
        use json_file_module
        use json_module
        use system_utils, only: open_browser

        character(kind=c_char), intent(in) :: seq(*), req(*)
        type(c_ptr), intent(in), value :: arg
        character(len=:), allocatable :: cmd, success_reason, json_str, cmd_msg, url
        character(len=:), dimension(:), allocatable :: input_str_array
        integer, dimension(:), allocatable :: input_str_array_len
        type(json_core) :: json_out
        type(json_value), pointer :: root => null()
        integer :: os
        logical :: success

        success = .true.
        success_reason = ""

        call gather_args(req, input_str_array, input_str_array_len)
        url = input_str_array(1)
        call open_browser(url, success=success, success_reason=success_reason)

        call json_out%create_object(root, "")
        call json_out%add(root, "success_reason", success_reason)
        call json_out%add(root, "success", success)
        call json_out%serialize(root, json_str)
        call json_out%destroy(root)

        call webview_return_result(w, c_string_to_f_string(seq), 0, json_str)
    end subroutine open_external_link
end module callback_bindings
