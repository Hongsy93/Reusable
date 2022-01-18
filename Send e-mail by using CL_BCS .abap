DATA: lo_send_request      TYPE REF TO cl_bcs,
      l_subject            TYPE so_obj_des,
* lt_body TYPE solix_tab,
      lt_body              TYPE soli_tab,
      ls_body              LIKE LINE OF lt_body,
      lo_document          TYPE REF TO cl_document_bcs,
      lx_document_bcs      TYPE REF TO cx_document_bcs,
      l_persnumber         LIKE adrp-persnumber,
      l_addrnumber         LIKE adrc-addrnumber,
      lt_adsmtp            TYPE TABLE OF adsmtp WITH HEADER LINE,
      lo_sender            TYPE REF TO if_sender_bcs,
      lo_recipient         TYPE REF TO if_recipient_bcs,
      l_sender_email       TYPE adr6-smtp_addr,
      l_receiver_email     TYPE adr6-smtp_addr,
      lv_with_error_screen TYPE os_boolean,
      lv_sent_to_all       TYPE os_boolean.
"-------------------------------------------"
" Send Email
"-------------------------------------------"
TRY .
    "Create send request
    lo_send_request = cl_bcs=>create_persistent( ).
    l_subject = 'Subject Test'.
    ls_body-line = '<a href=https://www.glovis.net/Kor/main/index.do>URL : Hyundai Glovis</a>'.
    APPEND ls_body TO lt_body.
    " Send in HTML format
    lo_document = cl_document_bcs=>create_document(
    i_type = 'HTM'
    i_subject = l_subject
    i_text = lt_body
* i_hex = lt_body
    ).
    " set the e-mail address of the sender:
    lo_sender = cl_sapuser_bcs=>create( sy-uname ).
    " set the e-mail address of the recipient
    l_receiver_email = 'D200038@glovis-partner.net'.
    lo_recipient = cl_cam_address_bcs=>create_internet_address(
    i_address_string = l_receiver_email
    ).
    "****************************"
    " EMAIL
    "*****************************"
    " set the e-mail address of the sender:
    lo_send_request->add_recipient(
    EXPORTING
    i_recipient = lo_recipient
    i_express = 'X'
    ).
    " assign document to the send request:
    lo_send_request->set_document( lo_document ).
    " add the sender:
    lo_send_request->set_sender( lo_sender ).
    lo_send_request->set_send_immediately( abap_true ). "«ÿ¡‡æfl ¹Ÿ·OE ¸fi¿oe °®.
    MOVE space TO lv_with_error_screen.
    " SAP Send Email CL_BCS
    lv_sent_to_all = lo_send_request->send( lv_with_error_screen ).
    IF lv_sent_to_all = abap_true.
      WRITE:/ 'Successfully Sent'.
      COMMIT WORK.
    ENDIF.
  CATCH cx_document_bcs INTO lx_document_bcs.
    WRITE:/ 'Error!'.
ENDTRY.
