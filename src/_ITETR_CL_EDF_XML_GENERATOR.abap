CLASS /itetr/cl_edf_xml_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES BEGIN OF mty_k_mapping.
    TYPES accountmainid(10).
    TYPES index_head TYPE i.
    TYPES END OF mty_k_mapping.

    TYPES mtty_k_mapping TYPE SORTED TABLE OF mty_k_mapping WITH UNIQUE KEY accountmainid.

    TYPES BEGIN OF mty_y_mapping.
    TYPES linenumbercounter TYPE /itetr/edf_yvmy_no.
    TYPES index_head TYPE i.
    TYPES END OF mty_y_mapping.

    TYPES mtty_y_mapping TYPE SORTED TABLE OF mty_y_mapping WITH UNIQUE KEY linenumbercounter.

    DATA ms_header  TYPE /itetr/edf_s_xml_header .
    DATA ms_root_y  TYPE /itetr/if_edf_xml_y=>ty_root .
    DATA ms_root_yb TYPE /itetr/if_edf_xml_yb=>ty_root .
    DATA ms_root_k               TYPE /itetr/if_edf_xml_k=>ty_root .
    DATA ms_root_kb              TYPE /itetr/if_edf_xml_kb=>ty_root .
    DATA ms_root_dr              TYPE /itetr/if_edf_xml_dr=>ty_root .
    CONSTANTS mc_journal_context TYPE string VALUE 'journal_context'.
    CONSTANTS mc_journal TYPE string VALUE 'journal'.
    CONSTANTS mc_inf TYPE string VALUE 'INF'.
    CONSTANTS mc_countable TYPE string VALUE 'countable'.

    METHODS identifier
      IMPORTING
        !iv_xmlty TYPE /itetr/edf_e_xml_types .
    METHODS instant
      IMPORTING
        !iv_xmlty TYPE /itetr/edf_e_xml_types .
    METHODS unit
      IMPORTING
        !iv_xmlty TYPE /itetr/edf_e_xml_types .
    METHODS documentinfo
      IMPORTING
        !iv_xmlty TYPE /itetr/edf_e_xml_types .
    METHODS entityinformation
      IMPORTING
        !iv_xmlty TYPE /itetr/edf_e_xml_types .
    METHODS accountantinformation
      IMPORTING
        !iv_xmlty TYPE /itetr/edf_e_xml_types .
    METHODS set_header
      IMPORTING
        !is_header TYPE /itetr/edf_s_xml_header
        !iv_xmlty  TYPE /itetr/edf_e_xml_types .
    METHODS set_head_y
      IMPORTING
        !is_head TYPE /itetr/edf_s_xml_head .
    METHODS set_item_y
      IMPORTING
        !is_item TYPE /itetr/edf_s_xml_item .
    METHODS generate_html
      IMPORTING
        !iv_xmlty      TYPE /itetr/edf_e_xml_types
        !iv_xml        TYPE xstring
      RETURNING
        VALUE(rv_html) TYPE xstring .
    METHODS generate_xml
      IMPORTING
        !iv_xmlty     TYPE /itetr/edf_e_xml_types
      RETURNING
        VALUE(rv_xml) TYPE xstring .
    METHODS save
      IMPORTING
        !iv_bukrs TYPE bukrs
        !iv_bcode TYPE /itetr/edf_bcode
        !iv_gjahr TYPE gjahr
        !iv_monat TYPE monat
        !iv_partn TYPE /itetr/edf_part_no .
    METHODS set_head_yb
      IMPORTING
        !is_head TYPE /itetr/edf_s_xml_head .
    METHODS set_item_yb
      IMPORTING
        !is_item TYPE /itetr/edf_s_xml_item .
    METHODS set_head_gib_yb
      IMPORTING
        !is_head TYPE /itetr/edf_s_xml_head .
    METHODS set_item_gib_yb
      IMPORTING
        !is_item TYPE /itetr/edf_s_xml_item .
    METHODS set_head_k
      IMPORTING
        !is_head TYPE /itetr/edf_s_xml_head .
    METHODS set_item_k
      IMPORTING
        !is_item TYPE /itetr/edf_s_xml_item .
    METHODS set_head_kb
      IMPORTING
        !is_head TYPE /itetr/edf_s_xml_head .
    METHODS set_item_kb
      IMPORTING
        !is_item TYPE /itetr/edf_s_xml_item .
    METHODS set_head_gib_kb
      IMPORTING
        !is_head TYPE /itetr/edf_s_xml_head .
    METHODS set_item_gib_kb
      IMPORTING
        !is_item TYPE /itetr/edf_s_xml_item .
    METHODS set_head_dr
      IMPORTING
        !is_head TYPE /itetr/edf_s_xml_head .
    METHODS set_item_dr
      IMPORTING
        !is_item TYPE /itetr/edf_s_xml_item .
protected section.
PRIVATE SECTION.

  DATA ms_root_gib_yb TYPE /itetr/if_edf_xml_yb=>ty_root .
  DATA ms_root_gib_kb TYPE /itetr/if_edf_xml_kb=>ty_root .
  CONSTANTS mc_standard TYPE string VALUE 'standard'.
  CONSTANTS mc_period_change TYPE string VALUE 'period_change'.
  CONSTANTS mc_ledger_context TYPE string VALUE 'ledger_context'.
  CONSTANTS mc_now TYPE string VALUE 'now'.
  DATA mt_k_mapping TYPE mtty_k_mapping .
  DATA mt_y_mapping TYPE mtty_y_mapping .
ENDCLASS.



