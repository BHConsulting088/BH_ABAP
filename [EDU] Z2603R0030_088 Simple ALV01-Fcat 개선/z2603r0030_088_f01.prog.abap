**********************************************************************
* Program ID   : YSMCHO_SQL
* Title        : [COMMON] SQL Test Program
* Create Date  : 2026.08.13
* Developer    : 조성민
* Tech. Script :
**********************************************************************
* Change History.
**********************************************************************
* Mod. # |Date           |Developer |Description(Reason)
**********************************************************************
*        |2026.08.13     |조성민    |initial coding
**********************************************************************
REPORT YSMCHO_SQL.

**********************************************************************
* CLS
**********************************************************************


**********************************************************************
* TOP
**********************************************************************
DATA : EXIST_SAVING_TABLE,
       OK_CODE TYPE SY-UCOMM.

" ALV
DATA : GS_LAYO         TYPE LVC_S_LAYO,
       GV_SAVE,
       GS_VARIANT      TYPE DISVARIANT,
       GO_DOCKING      TYPE REF TO CL_GUI_DOCKING_CONTAINER,
       GO_SPLITTER     TYPE REF TO CL_GUI_SPLITTER_CONTAINER,
       GO_CONTAINER_RU TYPE REF TO CL_GUI_CONTAINER,
       GO_CONTAINER_RD TYPE REF TO CL_GUI_CONTAINER,
       GO_CONTAINER_LU TYPE REF TO CL_GUI_CONTAINER,
       GO_CONTAINER_LD TYPE REF TO CL_GUI_CONTAINER.

" ABAP Editor
DATA : GO_EDIT_L      TYPE REF TO CL_GUI_ABAPEDIT,
       GO_EDIT_R      TYPE REF TO CL_GUI_ABAPEDIT,
       GO_COMPLETER_L TYPE REF TO CL_ABAP_PARSER,
       GO_COMPLETER_R TYPE REF TO CL_ABAP_PARSER.

CONSTANTS : SAVING_TABLE_NAME      TYPE TABNAME   VALUE 'ZSMCHO_SQL',
            CLIENT_FIELDNAME       TYPE FIELDNAME VALUE 'MANDT',
            USER_FIELDNAME         TYPE FIELDNAME VALUE 'ZUSER',
            DATA_FIELDNAME_L       TYPE FIELDNAME VALUE 'DATA_LEFT',
            DATA_FIELDNAME_R       TYPE FIELDNAME VALUE 'DATA_RIGHT',
            ABAP_EDITOR_MAX_LENGTH TYPE I VALUE 255.

**********************************************************************
* Main
**********************************************************************
INITIALIZATION.
  PERFORM CHECK_DBTAB_EXIST.

START-OF-SELECTION.
  CALL SCREEN 0100.

**********************************************************************
* Subroutine
**********************************************************************
*&---------------------------------------------------------------------*
*&      Form  CHECK_DBTAB_EXIST
*&---------------------------------------------------------------------*
FORM CHECK_DBTAB_EXIST .

  SELECT COUNT(*)
    FROM ( DD02L AS _A
      JOIN DD03L AS _B ON _B~TABNAME  = _A~TABNAME
                      AND _B~AS4LOCAL = _A~AS4LOCAL
                      AND _B~AS4VERS  = _A~AS4VERS
                      AND _A~TABNAME  = @SAVING_TABLE_NAME )
      JOIN  DD03L AS B ON B~FIELDNAME = @CLIENT_FIELDNAME
                      AND B~TABNAME   = _A~TABNAME
                      AND B~DOMNAME   = 'MANDT'
      JOIN  DD03L AS C ON C~FIELDNAME = @USER_FIELDNAME
                      AND C~TABNAME   = _A~TABNAME
                      AND C~DOMNAME   = 'SYCHAR12'
      JOIN  DD03L AS D ON D~FIELDNAME = @DATA_FIELDNAME_L
                      AND D~TABNAME   = _A~TABNAME
                      AND D~DOMNAME   = 'RAWSTRING'
      JOIN  DD03L AS E ON E~FIELDNAME = @DATA_FIELDNAME_R
                      AND E~TABNAME   = _A~TABNAME
                      AND E~DOMNAME   = 'RAWSTRING'
  INTO @DATA(LV_COUNT).

  IF SY-SUBRC EQ 0.
    EXIST_SAVING_TABLE = ABAP_TRUE.
  ENDIF.

