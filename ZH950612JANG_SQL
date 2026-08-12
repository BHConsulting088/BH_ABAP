*&---------------------------------------------------------------------*
*& Report  ZH950612JANG_SQL
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZH950612JANG_SQL.

DATA TEXT_S96 TYPE STRING.
DATA TEXT_S97 TYPE STRING.
DATA TEXT_S98 TYPE STRING.
DATA TEXT_S99 TYPE STRING.

DATA OK_CODE TYPE SY-UCOMM.
DATA: BEGIN OF S_ERR_INFO
, CODE TYPE STRING
, MSG  TYPE STRING
    , END   OF S_ERR_INFO.
CONSTANTS TEMPORARY_ITAB_NAME TYPE FIELDNAME VALUE 'LT_DATA'.

DATA EXIST_SAVING_TABLE TYPE XFELD.
CONSTANTS SAVING_TABLE_NAME TYPE TABNAME   VALUE 'ZH950612JANG_SQL'.
CONSTANTS CLIENT_FIELDNAME  TYPE FIELDNAME VALUE 'MANDT'.
CONSTANTS USER_FIELDNAME    TYPE FIELDNAME VALUE 'ZUSER'.
CONSTANTS DATA_FIELDNAME_L  TYPE FIELDNAME VALUE 'DATA_LEFT'.
CONSTANTS DATA_FIELDNAME_R  TYPE FIELDNAME VALUE 'DATA_RIGHT'.
CONSTANTS: BEGIN OF USER_COMMAND
, SAVE       TYPE SY-UCOMM VALUE 'SAVE'
, RUN_ALL    TYPE SY-UCOMM VALUE 'RUNA'
, RUN_LEFT   TYPE SY-UCOMM VALUE 'RUNL'
, RUN_RIGHT  TYPE SY-UCOMM VALUE 'RUNR'
, HOW_TO_USE TYPE SY-UCOMM VALUE 'HELP'
         , END   OF USER_COMMAND.

" SCREEN 0100 ----------------------------------------------------------
DATA: O_DNKNG          TYPE REF TO CL_GUI_DOCKING_CONTAINER
    , O_SPLIT_VERTICAL TYPE REF TO CL_GUI_EASY_SPLITTER_CONTAINER.
DATA: O_SPLIT_L TYPE REF TO CL_GUI_EASY_SPLITTER_CONTAINER
    , O_SPLIT_R TYPE REF TO CL_GUI_EASY_SPLITTER_CONTAINER.

CONSTANTS ABAP_EDITOR_MAX_WIDTH TYPE I VALUE 255.
TYPES: BEGIN OF TS_EDIT
, TEXT TYPE CHAR255
     , END OF TS_EDIT.
TYPES TT_EDIT TYPE STANDARD TABLE OF TS_EDIT.
DATA: O_EDIT_L      TYPE REF TO CL_GUI_ABAPEDIT
    , O_EDIT_R      TYPE REF TO CL_GUI_ABAPEDIT.
DATA: O_COMPLETER_L TYPE REF TO CL_ABAP_PARSER
    , O_COMPLETER_R TYPE REF TO CL_ABAP_PARSER.

DATA: O_GRID_L TYPE REF TO CL_GUI_ALV_GRID
    , O_GRID_R TYPE REF TO CL_GUI_ALV_GRID.


INITIALIZATION.
  PERFORM SET_TEXT.
  PERFORM CHECK_DBTAB_EXIST.



START-OF-SELECTION.
  CALL SCREEN 0100.



************************************************************************
************************************************************************
************************************************************************
MODULE EXIT INPUT.
  CASE OK_CODE.
    WHEN 'CANC' OR 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
************************************************************************
************************************************************************
************************************************************************
MODULE STATUS_0100 OUTPUT.
  PERFORM SET_STATUS.

  IF O_DNKNG IS NOT BOUND.
    PERFORM CREATE_CONTAINER.
    PERFORM CREATE_ALV USING: O_EDIT_L   O_SPLIT_L   O_COMPLETER_L   O_GRID_L   DATA_FIELDNAME_L
                            , O_EDIT_R   O_SPLIT_R   O_COMPLETER_R   O_GRID_R   DATA_FIELDNAME_R.
  ENDIF.