CLASS /ITETR/CL_EDF_XML_GENERATOR IMPLEMENTATION.


  METHOD accountantinformation.
    DATA ls_smm TYPE /itetr/edf_symmb.
    FIELD-SYMBOLS <fs_accountantinformation_y> TYPE /itetr/if_edf_xml_y=>ty_accountantinformation.
    FIELD-SYMBOLS <ft_accountantinformation_y> TYPE /itetr/if_edf_xml_y=>tty_accountantinformation.

    FIELD-SYMBOLS <fs_accountantinformation_yb> TYPE /itetr/if_edf_xml_yb=>ty_accountantinformation.
    FIELD-SYMBOLS <ft_accountantinformation_yb> TYPE /itetr/if_edf_xml_yb=>tty_accountantinformation.

    FIELD-SYMBOLS <fs_accountantinformation_gyb> TYPE /itetr/if_edf_xml_yb=>ty_accountantinformation.
    FIELD-SYMBOLS <ft_accountantinformation_gyb> TYPE /itetr/if_edf_xml_yb=>tty_accountantinformation.

    FIELD-SYMBOLS <fs_accountantinformation_k> TYPE /itetr/if_edf_xml_k=>ty_accountantinformation.
    FIELD-SYMBOLS <ft_accountantinformation_k> TYPE /itetr/if_edf_xml_k=>tty_accountantinformation.

    FIELD-SYMBOLS <fs_accountantinformation_kb> TYPE /itetr/if_edf_xml_kb=>ty_accountantinformation.
    FIELD-SYMBOLS <ft_accountantinformation_kb> TYPE /itetr/if_edf_xml_kb=>tty_accountantinformation.

    FIELD-SYMBOLS <fs_accountantinformation_gkb> TYPE /itetr/if_edf_xml_kb=>ty_accountantinformation.
    FIELD-SYMBOLS <ft_accountantinformation_gkb> TYPE /itetr/if_edf_xml_kb=>tty_accountantinformation.

    FIELD-SYMBOLS <fs_accountantinformation_dr> TYPE /itetr/if_edf_xml_dr=>ty_accountantinformation.
    FIELD-SYMBOLS <ft_accountantinformation_dr> TYPE /itetr/if_edf_xml_dr=>tty_accountantinformation.
    CASE iv_xmlty.
      WHEN 1.
        ASSIGN ('ms_root_y-accountingentries-entityinformation-accountantinformation')       TO <ft_accountantinformation_y>.
        APPEND INITIAL LINE TO <ft_accountantinformation_y> ASSIGNING <fs_accountantinformation_y>.

        LOOP AT ms_header-symmb_t INTO ls_smm.

          <fs_accountantinformation_y>-accountantname-contextref                              = mc_journal_context.

          CONCATENATE ls_smm-mmtit
                      ls_smm-name
                      ls_smm-surname
                      INTO <fs_accountantinformation_y>-accountantname-content
                      SEPARATED BY space.

          "entityInformation-accountantInformation-accountantAddress-accountantBuildingNumber
          <fs_accountantinformation_y>-accountantaddress-accountantbuildingnumber-contextref  = mc_journal_context.
          <fs_accountantinformation_y>-accountantaddress-accountantbuildingnumber-content     = ls_smm-house_num.
          "entityInformation-accountantInformation-accountantAddress-accountantStreet
          <fs_accountantinformation_y>-accountantaddress-accountantstreet-contextref          = mc_journal_context.
          <fs_accountantinformation_y>-accountantaddress-accountantstreet-content             = ls_smm-adress1.
          "entityInformation-accountantInformation-accountantAddress-accountantAddressStreet2
          <fs_accountantinformation_y>-accountantaddress-accountantaddressstreet2-contextref  = mc_journal_context.
          <fs_accountantinformation_y>-accountantaddress-accountantaddressstreet2-content     = ls_smm-adress2.
          "entityInformation-accountantInformation-accountantAddress-accountantCity
          <fs_accountantinformation_y>-accountantaddress-accountantcity-contextref            = mc_journal_context.
          <fs_accountantinformation_y>-accountantaddress-accountantcity-content               = ls_smm-city.
          "entityInformation-accountantInformation-accountantAddress-accountantCountry
          <fs_accountantinformation_y>-accountantaddress-accountantcountry-contextref         = mc_journal_context.
          <fs_accountantinformation_y>-accountantaddress-accountantcountry-content            = ls_smm-country_u.
          "entityInformation-accountantInformation-accountantAddress-accountantZipOrPostalCode
          <fs_accountantinformation_y>-accountantaddress-accountantziporpostalcode-contextref = mc_journal_context.
          <fs_accountantinformation_y>-accountantaddress-accountantziporpostalcode-content    = ls_smm-postal_code.
          "accountantEngagementTypeDescription-accountantContactInformation-accountantContactPhone-accountantContactPhoneNumberDescription
          <fs_accountantinformation_y>-accountantengagementtypedesc-contextref                = mc_journal_context.

          IF ls_smm-mmtit EQ 'F.Y.'.
            <fs_accountantinformation_y>-accountantengagementtypedesc-content    = '-'.
          ELSE.
            IF ls_smm-contrname IS NOT INITIAL.
              IF <fs_accountantinformation_y>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_y>-accountantengagementtypedesc-content  = ls_smm-contrname.
              ELSE.
                CONCATENATE ls_smm-contrname
                            ','
                            <fs_accountantinformation_y>-accountantengagementtypedesc-content
                            INTO <fs_accountantinformation_y>-accountantengagementtypedesc-content
                            SEPARATED BY space.

              ENDIF.
            ENDIF.

            IF ls_smm-contrno IS NOT INITIAL.
              IF <fs_accountantinformation_y>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_y>-accountantengagementtypedesc-content = ls_smm-contrno.
              ELSE.
                CONCATENATE <fs_accountantinformation_y>-accountantengagementtypedesc-content
                            ','
                            ls_smm-contrno
                            INTO  <fs_accountantinformation_y>-accountantengagementtypedesc-content
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
          ENDIF.
          "accountantContactPhone
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-contextref = ''.
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-content    = 'bookkeeper'.
          "
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-contextref  = mc_journal_context.
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-content     = ls_smm-tel_number.
          "accountantContactFax
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-contextref      = mc_journal_context.
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-content         = ls_smm-fax_number.
          "accountantContactEmail
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-contextref = mc_journal_context.
          <fs_accountantinformation_y>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-content    = ls_smm-email.


        ENDLOOP.

      WHEN 2.
        ASSIGN ('ms_root_yb-accountingentries-entityinformation-accountantinformation')      TO <ft_accountantinformation_yb>.
        APPEND INITIAL LINE TO <ft_accountantinformation_yb> ASSIGNING <fs_accountantinformation_yb>.

        LOOP AT ms_header-symmb_t INTO ls_smm.

          <fs_accountantinformation_yb>-accountantname-contextref                              = mc_journal_context.

          CONCATENATE ls_smm-mmtit
                      ls_smm-name
                      ls_smm-surname
                      INTO <fs_accountantinformation_yb>-accountantname-content
                      SEPARATED BY space.

          "entityInformation-accountantInformation-accountantAddress-accountantBuildingNumber
          <fs_accountantinformation_yb>-accountantaddress-accountantbuildingnumber-contextref  = mc_journal_context.
          <fs_accountantinformation_yb>-accountantaddress-accountantbuildingnumber-content     = ls_smm-house_num.
          "entityInformation-accountantInformation-accountantAddress-accountantStreet
          <fs_accountantinformation_yb>-accountantaddress-accountantstreet-contextref          = mc_journal_context.
          <fs_accountantinformation_yb>-accountantaddress-accountantstreet-content             = ls_smm-adress1.
          "entityInformation-accountantInformation-accountantAddress-accountantAddressStreet2
          <fs_accountantinformation_yb>-accountantaddress-accountantaddressstreet2-contextref  = mc_journal_context.
          <fs_accountantinformation_yb>-accountantaddress-accountantaddressstreet2-content     = ls_smm-adress2.
          "entityInformation-accountantInformation-accountantAddress-accountantCity
          <fs_accountantinformation_yb>-accountantaddress-accountantcity-contextref            = mc_journal_context.
          <fs_accountantinformation_yb>-accountantaddress-accountantcity-content               = ls_smm-city.
          "entityInformation-accountantInformation-accountantAddress-accountantCountry
          <fs_accountantinformation_yb>-accountantaddress-accountantcountry-contextref         = mc_journal_context.
          <fs_accountantinformation_yb>-accountantaddress-accountantcountry-content            = ls_smm-country_u.
          "entityInformation-accountantInformation-accountantAddress-accountantZipOrPostalCode
          <fs_accountantinformation_yb>-accountantaddress-accountantziporpostalcode-contextref = mc_journal_context.
          <fs_accountantinformation_yb>-accountantaddress-accountantziporpostalcode-content    = ls_smm-postal_code.
          "accountantEngagementTypeDescription-accountantContactInformation-accountantContactPhone-accountantContactPhoneNumberDescription
          <fs_accountantinformation_yb>-accountantengagementtypedesc-contextref                = mc_journal_context.

          IF ls_smm-mmtit EQ 'F.Y.'.
            <fs_accountantinformation_yb>-accountantengagementtypedesc-content    = '-'.
          ELSE.
            IF ls_smm-contrname IS NOT INITIAL.
              IF <fs_accountantinformation_yb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_yb>-accountantengagementtypedesc-content  = ls_smm-contrname.
              ELSE.
                CONCATENATE ls_smm-contrname
                            ','
                            <fs_accountantinformation_yb>-accountantengagementtypedesc-content
                            INTO <fs_accountantinformation_yb>-accountantengagementtypedesc-content
                            SEPARATED BY space.

              ENDIF.
            ENDIF.

            IF ls_smm-contrno IS NOT INITIAL.
              IF <fs_accountantinformation_yb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_yb>-accountantengagementtypedesc-content = ls_smm-contrno.
              ELSE.
                CONCATENATE <fs_accountantinformation_yb>-accountantengagementtypedesc-content
                            ','
                            ls_smm-contrno
                            INTO  <fs_accountantinformation_yb>-accountantengagementtypedesc-content
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
          ENDIF.
          "accountantContactPhone
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-contextref = ''.
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-content    = 'bookkeeper'.
          "
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-contextref  = mc_journal_context.
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-content     = ls_smm-tel_number.
          "accountantContactFax
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-contextref      = mc_journal_context.
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-content         = ls_smm-fax_number.
          "accountantContactEmail
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-contextref = mc_journal_context.
          <fs_accountantinformation_yb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-content    = ls_smm-email.


        ENDLOOP.
      WHEN 3.
        ASSIGN ('ms_root_gib_yb-accountingentries-entityinformation-accountantinformation')  TO <ft_accountantinformation_gyb>.
        APPEND INITIAL LINE TO <ft_accountantinformation_gyb> ASSIGNING <fs_accountantinformation_gyb>.
        LOOP AT ms_header-symmb_t INTO ls_smm.

          <fs_accountantinformation_gyb>-accountantname-contextref                              = mc_journal_context.

          CONCATENATE ls_smm-mmtit
                      ls_smm-name
                      ls_smm-surname
                      INTO <fs_accountantinformation_gyb>-accountantname-content
                      SEPARATED BY space.

          "entityInformation-accountantInformation-accountantAddress-accountantBuildingNumber
          <fs_accountantinformation_gyb>-accountantaddress-accountantbuildingnumber-contextref  = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantaddress-accountantbuildingnumber-content     = ls_smm-house_num.
          "entityInformation-accountantInformation-accountantAddress-accountantStreet
          <fs_accountantinformation_gyb>-accountantaddress-accountantstreet-contextref          = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantaddress-accountantstreet-content             = ls_smm-adress1.
          "entityInformation-accountantInformation-accountantAddress-accountantAddressStreet2
          <fs_accountantinformation_gyb>-accountantaddress-accountantaddressstreet2-contextref  = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantaddress-accountantaddressstreet2-content     = ls_smm-adress2.
          "entityInformation-accountantInformation-accountantAddress-accountantCity
          <fs_accountantinformation_gyb>-accountantaddress-accountantcity-contextref            = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantaddress-accountantcity-content               = ls_smm-city.
          "entityInformation-accountantInformation-accountantAddress-accountantCountry
          <fs_accountantinformation_gyb>-accountantaddress-accountantcountry-contextref         = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantaddress-accountantcountry-content            = ls_smm-country_u.
          "entityInformation-accountantInformation-accountantAddress-accountantZipOrPostalCode
          <fs_accountantinformation_gyb>-accountantaddress-accountantziporpostalcode-contextref = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantaddress-accountantziporpostalcode-content    = ls_smm-postal_code.
          "accountantEngagementTypeDescription-accountantContactInformation-accountantContactPhone-accountantContactPhoneNumberDescription
          <fs_accountantinformation_gyb>-accountantengagementtypedesc-contextref                = mc_journal_context.

          IF ls_smm-mmtit EQ 'F.Y.'.
            <fs_accountantinformation_gyb>-accountantengagementtypedesc-content    = '-'.
          ELSE.
            IF ls_smm-contrname IS NOT INITIAL.
              IF <fs_accountantinformation_gyb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_gyb>-accountantengagementtypedesc-content  = ls_smm-contrname.
              ELSE.
                CONCATENATE ls_smm-contrname
                            ','
                            <fs_accountantinformation_gyb>-accountantengagementtypedesc-content
                            INTO <fs_accountantinformation_gyb>-accountantengagementtypedesc-content
                            SEPARATED BY space.

              ENDIF.
            ENDIF.

            IF ls_smm-contrno IS NOT INITIAL.
              IF <fs_accountantinformation_gyb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_gyb>-accountantengagementtypedesc-content = ls_smm-contrno.
              ELSE.
                CONCATENATE <fs_accountantinformation_gyb>-accountantengagementtypedesc-content
                            ','
                            ls_smm-contrno
                            INTO  <fs_accountantinformation_gyb>-accountantengagementtypedesc-content
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
          ENDIF.
          "accountantContactPhone
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-contextref = ''.
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-content    = 'bookkeeper'.
          "
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-contextref  = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-content     = ls_smm-tel_number.
          "accountantContactFax
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-contextref      = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-content         = ls_smm-fax_number.
          "accountantContactEmail
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-contextref = mc_journal_context.
          <fs_accountantinformation_gyb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-content    = ls_smm-email.


        ENDLOOP.

      WHEN 4.
        ASSIGN ('ms_root_k-accountingentries-entityinformation-accountantinformation')       TO <ft_accountantinformation_k>.
        APPEND INITIAL LINE TO <ft_accountantinformation_k> ASSIGNING <fs_accountantinformation_k>.
        LOOP AT ms_header-symmb_t INTO ls_smm.

          <fs_accountantinformation_k>-accountantname-contextref                              = mc_journal_context.

          CONCATENATE ls_smm-mmtit
                      ls_smm-name
                      ls_smm-surname
                      INTO <fs_accountantinformation_k>-accountantname-content
                      SEPARATED BY space.

          "entityInformation-accountantInformation-accountantAddress-accountantBuildingNumber
          <fs_accountantinformation_k>-accountantaddress-accountantbuildingnumber-contextref  = mc_journal_context.
          <fs_accountantinformation_k>-accountantaddress-accountantbuildingnumber-content     = ls_smm-house_num.
          "entityInformation-accountantInformation-accountantAddress-accountantStreet
          <fs_accountantinformation_k>-accountantaddress-accountantstreet-contextref          = mc_journal_context.
          <fs_accountantinformation_k>-accountantaddress-accountantstreet-content             = ls_smm-adress1.
          "entityInformation-accountantInformation-accountantAddress-accountantAddressStreet2
          <fs_accountantinformation_k>-accountantaddress-accountantaddressstreet2-contextref  = mc_journal_context.
          <fs_accountantinformation_k>-accountantaddress-accountantaddressstreet2-content     = ls_smm-adress2.
          "entityInformation-accountantInformation-accountantAddress-accountantCity
          <fs_accountantinformation_k>-accountantaddress-accountantcity-contextref            = mc_journal_context.
          <fs_accountantinformation_k>-accountantaddress-accountantcity-content               = ls_smm-city.
          "entityInformation-accountantInformation-accountantAddress-accountantCountry
          <fs_accountantinformation_k>-accountantaddress-accountantcountry-contextref         = mc_journal_context.
          <fs_accountantinformation_k>-accountantaddress-accountantcountry-content            = ls_smm-country_u.
          "entityInformation-accountantInformation-accountantAddress-accountantZipOrPostalCode
          <fs_accountantinformation_k>-accountantaddress-accountantziporpostalcode-contextref = mc_journal_context.
          <fs_accountantinformation_k>-accountantaddress-accountantziporpostalcode-content    = ls_smm-postal_code.
          "accountantEngagementTypeDescription-accountantContactInformation-accountantContactPhone-accountantContactPhoneNumberDescription
          <fs_accountantinformation_k>-accountantengagementtypedesc-contextref                = mc_journal_context.

          IF ls_smm-mmtit EQ 'F.Y.'.
            <fs_accountantinformation_k>-accountantengagementtypedesc-content    = '-'.
          ELSE.
            IF ls_smm-contrname IS NOT INITIAL.
              IF <fs_accountantinformation_k>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_k>-accountantengagementtypedesc-content  = ls_smm-contrname.
              ELSE.
                CONCATENATE ls_smm-contrname
                            ','
                            <fs_accountantinformation_k>-accountantengagementtypedesc-content
                            INTO <fs_accountantinformation_k>-accountantengagementtypedesc-content
                            SEPARATED BY space.

              ENDIF.
            ENDIF.

            IF ls_smm-contrno IS NOT INITIAL.
              IF <fs_accountantinformation_k>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_k>-accountantengagementtypedesc-content = ls_smm-contrno.
              ELSE.
                CONCATENATE <fs_accountantinformation_k>-accountantengagementtypedesc-content
                            ','
                            ls_smm-contrno
                            INTO  <fs_accountantinformation_k>-accountantengagementtypedesc-content
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
          ENDIF.
          "accountantContactPhone
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-contextref = ''.
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-content    = 'bookkeeper'.
          "
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-contextref  = mc_journal_context.
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-content     = ls_smm-tel_number.
          "accountantContactFax
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-contextref      = mc_journal_context.
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-content         = ls_smm-fax_number.
          "accountantContactEmail
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-contextref = mc_journal_context.
          <fs_accountantinformation_k>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-content    = ls_smm-email.


        ENDLOOP.
      WHEN 5.
        ASSIGN ('ms_root_kb-accountingentries-entityinformation-accountantinformation')      TO <ft_accountantinformation_kb>.
        APPEND INITIAL LINE TO <ft_accountantinformation_kb> ASSIGNING <fs_accountantinformation_kb>.
        LOOP AT ms_header-symmb_t INTO ls_smm.

          <fs_accountantinformation_kb>-accountantname-contextref                              = mc_journal_context.

          CONCATENATE ls_smm-mmtit
                      ls_smm-name
                      ls_smm-surname
                      INTO <fs_accountantinformation_kb>-accountantname-content
                      SEPARATED BY space.

          "entityInformation-accountantInformation-accountantAddress-accountantBuildingNumber
          <fs_accountantinformation_kb>-accountantaddress-accountantbuildingnumber-contextref  = mc_journal_context.
          <fs_accountantinformation_kb>-accountantaddress-accountantbuildingnumber-content     = ls_smm-house_num.
          "entityInformation-accountantInformation-accountantAddress-accountantStreet
          <fs_accountantinformation_kb>-accountantaddress-accountantstreet-contextref          = mc_journal_context.
          <fs_accountantinformation_kb>-accountantaddress-accountantstreet-content             = ls_smm-adress1.
          "entityInformation-accountantInformation-accountantAddress-accountantAddressStreet2
          <fs_accountantinformation_kb>-accountantaddress-accountantaddressstreet2-contextref  = mc_journal_context.
          <fs_accountantinformation_kb>-accountantaddress-accountantaddressstreet2-content     = ls_smm-adress2.
          "entityInformation-accountantInformation-accountantAddress-accountantCity
          <fs_accountantinformation_kb>-accountantaddress-accountantcity-contextref            = mc_journal_context.
          <fs_accountantinformation_kb>-accountantaddress-accountantcity-content               = ls_smm-city.
          "entityInformation-accountantInformation-accountantAddress-accountantCountry
          <fs_accountantinformation_kb>-accountantaddress-accountantcountry-contextref         = mc_journal_context.
          <fs_accountantinformation_kb>-accountantaddress-accountantcountry-content            = ls_smm-country_u.
          "entityInformation-accountantInformation-accountantAddress-accountantZipOrPostalCode
          <fs_accountantinformation_kb>-accountantaddress-accountantziporpostalcode-contextref = mc_journal_context.
          <fs_accountantinformation_kb>-accountantaddress-accountantziporpostalcode-content    = ls_smm-postal_code.
          "accountantEngagementTypeDescription-accountantContactInformation-accountantContactPhone-accountantContactPhoneNumberDescription
          <fs_accountantinformation_kb>-accountantengagementtypedesc-contextref                = mc_journal_context.

          IF ls_smm-mmtit EQ 'F.Y.'.
            <fs_accountantinformation_kb>-accountantengagementtypedesc-content    = '-'.
          ELSE.
            IF ls_smm-contrname IS NOT INITIAL.
              IF <fs_accountantinformation_kb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_kb>-accountantengagementtypedesc-content  = ls_smm-contrname.
              ELSE.
                CONCATENATE ls_smm-contrname
                            ','
                            <fs_accountantinformation_kb>-accountantengagementtypedesc-content
                            INTO <fs_accountantinformation_kb>-accountantengagementtypedesc-content
                            SEPARATED BY space.

              ENDIF.
            ENDIF.

            IF ls_smm-contrno IS NOT INITIAL.
              IF <fs_accountantinformation_kb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_kb>-accountantengagementtypedesc-content = ls_smm-contrno.
              ELSE.
                CONCATENATE <fs_accountantinformation_kb>-accountantengagementtypedesc-content
                            ','
                            ls_smm-contrno
                            INTO  <fs_accountantinformation_kb>-accountantengagementtypedesc-content
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
          ENDIF.
          "accountantContactPhone
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-contextref = ''.
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-content    = 'bookkeeper'.
          "
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-contextref  = mc_journal_context.
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-content     = ls_smm-tel_number.
          "accountantContactFax
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-contextref      = mc_journal_context.
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-content         = ls_smm-fax_number.
          "accountantContactEmail
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-contextref = mc_journal_context.
          <fs_accountantinformation_kb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-content    = ls_smm-email.


        ENDLOOP.
      WHEN 6.
        ASSIGN ('ms_root_gib_kb-accountingentries-entityinformation-accountantinformation')  TO <ft_accountantinformation_gkb>.
        APPEND INITIAL LINE TO <ft_accountantinformation_gkb> ASSIGNING <fs_accountantinformation_gkb>.
        LOOP AT ms_header-symmb_t INTO ls_smm.

          <fs_accountantinformation_gkb>-accountantname-contextref                              = mc_journal_context.

          CONCATENATE ls_smm-mmtit
                      ls_smm-name
                      ls_smm-surname
                      INTO <fs_accountantinformation_gkb>-accountantname-content
                      SEPARATED BY space.

          "entityInformation-accountantInformation-accountantAddress-accountantBuildingNumber
          <fs_accountantinformation_gkb>-accountantaddress-accountantbuildingnumber-contextref  = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantaddress-accountantbuildingnumber-content     = ls_smm-house_num.
          "entityInformation-accountantInformation-accountantAddress-accountantStreet
          <fs_accountantinformation_gkb>-accountantaddress-accountantstreet-contextref          = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantaddress-accountantstreet-content             = ls_smm-adress1.
          "entityInformation-accountantInformation-accountantAddress-accountantAddressStreet2
          <fs_accountantinformation_gkb>-accountantaddress-accountantaddressstreet2-contextref  = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantaddress-accountantaddressstreet2-content     = ls_smm-adress2.
          "entityInformation-accountantInformation-accountantAddress-accountantCity
          <fs_accountantinformation_gkb>-accountantaddress-accountantcity-contextref            = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantaddress-accountantcity-content               = ls_smm-city.
          "entityInformation-accountantInformation-accountantAddress-accountantCountry
          <fs_accountantinformation_gkb>-accountantaddress-accountantcountry-contextref         = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantaddress-accountantcountry-content            = ls_smm-country_u.
          "entityInformation-accountantInformation-accountantAddress-accountantZipOrPostalCode
          <fs_accountantinformation_gkb>-accountantaddress-accountantziporpostalcode-contextref = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantaddress-accountantziporpostalcode-content    = ls_smm-postal_code.
          "accountantEngagementTypeDescription-accountantContactInformation-accountantContactPhone-accountantContactPhoneNumberDescription
          <fs_accountantinformation_gkb>-accountantengagementtypedesc-contextref                = mc_journal_context.

          IF ls_smm-mmtit EQ 'F.Y.'.
            <fs_accountantinformation_gkb>-accountantengagementtypedesc-content    = '-'.
          ELSE.
            IF ls_smm-contrname IS NOT INITIAL.
              IF <fs_accountantinformation_gkb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_gkb>-accountantengagementtypedesc-content  = ls_smm-contrname.
              ELSE.
                CONCATENATE ls_smm-contrname
                            ','
                            <fs_accountantinformation_gkb>-accountantengagementtypedesc-content
                            INTO <fs_accountantinformation_gkb>-accountantengagementtypedesc-content
                            SEPARATED BY space.

              ENDIF.
            ENDIF.

            IF ls_smm-contrno IS NOT INITIAL.
              IF <fs_accountantinformation_gkb>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_gkb>-accountantengagementtypedesc-content = ls_smm-contrno.
              ELSE.
                CONCATENATE <fs_accountantinformation_gkb>-accountantengagementtypedesc-content
                            ','
                            ls_smm-contrno
                            INTO  <fs_accountantinformation_gkb>-accountantengagementtypedesc-content
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
          ENDIF.
          "accountantContactPhone
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-contextref = ''.
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-content    = 'bookkeeper'.
          "
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-contextref  = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-content     = ls_smm-tel_number.
          "accountantContactFax
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-contextref      = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-content         = ls_smm-fax_number.
          "accountantContactEmail
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-contextref = mc_journal_context.
          <fs_accountantinformation_gkb>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-content    = ls_smm-email.


        ENDLOOP.
      WHEN 7.
        ASSIGN ('ms_root_dr-accountingentries-entityinformation-accountantinformation')      TO <ft_accountantinformation_dr>.
        APPEND INITIAL LINE TO <ft_accountantinformation_dr> ASSIGNING <fs_accountantinformation_dr>.
        LOOP AT ms_header-symmb_t INTO ls_smm.

          <fs_accountantinformation_dr>-accountantname-contextref                              = mc_journal_context.

          CONCATENATE ls_smm-mmtit
                      ls_smm-name
                      ls_smm-surname
                      INTO <fs_accountantinformation_dr>-accountantname-content
                      SEPARATED BY space.

          "entityInformation-accountantInformation-accountantAddress-accountantBuildingNumber
          <fs_accountantinformation_dr>-accountantaddress-accountantbuildingnumber-contextref  = mc_journal_context.
          <fs_accountantinformation_dr>-accountantaddress-accountantbuildingnumber-content     = ls_smm-house_num.
          "entityInformation-accountantInformation-accountantAddress-accountantStreet
          <fs_accountantinformation_dr>-accountantaddress-accountantstreet-contextref          = mc_journal_context.
          <fs_accountantinformation_dr>-accountantaddress-accountantstreet-content             = ls_smm-adress1.
          "entityInformation-accountantInformation-accountantAddress-accountantAddressStreet2
          <fs_accountantinformation_dr>-accountantaddress-accountantaddressstreet2-contextref  = mc_journal_context.
          <fs_accountantinformation_dr>-accountantaddress-accountantaddressstreet2-content     = ls_smm-adress2.
          "entityInformation-accountantInformation-accountantAddress-accountantCity
          <fs_accountantinformation_dr>-accountantaddress-accountantcity-contextref            = mc_journal_context.
          <fs_accountantinformation_dr>-accountantaddress-accountantcity-content               = ls_smm-city.
          "entityInformation-accountantInformation-accountantAddress-accountantCountry
          <fs_accountantinformation_dr>-accountantaddress-accountantcountry-contextref         = mc_journal_context.
          <fs_accountantinformation_dr>-accountantaddress-accountantcountry-content            = ls_smm-country_u.
          "entityInformation-accountantInformation-accountantAddress-accountantZipOrPostalCode
          <fs_accountantinformation_dr>-accountantaddress-accountantziporpostalcode-contextref = mc_journal_context.
          <fs_accountantinformation_dr>-accountantaddress-accountantziporpostalcode-content    = ls_smm-postal_code.
          "accountantEngagementTypeDescription-accountantContactInformation-accountantContactPhone-accountantContactPhoneNumberDescription
          <fs_accountantinformation_dr>-accountantengagementtypedesc-contextref                = mc_journal_context.

          IF ls_smm-mmtit EQ 'F.Y.'.
            <fs_accountantinformation_dr>-accountantengagementtypedesc-content    = '-'.
          ELSE.
            IF ls_smm-contrname IS NOT INITIAL.
              IF <fs_accountantinformation_dr>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_dr>-accountantengagementtypedesc-content  = ls_smm-contrname.
              ELSE.
                CONCATENATE ls_smm-contrname
                            ','
                            <fs_accountantinformation_dr>-accountantengagementtypedesc-content
                            INTO <fs_accountantinformation_dr>-accountantengagementtypedesc-content
                            SEPARATED BY space.

              ENDIF.
            ENDIF.

            IF ls_smm-contrno IS NOT INITIAL.
              IF <fs_accountantinformation_dr>-accountantengagementtypedesc-content IS INITIAL.
                <fs_accountantinformation_dr>-accountantengagementtypedesc-content = ls_smm-contrno.
              ELSE.
                CONCATENATE <fs_accountantinformation_dr>-accountantengagementtypedesc-content
                            ','
                            ls_smm-contrno
                            INTO  <fs_accountantinformation_dr>-accountantengagementtypedesc-content
                            SEPARATED BY space.
              ENDIF.
            ENDIF.
          ENDIF.
          "accountantContactPhone
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-contextref = ''.
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactphone-accountantcontphonenumberdesc-content    = 'bookkeeper'.
          "
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-contextref  = mc_journal_context.
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactphone-accountantcontactphonenumber-content     = ls_smm-tel_number.
          "accountantContactFax
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-contextref      = mc_journal_context.
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactfax-accountantcontactfaxnumber-content         = ls_smm-fax_number.
          "accountantContactEmail
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-contextref = mc_journal_context.
          <fs_accountantinformation_dr>-accountantcontactinformation-accountantcontactemail-accountantcontactemailaddress-content    = ls_smm-email.


        ENDLOOP.
    ENDCASE.







  ENDMETHOD.


  METHOD documentinfo.
    DATA lv_unique_id TYPE /itetr/edf_e_unqid.
    DATA ls_srnr TYPE /itetr/etr_srnmr.

    FIELD-SYMBOLS <fs_documentinfo_y>      TYPE /itetr/if_edf_xml_y=>ty_documentinfo.
    FIELD-SYMBOLS <fs_documentinfo_yb>     TYPE /itetr/if_edf_xml_yb=>ty_documentinfo.
    FIELD-SYMBOLS <fs_documentinfo_gib_yb> TYPE /itetr/if_edf_xml_yb=>ty_documentinfo.
    FIELD-SYMBOLS <fs_documentinfo_k>      TYPE /itetr/if_edf_xml_k=>ty_documentinfo.
    FIELD-SYMBOLS <fs_documentinfo_kb>     TYPE /itetr/if_edf_xml_kb=>ty_documentinfo.
    FIELD-SYMBOLS <fs_documentinfo_gib_kb> TYPE /itetr/if_edf_xml_kb=>ty_documentinfo.
    FIELD-SYMBOLS <fs_documentinfo_dr>     TYPE /itetr/if_edf_xml_dr=>ty_documentinfo.

    SELECT SINGLE *
        INTO ls_srnr
        FROM /itetr/etr_srnmr
        WHERE bukrs EQ ms_header-bukrs
          AND xmlty EQ iv_xmlty.

    CONCATENATE ls_srnr-serpr
                ms_header-gjahr
                ms_header-monat
                ms_header-parno
                INTO lv_unique_id.

    CASE iv_xmlty.
      WHEN 1.
        ASSIGN ('ms_root_y-accountingentries-documentinfo')        TO <fs_documentinfo_y>.

        <fs_documentinfo_y>-entriestype-contextref        = mc_journal_context.
        <fs_documentinfo_y>-entriestype-content           = mc_journal.
        <fs_documentinfo_y>-uniqueid-contextref           = mc_journal_context.
        <fs_documentinfo_y>-uniqueid-content              = lv_unique_id.
        <fs_documentinfo_y>-language-contextref           = mc_journal_context.
        <fs_documentinfo_y>-language-content              = 'iso639:tr'.
        <fs_documentinfo_y>-creationdate-contextref       = mc_journal_context.
        <fs_documentinfo_y>-creationdate-content          = ms_header-creation_date.
        <fs_documentinfo_y>-creator-contextref            = mc_journal_context.
        <fs_documentinfo_y>-creator-content               = ms_header-creator_name.
        <fs_documentinfo_y>-entriescomment-contextref     = mc_journal_context.
        <fs_documentinfo_y>-entriescomment-content        = ms_header-entriescomment.
        <fs_documentinfo_y>-periodcoveredstart-content    = ms_header-periodcoveredstart.
        <fs_documentinfo_y>-periodcoveredend-content      = ms_header-periodcoveredend.
        <fs_documentinfo_y>-periodcoveredstart-contextref = mc_journal_context.
        <fs_documentinfo_y>-periodcoveredend-contextref   = mc_journal_context.
        <fs_documentinfo_y>-sourceapplication-contextref  = mc_journal_context.
        <fs_documentinfo_y>-sourceapplication-content     = '1234567808 Gelir İdaresi Başkanlığı ABC e-Defter Uygulaması 1.0'.
      WHEN 2.
        ASSIGN ('ms_root_yb-accountingentries-documentinfo')       TO <fs_documentinfo_yb>.

        <fs_documentinfo_yb>-entriestype-contextref        = mc_journal_context.
        <fs_documentinfo_yb>-entriestype-content           = mc_journal.
        <fs_documentinfo_yb>-uniqueid-contextref           = mc_journal_context.
        <fs_documentinfo_yb>-uniqueid-content              = lv_unique_id.
        <fs_documentinfo_yb>-language-contextref           = mc_journal_context.
        <fs_documentinfo_yb>-language-content              = 'iso639:tr'.
        <fs_documentinfo_yb>-creationdate-contextref       = mc_journal_context.
        <fs_documentinfo_yb>-creationdate-content          = ms_header-creation_date.
        <fs_documentinfo_yb>-creator-contextref            = mc_journal_context.
        <fs_documentinfo_yb>-creator-content               = ms_header-creator_name.
        <fs_documentinfo_yb>-entriescomment-contextref     = mc_journal_context.
        <fs_documentinfo_yb>-entriescomment-content        = ms_header-entriescomment.
        <fs_documentinfo_yb>-periodcoveredstart-content    = ms_header-periodcoveredstart.
        <fs_documentinfo_yb>-periodcoveredend-content      = ms_header-periodcoveredend.
        <fs_documentinfo_yb>-periodcoveredstart-contextref = mc_journal_context.
        <fs_documentinfo_yb>-periodcoveredend-contextref   = mc_journal_context.
        <fs_documentinfo_yb>-sourceapplication-contextref  = mc_journal_context.
        <fs_documentinfo_yb>-sourceapplication-content     = '1234567808 Gelir İdaresi Başkanlığı ABC e-Defter Uygulaması 1.0'.
      WHEN 3.
        ASSIGN ('ms_root_gib_yb-accountingentries-documentinfo')  TO <fs_documentinfo_gib_yb>.

        <fs_documentinfo_gib_yb>-entriestype-contextref        = mc_journal_context.
        <fs_documentinfo_gib_yb>-entriestype-content           = mc_journal.
        <fs_documentinfo_gib_yb>-uniqueid-contextref           = mc_journal_context.
        <fs_documentinfo_gib_yb>-uniqueid-content              = lv_unique_id.
        <fs_documentinfo_gib_yb>-language-contextref           = mc_journal_context.
        <fs_documentinfo_gib_yb>-language-content              = 'iso639:tr'.
        <fs_documentinfo_gib_yb>-creationdate-contextref       = mc_journal_context.
        <fs_documentinfo_gib_yb>-creationdate-content          = ms_header-creation_date.
        <fs_documentinfo_gib_yb>-creator-contextref            = mc_journal_context.
        <fs_documentinfo_gib_yb>-creator-content               = ms_header-creator_name.
        <fs_documentinfo_gib_yb>-entriescomment-contextref     = mc_journal_context.
        <fs_documentinfo_gib_yb>-entriescomment-content        = ms_header-entriescomment.
        <fs_documentinfo_gib_yb>-periodcoveredstart-content    = ms_header-periodcoveredstart.
        <fs_documentinfo_gib_yb>-periodcoveredend-content      = ms_header-periodcoveredend.
        <fs_documentinfo_gib_yb>-periodcoveredstart-contextref = mc_journal_context.
        <fs_documentinfo_gib_yb>-periodcoveredend-contextref   = mc_journal_context.
        <fs_documentinfo_gib_yb>-sourceapplication-contextref  = mc_journal_context.
        <fs_documentinfo_gib_yb>-sourceapplication-content     = '1234567808 Gelir İdaresi Başkanlığı ABC e-Defter Uygulaması 1.0'.
      WHEN 4.
        ASSIGN ('ms_root_k-accountingentries-documentinfo')       TO <fs_documentinfo_k>.

        <fs_documentinfo_k>-entriestype-contextref        = mc_journal_context.
        <fs_documentinfo_k>-entriestype-content           = mc_journal.
        <fs_documentinfo_k>-uniqueid-contextref           = mc_journal_context.
        <fs_documentinfo_k>-uniqueid-content              = lv_unique_id.
        <fs_documentinfo_k>-language-contextref           = mc_journal_context.
        <fs_documentinfo_k>-language-content              = 'iso639:tr'.
        <fs_documentinfo_k>-creationdate-contextref       = mc_journal_context.
        <fs_documentinfo_k>-creationdate-content          = ms_header-creation_date.
        <fs_documentinfo_k>-creator-contextref            = mc_journal_context.
        <fs_documentinfo_k>-creator-content               = ms_header-creator_name.
        <fs_documentinfo_k>-entriescomment-contextref     = mc_journal_context.
        <fs_documentinfo_k>-entriescomment-content        = ms_header-entriescomment.
        <fs_documentinfo_k>-periodcoveredstart-content    = ms_header-periodcoveredstart.
        <fs_documentinfo_k>-periodcoveredend-content      = ms_header-periodcoveredend.
        <fs_documentinfo_k>-periodcoveredstart-contextref = mc_journal_context.
        <fs_documentinfo_k>-periodcoveredend-contextref   = mc_journal_context.
        <fs_documentinfo_k>-sourceapplication-contextref  = mc_journal_context.
        <fs_documentinfo_k>-sourceapplication-content     = '1234567808 Gelir İdaresi Başkanlığı ABC e-Defter Uygulaması 1.0'.
      WHEN 5.
        ASSIGN ('ms_root_kb-accountingentries-documentinfo')       TO <fs_documentinfo_kb>.

        <fs_documentinfo_kb>-entriestype-contextref        = mc_journal_context.
        <fs_documentinfo_kb>-entriestype-content           = mc_journal.
        <fs_documentinfo_kb>-uniqueid-contextref           = mc_journal_context.
        <fs_documentinfo_kb>-uniqueid-content              = lv_unique_id.
        <fs_documentinfo_kb>-language-contextref           = mc_journal_context.
        <fs_documentinfo_kb>-language-content              = 'iso639:tr'.
        <fs_documentinfo_kb>-creationdate-contextref       = mc_journal_context.
        <fs_documentinfo_kb>-creationdate-content          = ms_header-creation_date.
        <fs_documentinfo_kb>-creator-contextref            = mc_journal_context.
        <fs_documentinfo_kb>-creator-content               = ms_header-creator_name.
        <fs_documentinfo_kb>-entriescomment-contextref     = mc_journal_context.
        <fs_documentinfo_kb>-entriescomment-content        = ms_header-entriescomment.
        <fs_documentinfo_kb>-periodcoveredstart-content    = ms_header-periodcoveredstart.
        <fs_documentinfo_kb>-periodcoveredend-content      = ms_header-periodcoveredend.
        <fs_documentinfo_kb>-periodcoveredstart-contextref = mc_journal_context.
        <fs_documentinfo_kb>-periodcoveredend-contextref   = mc_journal_context.
        <fs_documentinfo_kb>-sourceapplication-contextref  = mc_journal_context.
        <fs_documentinfo_kb>-sourceapplication-content     = '1234567808 Gelir İdaresi Başkanlığı ABC e-Defter Uygulaması 1.0'.
      WHEN 6.
        ASSIGN ('ms_root_gib_kb-accountingentries-documentinfo')   TO <fs_documentinfo_gib_kb>.

        <fs_documentinfo_gib_kb>-entriestype-contextref        = mc_journal_context.
        <fs_documentinfo_gib_kb>-entriestype-content           = mc_journal.
        <fs_documentinfo_gib_kb>-uniqueid-contextref           = mc_journal_context.
        <fs_documentinfo_gib_kb>-uniqueid-content              = lv_unique_id.
        <fs_documentinfo_gib_kb>-language-contextref           = mc_journal_context.
        <fs_documentinfo_gib_kb>-language-content              = 'iso639:tr'.
        <fs_documentinfo_gib_kb>-creationdate-contextref       = mc_journal_context.
        <fs_documentinfo_gib_kb>-creationdate-content          = ms_header-creation_date.
        <fs_documentinfo_gib_kb>-creator-contextref            = mc_journal_context.
        <fs_documentinfo_gib_kb>-creator-content               = ms_header-creator_name.
        <fs_documentinfo_gib_kb>-entriescomment-contextref     = mc_journal_context.
        <fs_documentinfo_gib_kb>-entriescomment-content        = ms_header-entriescomment.
        <fs_documentinfo_gib_kb>-periodcoveredstart-content    = ms_header-periodcoveredstart.
        <fs_documentinfo_gib_kb>-periodcoveredend-content      = ms_header-periodcoveredend.
        <fs_documentinfo_gib_kb>-periodcoveredstart-contextref = mc_journal_context.
        <fs_documentinfo_gib_kb>-periodcoveredend-contextref   = mc_journal_context.
        <fs_documentinfo_gib_kb>-sourceapplication-contextref  = mc_journal_context.
        <fs_documentinfo_gib_kb>-sourceapplication-content     = '1234567808 Gelir İdaresi Başkanlığı ABC e-Defter Uygulaması 1.0'.
      WHEN 7.
        ASSIGN ('ms_root_dr-accountingentries-documentinfo')       TO <fs_documentinfo_dr>.

        <fs_documentinfo_dr>-entriestype-contextref        = mc_journal_context.
        <fs_documentinfo_dr>-entriestype-content           = mc_journal.
        <fs_documentinfo_dr>-uniqueid-contextref           = mc_journal_context.
        <fs_documentinfo_dr>-uniqueid-content              = lv_unique_id.
        <fs_documentinfo_dr>-language-contextref           = mc_journal_context.
        <fs_documentinfo_dr>-language-content              = 'iso639:tr'.
        <fs_documentinfo_dr>-creationdate-contextref       = mc_journal_context.
        <fs_documentinfo_dr>-creationdate-content          = ms_header-creation_date.
        <fs_documentinfo_dr>-creator-contextref            = mc_journal_context.
        <fs_documentinfo_dr>-creator-content               = ms_header-creator_name.
        <fs_documentinfo_dr>-entriescomment-contextref     = mc_journal_context.
        <fs_documentinfo_dr>-entriescomment-content        = ms_header-entriescomment.
        <fs_documentinfo_dr>-periodcoveredstart-content    = ms_header-periodcoveredstart.
        <fs_documentinfo_dr>-periodcoveredend-content      = ms_header-periodcoveredend.
        <fs_documentinfo_dr>-periodcoveredstart-contextref = mc_journal_context.
        <fs_documentinfo_dr>-periodcoveredend-contextref   = mc_journal_context.
        <fs_documentinfo_dr>-sourceapplication-contextref  = mc_journal_context.
        <fs_documentinfo_dr>-sourceapplication-content     = '1234567808 Gelir İdaresi Başkanlığı ABC e-Defter Uygulaması 1.0'.
    ENDCASE.






  ENDMETHOD.


  METHOD entityinformation.


    FIELD-SYMBOLS <fs_entityinformation_y>      TYPE /itetr/if_edf_xml_y=>ty_entityinformation.
    FIELD-SYMBOLS <fs_entityinformation_yb>     TYPE /itetr/if_edf_xml_yb=>ty_entityinformation.
    FIELD-SYMBOLS <fs_entityinformation_gib_yb> TYPE /itetr/if_edf_xml_yb=>ty_entityinformation.
    FIELD-SYMBOLS <fs_entityinformation_k>      TYPE /itetr/if_edf_xml_k=>ty_entityinformation.
    FIELD-SYMBOLS <fs_entityinformation_kb>     TYPE /itetr/if_edf_xml_kb=>ty_entityinformation.
    FIELD-SYMBOLS <fs_entityinformation_gib_kb> TYPE /itetr/if_edf_xml_kb=>ty_entityinformation.
    FIELD-SYMBOLS <fs_entityinformation_dr>     TYPE /itetr/if_edf_xml_dr=>ty_entityinformation.


    CASE iv_xmlty.
      WHEN 1.
        ASSIGN ('ms_root_y-accountingentries-entityinformation')       TO <fs_entityinformation_y>.

        "entityInformation-entityPhoneNumber-phonenumber
        <fs_entityinformation_y>-entityphonenumber-phonenumber-contextref                  = mc_journal_context.
        <fs_entityinformation_y>-entityphonenumber-phonenumber-content                     = ms_header-srkdb-tel_number.
        "entityInformation-entityPhoneNumber-phoneNumberDescription
        <fs_entityinformation_y>-entityphonenumber-phonenumberdescription-contextref       = mc_journal_context.
        <fs_entityinformation_y>-entityphonenumber-phonenumberdescription-content          = 'main'.
        "entityInformation-entityFaxNumberStructure
        <fs_entityinformation_y>-entityfaxnumberstructure-entityfaxnumber-contextref       = mc_journal_context.
        <fs_entityinformation_y>-entityfaxnumberstructure-entityfaxnumber-content          = ms_header-srkdb-fax_number.
        "entityInformation-entityEmailAddressStructure
        <fs_entityinformation_y>-entityemailaddressstructure-entityemailaddress-contextref = mc_journal_context.
        <fs_entityinformation_y>-entityemailaddressstructure-entityemailaddress-content    = ms_header-srkdb-email.
        "entityInformation-organizationIdentifiers-organizationIdentifier
        <fs_entityinformation_y>-organizationidentifiers-organizationidentifier-contextref = mc_journal_context.
        <fs_entityinformation_y>-organizationidentifiers-organizationidentifier-content    = ms_header-company_name.
        "entityInformation-organizationIdentifiers-organizationDescription
        <fs_entityinformation_y>-organizationidentifiers-organizationdescription-contextref = mc_journal_context.
        <fs_entityinformation_y>-organizationidentifiers-organizationdescription-content    = 'Kurum Unvanı'.
        "entityInformation-organizationAddress-organizationBuildingNumber
        <fs_entityinformation_y>-organizationaddress-organizationbuildingnumber-contextref = mc_journal_context.
        <fs_entityinformation_y>-organizationaddress-organizationbuildingnumber-content    = ms_header-srkdb-house_num.
        "entityInformation-organizationAddress-organizationAddressStreet
        <fs_entityinformation_y>-organizationaddress-organizationaddressstreet-contextref  = mc_journal_context.
        <fs_entityinformation_y>-organizationaddress-organizationaddressstreet-content     = ms_header-srkdb-adress1.
        "entityInformation-organizationAddress-organizationAddressStreet2
        <fs_entityinformation_y>-organizationaddress-organizationaddressstreet2-contextref = mc_journal_context.
        <fs_entityinformation_y>-organizationaddress-organizationaddressstreet2-content    = ms_header-srkdb-adress2.
        "entityInformation-organizationAddress-organizationAddressCity
        <fs_entityinformation_y>-organizationaddress-organizationaddresscity-contextref    = mc_journal_context.
        <fs_entityinformation_y>-organizationaddress-organizationaddresscity-content       = ms_header-srkdb-city.
        "entityInformation-organizationAddress-organizationAddressZipOrPostalCode
        <fs_entityinformation_y>-organizationaddress-orgaddressziporpostalcode-contextref  = mc_journal_context.
        <fs_entityinformation_y>-organizationaddress-orgaddressziporpostalcode-content     = ms_header-srkdb-postal_code.
        "entityInformation-organizationAddress-organizationAddressCountry
        <fs_entityinformation_y>-organizationaddress-organizationaddresscountry-contextref = mc_journal_context.
        <fs_entityinformation_y>-organizationaddress-organizationaddresscountry-content    = ms_header-srkdb-country_u.
        "entityInformation-entityWebSite
        <fs_entityinformation_y>-entitywebsite-websiteurl-contextref                       = mc_journal_context.
        <fs_entityinformation_y>-entitywebsite-websiteurl-content                          = ms_header-srkdb-web.
        "entityInformation-businessDescription
        <fs_entityinformation_y>-businessdescription-contextref                            = mc_journal_context.
        <fs_entityinformation_y>-businessdescription-content                               = ms_header-srkdb-nace_code.
        "entityInformation-fiscalYearStart
        <fs_entityinformation_y>-fiscalyearstart-contextref                                = mc_journal_context.
        <fs_entityinformation_y>-fiscalyearstart-content                                   = ms_header-fiscalyearstart.
        "entityInformation-fiscalYearEnd
        <fs_entityinformation_y>-fiscalyearend-contextref                                  = mc_journal_context.
        <fs_entityinformation_y>-fiscalyearend-content                                     = ms_header-fiscalyearend.

      WHEN 2.
        ASSIGN ('ms_root_yb-accountingentries-entityinformation')      TO <fs_entityinformation_yb>.

        "entityInformation-entityPhoneNumber-phonenumber
        <fs_entityinformation_yb>-entityphonenumber-phonenumber-contextref                  = mc_journal_context.
        <fs_entityinformation_yb>-entityphonenumber-phonenumber-content                     = ms_header-srkdb-tel_number.
        "entityInformation-entityPhoneNumber-phoneNumberDescription
        <fs_entityinformation_yb>-entityphonenumber-phonenumberdescription-contextref       = mc_journal_context.
        <fs_entityinformation_yb>-entityphonenumber-phonenumberdescription-content          = 'main'.
        "entityInformation-entityFaxNumberStructure
        <fs_entityinformation_yb>-entityfaxnumberstructure-entityfaxnumber-contextref       = mc_journal_context.
        <fs_entityinformation_yb>-entityfaxnumberstructure-entityfaxnumber-content          = ms_header-srkdb-fax_number.
        "entityInformation-entityEmailAddressStructure
        <fs_entityinformation_yb>-entityemailaddressstructure-entityemailaddress-contextref = mc_journal_context.
        <fs_entityinformation_yb>-entityemailaddressstructure-entityemailaddress-content    = ms_header-srkdb-email.
        "entityInformation-organizationIdentifiers-organizationIdentifier
        <fs_entityinformation_yb>-organizationidentifiers-organizationidentifier-contextref = mc_journal_context.
        <fs_entityinformation_yb>-organizationidentifiers-organizationidentifier-content    = ms_header-company_name.
        "entityInformation-organizationIdentifiers-organizationDescription
        <fs_entityinformation_yb>-organizationidentifiers-organizationdescription-contextref = mc_journal_context.
        <fs_entityinformation_yb>-organizationidentifiers-organizationdescription-content    = 'Kurum Unvanı'.
        "entityInformation-organizationAddress-organizationBuildingNumber
        <fs_entityinformation_yb>-organizationaddress-organizationbuildingnumber-contextref = mc_journal_context.
        <fs_entityinformation_yb>-organizationaddress-organizationbuildingnumber-content    = ms_header-srkdb-house_num.
        "entityInformation-organizationAddress-organizationAddressStreet
        <fs_entityinformation_yb>-organizationaddress-organizationaddressstreet-contextref  = mc_journal_context.
        <fs_entityinformation_yb>-organizationaddress-organizationaddressstreet-content     = ms_header-srkdb-adress1.
        "entityInformation-organizationAddress-organizationAddressStreet2
        <fs_entityinformation_yb>-organizationaddress-organizationaddressstreet2-contextref = mc_journal_context.
        <fs_entityinformation_yb>-organizationaddress-organizationaddressstreet2-content    = ms_header-srkdb-adress2.
        "entityInformation-organizationAddress-organizationAddressCity
        <fs_entityinformation_yb>-organizationaddress-organizationaddresscity-contextref    = mc_journal_context.
        <fs_entityinformation_yb>-organizationaddress-organizationaddresscity-content       = ms_header-srkdb-city.
        "entityInformation-organizationAddress-organizationAddressZipOrPostalCode
        <fs_entityinformation_yb>-organizationaddress-orgaddressziporpostalcode-contextref  = mc_journal_context.
        <fs_entityinformation_yb>-organizationaddress-orgaddressziporpostalcode-content     = ms_header-srkdb-postal_code.
        "entityInformation-organizationAddress-organizationAddressCountry
        <fs_entityinformation_yb>-organizationaddress-organizationaddresscountry-contextref = mc_journal_context.
        <fs_entityinformation_yb>-organizationaddress-organizationaddresscountry-content    = ms_header-srkdb-country_u.
        "entityInformation-entityWebSite
        <fs_entityinformation_yb>-entitywebsite-websiteurl-contextref                       = mc_journal_context.
        <fs_entityinformation_yb>-entitywebsite-websiteurl-content                          = ms_header-srkdb-web.
        "entityInformation-businessDescription
        <fs_entityinformation_yb>-businessdescription-contextref                            = mc_journal_context.
        <fs_entityinformation_yb>-businessdescription-content                               = ms_header-srkdb-nace_code.
        "entityInformation-fiscalYearStart
        <fs_entityinformation_yb>-fiscalyearstart-contextref                                = mc_journal_context.
        <fs_entityinformation_yb>-fiscalyearstart-content                                   = ms_header-fiscalyearstart.
        "entityInformation-fiscalYearEnd
        <fs_entityinformation_yb>-fiscalyearend-contextref                                  = mc_journal_context.
        <fs_entityinformation_yb>-fiscalyearend-content                                     = ms_header-fiscalyearend.

      WHEN 3.
        ASSIGN ('ms_root_gib_yb-accountingentries-entityinformation')  TO <fs_entityinformation_gib_yb>.

        "entityInformation-entityPhoneNumber-phonenumber
        <fs_entityinformation_gib_yb>-entityphonenumber-phonenumber-contextref                  = mc_journal_context.
        <fs_entityinformation_gib_yb>-entityphonenumber-phonenumber-content                     = ms_header-srkdb-tel_number.
        "entityInformation-entityPhoneNumber-phoneNumberDescription
        <fs_entityinformation_gib_yb>-entityphonenumber-phonenumberdescription-contextref       = mc_journal_context.
        <fs_entityinformation_gib_yb>-entityphonenumber-phonenumberdescription-content          = 'main'.
        "entityInformation-entityFaxNumberStructure
        <fs_entityinformation_gib_yb>-entityfaxnumberstructure-entityfaxnumber-contextref       = mc_journal_context.
        <fs_entityinformation_gib_yb>-entityfaxnumberstructure-entityfaxnumber-content          = ms_header-srkdb-fax_number.
        "entityInformation-entityEmailAddressStructure
        <fs_entityinformation_gib_yb>-entityemailaddressstructure-entityemailaddress-contextref = mc_journal_context.
        <fs_entityinformation_gib_yb>-entityemailaddressstructure-entityemailaddress-content    = ms_header-srkdb-email.
        "entityInformation-organizationIdentifiers-organizationIdentifier
        <fs_entityinformation_gib_yb>-organizationidentifiers-organizationidentifier-contextref = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationidentifiers-organizationidentifier-content    = ms_header-company_name.
        "entityInformation-organizationIdentifiers-organizationDescription
        <fs_entityinformation_gib_yb>-organizationidentifiers-organizationdescription-contextref = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationidentifiers-organizationdescription-content    = 'Kurum Unvanı'.
        "entityInformation-organizationAddress-organizationBuildingNumber
        <fs_entityinformation_gib_yb>-organizationaddress-organizationbuildingnumber-contextref = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationaddress-organizationbuildingnumber-content    = ms_header-srkdb-house_num.
        "entityInformation-organizationAddress-organizationAddressStreet
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddressstreet-contextref  = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddressstreet-content     = ms_header-srkdb-adress1.
        "entityInformation-organizationAddress-organizationAddressStreet2
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddressstreet2-contextref = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddressstreet2-content    = ms_header-srkdb-adress2.
        "entityInformation-organizationAddress-organizationAddressCity
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddresscity-contextref    = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddresscity-content       = ms_header-srkdb-city.
        "entityInformation-organizationAddress-organizationAddressZipOrPostalCode
        <fs_entityinformation_gib_yb>-organizationaddress-orgaddressziporpostalcode-contextref  = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationaddress-orgaddressziporpostalcode-content     = ms_header-srkdb-postal_code.
        "entityInformation-organizationAddress-organizationAddressCountry
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddresscountry-contextref = mc_journal_context.
        <fs_entityinformation_gib_yb>-organizationaddress-organizationaddresscountry-content    = ms_header-srkdb-country_u.
        "entityInformation-entityWebSite
        <fs_entityinformation_gib_yb>-entitywebsite-websiteurl-contextref                       = mc_journal_context.
        <fs_entityinformation_gib_yb>-entitywebsite-websiteurl-content                          = ms_header-srkdb-web.
        "entityInformation-businessDescription
        <fs_entityinformation_gib_yb>-businessdescription-contextref                            = mc_journal_context.
        <fs_entityinformation_gib_yb>-businessdescription-content                               = ms_header-srkdb-nace_code.
        "entityInformation-fiscalYearStart
        <fs_entityinformation_gib_yb>-fiscalyearstart-contextref                                = mc_journal_context.
        <fs_entityinformation_gib_yb>-fiscalyearstart-content                                   = ms_header-fiscalyearstart.
        "entityInformation-fiscalYearEnd
        <fs_entityinformation_gib_yb>-fiscalyearend-contextref                                  = mc_journal_context.
        <fs_entityinformation_gib_yb>-fiscalyearend-content                                     = ms_header-fiscalyearend.
      WHEN 4.
        ASSIGN ('ms_root_k-accountingentries-entityinformation')       TO <fs_entityinformation_k>.
        "entityInformation-entityPhoneNumber-phonenumber
        <fs_entityinformation_k>-entityphonenumber-phonenumber-contextref                  = mc_journal_context.
        <fs_entityinformation_k>-entityphonenumber-phonenumber-content                     = ms_header-srkdb-tel_number.
        "entityInformation-entityPhoneNumber-phoneNumberDescription
        <fs_entityinformation_k>-entityphonenumber-phonenumberdescription-contextref       = mc_journal_context.
        <fs_entityinformation_k>-entityphonenumber-phonenumberdescription-content          = 'main'.
        "entityInformation-entityFaxNumberStructure
        <fs_entityinformation_k>-entityfaxnumberstructure-entityfaxnumber-contextref       = mc_journal_context.
        <fs_entityinformation_k>-entityfaxnumberstructure-entityfaxnumber-content          = ms_header-srkdb-fax_number.
        "entityInformation-entityEmailAddressStructure
        <fs_entityinformation_k>-entityemailaddressstructure-entityemailaddress-contextref = mc_journal_context.
        <fs_entityinformation_k>-entityemailaddressstructure-entityemailaddress-content    = ms_header-srkdb-email.
        "entityInformation-organizationIdentifiers-organizationIdentifier
        <fs_entityinformation_k>-organizationidentifiers-organizationidentifier-contextref = mc_journal_context.
        <fs_entityinformation_k>-organizationidentifiers-organizationidentifier-content    = ms_header-company_name.
        "entityInformation-organizationIdentifiers-organizationDescription
        <fs_entityinformation_k>-organizationidentifiers-organizationdescription-contextref = mc_journal_context.
        <fs_entityinformation_k>-organizationidentifiers-organizationdescription-content    = 'Kurum Unvanı'.
        "entityInformation-organizationAddress-organizationBuildingNumber
        <fs_entityinformation_k>-organizationaddress-organizationbuildingnumber-contextref = mc_journal_context.
        <fs_entityinformation_k>-organizationaddress-organizationbuildingnumber-content    = ms_header-srkdb-house_num.
        "entityInformation-organizationAddress-organizationAddressStreet
        <fs_entityinformation_k>-organizationaddress-organizationaddressstreet-contextref  = mc_journal_context.
        <fs_entityinformation_k>-organizationaddress-organizationaddressstreet-content     = ms_header-srkdb-adress1.
        "entityInformation-organizationAddress-organizationAddressStreet2
        <fs_entityinformation_k>-organizationaddress-organizationaddressstreet2-contextref = mc_journal_context.
        <fs_entityinformation_k>-organizationaddress-organizationaddressstreet2-content    = ms_header-srkdb-adress2.
        "entityInformation-organizationAddress-organizationAddressCity
        <fs_entityinformation_k>-organizationaddress-organizationaddresscity-contextref    = mc_journal_context.
        <fs_entityinformation_k>-organizationaddress-organizationaddresscity-content       = ms_header-srkdb-city.
        "entityInformation-organizationAddress-organizationAddressZipOrPostalCode
        <fs_entityinformation_k>-organizationaddress-orgaddressziporpostalcode-contextref  = mc_journal_context.
        <fs_entityinformation_k>-organizationaddress-orgaddressziporpostalcode-content     = ms_header-srkdb-postal_code.
        "entityInformation-organizationAddress-organizationAddressCountry
        <fs_entityinformation_k>-organizationaddress-organizationaddresscountry-contextref = mc_journal_context.
        <fs_entityinformation_k>-organizationaddress-organizationaddresscountry-content    = ms_header-srkdb-country_u.
        "entityInformation-entityWebSite
        <fs_entityinformation_k>-entitywebsite-websiteurl-contextref                       = mc_journal_context.
        <fs_entityinformation_k>-entitywebsite-websiteurl-content                          = ms_header-srkdb-web.
        "entityInformation-businessDescription
        <fs_entityinformation_k>-businessdescription-contextref                            = mc_journal_context.
        <fs_entityinformation_k>-businessdescription-content                               = ms_header-srkdb-nace_code.
        "entityInformation-fiscalYearStart
        <fs_entityinformation_k>-fiscalyearstart-contextref                                = mc_journal_context.
        <fs_entityinformation_k>-fiscalyearstart-content                                   = ms_header-fiscalyearstart.
        "entityInformation-fiscalYearEnd
        <fs_entityinformation_k>-fiscalyearend-contextref                                  = mc_journal_context.
        <fs_entityinformation_k>-fiscalyearend-content                                     = ms_header-fiscalyearend.
      WHEN 5.
        ASSIGN ('ms_root_kb-accountingentries-entityinformation')      TO <fs_entityinformation_kb>.
        "entityInformation-entityPhoneNumber-phonenumber
        <fs_entityinformation_kb>-entityphonenumber-phonenumber-contextref                  = mc_journal_context.
        <fs_entityinformation_kb>-entityphonenumber-phonenumber-content                     = ms_header-srkdb-tel_number.
        "entityInformation-entityPhoneNumber-phoneNumberDescription
        <fs_entityinformation_kb>-entityphonenumber-phonenumberdescription-contextref       = mc_journal_context.
        <fs_entityinformation_kb>-entityphonenumber-phonenumberdescription-content          = 'main'.
        "entityInformation-entityFaxNumberStructure
        <fs_entityinformation_kb>-entityfaxnumberstructure-entityfaxnumber-contextref       = mc_journal_context.
        <fs_entityinformation_kb>-entityfaxnumberstructure-entityfaxnumber-content          = ms_header-srkdb-fax_number.
        "entityInformation-entityEmailAddressStructure
        <fs_entityinformation_kb>-entityemailaddressstructure-entityemailaddress-contextref = mc_journal_context.
        <fs_entityinformation_kb>-entityemailaddressstructure-entityemailaddress-content    = ms_header-srkdb-email.
        "entityInformation-organizationIdentifiers-organizationIdentifier
        <fs_entityinformation_kb>-organizationidentifiers-organizationidentifier-contextref = mc_journal_context.
        <fs_entityinformation_kb>-organizationidentifiers-organizationidentifier-content    = ms_header-company_name.
        "entityInformation-organizationIdentifiers-organizationDescription
        <fs_entityinformation_kb>-organizationidentifiers-organizationdescription-contextref = mc_journal_context.
        <fs_entityinformation_kb>-organizationidentifiers-organizationdescription-content    = 'Kurum Unvanı'.
        "entityInformation-organizationAddress-organizationBuildingNumber
        <fs_entityinformation_kb>-organizationaddress-organizationbuildingnumber-contextref = mc_journal_context.
        <fs_entityinformation_kb>-organizationaddress-organizationbuildingnumber-content    = ms_header-srkdb-house_num.
        "entityInformation-organizationAddress-organizationAddressStreet
        <fs_entityinformation_kb>-organizationaddress-organizationaddressstreet-contextref  = mc_journal_context.
        <fs_entityinformation_kb>-organizationaddress-organizationaddressstreet-content     = ms_header-srkdb-adress1.
        "entityInformation-organizationAddress-organizationAddressStreet2
        <fs_entityinformation_kb>-organizationaddress-organizationaddressstreet2-contextref = mc_journal_context.
        <fs_entityinformation_kb>-organizationaddress-organizationaddressstreet2-content    = ms_header-srkdb-adress2.
        "entityInformation-organizationAddress-organizationAddressCity
        <fs_entityinformation_kb>-organizationaddress-organizationaddresscity-contextref    = mc_journal_context.
        <fs_entityinformation_kb>-organizationaddress-organizationaddresscity-content       = ms_header-srkdb-city.
        "entityInformation-organizationAddress-organizationAddressZipOrPostalCode
        <fs_entityinformation_kb>-organizationaddress-orgaddressziporpostalcode-contextref  = mc_journal_context.
        <fs_entityinformation_kb>-organizationaddress-orgaddressziporpostalcode-content     = ms_header-srkdb-postal_code.
        "entityInformation-organizationAddress-organizationAddressCountry
        <fs_entityinformation_kb>-organizationaddress-organizationaddresscountry-contextref = mc_journal_context.
        <fs_entityinformation_kb>-organizationaddress-organizationaddresscountry-content    = ms_header-srkdb-country_u.
        "entityInformation-entityWebSite
        <fs_entityinformation_kb>-entitywebsite-websiteurl-contextref                       = mc_journal_context.
        <fs_entityinformation_kb>-entitywebsite-websiteurl-content                          = ms_header-srkdb-web.
        "entityInformation-businessDescription
        <fs_entityinformation_kb>-businessdescription-contextref                            = mc_journal_context.
        <fs_entityinformation_kb>-businessdescription-content                               = ms_header-srkdb-nace_code.
        "entityInformation-fiscalYearStart
        <fs_entityinformation_kb>-fiscalyearstart-contextref                                = mc_journal_context.
        <fs_entityinformation_kb>-fiscalyearstart-content                                   = ms_header-fiscalyearstart.
        "entityInformation-fiscalYearEnd
        <fs_entityinformation_kb>-fiscalyearend-contextref                                  = mc_journal_context.
        <fs_entityinformation_kb>-fiscalyearend-content                                     = ms_header-fiscalyearend.
      WHEN 6.
        ASSIGN ('ms_root_gib_kb-accountingentries-entityinformation')  TO <fs_entityinformation_gib_kb>.
        "entityInformation-entityPhoneNumber-phonenumber
        <fs_entityinformation_gib_kb>-entityphonenumber-phonenumber-contextref                  = mc_journal_context.
        <fs_entityinformation_gib_kb>-entityphonenumber-phonenumber-content                     = ms_header-srkdb-tel_number.
        "entityInformation-entityPhoneNumber-phoneNumberDescription
        <fs_entityinformation_gib_kb>-entityphonenumber-phonenumberdescription-contextref       = mc_journal_context.
        <fs_entityinformation_gib_kb>-entityphonenumber-phonenumberdescription-content          = 'main'.
        "entityInformation-entityFaxNumberStructure
        <fs_entityinformation_gib_kb>-entityfaxnumberstructure-entityfaxnumber-contextref       = mc_journal_context.
        <fs_entityinformation_gib_kb>-entityfaxnumberstructure-entityfaxnumber-content          = ms_header-srkdb-fax_number.
        "entityInformation-entityEmailAddressStructure
        <fs_entityinformation_gib_kb>-entityemailaddressstructure-entityemailaddress-contextref = mc_journal_context.
        <fs_entityinformation_gib_kb>-entityemailaddressstructure-entityemailaddress-content    = ms_header-srkdb-email.
        "entityInformation-organizationIdentifiers-organizationIdentifier
        <fs_entityinformation_gib_kb>-organizationidentifiers-organizationidentifier-contextref = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationidentifiers-organizationidentifier-content    = ms_header-company_name.
        "entityInformation-organizationIdentifiers-organizationDescription
        <fs_entityinformation_gib_kb>-organizationidentifiers-organizationdescription-contextref = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationidentifiers-organizationdescription-content    = 'Kurum Unvanı'.
        "entityInformation-organizationAddress-organizationBuildingNumber
        <fs_entityinformation_gib_kb>-organizationaddress-organizationbuildingnumber-contextref = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationaddress-organizationbuildingnumber-content    = ms_header-srkdb-house_num.
        "entityInformation-organizationAddress-organizationAddressStreet
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddressstreet-contextref  = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddressstreet-content     = ms_header-srkdb-adress1.
        "entityInformation-organizationAddress-organizationAddressStreet2
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddressstreet2-contextref = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddressstreet2-content    = ms_header-srkdb-adress2.
        "entityInformation-organizationAddress-organizationAddressCity
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddresscity-contextref    = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddresscity-content       = ms_header-srkdb-city.
        "entityInformation-organizationAddress-organizationAddressZipOrPostalCode
        <fs_entityinformation_gib_kb>-organizationaddress-orgaddressziporpostalcode-contextref  = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationaddress-orgaddressziporpostalcode-content     = ms_header-srkdb-postal_code.
        "entityInformation-organizationAddress-organizationAddressCountry
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddresscountry-contextref = mc_journal_context.
        <fs_entityinformation_gib_kb>-organizationaddress-organizationaddresscountry-content    = ms_header-srkdb-country_u.
        "entityInformation-entityWebSite
        <fs_entityinformation_gib_kb>-entitywebsite-websiteurl-contextref                       = mc_journal_context.
        <fs_entityinformation_gib_kb>-entitywebsite-websiteurl-content                          = ms_header-srkdb-web.
        "entityInformation-businessDescription
        <fs_entityinformation_gib_kb>-businessdescription-contextref                            = mc_journal_context.
        <fs_entityinformation_gib_kb>-businessdescription-content                               = ms_header-srkdb-nace_code.
        "entityInformation-fiscalYearStart
        <fs_entityinformation_gib_kb>-fiscalyearstart-contextref                                = mc_journal_context.
        <fs_entityinformation_gib_kb>-fiscalyearstart-content                                   = ms_header-fiscalyearstart.
        "entityInformation-fiscalYearEnd
        <fs_entityinformation_gib_kb>-fiscalyearend-contextref                                  = mc_journal_context.
        <fs_entityinformation_gib_kb>-fiscalyearend-content                                     = ms_header-fiscalyearend.
      WHEN 7.
        ASSIGN ('ms_root_dr-accountingentries-entityinformation')      TO <fs_entityinformation_dr>.
        "entityInformation-entityPhoneNumber-phonenumber
        <fs_entityinformation_dr>-entityphonenumber-phonenumber-contextref                  = mc_now.
        <fs_entityinformation_dr>-entityphonenumber-phonenumber-content                     = ms_header-srkdb-tel_number.
        "entityInformation-entityPhoneNumber-phoneNumberDescription
        <fs_entityinformation_dr>-entityphonenumber-phonenumberdescription-contextref       = mc_now.
        <fs_entityinformation_dr>-entityphonenumber-phonenumberdescription-content          = 'main'.
        "entityInformation-entityFaxNumberStructure
        <fs_entityinformation_dr>-entityfaxnumberstructure-entityfaxnumber-contextref       = mc_now.
        <fs_entityinformation_dr>-entityfaxnumberstructure-entityfaxnumber-content          = ms_header-srkdb-fax_number.
        "entityInformation-entityEmailAddressStructure
        <fs_entityinformation_dr>-entityemailaddressstructure-entityemailaddress-contextref = mc_now.
        <fs_entityinformation_dr>-entityemailaddressstructure-entityemailaddress-content    = ms_header-srkdb-email.
        "entityInformation-organizationIdentifiers-organizationIdentifier
        <fs_entityinformation_dr>-organizationidentifiers-organizationidentifier-contextref = mc_now.
        <fs_entityinformation_dr>-organizationidentifiers-organizationidentifier-content    = ms_header-company_name.
        "entityInformation-organizationIdentifiers-organizationDescription
        <fs_entityinformation_dr>-organizationidentifiers-organizationdescription-contextref = mc_now.
        <fs_entityinformation_dr>-organizationidentifiers-organizationdescription-content    = 'Kurum Unvanı'.
        "entityInformation-organizationAddress-organizationBuildingNumber
        <fs_entityinformation_dr>-organizationaddress-organizationbuildingnumber-contextref = mc_now.
        <fs_entityinformation_dr>-organizationaddress-organizationbuildingnumber-content    = ms_header-srkdb-house_num.
        "entityInformation-organizationAddress-organizationAddressStreet
        <fs_entityinformation_dr>-organizationaddress-organizationaddressstreet-contextref  = mc_now.
        <fs_entityinformation_dr>-organizationaddress-organizationaddressstreet-content     = ms_header-srkdb-adress1.
        "entityInformation-organizationAddress-organizationAddressStreet2
        <fs_entityinformation_dr>-organizationaddress-organizationaddressstreet2-contextref = mc_now.
        <fs_entityinformation_dr>-organizationaddress-organizationaddressstreet2-content    = ms_header-srkdb-adress2.
        "entityInformation-organizationAddress-organizationAddressCity
        <fs_entityinformation_dr>-organizationaddress-organizationaddresscity-contextref    = mc_now.
        <fs_entityinformation_dr>-organizationaddress-organizationaddresscity-content       = ms_header-srkdb-city.
        "entityInformation-organizationAddress-organizationAddressZipOrPostalCode
        <fs_entityinformation_dr>-organizationaddress-orgaddressziporpostalcode-contextref  = mc_now.
        <fs_entityinformation_dr>-organizationaddress-orgaddressziporpostalcode-content     = ms_header-srkdb-postal_code.
        "entityInformation-organizationAddress-organizationAddressCountry
        <fs_entityinformation_dr>-organizationaddress-organizationaddresscountry-contextref = mc_now.
        <fs_entityinformation_dr>-organizationaddress-organizationaddresscountry-content    = ms_header-srkdb-country_u.
        "entityInformation-entityWebSite
        <fs_entityinformation_dr>-entitywebsite-websiteurl-contextref                       = mc_now.
        <fs_entityinformation_dr>-entitywebsite-websiteurl-content                          = ms_header-srkdb-web.
        "entityInformation-businessDescription
        <fs_entityinformation_dr>-businessdescription-contextref                            = mc_now.
        <fs_entityinformation_dr>-businessdescription-content                               = ms_header-srkdb-nace_code.
        "entityInformation-fiscalYearStart
        <fs_entityinformation_dr>-fiscalyearstart-contextref                                = mc_now.
        <fs_entityinformation_dr>-fiscalyearstart-content                                   = ms_header-fiscalyearstart.
        "entityInformation-fiscalYearEnd
        <fs_entityinformation_dr>-fiscalyearend-contextref                                  = mc_now.
        <fs_entityinformation_dr>-fiscalyearend-content                                     = ms_header-fiscalyearend.
    ENDCASE.




  ENDMETHOD.


  METHOD generate_html.


    DATA lo_xslt_processor  TYPE REF TO cl_xslt_processor.
    DATA lo_ixml            TYPE REF TO if_ixml.
    DATA lo_stream_factory  TYPE REF TO if_ixml_stream_factory.
    DATA lo_resstr          TYPE REF TO if_ixml_ostream.
    DATA lo_srcstr          TYPE REF TO if_ixml_istream.
    DATA lv_xslt_name TYPE progname.


    CASE iv_xmlty.
      WHEN '1'.
        lv_xslt_name = '/ITETR/EDF_HTML_YEVMIYE_XSLT'.
      WHEN '2'.
        lv_xslt_name = '/ITETR/EDF_HTML_BERAT_XSLT'.
      WHEN '3'.
        lv_xslt_name = '/ITETR/EDF_HTML_BERAT_XSLT'.
      WHEN '4'.
        lv_xslt_name = '/ITETR/EDF_HTML_KEBIR_XSLT'.
      WHEN '5'.
        lv_xslt_name = '/ITETR/EDF_HTML_BERAT_XSLT'.
      WHEN '6'.
        lv_xslt_name = '/ITETR/EDF_HTML_BERAT_XSLT'.
      WHEN '7'.
        lv_xslt_name = '/ITETR/EDF_HTML_DEFTER_XSLT'.
    ENDCASE.


    CREATE OBJECT lo_xslt_processor.

    lo_ixml           = cl_ixml=>create( ).
    lo_stream_factory = lo_ixml->create_stream_factory( ).
    lo_srcstr = lo_stream_factory->create_istream_xstring( string = iv_xml ).
    lo_xslt_processor->set_source_stream( stream = lo_srcstr ).
    lo_resstr = lo_stream_factory->create_ostream_xstring( string = rv_html ).
    lo_xslt_processor->set_result_stream( stream = lo_resstr ).
    lo_xslt_processor->run( progname = lv_xslt_name ).


  ENDMETHOD.


  METHOD generate_xml.

    DATA lo_root     TYPE REF TO cx_root.
    DATA lv_xslt_name TYPE progname.
    FIELD-SYMBOLS <fs_root> TYPE any.

    CASE iv_xmlty.
      WHEN '1'.
        lv_xslt_name = '/ITETR/EDF_XML_Y_FORMAT_ST'.
        ASSIGN ms_root_y TO <fs_root>.
      WHEN '2'.
        lv_xslt_name = '/ITETR/EDF_XML_YB_FORMAT_ST'.
        ASSIGN ms_root_yb TO <fs_root>.
      WHEN '3'.
        lv_xslt_name = '/ITETR/EDF_XML_YB_FORMAT_ST'.
        ASSIGN ms_root_yb TO <fs_root>.
      WHEN '4'.
        lv_xslt_name = '/ITETR/EDF_XML_K_FORMAT_ST'.
        ASSIGN ms_root_k TO <fs_root>.
      WHEN '5'.
        lv_xslt_name = '/ITETR/EDF_XML_KB_FORMAT_ST'.
        ASSIGN ms_root_kb TO <fs_root>.
      WHEN '6'.
        lv_xslt_name = '/ITETR/EDF_XML_KB_FORMAT_ST'.
        ASSIGN ms_root_kb TO <fs_root>.
      WHEN '7'.
        lv_xslt_name = '/ITETR/EDF_XML_DR_FORMAT_ST'.
        ASSIGN ms_root_dr TO <fs_root>.
    ENDCASE.


    IF <fs_root> IS NOT INITIAL.
      TRY.
          CALL TRANSFORMATION (lv_xslt_name)
            SOURCE root_val = <fs_root>
            RESULT XML rv_xml
            OPTIONS xml_header = 'full'.
        CATCH cx_root INTO lo_root.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  method IDENTIFIER.

    FIELD-SYMBOLS <fs_indentifier> type /ITETR/IF_EDF_XML_Y=>ty_identifier.


    case IV_XMLTY.
      when 1.
       ASSIGN ('ms_root_y-context-entity-identifier') to <fs_indentifier>.
      WHEN 2.
       ASSIGN ('ms_root_yb-context-entity-identifier') to <fs_indentifier>.
      WHEN 3.
       ASSIGN ('ms_root_gib_yb-context-entity-identifier') to <fs_indentifier>.
      when 4.
       ASSIGN ('ms_root_k-context-entity-identifier') to <fs_indentifier>.
       when 5.
       ASSIGN ('ms_root_kb-context-entity-identifier') to <fs_indentifier>.
       when 6.
       ASSIGN ('ms_root_gib_kb-context-entity-identifier') to <fs_indentifier>.
       when 7.
       ASSIGN ('ms_root_dr-context-entity-identifier') to <fs_indentifier>.
    ENDCASE.


    <fs_indentifier>-scheme  = 'http://www.gib.gov.tr'.
    <fs_indentifier>-content = ms_header-stcd1.

  endmethod.


  METHOD instant.

    FIELD-SYMBOLS <fs_instant> TYPE /itetr/if_edf_xml_y=>ty_instant.

    CASE iv_xmlty.
      WHEN 1.
        ASSIGN ('ms_root_y-context-period-instant')      TO <fs_instant>.
      WHEN 2.
        ASSIGN ('ms_root_yb-context-period-instant')     TO <fs_instant>.
      WHEN 3.
        ASSIGN ('ms_root_gib_yb-context-period-instant') TO <fs_instant>.
      WHEN 4.
        ASSIGN ('ms_root_k-context-period-instant')      TO <fs_instant>.
      WHEN 5.
        ASSIGN ('ms_root_kb-context-period-instant')     TO <fs_instant>.
      WHEN 6.
        ASSIGN ('ms_root_gib_kb-context-period-instant') TO <fs_instant>.
      WHEN 7.
        ASSIGN ('ms_root_dr-context-period-instant')     TO <fs_instant>.
    ENDCASE.

    <fs_instant>-content    = ms_header-period.

  ENDMETHOD.


  METHOD save.

    DATA lv_counter(1).
    DATA lv_file_count TYPE i.
    DATA ls_dihhd TYPE /itetr/edf_dihhd.
    DATA lt_dihhd TYPE TABLE OF /itetr/edf_dihhd.
    DATA lv_ftype TYPE /itetr/edf_dihhd-ftype.
    DATA lv_xml   TYPE xstring.
    DATA lv_html  TYPE xstring.
    DATA lo_root  TYPE REF TO cx_root.


    DO 7 TIMES.
      CLEAR lv_xml.
      CLEAR lv_html.
      CLEAR lv_file_count.
      ADD 1 TO lv_counter.

      DO 2 TIMES.
        ADD 1 TO lv_file_count.

        CLEAR ls_dihhd.

        IF lv_counter EQ '1'.
          ls_dihhd-dfile = 'Y'.
        ELSEIF lv_counter EQ '2'.
          ls_dihhd-dfile = 'YB'.
        ELSEIF lv_counter EQ '3'.
          ls_dihhd-dfile = 'GIB-YB'.
        ELSEIF lv_counter EQ '4'.
          ls_dihhd-dfile = 'K'.
        ELSEIF lv_counter EQ '5'.
          ls_dihhd-dfile = 'KB'.
        ELSEIF lv_counter EQ '6'.
          ls_dihhd-dfile = 'GIB-KB'.
        ELSEIF lv_counter EQ '7'.
          ls_dihhd-dfile = 'DR'.
        ENDIF.

        CASE lv_file_count.
          WHEN '1'.
            TRY.
                CALL METHOD me->generate_xml
                  EXPORTING
                    iv_xmlty = lv_counter
                  RECEIVING
                    rv_xml   = lv_xml.

                ls_dihhd-ftype = 'XML'.
                ls_dihhd-filex = lv_xml.
              CATCH cx_root INTO lo_root.
            ENDTRY.
          WHEN '2'.
            TRY.
                CALL METHOD me->generate_html
                  EXPORTING
                    iv_xmlty = lv_counter
                    iv_xml   = lv_xml
                  RECEIVING
                    rv_html  = lv_html.

                ls_dihhd-ftype = 'HTML'.
                ls_dihhd-filex = lv_html.
              CATCH cx_root INTO lo_root.
            ENDTRY.
        ENDCASE.


        IF ls_dihhd-ftype IS NOT INITIAL.

          ls_dihhd-bukrs = iv_bukrs.
          ls_dihhd-bcode = iv_bcode.
          ls_dihhd-gjahr = iv_gjahr.
          ls_dihhd-monat = iv_monat.
          ls_dihhd-partn = iv_partn.

          APPEND ls_dihhd TO lt_dihhd.
          CLEAR ls_dihhd.

        ENDIF.

      ENDDO.

    ENDDO.

    IF lines( lt_dihhd ) GT 0.
      MODIFY /itetr/edf_dihhd FROM TABLE lt_dihhd[].
      COMMIT WORK AND WAIT.
    ENDIF.


  ENDMETHOD.


  METHOD SET_HEADER.

    CLEAR ms_header.
    ms_header = is_header.
    CALL METHOD me->identifier( EXPORTING iv_xmlty = iv_xmlty ).
    CALL METHOD me->instant( EXPORTING iv_xmlty = iv_xmlty ).
    CALL METHOD me->unit( EXPORTING iv_xmlty = iv_xmlty ).
    CALL METHOD me->entityinformation( EXPORTING iv_xmlty = iv_xmlty ).
    CALL METHOD me->documentinfo( EXPORTING iv_xmlty = iv_xmlty ).
    CALL METHOD me->accountantinformation( EXPORTING iv_xmlty = iv_xmlty ).

  ENDMETHOD.


  METHOD set_head_dr.

    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_dr=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_dr=>ty_entrydetail.


    IF lines( ms_root_dr-accountingentries-entryheader ) EQ 0.

      APPEND INITIAL LINE TO ms_root_dr-accountingentries-entryheader ASSIGNING <fs_entryheader>.

      <fs_entryheader>-qualifierentry-contextref = mc_now.
      <fs_entryheader>-qualifierentry-content    = mc_standard.

      DO 32 TIMES.

        APPEND INITIAL LINE TO <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail>.
        <fs_entrydetail>-linenumber-contextref                      = mc_now.
        <fs_entrydetail>-account-accountmainid-contextref           = mc_now.
        <fs_entrydetail>-account-accountmaindescription-contextref  = mc_now.
        <fs_entrydetail>-amount-contextref                          = mc_now.
        <fs_entrydetail>-amount-decimals                            = mc_inf.
        <fs_entrydetail>-amount-unitref                             = is_head-waers.
        TRANSLATE <fs_entrydetail>-amount-unitref TO LOWER CASE.
        <fs_entrydetail>-debitcreditcode-contextref                 = mc_now.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-contextref            = mc_now.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-content               = mc_period_change.
        <fs_entrydetail>-documentapplytonumber-contextref           = mc_now.
        <fs_entrydetail>-documentapplytonumber-content              = '0'.
        CONDENSE <fs_entrydetail>-documentapplytonumber-content NO-GAPS.
        <fs_entrydetail>-amount-content                             = '0'.
        CONDENSE <fs_entrydetail>-amount-content NO-GAPS.
        CASE sy-tabix.
          WHEN 1.
            <fs_entrydetail>-linenumber-content                         = '1'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '100'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'KASA'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 2.
            <fs_entrydetail>-linenumber-content                         = '2'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '100'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'KASA'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 3.
            <fs_entrydetail>-linenumber-content                         = '3'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '101'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'ALINAN ÇEKLER'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 4.
            <fs_entrydetail>-linenumber-content                         = '4'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '101'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'ALINAN ÇEKLER'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 5.
            <fs_entrydetail>-linenumber-content                         = '5'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '102'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'BANKALAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 6.
            <fs_entrydetail>-linenumber-content                         = '6'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '102'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'BANKALAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 7.
            <fs_entrydetail>-linenumber-content                         = '7'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '120'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'ALICILAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 8.
            <fs_entrydetail>-linenumber-content                         = '8'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '120'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'ALICILAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 9.
            <fs_entrydetail>-linenumber-content                         = '9'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '121'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'ALACAK SENETLERİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 10.
            <fs_entrydetail>-linenumber-content                         = '10'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '121'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'ALACAK SENETLERİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 11.
            <fs_entrydetail>-linenumber-content                         = '11'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '135'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'PERSONELDEN ALACAKLAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 12.
            <fs_entrydetail>-linenumber-content                         = '12'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '135'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'PERSONELDEN ALACAKLAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 13.
            <fs_entrydetail>-linenumber-content                         = '13'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '153'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'TİCARİ MALLAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 14.
            <fs_entrydetail>-linenumber-content                         = '14'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '153'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'TİCARİ MALLAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 15.
            <fs_entrydetail>-linenumber-content                         = '15'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '190'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'DEVREDEN KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 16.
            <fs_entrydetail>-linenumber-content                         = '16'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '190'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'DEVREDEN KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 17.
            <fs_entrydetail>-linenumber-content                         = '17'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İNDİRİLECEK KATMA DEĞER VERGİSİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 18.
            <fs_entrydetail>-linenumber-content                         = '18'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İNDİRİLECEK KATMA DEĞER VERGİSİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 19.
            <fs_entrydetail>-linenumber-content                         = '19'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '320'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'SATICILAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 20.
            <fs_entrydetail>-linenumber-content                         = '20'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '320'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'SATICILAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 21.
            <fs_entrydetail>-linenumber-content                         = '21'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'HESAPLANAN KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 22.
            <fs_entrydetail>-linenumber-content                         = '22'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'HESAPLANAN KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 23.
            <fs_entrydetail>-linenumber-content                         = '23'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '500'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'SERMAYE'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 24.
            <fs_entrydetail>-linenumber-content                         = '24'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '500'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'SERMAYE'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 25.
            <fs_entrydetail>-linenumber-content                         = '25'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '590'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'DÖNEM NET KÂRI'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 26.                                                        "
            <fs_entrydetail>-linenumber-content                         = '26'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '590'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'DÖNEM NET KÂRI'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 27.                                                        "
            <fs_entrydetail>-linenumber-content                         = '27'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'YURTİÇİ SATIŞLAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 28.                                                         "
            <fs_entrydetail>-linenumber-content                         = '28'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'YURTİÇİ SATIŞLAR'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 29.                                                         "
            <fs_entrydetail>-linenumber-content                         = '29'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '620'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'SATILAN MAMÜLLER MALİYETİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 30.                                                         "
            <fs_entrydetail>-linenumber-content                         = '30'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '620'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'GSATILAN MAMÜLLER MALİYETİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 31.
            <fs_entrydetail>-linenumber-content                         = '31'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '770'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'GENEL YÖNETİM GİDERLERİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 32.
            <fs_entrydetail>-linenumber-content                         = '32'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '770'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'GENEL YÖNETİM GİDERLERİ'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
        ENDCASE.

      ENDDO.

    ENDIF.

  ENDMETHOD.


  METHOD SET_HEAD_GIB_KB.

    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_kb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_kb=>ty_entrydetail.



   IF lines( ms_root_gib_kb-accountingentries-entryheader ) EQ 0.

      APPEND INITIAL LINE TO ms_root_gib_kb-accountingentries-entryheader ASSIGNING <fs_entryheader>.

      <fs_entryheader>-qualifierentry-contextref = mc_ledger_context.
      <fs_entryheader>-qualifierentry-content    = mc_standard.


        DO 10 TIMES.

        APPEND INITIAL LINE TO <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail>.
        <fs_entrydetail>-linenumber-contextref                      = mc_ledger_context.
        <fs_entrydetail>-account-accountmainid-contextref           = mc_ledger_context.
        <fs_entrydetail>-account-accountmaindescription-contextref  = mc_ledger_context.
        <fs_entrydetail>-amount-contextref                          = mc_ledger_context.
        <fs_entrydetail>-amount-decimals                            = mc_inf.
        <fs_entrydetail>-amount-unitref                             = is_head-waers.
        TRANSLATE <fs_entrydetail>-amount-unitref TO LOWER CASE.
        <fs_entrydetail>-debitcreditcode-contextref                 = mc_ledger_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-contextref            = mc_ledger_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-content               = mc_period_change.
        <fs_entrydetail>-amount-content                             = '0'.
        CONDENSE <fs_entrydetail>-amount-content NO-GAPS.
        CASE sy-tabix.
          WHEN 1.
            <fs_entrydetail>-linenumber-content                         = '1'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 2.
            <fs_entrydetail>-linenumber-content                         = '2'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 3.
            <fs_entrydetail>-linenumber-content                         = '3'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 4.
            <fs_entrydetail>-linenumber-content                         = '4'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 5.
            <fs_entrydetail>-linenumber-content                         = '5'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 6.
            <fs_entrydetail>-linenumber-content                         = '6'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 7.
            <fs_entrydetail>-linenumber-content                         = '7'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 8.
            <fs_entrydetail>-linenumber-content                         = '8'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 9.
            <fs_entrydetail>-linenumber-content                         = '9'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 10.
            <fs_entrydetail>-linenumber-content                         = '10'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
        ENDCASE.

      ENDDO.

    ENDIF.

  ENDMETHOD.


  METHOD set_head_gib_yb.

    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_yb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_yb=>ty_entrydetail.

    IF lines( ms_root_gib_yb-accountingentries-entryheader ) EQ 0.

      APPEND INITIAL LINE TO ms_root_gib_yb-accountingentries-entryheader ASSIGNING <fs_entryheader>.

      <fs_entryheader>-qualifierentry-contextref = mc_journal_context.
      <fs_entryheader>-qualifierentry-content    = mc_standard.


       DO 10 TIMES.

        APPEND INITIAL LINE TO <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail>.
        <fs_entrydetail>-linenumber-contextref                      = mc_journal_context.
        <fs_entrydetail>-account-accountmainid-contextref           = mc_journal_context.
        <fs_entrydetail>-account-accountmaindescription-contextref  = mc_journal_context.
        <fs_entrydetail>-amount-contextref                          = mc_journal_context.
        <fs_entrydetail>-amount-decimals                            = mc_inf.
        <fs_entrydetail>-amount-unitref                             = is_head-waers.
        TRANSLATE <fs_entrydetail>-amount-unitref TO LOWER CASE.
        <fs_entrydetail>-debitcreditcode-contextref                 = mc_journal_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-contextref            = mc_journal_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-content               = mc_period_change.
        <fs_entrydetail>-amount-content                             = '0'.
        CONDENSE <fs_entrydetail>-amount-content NO-GAPS.
        CASE sy-tabix.
          WHEN 1.
            <fs_entrydetail>-linenumber-content                         = '1'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 2.
            <fs_entrydetail>-linenumber-content                         = '2'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 3.
            <fs_entrydetail>-linenumber-content                         = '3'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 4.
            <fs_entrydetail>-linenumber-content                         = '4'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 5.
            <fs_entrydetail>-linenumber-content                         = '5'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 6.
            <fs_entrydetail>-linenumber-content                         = '6'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 7.
            <fs_entrydetail>-linenumber-content                         = '7'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 8.
            <fs_entrydetail>-linenumber-content                         = '8'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 9.
            <fs_entrydetail>-linenumber-content                         = '9'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 10.
            <fs_entrydetail>-linenumber-content                         = '10'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
        ENDCASE.

      ENDDO.

    ENDIF.

  ENDMETHOD.


  METHOD set_head_k.

    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_k=>ty_entryheader.

