$! BLDALG.COM - Com file to build the ALGOL RTS
$!
$ 
$ IF F$ENVI("PROCEDURE") .NES. F$SEARCH("UNSUPP$:BLDALG.COM") THEN GOTO SOURCE_KIT
$ ASSIGN UNSUPP$: IN
$ ASSIGN UNSUPP$: OUT
$ GOTO START

$SOURCE_KIT:
$ ASSIGN D:[170,172] IN
$ ASSIGN D:[170,0] CMN
$ ASSIGN D:[170,172] OUT

$START:
$ _RUN $MACRO
OUT:CM,OUT:CM/C=CMN:COMMON,IN:DEFS,IN:CM
OUT:IN,OUT:IN/C=CMN:COMMON,IN:DEFS,IN:IN
OUT:IO,OUT:IO/C=CMN:COMMON,IN:DEFS,IN:IO
OUT:ME,OUT:ME/C=CMN:COMMON,IN:DEFS,IN:ME
OUT:RC,OUT:RC/C=CMN:COMMON,IN:DEFS,IN:RC
OUT:SB,OUT:SB/C=CMN:COMMON,IN:DEFS,IN:SB
OUT:SC,OUT:SC/C=CMN:COMMON,IN:DEFS,IN:SC
OUT:VE,OUT:VE/C=CMN:COMMON,IN:DEFS,IN:VE
$ _EOD

$ _RUN $LINK
OUT:ALGOL,OUT:ALGOL/A/W,OUT:ALGOL/U:4000/H:177776=OUT:IN/C
OUT:CM/C
OUT:IO/C
OUT:ME/C
OUT:RC/C
OUT:SB/C
OUT:SC/C
OUT:VE/C
CMN:ERR.STB
PA
$ _EOD

$ _RUN $SILUS
OUT:ALGOL.RTS,TT:=OUT:ALGOL
$ _EOD

$!
$! Disable logfile so the remove of the RTS does not show up as an error
$! if it's not currently installed.  We want this command procedure to
$! complete with no errors.
$!
$_SET NOON
$ LOG_FILE = F$ENVIRONMENT("LOG_FILE")
$_IF LOG_FILE .NES. "" THEN SET LOGFILE/DISABLE
$_REMOVE/RUN ALGOL
$_IF LOG_FILE .NES. "" THEN SET LOGFILE/ENABLE
$_SET ON
$_INSTALL/RUN OUT:ALGOL.RTS
$ _EXIT