ENDMODULE.
************************************************************************
************************************************************************
************************************************************************
  MODULE USER_COMMAND_0100 INPUT.
    CLEAR S_ERR_INFO.

    CASE OK_CODE.
      WHEN USER_COMMAND-RUN_ALL.
        IF EXIST_SAVING_TABLE = ABAP_TRUE.
          PERFORM SAVE.
        ENDIF.
        PERFORM RUN USING: O_GRID_L   O_EDIT_L
                         , O_GRID_R   O_EDIT_R.

      WHEN USER_COMMAND-RUN_LEFT.
        IF EXIST_SAVING_TABLE = ABAP_TRUE.
          PERFORM SAVE.
        ENDIF.
        PERFORM RUN USING: O_GRID_L   O_EDIT_L.

      WHEN USER_COMMAND-RUN_RIGHT.
        IF EXIST_SAVING_TABLE = ABAP_TRUE.
          PERFORM SAVE.
        ENDIF.
        PERFORM RUN USING: O_GRID_R   O_EDIT_R.

      WHEN USER_COMMAND-SAVE.
        CHECK EXIST_SAVING_TABLE = ABAP_TRUE. "MODULE EXIT.
        PERFORM SAVE.

      WHEN USER_COMMAND-HOW_TO_USE.
        PERFORM HOW_TO_USE.
    ENDCASE.
  ENDMODULE.
************************************************************************
************************************************************************
************************************************************************



************************************************************************
************************************************************************
************************************************************************
FORM CHECK_DBTAB_EXIST .
  SELECT COUNT(*) FROM (      DD02L AS _A
                         JOIN DD03L AS _B ON     _B~TABNAME  = _A~TABNAME
                                             AND _B~AS4LOCAL = _A~AS4LOCAL
                                             AND _B~AS4VERS  = _A~AS4VERS
                                             AND _A~TABNAME  = @SAVING_TABLE_NAME )
                  JOIN DD03L   AS B ON     B~FIELDNAME = @CLIENT_FIELDNAME
                                       AND B~TABNAME   = _A~TABNAME
                                       AND B~DOMNAME   = 'MADNT'
                  JOIN DD03L   AS C ON     C~FIELDNAME = @USER_FIELDNAME
                                       AND C~TABNAME   = _A~TABNAME
                                       AND C~DOMNAME   = 'SYCHAR12'
                  JOIN DD03L   AS D ON     D~FIELDNAME = @DATA_FIELDNAME_L
                                       AND D~TABNAME   = _A~TABNAME
                                       AND D~DOMNAME   = 'RAWSTRING'
                  JOIN DD03L   AS E ON     E~FIELDNAME = @DATA_FIELDNAME_R
                                       AND E~TABNAME   = _A~TABNAME
                                       AND E~DOMNAME   = 'RAWSTRING'
    INTO @DATA(LV_COUNT).