*    APPEND INITIAL LINE TO ms_root_k-accountingentries-entryheader ASSIGNING <fs_entryheader>.
*
*
*    <fs_entryheader>-totaldebit-contextref  = mc_ledger_context.
*    <fs_entryheader>-totaldebit-decimals    = mc_inf.
*    <fs_entryheader>-totaldebit-unitref     = is_head-waers.
*    TRANSLATE <fs_entryheader>-totaldebit-unitref TO LOWER CASE.
*    <fs_entryheader>-totalcredit-contextref = mc_ledger_context.
*    <fs_entryheader>-totalcredit-decimals   = mc_inf.
*    <fs_entryheader>-totalcredit-contextref = is_head-waers.
*    TRANSLATE <fs_entryheader>-totalcredit-unitref TO LOWER CASE.

  ENDMETHOD.


  METHOD SET_HEAD_KB.

    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_kb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_kb=>ty_entrydetail.

    IF lines( ms_root_kb-accountingentries-entryheader ) EQ 0.

      APPEND INITIAL LINE TO ms_root_kb-accountingentries-entryheader ASSIGNING <fs_entryheader>.

      <fs_entryheader>-qualifierentry-contextref = mc_ledger_context.
      <fs_entryheader>-qualifierentry-content    = mc_standard.


       DO 10 TIMES.

        APPEND INITIAL LINE TO <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail>.
        <fs_entrydetail>-linenumber-contextref                      = mc_ledger_context.
        <fs_entrydetail>-account-accountmainid-contextref           = mc_ledger_context.
        <fs_entrydetail>-account-accountmaindescription-contextref  = mc_ledger_context.
        <fs_entrydetail>-amount-contextref                          = mc_ledger_context.
        <fs_entrydetail>-amount-decimals                            = mc_inf.
        <fs_entrydetail>-amount-unitref                             = is_head-waers.
        TRANSLATE <fs_entrydetail>-amount-unitref TO LOWER CASE.
        <fs_entrydetail>-debitcreditcode-contextref                 = mc_ledger_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-contextref            = mc_ledger_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-content               = mc_period_change.
        <fs_entrydetail>-amount-content                             = '0'.
        CONDENSE <fs_entrydetail>-amount-content NO-GAPS.
        CASE sy-tabix.
          WHEN 1.
            <fs_entrydetail>-linenumber-content                         = '1'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 2.
            <fs_entrydetail>-linenumber-content                         = '2'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 3.
            <fs_entrydetail>-linenumber-content                         = '3'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 4.
            <fs_entrydetail>-linenumber-content                         = '4'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 5.
            <fs_entrydetail>-linenumber-content                         = '5'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 6.
            <fs_entrydetail>-linenumber-content                         = '6'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 7.
            <fs_entrydetail>-linenumber-content                         = '7'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 8.
            <fs_entrydetail>-linenumber-content                         = '8'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 9.
            <fs_entrydetail>-linenumber-content                         = '9'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 10.
            <fs_entrydetail>-linenumber-content                         = '10'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
        ENDCASE.

      ENDDO.

    ENDIF.

  ENDMETHOD.


  METHOD set_head_y.

    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_y=>ty_entryheader.

