FORM set_fieldcatalog .

  PERFORM make_fcat USING gt_main[]
                          gt_fieldcat_0100[].

  LOOP AT gt_fieldcat_0100 INTO gs_fieldcat.
    CASE gs_fieldcat-fieldname.
      WHEN 'MANDT'. m_fieldcat_text TEXT-f01. "Client
      WHEN 'MARK'.  gs_fieldcat-no_out = 'X'.
    ENDCASE.
    MODIFY gt_fieldcat_0100 FROM gs_fieldcat.
  ENDLOOP.

ENDFORM.

FORM make_fcat  USING pt_tab    TYPE table
                      pt_fcat   TYPE lvc_t_fcat.

  DATA: lo_dref TYPE REF TO data.

  CREATE DATA lo_dref LIKE pt_tab.
  FIELD-SYMBOLS <lt_tab> TYPE table.
  ASSIGN lo_dref->* TO <lt_tab>.

  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = DATA(lr_table)
        CHANGING
          t_table      = <lt_tab>.
    CATCH cx_salv_msg.
  ENDTRY.

  pt_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
              r_columns      = lr_table->get_columns( )
              r_aggregations = lr_table->get_aggregations( )
              ).

ENDFORM.
