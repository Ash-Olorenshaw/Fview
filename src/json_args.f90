module json_args
    use json_module, only: json_file
    use webview

    implicit none
contains
    subroutine gather_args(req, args, args_len)
        character(kind=c_char), intent(in) :: req(*)
        character(len=:), dimension(:), allocatable, intent(inout) :: args
        integer, dimension(:), allocatable, intent(inout) :: args_len
        type(json_file) :: json_in

        call json_in%initialize()
        call json_in%deserialize("{ ""data"": " // c_string_to_f_string(req) // "}")
        call json_in%get("data", args, ilen = args_len)
        call json_in%destroy()
    end subroutine gather_args

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
end module json_args