*  WITH +FIELDS AS ( SELECT FROM DD02L AS A
*                           JOIN DD03L AS B ON     B~TABNAME  = A~TABNAME
*                                              AND B~AS4LOCAL = A~AS4LOCAL
*                                              AND B~AS4VERS  = A~AS4VERS
*                      FIELDS A~TABNAME
*                      WHERE A~TABNAME = @SAVING_TABLE_NAME )
*  SELECT COUNT(*) FROM +FIELDS AS A
*                  JOIN DD03L   AS B ON     B~FIELDNAME = @CLIENT_FIELDNAME
*                                       AND B~TABNAME   = A~TABNAME
*                                       AND B~DOMNAME   = 'MADNT'
*                  JOIN DD03L   AS C ON     C~FIELDNAME = @USER_FIELDNAME
*                                       AND C~TABNAME   = A~TABNAME
*                                       AND C~DOMNAME   = 'SYCHAR12'
*                  JOIN DD03L   AS D ON     D~FIELDNAME = @DATA_FIELDNAME_L
*                                       AND D~TABNAME   = A~TABNAME
*                                       AND D~DOMNAME   = 'RAWSTRING'
*                  JOIN DD03L   AS E ON     E~FIELDNAME = @DATA_FIELDNAME_R
*                                       AND E~TABNAME   = A~TABNAME
*                                       AND E~DOMNAME   = 'RAWSTRING'
*    INTO @DATA(LV_COUNT).
  IF SY-SUBRC = 0.
    EXIST_SAVING_TABLE = ABAP_TRUE.
  ENDIF.
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM CREATE_CONTAINER.
  O_DNKNG = NEW #( REPID     = SY-REPID
                   DYNNR     = SY-DYNNR
                   SIDE      = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_TOP
                   EXTENSION = 500 ).

  O_SPLIT_VERTICAL = NEW #( PARENT      = O_DNKNG
                            ORIENTATION = 1 ).

  O_SPLIT_L = NEW #( PARENT      = O_SPLIT_VERTICAL->TOP_LEFT_CONTAINER
                     ORIENTATION = 0 ).
  O_SPLIT_R = NEW #( PARENT      = O_SPLIT_VERTICAL->BOTTOM_RIGHT_CONTAINER
                     ORIENTATION = 0 ).
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM CREATE_ALV USING IO_EDIT       TYPE REF TO CL_GUI_ABAPEDIT
                      IO_SPLIT      TYPE REF TO CL_GUI_EASY_SPLITTER_CONTAINER
                      IO_COMPLETER  TYPE REF TO CL_ABAP_PARSER
                      IO_GRID       TYPE REF TO CL_GUI_ALV_GRID
                      IV_DATA_FIELD TYPE        LVC_FNAME.
  IO_EDIT = NEW #( PARENT           = IO_SPLIT->TOP_LEFT_CONTAINER
                   MAX_NUMBER_CHARS = ABAP_EDITOR_MAX_WIDTH ).
*  IO_EDIT = NEW #( PARENT           = IO_SPLIT->TOP_LEFT_CONTAINER
*                   MAX_NUMBER_CHARS = ABAP_EDITOR_MAX_WIDTH
*                   SOURCE_TYPE      = 'ABAP' ).
  IO_EDIT->SET_TOOLBAR_MODE( TOOLBAR_MODE = CL_GUI_ABAPEDIT=>TRUE ).
  IO_EDIT->SET_STATUSBAR_MODE( STATUSBAR_MODE = CL_GUI_ABAPEDIT=>TRUE ).

  DATA: LT_EDIT  TYPE TT_EDIT
      , LV_DATA  TYPE XSTRING
      , LV_WHERE TYPE STRING.

  IF EXIST_SAVING_TABLE = ABAP_TRUE.
    LV_WHERE = |{ USER_FIELDNAME } = @SY-UNAME|.
    SELECT SINGLE (IV_DATA_FIELD) FROM (SAVING_TABLE_NAME)
      WHERE (LV_WHERE)
      INTO @LV_DATA.

    IF LV_DATA IS NOT INITIAL.
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY' EXPORTING BUFFER     = LV_DATA
                                             TABLES    BINARY_TAB = LT_EDIT.
    ENDIF.
  ENDIF.

  IO_EDIT->SET_TEXT( TABLE = LT_EDIT ).

  IO_EDIT->INIT_COMPLETER( ).
  IO_COMPLETER = IO_EDIT->GET_COMPLETER( ).

  SET HANDLER IO_COMPLETER->HANDLE_COMPLETION_REQUEST
              IO_COMPLETER->HANDLE_INSERTION_REQUEST
              IO_COMPLETER->HANDLE_QUICKINFO_REQUEST  FOR IO_EDIT.
  IO_EDIT->REGISTER_EVENT_COMPLETION( ).
  IO_EDIT->REGISTER_EVENT_INSERT_PATTERN( ).
  IO_EDIT->REGISTER_EVENT_QUICK_INFO( ).

  IO_GRID = NEW #( I_PARENT = IO_SPLIT->BOTTOM_RIGHT_CONTAINER ).

  CL_GUI_CONTROL=>SET_FOCUS( CONTROL = IO_EDIT ).
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM RUN USING IO_GRID TYPE REF TO CL_GUI_ALV_GRID
               IO_EDIT TYPE REF TO CL_GUI_ABAPEDIT.
