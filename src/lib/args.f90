module args
    implicit none
    private

    character(len = 64) :: arg
    integer :: i

contains

    subroutine get_arg(flag)
        character(len = *), intent(in) :: flag
    end subroutine get_arg

end module args