*    APPEND INITIAL LINE TO ms_root_y-accountingentries-entryheader ASSIGNING <fs_entryheader>.
*
*    <fs_entryheader>-enteredby-contextref    = mc_journal_context.
*    <fs_entryheader>-enteredby-content       = is_head-enteredby.
*    <fs_entryheader>-entereddate-contextref  = mc_journal_context.
*    <fs_entryheader>-entereddate-content     = is_head-entereddate.
*    <fs_entryheader>-entrynumber-contextref  = mc_journal_context.
*    <fs_entryheader>-entrynumber-content     = is_head-header-belnr.
*    <fs_entryheader>-entrycomment-contextref = mc_journal_context.
*    <fs_entryheader>-entrycomment-content    = is_head-entrycomment.
*
*
*    <fs_entryheader>-totaldebit-contextref = mc_journal_context.
*    <fs_entryheader>-totaldebit-decimals   = mc_inf.
*    <fs_entryheader>-totaldebit-unitref    = is_head-waers.
*    TRANSLATE <fs_entryheader>-totaldebit-unitref TO LOWER CASE.
*
*    <fs_entryheader>-totalcredit-contextref = mc_journal_context.
*    <fs_entryheader>-totalcredit-decimals   = mc_inf.
*    <fs_entryheader>-totalcredit-unitref    = is_head-waers.
*    TRANSLATE <fs_entryheader>-totalcredit-unitref TO LOWER CASE.
*
*
*    <fs_entryheader>-entrynumbercounter-contextref = mc_journal_context.
*    <fs_entryheader>-entrynumbercounter-decimals   = mc_inf.
*    <fs_entryheader>-entrynumbercounter-unitref    = mc_countable.
*    <fs_entryheader>-entrynumbercounter-content    = is_head-header-yevno.

  ENDMETHOD.


  METHOD set_head_yb.

    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_yb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_yb=>ty_entrydetail.


    IF lines( ms_root_yb-accountingentries-entryheader ) EQ 0.

      APPEND INITIAL LINE TO ms_root_yb-accountingentries-entryheader ASSIGNING <fs_entryheader>.

      <fs_entryheader>-qualifierentry-contextref = mc_journal_context.
      <fs_entryheader>-qualifierentry-content    = mc_standard.

       DO 10 TIMES.

        APPEND INITIAL LINE TO <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail>.
        <fs_entrydetail>-linenumber-contextref                      = mc_journal_context.
        <fs_entrydetail>-account-accountmainid-contextref           = mc_journal_context.
        <fs_entrydetail>-account-accountmaindescription-contextref  = mc_journal_context.
        <fs_entrydetail>-amount-contextref                          = mc_journal_context.
        <fs_entrydetail>-amount-decimals                            = mc_inf.
        <fs_entrydetail>-amount-unitref                             = is_head-waers.
        TRANSLATE <fs_entrydetail>-amount-unitref TO LOWER CASE.
        <fs_entrydetail>-debitcreditcode-contextref                 = mc_journal_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-contextref            = mc_journal_context.
        <fs_entrydetail>-xbrlinfo-xbrlinclude-content               = mc_period_change.
        <fs_entrydetail>-amount-content                             = '0'.
        CONDENSE <fs_entrydetail>-amount-content NO-GAPS.
        CASE sy-tabix.
          WHEN 1.
            <fs_entrydetail>-linenumber-content                         = '1'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 2.
            <fs_entrydetail>-linenumber-content                         = '2'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '391'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Hesaplanan KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 3.
            <fs_entrydetail>-linenumber-content                         = '3'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 4.
            <fs_entrydetail>-linenumber-content                         = '4'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '191'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'İndirilecek KDV'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 5.
            <fs_entrydetail>-linenumber-content                         = '5'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 6.
            <fs_entrydetail>-linenumber-content                         = '6'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '600'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt İçi Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 7.
            <fs_entrydetail>-linenumber-content                         = '7'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 8.
            <fs_entrydetail>-linenumber-content                         = '8'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '601'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Yurt Dışı Satışlar'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
          WHEN 9.
            <fs_entrydetail>-linenumber-content                         = '9'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'D'.
          WHEN 10.
            <fs_entrydetail>-linenumber-content                         = '10'.
            "
            <fs_entrydetail>-account-accountmainid-content              = '602'.
            "
            <fs_entrydetail>-account-accountmaindescription-content     = 'Diğer Gelirler Hesabı'.
            "
            <fs_entrydetail>-debitcreditcode-content                    = 'C'.
        ENDCASE.

      ENDDO.

    ENDIF.

  ENDMETHOD.


  METHOD set_item_dr.

    DATA lv_line TYPE i.
    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_dr=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_dr=>ty_entrydetail.

    lv_line = lines( ms_root_dr-accountingentries-entryheader ).

    READ TABLE ms_root_dr-accountingentries-entryheader ASSIGNING <fs_entryheader> INDEX lv_line.
    CHECK <fs_entryheader> IS ASSIGNED.

    READ TABLE <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail> WITH KEY account-accountmainid-content = is_item-accountmainid
                                                                                debitcreditcode-content       = is_item-debitcreditcode.
    CHECK <fs_entrydetail> IS ASSIGNED.
    ADD is_item-item-dmbtr_def TO <fs_entrydetail>-amount-content.
    CONDENSE <fs_entrydetail>-amount-content NO-GAPS.

    ADD 1 TO <fs_entrydetail>-documentapplytonumber-content.
    CONDENSE <fs_entrydetail>-documentapplytonumber-content NO-GAPS.
  ENDMETHOD.


  METHOD set_item_gib_kb.

    DATA lv_line TYPE i.
    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_kb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_kb=>ty_entrydetail.

    lv_line = lines( ms_root_gib_kb-accountingentries-entryheader ).

    READ TABLE ms_root_gib_kb-accountingentries-entryheader ASSIGNING <fs_entryheader> INDEX lv_line.
    CHECK <fs_entryheader> IS ASSIGNED.

    READ TABLE <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail> WITH KEY account-accountmainid-content = is_item-accountmainid
                                                                                debitcreditcode-content       = is_item-debitcreditcode.
    CHECK <fs_entrydetail> IS ASSIGNED.
    ADD is_item-item-dmbtr_def TO <fs_entrydetail>-amount-content.
    CONDENSE <fs_entrydetail>-amount-content NO-GAPS.


  ENDMETHOD.


  METHOD SET_ITEM_GIB_YB.

    DATA lv_line TYPE i.
    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_yb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_yb=>ty_entrydetail.

    lv_line = lines( ms_root_gib_yb-accountingentries-entryheader ).

    READ TABLE ms_root_gib_yb-accountingentries-entryheader ASSIGNING <fs_entryheader> INDEX lv_line.
    CHECK <fs_entryheader> IS ASSIGNED.

    READ TABLE <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail> WITH KEY account-accountmainid-content = is_item-accountmainid
                                                                                debitcreditcode-content       = is_item-debitcreditcode.
    CHECK <fs_entrydetail> IS ASSIGNED.
    ADD is_item-item-dmbtr_def TO <fs_entrydetail>-amount-content.
    CONDENSE <fs_entrydetail>-amount-content NO-GAPS.

  ENDMETHOD.


  METHOD set_item_k.

    DATA lv_line TYPE i.
    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_k=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_k=>ty_entrydetail.


    DATA ls_k_mapping TYPE mty_k_mapping.


    lv_line = lines( ms_root_k-accountingentries-entryheader ).

    CLEAR ls_k_mapping.
    READ TABLE  mt_k_mapping INTO ls_k_mapping WITH TABLE KEY accountmainid = is_item-accountmainid+0(3).
    IF sy-subrc IS INITIAL.
      lv_line = ls_k_mapping-index_head.
      READ TABLE ms_root_k-accountingentries-entryheader ASSIGNING <fs_entryheader> INDEX lv_line.
    ELSE.
      APPEND INITIAL LINE TO ms_root_k-accountingentries-entryheader ASSIGNING <fs_entryheader>.
      ls_k_mapping-accountmainid = is_item-accountmainid+0(3).
      ls_k_mapping-index_head    = sy-tabix.
      INSERT ls_k_mapping INTO TABLE mt_k_mapping.
      <fs_entryheader>-totaldebit-contextref  = mc_ledger_context.
      <fs_entryheader>-totaldebit-decimals    = mc_inf.
      <fs_entryheader>-totaldebit-unitref     = is_item-head-waers.
      TRANSLATE <fs_entryheader>-totaldebit-unitref TO LOWER CASE.
      <fs_entryheader>-totalcredit-contextref = mc_ledger_context.
      <fs_entryheader>-totalcredit-decimals   = mc_inf.
      <fs_entryheader>-totalcredit-contextref = is_item-waers.
      TRANSLATE <fs_entryheader>-totalcredit-unitref TO LOWER CASE.
    ENDIF.

    CHECK <fs_entryheader> IS ASSIGNED.

    APPEND INITIAL LINE TO <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail>.
    CHECK <fs_entrydetail> IS ASSIGNED.

    ADD is_item-debitamount  TO <fs_entryheader>-totaldebit-content.
    ADD is_item-creditamount TO <fs_entryheader>-totalcredit-content.
    CONDENSE <fs_entryheader>-totaldebit-content  NO-GAPS.
    CONDENSE <fs_entryheader>-totalcredit-content NO-GAPS.

    <fs_entrydetail>-postingdate-contextref                     = mc_ledger_context.
    <fs_entrydetail>-postingdate-content                        = is_item-postingdate.
    "
    <fs_entrydetail>-linenumber-contextref                      = mc_ledger_context.
    <fs_entrydetail>-linenumber-content                         = is_item-item-linen.
    "
    <fs_entrydetail>-linenumbercounter-contextref               = mc_ledger_context.
    <fs_entrydetail>-linenumbercounter-decimals                 = mc_inf.
    <fs_entrydetail>-linenumbercounter-unitref                  = mc_countable.
    <fs_entrydetail>-linenumbercounter-content                  = lines( <fs_entryheader>-entrydetail ).
    "
    <fs_entrydetail>-account-accountmainid-contextref           = mc_ledger_context.
    <fs_entrydetail>-account-accountmainid-content              = is_item-accountmainid.
    "
    <fs_entrydetail>-account-accountmaindescription-contextref  = mc_ledger_context.
    <fs_entrydetail>-account-accountmaindescription-content     = is_item-accountmaindescription.
    "
    <fs_entrydetail>-account-accountsub-accountsubdescription-contextref  = mc_ledger_context.
    <fs_entrydetail>-account-accountsub-accountsubdescription-content     = is_item-accountsubdescription.
    "
    <fs_entrydetail>-account-accountsub-accountsubid-contextref  = mc_ledger_context.
    <fs_entrydetail>-account-accountsub-accountsubid-content     = is_item-accountsubid.
    "
    <fs_entrydetail>-amount-contextref                          = mc_ledger_context.
    <fs_entrydetail>-amount-decimals                            = mc_inf.
    <fs_entrydetail>-amount-unitref                             = is_item-waers.
    TRANSLATE <fs_entrydetail>-amount-unitref TO LOWER CASE.
    <fs_entrydetail>-amount-content                             = is_item-item-dmbtr_def.
    CONDENSE <fs_entrydetail>-amount-content NO-GAPS.
    "
    <fs_entrydetail>-debitcreditcode-contextref                 = mc_ledger_context.
    <fs_entrydetail>-debitcreditcode-content                    = is_item-debitcreditcode.
    "
    <fs_entrydetail>-postingdate-contextref                     = mc_ledger_context.
    <fs_entrydetail>-postingdate-content                        = is_item-postingdate.
    "
    <fs_entrydetail>-documenttype-contextref                    = mc_ledger_context.
    <fs_entrydetail>-documenttype-content                       = is_item-documenttype.
    "
    <fs_entrydetail>-documentnumber-contextref                  = mc_ledger_context.
    <fs_entrydetail>-documentnumber-content                     = ''.
    "
    <fs_entrydetail>-documentreference-contextref               = mc_ledger_context.
    <fs_entrydetail>-documentreference-content                  = is_item-item-belnr.
    "
    <fs_entrydetail>-documentdate-contextref                    = mc_ledger_context.
    <fs_entrydetail>-documentdate-content                       = is_item-documentdate.
    "
    <fs_entrydetail>-detailcomment-contextref                   = mc_ledger_context.
    <fs_entrydetail>-detailcomment-content                      = is_item-detailcomment.

  ENDMETHOD.


  METHOD SET_ITEM_KB.

    DATA lv_line TYPE i.
    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_kb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_kb=>ty_entrydetail.

    lv_line = lines( ms_root_kb-accountingentries-entryheader ).

    READ TABLE ms_root_kb-accountingentries-entryheader ASSIGNING <fs_entryheader> INDEX lv_line.
    CHECK <fs_entryheader> IS ASSIGNED.

    READ TABLE <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail> WITH KEY account-accountmainid-content = is_item-accountmainid
                                                                                debitcreditcode-content       = is_item-debitcreditcode.
    CHECK <fs_entrydetail> IS ASSIGNED.
    ADD is_item-item-dmbtr_def TO <fs_entrydetail>-amount-content.
    CONDENSE <fs_entrydetail>-amount-content NO-GAPS.

  ENDMETHOD.


  METHOD set_item_y.

    DATA lv_line TYPE i.
    DATA ls_y_mapping TYPE mty_y_mapping.
    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_y=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_y=>ty_entrydetail.