DATA LT_EDIT TYPE TT_EDIT.
TRY.
  IO_EDIT->GET_TEXT( IMPORTING TABLE = LT_EDIT ).

CATCH CX_ROOT.

ENDTRY.
  IF LT_EDIT IS INITIAL.
    EXIT.
  ENDIF.


"<<-- 2025-11-30  05DA7F88AE7A1FE0B3B5F26B239F46F6 -----------------------------------------------<<
" 쿼리뿐 아니라 아무 코드나 실행할 수 있게 수정.
  " AS-IS CODE ------------------------------------
  " DATA LV_IS_SINGLE TYPE XFELD.
  " PERFORM EDIT_SQL_QUERY CHANGING LT_EDIT
  "                                 LV_IS_SINGLE.
  " IF S_ERR_INFO IS NOT INITIAL.
  "   RETURN.
  " ENDIF.
  "
  " PERFORM SET_INTO_CLAUSE USING    LV_IS_SINGLE
  "                         CHANGING LT_EDIT.
"-->> 2025-11-30  05DA7F88AE7A1FE0B3B5F26B239F46F6 ----------------------------------------------->>

DATA: LR_T_GRID TYPE REF TO DATA
    , LV_TITLE  TYPE        LVC_TITLE.
PERFORM _RUN USING    LT_EDIT
                      IO_EDIT
             CHANGING LR_T_GRID
                      LV_TITLE.
IF S_ERR_INFO IS NOT INITIAL.
  RETURN.
ENDIF.

DATA LT_FCAT TYPE LVC_T_FCAT.
PERFORM GET_FCAT USING    LR_T_GRID
                 CHANGING LT_FCAT.

PERFORM DISPLAY_ALV USING    LV_TITLE
                             IO_GRID
                    CHANGING LR_T_GRID
                             LT_FCAT.
ENDFORM.
*&-------------------------------------------------------------------------------------------------*
*&-------------------------------------------------------------------------------------------------*
*&-------------------------------------------------------------------------------------------------*
*&-------------------------------------------------------------------------------------------------*
FORM EDIT_SQL_QUERY CHANGING CT_EDIT      TYPE TT_EDIT
                             CV_IS_SINGLE TYPE XFELD.
  LOOP AT CT_EDIT ASSIGNING FIELD-SYMBOL(<LS_EDIT>)
                  WHERE TABLE_LINE IS NOT INITIAL.
    TRANSLATE <LS_EDIT>-TEXT TO UPPER CASE.

    IF <LS_EDIT>(1) = '*' OR <LS_EDIT>(1) = '"' .
      CONTINUE.
    ENDIF.

    "CHECK SELECT
    IF SY-TABIX = 1.
      SHIFT <LS_EDIT> LEFT DELETING LEADING SPACE.
      IF NOT ( <LS_EDIT> CP 'SELECT*' OR <LS_EDIT> CP 'WITH*' ).
        S_ERR_INFO-CODE = '8C09'.
        S_ERR_INFO-MSG = TEXT_S99.
        MESSAGE |{ S_ERR_INFO-MSG } (ErrCode { S_ERR_INFO-CODE })| TYPE 'I'.
        RETURN.
      ENDIF.
    ENDIF.

    "DELETE_CLOSE_DOT
    FIND '.' IN <LS_EDIT> IN CHARACTER MODE RESULTS DATA(LS_FIND).
      IF SY-SUBRC = 0.
        <LS_EDIT>-TEXT+LS_FIND-OFFSET(1) = SPACE.
      ENDIF.

    "DELETE SINGLE KEYWORD
    IF <LS_EDIT>-TEXT CS 'SINGLE'.
      IF    <LS_EDIT>-TEXT CS 'SELECT' "SELECT SINGLE
         OR (     SY-TABIX > 1 "SELECT<br>SINGLE
              AND CT_EDIT[ SY-TABIX - 1 ]-TEXT CS 'SELECT' ).
