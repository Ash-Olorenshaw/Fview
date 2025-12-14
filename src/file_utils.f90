module file_utils
    implicit none
contains
    function get_file_str(file_target, success) result(file_content) 
        integer :: io, file_size, iostat
        character(*), intent(in) :: file_target
        logical, intent(out), optional :: success
        character(:), allocatable :: file_content
        logical :: exists

        print *, "GETTING FILE", file_target

        inquire(file=file_target, SIZE=file_size, iostat=iostat, exist=exists)
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
        use system_utils, only: dir_exists

        character(:), allocatable :: path
        character(255) :: home_dir
        integer :: os

        os = OS_TYPE()
        if (os == OS_WINDOWS) then
            call get_environment_variable("userprofile", value=home_dir)
            path = trim(home_dir) // "\AppData\Local\QualitiesExplorer"
        else
            call get_environment_variable("HOME", value=home_dir)
            path = trim(home_dir) // "/.config/QualitiesExplorer"
        end if

        if (.not. dir_exists(path)) then
            call create_dir(path)
        end if
    end function

    subroutine create_dir(dir)
        character(:), allocatable, intent(in) :: dir
        character(:), allocatable :: cmd

        cmd = "mkdir """ // dir // """"
        call execute_command_line(cmd)
    end subroutine
end module file_utils
