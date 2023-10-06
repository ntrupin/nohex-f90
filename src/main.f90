program nohexmain
    use nohex
    implicit none

    integer :: argc, i, intmax, status
    character(len = 64) :: tmparg, fname
    character(len = 512) :: emsg
    integer, dimension(:), allocatable :: argv

    ! get max int
    intmax = huge(intmax)

    ! allocate args array
    argc = command_argument_count()
    allocate(argv(argc))

    if (argc < 1) then
        print *, "You must provide a number of columns"
        return
    end if

    ! read arguments
    do i = 1, argc
        call get_command_argument(i, tmparg)

        if (i == 1) then
            ! filename
            fname = tmparg
        else
            ! read into int
            read(tmparg, *, iostat = status, iomsg = emsg) argv(i)
        end if

        ! check for errors
        if (status /= 0) then
            print *, emsg
            return
        end if
    end do

    call output_file(fname, argv(2), argv(3))
end program nohexmain