*        "WITH는 안에서 SIGNLE 못 써서 상관 없음
        REPLACE ALL OCCURRENCES OF 'SINGLE' IN <LS_EDIT>-TEXT WITH SPACE.
        CV_IS_SINGLE = ABAP_TRUE.
      ENDIF.
    ENDIF.

    "주석은 어차피 무시되서 제거 안 함
  ENDLOOP.
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM SET_INTO_CLAUSE USING    IV_IS_SINGLE TYPE XFELD
                     CHANGING CT_EDIT      TYPE TT_EDIT.
  LOOP AT CT_EDIT ASSIGNING FIELD-SYMBOL(<LS_EDIT>) WHERE    TABLE_LINE CS 'INTO'
                                                          OR TABLE_LINE CS 'APPENDING'.
    IF    <LS_EDIT>-TEXT CS 'CORRESPONDING'
       OR <LS_EDIT>-TEXT CS 'TABLE'
       OR <LS_EDIT>-TEXT CS '@DATA'.
      CLEAR <LS_EDIT>.
    ENDIF.
  ENDLOOP.

  APPEND VALUE #( TEXT = |INTO TABLE @DATA({ TEMPORARY_ITAB_NAME })| ) TO CT_EDIT.

  IF IV_IS_SINGLE = ABAP_TRUE.
    APPEND VALUE #( TEXT = |UP TO 1 ROWS| ) TO CT_EDIT.
  ENDIF.

  APPEND VALUE #( TEXT = |.| ) TO CT_EDIT.
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM _RUN USING    IT_EDIT   TYPE        TT_EDIT
                   IO_EDIT   TYPE REF TO CL_GUI_ABAPEDIT
          CHANGING CR_T_GRID TYPE REF TO DATA
                   CV_TITLE  TYPE        LVC_TITLE.
  DATA LT_REPORT TYPE TABLE OF CHAR255.

  LT_REPORT = VALUE #( ( 'REPORT ZSQL_SUBROUTINEPOOL.' )
                       ( 'FORM GET_DATA CHANGING CR_T_GRID TYPE REF TO DATA.' )
                       (   'TRY.' ) ).
  LT_REPORT = VALUE #( BASE LT_REPORT
                       FOR <LS_EDIT> IN IT_EDIT
                       ( CONV CHAR255( <LS_EDIT>-TEXT ) ) ##OPERATOR[CHAR255]
              ).
  LT_REPORT = VALUE #( BASE LT_REPORT
                       (   'CATCH CX_ROOT.' )
                       (   'ENDTRY.' )

                       (   |FIELD-SYMBOLS <LT_DATA> TYPE ANY.| )
                       (   |ASSIGN ('{ TEMPORARY_ITAB_NAME }') TO <LT_DATA>.| )
                       (   |IF SY-SUBRC <> 0.| )
                       (     |DATA LR_T_DUMMY TYPE REF TO DATA.| )
                       (     |DATA: BEGIN OF LS_DUMMY| )
                       (     |, DUMMY TYPE STRING.| )
                       (     |DATA END   OF LS_DUMMY.| )
                       (     |CREATE DATA LR_T_DUMMY LIKE STANDARD TABLE OF LS_DUMMY.| )
                       (     |ASSIGN LR_T_DUMMY->* TO <LT_DATA>.| )
                       (   |ENDIF.| )

                       (   |CREATE DATA CR_T_GRID LIKE <LT_DATA>.| )
                       (   |ASSIGN CR_T_GRID->* TO FIELD-SYMBOL(<LT_GRID>).| )
                       (   |<LT_GRID> = <LT_DATA>.| )
                       ( 'ENDFORM.' ) ).


  DATA LV_SUBROUTINEPOOL TYPE SY-REPID.
  GENERATE SUBROUTINE POOL LT_REPORT NAME    LV_SUBROUTINEPOOL
                                     MESSAGE DATA(LV_MSG)
                                     LINE    DATA(LV_LINE).
  IF SY-SUBRC <> 0.
    S_ERR_INFO-MSG = |{ LV_LINE - 3 }행에서 에러 발행. { LV_MSG }|.
    S_ERR_INFO-CODE = 'F8C7'.
    MESSAGE |{ S_ERR_INFO-MSG } (ErrCode { S_ERR_INFO-CODE })| TYPE 'I'.
    RETURN.
  ENDIF.


