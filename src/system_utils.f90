module system_utils
    implicit none
contains
    subroutine open_browser(url, success, success_reason)
        use stdlib_system, only: OS_TYPE, OS_MACOS, OS_WINDOWS, OS_LINUX

        character(:), allocatable, intent(in) :: url
        character(:), allocatable, intent(inout) :: success_reason
        logical, intent(inout) :: success

        character(:), allocatable :: cmd, cmd_msg
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
                success_reason = "Unable to open browser. You are running an unsupported operating system."
        end select

        if (success) then
            cmd = cmd // url
            call execute_command_line(cmd, cmdmsg=cmd_msg)
            if (len(cmd_msg) .gt. 0) then
                success = .false.
                success_reason = "Unable to open browser. Shell error: " // cmd_msg
            end if
        end if
    end subroutine
end module system_utils
