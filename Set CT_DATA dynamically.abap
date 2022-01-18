METHOD if_fpm_guibb_list~get_data.

    IF mr_data IS NOT BOUND.
      CREATE DATA mr_data LIKE ct_data.
    ENDIF.

    ASSIGN mr_data->* TO FIELD-SYMBOL(<ui_data>).
    <ui_data> = CORRESPONDING #( mt_data ).
    IF ct_data NE <ui_data>.
      ct_data = <ui_data>.
      ev_data_changed = abap_true.
    ENDIF.
    
  ENDMETHOD.
