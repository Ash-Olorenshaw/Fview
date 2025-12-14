module system_utils
    implicit none
contains
    subroutine system_open(url, success, success_reason)
        use stdlib_system, only: OS_TYPE, OS_MACOS, OS_WINDOWS, OS_LINUX

        character(:), allocatable, intent(in) :: url
        character(:), allocatable, intent(inout) :: success_reason
        logical, intent(inout) :: success

        character(:), allocatable :: cmd
        character(255) :: cmd_msg
        integer :: os

        cmd = ""
        os = OS_TYPE()

        select case (os)
            case (OS_LINUX)
                cmd = "xdg-open "
            case (OS_WINDOWS)
                cmd = "cmd /c start "
            case (OS_MACOS)
                cmd = "open "
            case default
                success = .false.
                success_reason = "You are running an unsupported operating system."
        end select

        if (success) then
            cmd = cmd // url
            call execute_command_line(cmd, cmdmsg=cmd_msg)
        end if
    end subroutine

    function dir_exists(dir) result(exists)
        use stdlib_system, only: OS_TYPE, OS_MACOS, OS_WINDOWS, OS_LINUX

        character(:), allocatable, intent(in) :: dir
        character(:), allocatable :: cmd
        integer :: status, os
        logical :: exists
        
        cmd = ""
        os = OS_TYPE()
        exists = .false.

        if (os == OS_WINDOWS) then
            cmd = "IF EXIST """ // dir // "\NUL"" (EXIT 0) ELSE (EXIT 1)"
        else
            cmd = "if [ -d """ // dir // """ ]; then exit 0; else exit 1; fi;"
        end if

        call execute_command_line(cmd, exitstat=status)

        if (status == 0) then
            exists = .true.
        end if
    end function
end module system_utils
