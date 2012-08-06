//COPYRACF JOB 'REPRO',
//*        TYPRUN=SCAN,
//         NOTIFY=&SYSUID,
//         CLASS=A,
//         MSGCLASS=X,
//         MSGLEVEL=(1,1),
//         REGION=6000K,
//         COND=(4,LT)
//*
//****************************************************
//*        COPY RACF DATABASE TO SQUENTIAL FILE
//*        ORIGINAL FROM:
//*        HTTP://WWW.NIGELPENTLAND.CO.UK/RACF/CRACF.HTM
//****************************************************
//DELDEF   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//********
//* REPLACE "DATASET.RACFCOPY" WITH A DATASET NAME
//* THAT YOU HAVE ACCESS TO VIA FTP. 
//********
//SYSIN DD *
   DELETE  DATASET.RACFCOPY
   SET MAXCC = 0
/*
//****************************************************
//* REPLACE SYS1.RACF BELOW WITH YOUR RACF DATABASE.
//* TYPE "RVARY" IN TSO TO SEE WHERE THE RACF
//* DATABASE IS LOCATED.
//****************************************************
//* REMEMBER: REPLACE DATASET.RACFCOPY WITH THE SAME 
//* NAME YOU USED ABOVE.
//****************************************************
//REPROE   EXEC PGM=IDCAMS
//SYSUT1   DD DSN=SYS1.RACF,DISP=SHR
//SYSUT2   DD DSN=DATASET.RACFCOPY,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(70,10),RLSE),
//            DCB=(RECFM=FB,LRECL=4096,BLKSIZE=0)
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
  REPRO INFILE(SYSUT1) OUTFILE(SYSUT2)
/*
