module callback_bindings 
    use webview
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
        use file_utils, only: get_file_str
        use json_file_module
        use json_module

        character(kind=c_char), intent(in) :: seq(*), req(*)
        type(c_ptr), intent(in), value :: arg
        character(len=:), allocatable :: md_str, file_str, json_str
        character(len=:), dimension(:), allocatable :: input_str_array
        integer, dimension(:), allocatable :: input_str_array_len
        type(json_file) :: json_in
        type(json_core) :: json_out
        type(json_value), pointer :: root => null()
        logical :: md_str_success

        md_str_success = .true.

        call json_in%initialize()
        call json_in%deserialize("{ ""data"": " // c_string_to_f_string(req) // "}")
        call json_in%print()
        call json_in%get("data", input_str_array, ilen=input_str_array_len)
        call json_in%destroy()

        ! TODO: Handle 'file not found' errors
        file_str = "./qualities/" // input_str_array(1) // ".md"
        print *, file_str
        md_str = get_file_str(file_str, success = md_str_success)

        call json_out%create_object(root, "")
        call json_out%add(root, "result", md_str)
        call json_out%add(root, "success", md_str_success)
        call json_out%serialize(root, json_str)
        call json_out%destroy(root)
        call webview_return_result(w, c_string_to_f_string(seq), 0, json_str)
    end subroutine get_quality_text

    function c_string_to_f_string(carr) result(fstr)
        character(kind=c_char), intent(in) :: carr(*)
        character(len=:), allocatable :: fstr
        integer :: i
        i = 1
        do while (carr(i) /= c_null_char)
            i = i + 1
        end do
        allocate(character(len=i-1) :: fstr)
        fstr = transfer(carr(1:i-1), fstr)
    end function c_string_to_f_string

end module callback_bindings
