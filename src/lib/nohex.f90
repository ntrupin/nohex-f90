module nohex
    implicit none

    private
    public output_file

    character(len = 5) :: reset  = ACHAR(27) // "[0m" // CHAR(0), &
                          red    = ACHAR(27) // "[31m", &
                          green  = ACHAR(27) // "[32m", &
                          yellow = ACHAR(27) // "[33m", &
                          cyan   = ACHAR(27) // "[36m"

contains

    ! checks if a given byte is a whitespace character
    function is_whitespace(ch) result(ret)
        character, intent(in) :: ch
        logical :: ret

        ret = ch == CHAR(32) & ! space
         .OR. ch == CHAR(9)  & ! tab
         .OR. ch == CHAR(10) & ! newline
         .OR. ch == CHAR(13) & ! carriage return
         .OR. ch == CHAR(11) & ! vertical tab
         .OR. ch == CHAR(12)   ! form feed
    end function is_whitespace

    ! checks if a given character is ASCII
    function is_ascii(ch) result(ret)
        character, intent(in) :: ch
        logical :: ret

        ret = ch >= CHAR(0) .AND. ch <= CHAR(137)
    end function is_ascii

    subroutine output_file(fname, cols, max)
        character(len = 64), intent(in) :: fname
        integer, intent(in) :: cols, max

        integer :: io, status, i
        character(len = 512) :: emsg
        character(len = 5) :: color
        character, dimension(cols) :: row
        character :: data

        open(&
            unit = io, &
            file = trim(fname), &
            status = "old", &
            access = "stream", &
            action = "read", &
            iostat = status, &
            iomsg = emsg &
        )

        ! check for error
        if (status /= 0) then
            print *, trim(emsg)
            return
        endif

        do i = 1, max
            ! read byte from io
            read(io, iostat = status, iomsg = emsg) data
            ! check for error
            if (status /= 0) then
                print *, trim(emsg)
                return
            end if

            ! select color for byte
            select case (data)
                case (CHAR(0))
                    ! null character
                    color = reset
                    row(mod(i - 1, cols) + 1) = "0"
                case (CHAR(33):CHAR(126))
                    ! printable characters
                    color = cyan
                    row(mod(i - 1, cols) + 1) = data
                case default
                    if (is_whitespace(data)) then
                        ! whitespace character
                        color = green
                        row(mod(i - 1, cols) + 1) = "_"
                    else if (is_ascii(data)) then
                        ! other ascii
                        color = red
                        row(mod(i - 1, cols) + 1) = "*"
                    else
                        ! non-ascii
                        color = yellow 
                        row(mod(i - 1, cols) + 1) = "x"
                    end if
            end select

            write (*, "(a,Z2.2,a,A)", advance = "no") &
                color, data, reset, " "

            if (mod(i, cols) == 0) then
                write (*, *) row
                row = CHAR(0)
            else if (i == max) then
                write (*, *) repeat(' ', 3 * (cols - mod(i, cols)))//row
            end if
        end do

        ! close file
        close(io)
    end subroutine output_file

end module nohex