*  DATA: LV_BEFORE TYPE UTCLONG
*      , LV_DIFF   TYPE DECFLOAT34.
*  LV_BEFORE = UTCLONG_CURRENT( ).

  PERFORM GET_DATA IN PROGRAM (LV_SUBROUTINEPOOL)
                   IF FOUND
                   CHANGING CR_T_GRID.
  IF S_ERR_INFO IS INITIAL.
*    LV_DIFF = UTCLONG_DIFF( LOW  = LV_BEFORE
*                            HIGH = UTCLONG_CURRENT( ) ).
*    CV_TITLE = |The time required: { LV_DIFF } Sec.|.
  ENDIF.
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM GET_FCAT USING    IR_T_GRID TYPE REF TO DATA
              CHANGING CT_FCAT   TYPE        LVC_T_FCAT.
  FIELD-SYMBOLS <LT_GRID> TYPE ANY TABLE.
  ASSIGN IR_T_GRID->* TO <LT_GRID>.
    IF <LT_GRID> IS NOT ASSIGNED.
      S_ERR_INFO-CODE = 'FA31'.
      S_ERR_INFO-MSG = 'Error'.

      MESSAGE |{ S_ERR_INFO-MSG } (ErrCode { S_ERR_INFO-CODE })|
              TYPE 'I' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

  DATA(O_TABLE) = CAST CL_ABAP_TABLEDESCR( CL_ABAP_TYPEDESCR=>DESCRIBE_BY_DATA( <LT_GRID> ) ).
  DATA(O_STRUCT) = CAST CL_ABAP_STRUCTDESCR( O_TABLE->GET_TABLE_LINE_TYPE( ) ).
  DATA(T_DFIES) = CL_SALV_DATA_DESCR=>READ_STRUCTDESCR( O_STRUCT ).

  DATA LR_S_GRID TYPE REF TO DATA.
  CREATE DATA LR_S_GRID LIKE LINE OF <LT_GRID>.
  FIELD-SYMBOLS <LS_GRID> TYPE ANY.
  ASSIGN LR_S_GRID->* TO <LS_GRID>.
    IF <LS_GRID> IS NOT ASSIGNED.
      S_ERR_INFO-CODE = 'A7C8'.
      S_ERR_INFO-MSG = 'Error'.

      MESSAGE |{ S_ERR_INFO-MSG } (ErrCode { S_ERR_INFO-CODE })|
              TYPE 'I' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.


  LOOP AT T_DFIES ASSIGNING FIELD-SYMBOL(<LS_DFIES>).
    INSERT INITIAL LINE INTO TABLE CT_FCAT ASSIGNING FIELD-SYMBOL(<LS_FCAT>).

    <LS_FCAT> = CORRESPONDING #( <LS_DFIES> MAPPING REF_FIELD = REFFIELD
                                                    REF_TABLE = REFTABLE ).
    <LS_FCAT>-COL_OPT = 'A'.

    ASSIGN COMPONENT <LS_FCAT>-FIELDNAME OF STRUCTURE <LS_GRID> TO FIELD-SYMBOL(<LV_COMPONENT>).
      IF <LV_COMPONENT> IS ASSIGNED.
        DESCRIBE FIELD <LV_COMPONENT> HELP-ID DATA(LV_HELPID).
        IF LV_HELPID IS NOT INITIAL.
          SPLIT LV_HELPID AT '-' INTO <LS_FCAT>-REF_TABLE
                                      <LS_FCAT>-REF_FIELD.
        ENDIF.
      ENDIF.
    UNASSIGN <LV_COMPONENT>.
    CLEAR LV_HELPID.

    "필드라벨 추가
    <LS_FCAT>-COLTEXT = |{ <LS_FCAT>-FIELDNAME }|
                     && |{ COND #(
                             WHEN <LS_FCAT>-REPTEXT   IS NOT INITIAL THEN | ({ <LS_FCAT>-REPTEXT })|
                             WHEN <LS_FCAT>-SCRTEXT_L IS NOT INITIAL THEN | ({ <LS_FCAT>-SCRTEXT_L })|
                             WHEN <LS_FCAT>-SCRTEXT_M IS NOT INITIAL THEN | ({ <LS_FCAT>-SCRTEXT_M })|
                             WHEN <LS_FCAT>-SCRTEXT_S IS NOT INITIAL THEN | ({ <LS_FCAT>-SCRTEXT_S })|
                           ) }|.
    "데이터 출처 추가
    <LS_FCAT>-TOOLTIP = COND #( WHEN <LS_FCAT>-REF_TABLE IS NOT INITIAL THEN |{ <LS_FCAT>-REF_TABLE }~{ <LS_FCAT>-REF_FIELD }| ).
  ENDLOOP.
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM DISPLAY_ALV USING    IV_TITLE  TYPE        LVC_TITLE
                          IO_GRID   TYPE REF TO CL_GUI_ALV_GRID
                 CHANGING CR_T_GRID TYPE REF TO DATA
                          CT_FCAT   TYPE        LVC_T_FCAT.
  FIELD-SYMBOLS <LT_GRID> TYPE ANY TABLE.
  ASSIGN CR_T_GRID->* TO <LT_GRID>.

  IO_GRID->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT            = VALUE #( CWIDTH_OPT = 'A'
      GRID_TITLE           = |{ LINES( <LT_GRID> ) } Rows. ({ IV_TITLE })|
      SEL_MODE             = 'A'
      SMALLTITLE           = ABAP_TRUE
      ZEBRA                = ABAP_TRUE )
      IT_TOOLBAR_EXCLUDING = VALUE #( ( CL_GUI_ALV_GRID=>MC_MB_VIEW              )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO          )
                                      ( CL_GUI_ALV_GRID=>MC_FC_AUF               )
                                      ( CL_GUI_ALV_GRID=>MC_FC_GRAPH             )
                                      ( CL_GUI_ALV_GRID=>MC_FC_INFO              )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY          )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW      )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_CUT           )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW    )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW    )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_MOVE_ROW      )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_APPEND_ROW    )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE         )
                                      ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW )
                                      ( CL_GUI_ALV_GRID=>MC_FC_PRINT             )
                                      ( CL_GUI_ALV_GRID=>MC_FC_REFRESH           ) )
    CHANGING
      IT_OUTTAB       = <LT_GRID>
      IT_FIELDCATALOG = CT_FCAT ).
