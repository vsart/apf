MODULE APF
  IMPLICIT NONE
  
  INTEGER, PRIVATE, PARAMETER :: APFMAXNUMARGS = 16, APFMAXARGLEN = 128
  INTEGER, PRIVATE, PARAMETER :: APFINT = 0, APFDBL = 1
  
  INTEGER, PRIVATE, SAVE :: N = 0
  
  TYPE INTPTR
     INTEGER, POINTER :: P
  ENDTYPE INTPTR
  
  TYPE DBLPTR
     DOUBLE PRECISION, POINTER :: P
  ENDTYPE DBLPTR
  
  INTEGER, PRIVATE, SAVE :: TYPES(APFMAXNUMARGS)
  TYPE(INTPTR), PRIVATE, SAVE :: INTPTRS (APFMAXNUMARGS)
  TYPE(DBLPTR), PRIVATE, SAVE :: DBLPTRS(APFMAXNUMARGS)
  CHARACTER(LEN=APFMAXARGLEN), PRIVATE, SAVE :: NAMES(APFMAXARGLEN)
  
CONTAINS
  
  SUBROUTINE APF_INT_ADD(IPTR, NAME)
    IMPLICIT NONE
    
    INTEGER, POINTER, INTENT(IN) :: IPTR
    CHARACTER(LEN=*), INTENT(IN) :: NAME
    
    N = N + 1
    TYPES(N) = APFINT
    INTPTRS(N)%P => IPTR
    NAMES(N) = NAME
  ENDSUBROUTINE APF_INT_ADD
  
  
  SUBROUTINE APF_DBL_ADD(DPTR, NAME)
    IMPLICIT NONE
    
    DOUBLE PRECISION, POINTER, INTENT(IN) :: DPTR
    CHARACTER(LEN=*), INTENT(IN) :: NAME
    
    
    N = N + 1
    TYPES(N) = APFDBL
    DBLPTRS(N)%P => DPTR
    NAMES(N) = NAME
  ENDSUBROUTINE APF_DBL_ADD
  
  
  SUBROUTINE APF_PARSE()
    IMPLICIT NONE
    
    INTEGER :: I, K, ARGC
    INTEGER :: IAUX, STAT
    DOUBLE PRECISION :: DAUX
    CHARACTER(LEN=APFMAXARGLEN) :: ARGV
    
    ARGC = COMMAND_ARGUMENT_COUNT()
    
    I = 1
    DO WHILE (I .LE. ARGC)
       CALL GET_COMMAND_ARGUMENT(I, ARGV)
       
       DO K = 1, N
          IF (ARGV .NE. NAMES(K)) CYCLE
          
          IF (TYPES(K) .EQ. APFINT) THEN
             IF (K+1 .GT. ARGC) THEN
                PRINT *, 'Expected integer after ', TRIM(ARGV)
                STOP
             ENDIF
             
             I = I + 1
             CALL GET_COMMAND_ARGUMENT(I, ARGV)
             READ (ARGV, *, IOSTAT=STAT) IAUX
             
             IF (STAT .NE. 0) THEN
                PRINT *, 'Invalid integer found'
                STOP
             ENDIF
             
             INTPTRS(K)%P = IAUX
          ELSEIF (TYPES(K) .EQ. APFDBL) THEN
             IF (K+1 .GT. ARGC) THEN
                PRINT *, 'Expected double after ', TRIM(ARGV)
                STOP
             ENDIF
             
             I = I + 1
             CALL GET_COMMAND_ARGUMENT(I, ARGV)
             
             READ (ARGV, *, IOSTAT=STAT) DAUX
             
             IF (STAT .NE. 0) THEN
                PRINT *, 'Invalid double found'
                STOP
             ENDIF
             
             DBLPTRS(K)%P = DAUX
          ENDIF
          EXIT
       ENDDO
       
       I = I + 1
    ENDDO
  ENDSUBROUTINE APF_PARSE
  
ENDMODULE APF