*    lv_line = lines( ms_root_y-accountingentries-entryheader ).

    READ TABLE mt_y_mapping INTO ls_y_mapping WITH TABLE KEY linenumbercounter = is_item-item-yevno.
    IF sy-subrc IS INITIAL.
      lv_line = ls_y_mapping-index_head.
      READ TABLE ms_root_y-accountingentries-entryheader ASSIGNING <fs_entryheader> INDEX lv_line.
    ELSE.
      APPEND INITIAL LINE TO ms_root_y-accountingentries-entryheader ASSIGNING <fs_entryheader>.
      ls_y_mapping-index_head = sy-tabix.
      ls_y_mapping-linenumbercounter = is_item-item-yevno.
      INSERT ls_y_mapping INTO TABLE mt_y_mapping.
      "
      <fs_entryheader>-enteredby-contextref          = mc_journal_context.
      <fs_entryheader>-enteredby-content             = is_item-head-enteredby.
      <fs_entryheader>-entereddate-contextref        = mc_journal_context.
      <fs_entryheader>-entereddate-content           = is_item-head-entereddate.
      <fs_entryheader>-entrynumber-contextref        = mc_journal_context.
      <fs_entryheader>-entrynumber-content           = is_item-item-belnr.
      <fs_entryheader>-entrycomment-contextref       = mc_journal_context.
      <fs_entryheader>-entrycomment-content          = is_item-head-entrycomment.

      <fs_entryheader>-totaldebit-contextref         = mc_journal_context.
      <fs_entryheader>-totaldebit-decimals           = mc_inf.
      <fs_entryheader>-totaldebit-unitref            = is_item-item-waers.
      TRANSLATE <fs_entryheader>-totaldebit-unitref TO LOWER CASE.

      <fs_entryheader>-totalcredit-contextref        = mc_journal_context.
      <fs_entryheader>-totalcredit-decimals          = mc_inf.
      <fs_entryheader>-totalcredit-unitref           = is_item-head-waers.
      TRANSLATE <fs_entryheader>-totalcredit-unitref TO LOWER CASE.

      <fs_entryheader>-entrynumbercounter-contextref = mc_journal_context.
      <fs_entryheader>-entrynumbercounter-decimals   = mc_inf.
      <fs_entryheader>-entrynumbercounter-unitref    = mc_countable.
      <fs_entryheader>-entrynumbercounter-content    = is_item-item-yevno.
    ENDIF.
    CHECK <fs_entryheader> IS ASSIGNED.

    APPEND INITIAL LINE TO <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail>.
    CHECK <fs_entrydetail> IS ASSIGNED.
    "
    ADD is_item-debitamount TO <fs_entryheader>-totaldebit-content.
    CONDENSE <fs_entryheader>-totaldebit-content NO-GAPS.
    ADD is_item-creditamount TO <fs_entryheader>-totalcredit-content.
    CONDENSE <fs_entryheader>-totalcredit-content NO-GAPS.
    "
    <fs_entrydetail>-linenumber-contextref                               = mc_journal_context.
    <fs_entrydetail>-linenumber-content                                  = is_item-item-dfbuz.
    "
    <fs_entrydetail>-linenumbercounter-contextref                        = mc_journal_context.
    <fs_entrydetail>-linenumbercounter-decimals                          = mc_inf.
    <fs_entrydetail>-linenumbercounter-unitref                           = mc_countable.
    <fs_entrydetail>-linenumbercounter-content                           = is_item-item-yevno.
    "amount
    <fs_entrydetail>-amount-contextref                                   = mc_journal_context.
    <fs_entrydetail>-amount-decimals                                     = mc_inf.
    <fs_entrydetail>-amount-unitref                                      = is_item-waers.
    TRANSLATE <fs_entrydetail>-amount-unitref TO LOWER CASE.
    <fs_entrydetail>-amount-content                                      = is_item-item-dmbtr_def.
    "
    <fs_entrydetail>-debitcreditcode-contextref                          = mc_journal_context.
    <fs_entrydetail>-debitcreditcode-content                             = is_item-debitcreditcode.
    "
    <fs_entrydetail>-postingdate-contextref                              = mc_journal_context.
    <fs_entrydetail>-postingdate-content                                 = is_item-postingdate.
    "
    <fs_entrydetail>-documentreference-contextref                        = mc_journal_context.
    <fs_entrydetail>-documentreference-content                           = is_item-documentreference.
    "
    <fs_entrydetail>-detailcomment-contextref                            = mc_journal_context.
    <fs_entrydetail>-detailcomment-content                               = is_item-detailcomment.
    "
    <fs_entrydetail>-documentnumber-contextref                           = mc_journal_context.
    <fs_entrydetail>-documentnumber-content                              = is_item-documentnumber.
    "
    <fs_entrydetail>-documentdate-contextref                             = mc_journal_context.
    <fs_entrydetail>-documentdate-content                                = is_item-documentdate.
    "
    <fs_entrydetail>-paymentmethod-contextref                            = mc_journal_context.
    <fs_entrydetail>-paymentmethod-content                               = is_item-paymentmethod.
    "
    <fs_entrydetail>-documenttype-contextref                             = mc_journal_context.
    <fs_entrydetail>-documenttype-content                                = is_item-documenttype.
    "
    <fs_entrydetail>-account-accountmainid-contextref                    = mc_journal_context.
    <fs_entrydetail>-account-accountmainid-content                       = is_item-accountmainid.
    "
    <fs_entrydetail>-account-accountmaindescription-contextref           = mc_journal_context.
    <fs_entrydetail>-account-accountmaindescription-content              = is_item-accountmaindescription.
    "
    <fs_entrydetail>-account-accountsub-accountsubid-contextref          = mc_journal_context.
    <fs_entrydetail>-account-accountsub-accountsubid-content             = is_item-accountsubid.
    "
    <fs_entrydetail>-account-accountsub-accountsubdescription-contextref = mc_journal_context.
    <fs_entrydetail>-account-accountsub-accountsubdescription-content    = is_item-accountsubdescription.

  ENDMETHOD.


  METHOD set_item_yb.

    DATA lv_line TYPE i.
    FIELD-SYMBOLS <fs_entryheader> TYPE /itetr/if_edf_xml_yb=>ty_entryheader.
    FIELD-SYMBOLS <fs_entrydetail> TYPE /itetr/if_edf_xml_yb=>ty_entrydetail.

    lv_line = lines( ms_root_yb-accountingentries-entryheader ).

    READ TABLE ms_root_yb-accountingentries-entryheader ASSIGNING <fs_entryheader> INDEX lv_line.
    CHECK <fs_entryheader> IS ASSIGNED.

    READ TABLE <fs_entryheader>-entrydetail ASSIGNING <fs_entrydetail> WITH KEY account-accountmainid-content = is_item-accountmainid
                                                                                debitcreditcode-content       = is_item-debitcreditcode.
    CHECK <fs_entrydetail> IS ASSIGNED.
    ADD is_item-item-dmbtr_def TO <fs_entrydetail>-amount-content.
    CONDENSE <fs_entrydetail>-amount-content NO-GAPS.

  ENDMETHOD.


  METHOD unit.

    FIELD-SYMBOLS <fs_unit> TYPE /itetr/if_edf_xml_y=>ty_unit.

    FIELD-SYMBOLS <ft_unit> TYPE /itetr/if_edf_xml_y=>tty_unit.

    CASE iv_xmlty.
      WHEN 1.
        ASSIGN ('ms_root_y-unit')      TO <ft_unit>.
      WHEN 2.
        ASSIGN ('ms_root_yb-unit')     TO <ft_unit>.
      WHEN 3.
        ASSIGN ('ms_root_gib_yb-unit') TO <ft_unit>.
      WHEN 4.
        ASSIGN ('ms_root_k-unit')      TO <ft_unit>.
      WHEN 5.
        ASSIGN ('ms_root_kb-unit')     TO <ft_unit>.
      WHEN 6.
        ASSIGN ('ms_root_gib_kb-unit') TO <ft_unit>.
      WHEN 7.
        ASSIGN ('ms_root_dr-unit')     TO <ft_unit>.
    ENDCASE.

    DO 2 TIMES.
      APPEND INITIAL LINE TO <ft_unit> ASSIGNING <fs_unit>.
      IF <fs_unit> IS ASSIGNED.
        CASE sy-tabix.
          WHEN 1.
            <fs_unit>-id = ms_header-waers.
            TRANSLATE <fs_unit>-id TO LOWER CASE.
            CONCATENATE 'iso4217:'
                        ms_header-waers
                        INTO
                        <fs_unit>-measure-content.
          WHEN 2.
            <fs_unit>-id = 'countable'.
            <fs_unit>-measure-content = 'xbrli:pure'.
        ENDCASE.
        UNASSIGN <fs_unit>.
      ENDIF.
    ENDDO.

  ENDMETHOD.
ENDCLASS.