ENDFORM.
************************************************************************
************************************************************************
************************************************************************
FORM SAVE.
  DATA LR_S_TAB TYPE REF TO DATA.
  CREATE DATA LR_S_TAB TYPE (SAVING_TABLE_NAME).
  ASSIGN LR_S_TAB->* TO FIELD-SYMBOL(<LS_TAB>).

  ASSIGN COMPONENT CLIENT_FIELDNAME OF STRUCTURE <LS_TAB> TO FIELD-SYMBOL(<LV_MANDT>).
  <LV_MANDT> = SY-MANDT.

  ASSIGN COMPONENT USER_FIELDNAME OF STRUCTURE <LS_TAB> TO FIELD-SYMBOL(<LV_USER>).
  <LV_USER> = SY-UNAME.




  DATA: LT_TAB    TYPE TT_EDIT
      , LV_DATA_L TYPE XSTRING
      , LV_DATA_R LIKE LV_DATA_L.
  FIELD-SYMBOLS: <LV_DATA> LIKE LV_DATA_L
               , <O_EDIT>  LIKE O_EDIT_L
               , <LV_FIELD> TYPE FIELDNAME.

  DO 2 TIMES.
    CASE SY-INDEX.
      WHEN 1. "L
        ASSIGN: LV_DATA_L        TO <LV_DATA>
              , O_EDIT_L         TO <O_EDIT>
              , DATA_FIELDNAME_L TO <LV_FIELD>.
      WHEN 2. "R
        ASSIGN: LV_DATA_R        TO <LV_DATA>
              , O_EDIT_R         TO <O_EDIT>
              , DATA_FIELDNAME_R TO <LV_FIELD>.
    ENDCASE.


    TRY.
      <O_EDIT>->GET_TEXT( IMPORTING TABLE = LT_TAB ).
    CATCH CX_ROOT INTO DATA(LX_ROOT).
      S_ERR_INFO-CODE = 'AF71'.
      S_ERR_INFO-MSG = LX_ROOT->GET_TEXT( ).
      MESSAGE |{ S_ERR_INFO-MSG } (ErrCode { S_ERR_INFO-CODE })| TYPE 'I'.
      RETURN.
    ENDTRY.

    IF LT_TAB IS INITIAL.
      S_ERR_INFO-CODE = 'C820'.
      S_ERR_INFO-MSG = TEXT_S98.

      MESSAGE |{ S_ERR_INFO-MSG } (ErrCode { S_ERR_INFO-CODE })|
              TYPE 'I' DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    CL_ABAP_MEMORY_UTILITIES=>GET_TOTAL_USED_SIZE( IMPORTING SIZE = DATA(LV_LENGTH) ).

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING' EXPORTING  INPUT_LENGTH = CONV I( LV_LENGTH )
                                           IMPORTING  BUFFER       = <LV_DATA>
                                           TABLES     BINARY_TAB   = LT_TAB
                                           EXCEPTIONS FAILED       = 1
                                                      OTHERS       = 2.
    IF SY-SUBRC <> 0.
      S_ERR_INFO-CODE = 'FB0C'.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4
              INTO S_ERR_INFO-MSG.
      RETURN.
    ENDIF.

    ASSIGN COMPONENT <LV_FIELD> OF STRUCTURE <LS_TAB> TO FIELD-SYMBOL(<LV_DATA_DB>).
    <LV_DATA_DB> = <LV_DATA>.
  ENDDO.


  MODIFY (SAVING_TABLE_NAME) FROM <LS_TAB>.
    IF SY-SUBRC <> 0.
      S_ERR_INFO-CODE = 'D372'.
      S_ERR_INFO-MSG = TEXT_S97.
      MESSAGE |{ S_ERR_INFO-MSG } (ErrCode { S_ERR_INFO-CODE })|
              TYPE 'I' DISPLAY LIKE 'E'.
      ROLLBACK WORK.
      RETURN.
    ENDIF.

  COMMIT WORK.
  MESSAGE TEXT_S96 TYPE 'S'.