ENDFORM.

**********************************************************************
* PBO
**********************************************************************
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  INIT_0100  OUTPUT
*&---------------------------------------------------------------------*
MODULE INIT_0100 OUTPUT.

  IF GO_DOCKING IS INITIAL.

    PERFORM CREATE_OBJECT.
    PERFORM SET_LAYO.
    PERFORM SET_FIELDCAT.
*    PERFORM SET_EVENT_0100.
    PERFORM DISPLAY_ALV.

  ELSE.
    PERFORM REFRESH_ALV.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CLEAR_OK_CODE  OUTPUT
*&---------------------------------------------------------------------*
MODULE CLEAR_OK_CODE OUTPUT.
  CLEAR : OK_CODE.
ENDMODULE.

**********************************************************************
* PAI
**********************************************************************
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
MODULE EXIT_0100 INPUT.

  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE SCREEN.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  CREATE_OBJECT
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT .

  PERFORM CREATE_CONTAINER.
  PERFORM CREATE_GUI_EDITOR USING GO_EDIT_L GO_CONTAINER_LU GO_COMPLETER_L.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_CONTAINER
*&---------------------------------------------------------------------*
FORM CREATE_CONTAINER .

  CREATE OBJECT GO_DOCKING
    EXPORTING
      REPID                       = SY-CPROG    " Report to Which This Docking Control is Linked
      DYNNR                       = SY-DYNNR    " Screen to Which This Docking Control is Linked
      EXTENSION                   = 5000        " Control Extension
    EXCEPTIONS
      CNTL_ERROR                  = 1
      CNTL_SYSTEM_ERROR           = 2
      CREATE_ERROR                = 3
      LIFETIME_ERROR              = 4
      LIFETIME_DYNPRO_DYNPRO_LINK = 5
      OTHERS                      = 6.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CREATE OBJECT GO_SPLITTER
    EXPORTING
      PARENT            = GO_DOCKING    " Parent Container
      ROWS              = 2    " Number of Rows to be displayed
      COLUMNS           = 2    " Number of Columns to be Displayed
    EXCEPTIONS
      CNTL_ERROR        = 1
      CNTL_SYSTEM_ERROR = 2
      OTHERS            = 3.

  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL METHOD GO_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 1                   " Row
      COLUMN    = 1                   " Column
    RECEIVING
      CONTAINER = GO_CONTAINER_LU.    " Container

  CALL METHOD GO_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 1                   " Row
      COLUMN    = 2                   " Column
    RECEIVING
      CONTAINER = GO_CONTAINER_RU.    " Container

  CALL METHOD GO_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 2                   " Row
      COLUMN    = 1                   " Column
    RECEIVING
      CONTAINER = GO_CONTAINER_LD.    " Container

  CALL METHOD GO_SPLITTER->GET_CONTAINER
    EXPORTING
      ROW       = 2                   " Row
      COLUMN    = 2                   " Column
    RECEIVING
      CONTAINER = GO_CONTAINER_RD.    " Container

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_GUI_EDITOR
*&---------------------------------------------------------------------*
FORM CREATE_GUI_EDITOR USING PO_EDIT      TYPE REF TO CL_GUI_ABAPEDIT
                             PO_CONTAINER TYPE REF TO CL_GUI_CONTAINER
                             PO_COMPLETER TYPE REF TO CL_ABAP_PARSER.

  CREATE OBJECT PO_EDIT
    EXPORTING
      PARENT           = PO_CONTAINER             " Parent container
      MAX_NUMBER_CHARS = ABAP_EDITOR_MAX_LENGTH.  " Maximum Number of Characters




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYO
*&---------------------------------------------------------------------*
FORM SET_LAYO .

  GS_LAYO-CWIDTH_OPT = 'X'.
  GS_LAYO-ZEBRA = 'X'.
  GS_LAYO-SEL_MODE = 'D'.

  GS_VARIANT-REPORT = SY-CPROG.
  GV_SAVE = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT
*&---------------------------------------------------------------------*
FORM SET_FIELDCAT .



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REFRESH_ALV
*&---------------------------------------------------------------------*
FORM REFRESH_ALV .

ENDFORM.
