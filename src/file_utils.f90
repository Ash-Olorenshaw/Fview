module file_utils
    implicit none
contains
    function get_file_str(file_target, success) result(file_content) 
        integer :: io, file_size, iostat
        character(*), intent(in) :: file_target
        logical, intent(out), optional :: success
        character(:), allocatable :: file_content
        logical :: exists


        inquire(file=file_target, SIZE=file_size, iostat=iostat, exist=exists)
        print *, iostat
        if (iostat /= 0 .or. .not. exists) then
            success = .false.
            file_content = ""
            return
        end if
        allocate(character(len=file_size)::file_content)

        open(newunit=io, file=file_target, access="stream", status="old", action="read", iostat=iostat)
            if (iostat /= 0) then
                success = .false.
                file_content = ""
                return
            end if
            read(io) file_content
        close(io)
    end function

    function get_sys_conf_folder() result(path)
        use stdlib_system, only: OS_TYPE, OS_MACOS, OS_WINDOWS, OS_LINUX

        character(:), allocatable :: path, home_dir
        integer :: os

        os = OS_TYPE()
        if (os == OS_WINDOWS) then
            call get_environment_variable("userprofile", value=home_dir)
            path = home_dir // "\AppData\Local\QualitiesExplorer"
        else
            call get_environment_variable("HOME", value=home_dir)
            path = home_dir // "/.config/QualitiesExplorer"
        end if
    end function
end module file_utils