ENDFORM.
*&-------------------------------------------------------------------------------------------------*
*&-------------------------------------------------------------------------------------------------*
*&-------------------------------------------------------------------------------------------------*
*&-------------------------------------------------------------------------------------------------*
FORM HOW_TO_USE.
DATA LV_HELP TYPE C LENGTH 300.
LV_HELP =    |'{ TEMPORARY_ITAB_NAME }'이란 이름의 인터널 테이블에 데이터를 |
          && |넣으면 되고, 타입은 원하는 대로 지정해서 선언하면 됩니다.|.
MESSAGE LV_HELP TYPE 'I'.
ENDFORM.



FORM SET_STATUS .
  DATA LT_EXCLUDE TYPE TABLE OF SYST_UCOMM.

  IF EXIST_SAVING_TABLE = ABAP_FALSE.
    INSERT USER_COMMAND-SAVE INTO TABLE LT_EXCLUDE.
  ENDIF.

  CASE SY-DYNNR.
    WHEN '0100'.
      SET PF-STATUS 'STATUS_0100' EXCLUDING LT_EXCLUDE.
      SET TITLEBAR 'TITLE_0100' WITH `'LT_DATA'에 값 넣으면 됩니다.`.
  ENDCASE.
ENDFORM.



FORM SET_TEXT .
  TEXT_S96 = SWITCH #( SY-LANGU WHEN '3' THEN '저장되었습니다.'
                                ELSE 'Data is saved.' ).
  TEXT_S97 = SWITCH #( SY-LANGU WHEN '3' THEN '데이터 저장에 실패했습니다.'
                                ELSE 'Data saving is failed.' ).
  TEXT_S98 = SWITCH #( SY-LANGU
               WHEN '3' THEN '저장할 데이터가 없습니다.'
               ELSE 'Data to save not exists.'
             ).
  TEXT_S99 = SWITCH #( SY-LANGU
               WHEN '3' THEN 'SELECT 문만 사용할 수 있습니다.'
               ELSE 'Only SELECT is possible.'
             ).
ENDFORM.
