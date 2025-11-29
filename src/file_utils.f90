module file_utils
    implicit none
contains
    function get_file_str(file_target) result(file_content) 
        integer :: io, file_size, iostat
        character(*), intent(in) :: file_target
        character(:), allocatable :: file_content

        inquire(file=file_target, SIZE=file_size)
        allocate(character(len=file_size)::file_content)

        open(newunit=io, file=file_target, access="stream", status="old", action="read", iostat=iostat)
            if (iostat /= 0) then
                ! TODO - implement error telling you the file it failed to open
                error stop "Failed to open file."
            end if
            read(io) file_content
        close(io)
    end function
end module file_utils
