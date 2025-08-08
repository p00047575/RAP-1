CLASS zcl_eml_examples DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS create_salesorder.

    METHODS create_salesorder_auto.

    METHODS update_salesorder
      IMPORTING iv_salesorder TYPE char10.

    METHODS create_product
      IMPORTING iv_product TYPE matnr.

    METHODS update_product
      IMPORTING iv_product TYPE matnr.

    METHODS create_purchaseorder.

    METHODS create_handlingunit.

    METHODS move_handling_unit.

    METHODS update_salesorder_item.

    METHODS update_salesorder_complex
      IMPORTING iv_salesorder TYPE char10.

    METHODS update_salesorder_new_position
      IMPORTING iv_salesorder TYPE char10.

    METHODS update_salesorder_new_itemtext
      IMPORTING iv_salesorder     TYPE char10
                iv_salesorderitem TYPE sales_order_item.

ENDCLASS.


CLASS zcl_eml_examples IMPLEMENTATION.
  METHOD update_salesorder.
    MODIFY ENTITIES OF i_salesordertp
           ENTITY salesorder
           UPDATE
           FIELDS ( purchaseorderbycustomer )
           WITH VALUE #( ( PurchaseOrderByCustomer = 'Change sales order'
                           %key-salesorder         = iv_salesorder ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported).

    COMMIT ENTITIES.

    READ ENTITIES OF i_salesordertp
         ENTITY salesorder
         FROM VALUE #( ( salesorder = iv_salesorder ) )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT   DATA(lt_so_head)
         REPORTED ls_reported
         FAILED   ls_failed.
  ENDMETHOD.

  METHOD update_salesorder_item.
    MODIFY ENTITIES OF i_salesordertp
           ENTITY salesorder
           UPDATE
           FIELDS ( purchaseorderbycustomer )
           WITH VALUE #( ( PurchaseOrderByCustomer = 'Change sales order'
                           %key-salesorder         = '0000000016' ) )
           ENTITY salesorderitemtext
           UPDATE
           FIELDS ( longtext )
           WITH VALUE #( ( %key     = VALUE #( SalesOrder     = '0000000016'
                                               SalesOrderItem = '000010'
                                               Language       = 'D'
                                               LongTextID     = '0001' )
                           longtext = 'My updated item long text2' ) )

           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported).

    COMMIT ENTITIES.

    READ ENTITIES OF i_salesordertp
         ENTITY salesorderitemtext
         FROM VALUE #( ( %key = VALUE #( SalesOrder     = '0000000016'
                                         SalesOrderItem = '000010'
                                         Language       = 'D'
                                         LongTextID     = '0001' ) ) )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT   DATA(lt_text_data)
         REPORTED ls_reported
         FAILED   ls_failed.
  ENDMETHOD.

  METHOD create_product.
    " ABAP Cloud Successor for bapi_material_savedata
    DATA create_product TYPE TABLE FOR CREATE I_ProductTP_2.

    create_product = VALUE #( ( %cid                    = 'product1'
                                Product                 = iv_product
                                %control-Product        = if_abap_behv=>mk-on
                                ProductType             = 'FERT'
                                %control-ProductType    = if_abap_behv=>mk-on
                                BaseUnit                = 'EA'
                                %control-BaseUnit       = if_abap_behv=>mk-on
                                IndustrySector          = 'M'
                                %control-IndustrySector = if_abap_behv=>mk-on ) ).

    MODIFY ENTITIES OF I_ProductTP_2
           ENTITY Product
           CREATE FROM create_product
           CREATE BY \_ProductDescription
           FIELDS ( Language ProductDescription ) WITH VALUE #( ( %cid_ref = 'product1'
                                                                  Product  = iv_product
                                                                  %target  = VALUE #( Product            = iv_product
                                                                                      ProductDescription = 'test'
                                                                                      ( %cid     = 'desc1'
                                                                                        Language = 'E' )
                                                                                      ( %cid     = 'desc2'
                                                                                        Language = 'D' ) ) ) )

           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED DATA(mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(reported)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(failed).

    COMMIT ENTITIES
           RESPONSE OF I_ProductTP_2
               " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(failed_commit)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(reported_commit).
  ENDMETHOD.

  METHOD update_product.
    " ABAP Cloud Successor for bapi_material_savedata
    MODIFY ENTITIES OF I_ProductTP_2
           ENTITY Product
           UPDATE FIELDS ( ProductGroup )
           WITH VALUE #( ( %key-Product = iv_product
                           ProductOldID = 'Field changed' ) )

           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(reported).

    COMMIT ENTITIES
           RESPONSE OF I_ProductTP_2
               " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(failed_commit)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(reported_commit).
  ENDMETHOD.

  METHOD create_purchaseorder.
    MODIFY ENTITIES OF I_PurchaseOrderTP_2
           ENTITY PurchaseOrder
           CREATE
           FIELDS ( PurchaseOrderType
                    CompanyCode
                    PurchasingOrganization
                    PurchasingGroup
                    Supplier )
           WITH VALUE #( ( %cid  = 'PurchaseOrder'
                           %data = VALUE #( PurchaseOrderType      = 'NB'
                                            CompanyCode            = '1010'
                                            PurchasingOrganization = '1010'
                                            PurchasingGroup        = '001'
                                            Supplier               = 'AS001' ) ) )
            " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED   DATA(ls_mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported_modify).
  ENDMETHOD.

  METHOD create_handlingunit.
    MODIFY ENTITIES OF i_handlingunittp
           ENTITY HandlingUnit
           CREATE
           SET FIELDS WITH VALUE #( ( %cid                   = 'New HU'
                                      HandlingUnitExternalID = 'AS078_01'
                                      PackagingMaterial      = 'AS078' ) )
           ENTITY HandlingUnit
           CREATE BY \_HandlingUnitItem
           SET FIELDS WITH VALUE #( ( %cid_ref = 'New HU'
                                      %target  = VALUE #( ( %cid                      = 'New HU Item'
                                                            HandlingUnitTypeOfContent = '1' " Material
                                                            Plant                     = '1010'
                                                            StorageLocation           = '101'
                                                            Material                  = 'AS076'
                                                            HandlingUnitQuantity      = '100'
                                                            HandlingUnitQuantityUnit  = 'EA' ) ) ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED DATA(mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(reported).

    COMMIT ENTITIES BEGIN
           RESPONSE OF I_HandlingUnitTP
             " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_save_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_save_reported).

    COMMIT ENTITIES END.
  ENDMETHOD.

  METHOD move_handling_unit.
    MODIFY ENTITIES OF i_handlingunittp ENTITY HandlingUnit
           EXECUTE MoveHandlingUnits
           FROM VALUE #( ( HandlingUnitExternalID = '00000000000000800008'
                           %param                 = VALUE #( HandlingUnitGoodsMovementEvent = '0006'
                                                             HandlingUnitExternalID         = '00000000000000800008'
                                                             ReceivingPlant                 = '1010'
                                                             ReceivingStorageLocation       = '1010' ) ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           RESULT DATA(lt_result)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED DATA(lt_failed).

    COMMIT ENTITIES BEGIN
           RESPONSE OF I_HandlingUnitTP
             " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_save_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_save_reported).

    COMMIT ENTITIES END.
  ENDMETHOD.

  METHOD create_salesorder.
    MODIFY ENTITIES OF i_salesordertp
           ENTITY salesorder
           CREATE
           FIELDS ( salesordertype
                    salesorganization
                    distributionchannel
                    organizationdivision
                    soldtoparty )
           WITH VALUE #( ( %cid  = 'SalesOrder'
                           %data = VALUE #( SalesOrderType       = 'TA'
                                            SalesOrganization    = '1010'
                                            DistributionChannel  = '10'
                                            OrganizationDivision = '00'
                                            SoldToParty          = '0010100001' ) ) )
           CREATE BY \_text
           FIELDS ( LanguageForEdit LongTextIDForEdit LongText )
           WITH VALUE #( ( %cid_ref   = 'SalesOrder'
                           salesorder = space
                           %target    = VALUE #( ( %cid              = 'SalesOrderHeadText'
                                                   LanguageForEdit   = 'D'
                                                   LongTextIDForEdit = 'TX01'
                                                   LongText          = 'Header Text created' ) ) ) )
           CREATE BY \_item
           FIELDS ( product
                  requestedquantity )
           WITH VALUE #( ( %cid_ref   = 'SalesOrder'
                           salesorder = space
                           %target    = VALUE #( RequestedQuantity = '10'
                                                 ( %cid    = 'SalesOrderItem1'
                                                   Product = 'TG11' )
                                                 ( %cid    = 'SalesOrderItem2'
                                                   Product = 'TG12' ) ) ) )
           ENTITY SalesOrderItem
           CREATE BY \_ItemText
           FIELDS ( LongText LanguageForEdit LongTextIDForEdit )
           WITH VALUE #( SalesOrder     = space
                         SalesOrderItem = space
                         ( %cid_ref = 'SalesOrderItem1'
                           %target  = VALUE #( ( %cid              = 'SalesOrderItemText1'
                                                 LanguageForEdit   = 'D'
                                                 LongTextIDForEdit = '0001'
                                                 LongText          = 'Text created' ) ) )
                         ( %cid_ref = 'SalesOrderItem2'
                           %target  = VALUE #( ( %cid              = 'SalesOrderItemText2'
                                                 LanguageForEdit   = 'D'
                                                 LongTextIDForEdit = '0001'
                                                 LongText          = 'Text created' ) ) ) )
              " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED   DATA(ls_mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported_modify).

    DATA ls_so_temp_key TYPE STRUCTURE FOR KEY OF I_SalesOrderTP.

    COMMIT ENTITIES BEGIN
           RESPONSE OF i_salesordertp
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_save_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_save_reported).

    " TODO: variable is assigned but never used (ABAP cleaner)
    CONVERT KEY OF i_salesordertp FROM ls_so_temp_key TO DATA(ls_so_final_key).

    COMMIT ENTITIES END.
  ENDMETHOD.

  METHOD update_salesorder_complex.
    MODIFY ENTITIES OF i_salesordertp
           ENTITY salesorder
           UPDATE
           FIELDS ( purchaseorderbycustomer )
           WITH VALUE #( ( %key-salesorder         = |{ iv_salesorder ALPHA = IN }|
                           PurchaseOrderByCustomer = 'SalesOrder updated' ) )
           ENTITY salesorderitem
           UPDATE
           FIELDS ( requestedquantity )
           WITH VALUE #( ( %key              = VALUE #( SalesOrder     = |{ iv_salesorder ALPHA = IN }|
                                                        SalesOrderItem = '000010' )
                           RequestedQuantity = 5 ) )
           ENTITY salesorderitemtext
           UPDATE
           FIELDS ( longtext )
           WITH VALUE #( ( %key     = VALUE #( SalesOrder     = |{ iv_salesorder ALPHA = IN }|
                                               SalesOrderItem = '000020'
                                               Language       = 'D'
                                               LongTextID     = '0001' )
                           longtext = 'Text updated' ) )

           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported).

    COMMIT ENTITIES BEGIN
           RESPONSE OF i_salesordertp
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_save_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_save_reported).

    COMMIT ENTITIES END.
  ENDMETHOD.

  METHOD update_salesorder_new_position.
    MODIFY ENTITIES OF i_salesordertp
           ENTITY SalesOrder
           CREATE BY \_item
           FIELDS ( product
                    requestedquantity )
           WITH VALUE #( ( %key-salesorder = |{ iv_salesorder ALPHA = IN }|
                           salesorder      = |{ iv_salesorder ALPHA = IN }|
                           %target         = VALUE #( ( %cid              = 'SalesOrderItem1'
                                                        Product           = 'TG13'
                                                        RequestedQuantity = '10' ) ) ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported).

    COMMIT ENTITIES BEGIN
           RESPONSE OF i_salesordertp
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_save_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_save_reported).

    COMMIT ENTITIES END.
  ENDMETHOD.

  METHOD update_salesorder_new_itemtext.
    MODIFY ENTITIES OF i_salesordertp
           ENTITY SalesOrderItem
           CREATE BY \_ItemText
           FIELDS ( LongText LanguageForEdit LongTextIDForEdit )
           WITH VALUE #( ( %key-SalesOrder     = |{ iv_salesorder ALPHA = IN }|
                           %key-SalesOrderItem = |{ iv_salesorderitem ALPHA = IN }|
                           SalesOrder          = |{ iv_salesorder ALPHA = IN }|
                           SalesOrderItem      = |{ iv_salesorderitem ALPHA = IN }|
                           %target             = VALUE #( ( %cid              = 'SalesOrderItemText1'
                                                            LanguageForEdit   = 'D'
                                                            LongTextIDForEdit = '0001'
                                                            LongText          = 'Text created' ) ) ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported).

    COMMIT ENTITIES BEGIN
           RESPONSE OF i_salesordertp
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_save_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_save_reported).

    COMMIT ENTITIES END.
  ENDMETHOD.

  METHOD create_salesorder_auto.
    MODIFY ENTITIES OF i_salesordertp
           ENTITY salesorder
           CREATE AUTO FILL CID
           FIELDS ( salesordertype
                    salesorganization
                    distributionchannel
                    organizationdivision
                    soldtoparty )
           WITH VALUE #( ( %data = VALUE #( SalesOrderType       = 'TA'
                                            SalesOrganization    = '1010'
                                            DistributionChannel  = '10'
                                            OrganizationDivision = '00'
                                            SoldToParty          = '0010100001' ) ) )
           " TODO: variable is assigned but never used (ABAP cleaner)
           MAPPED   DATA(ls_mapped)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_reported_modify).

    DATA ls_so_temp_key TYPE STRUCTURE FOR KEY OF I_SalesOrderTP.

    COMMIT ENTITIES BEGIN
           RESPONSE OF i_salesordertp
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED   DATA(ls_save_failed)
           " TODO: variable is assigned but never used (ABAP cleaner)
           REPORTED DATA(ls_save_reported).

    " TODO: variable is assigned but never used (ABAP cleaner)
    CONVERT KEY OF i_salesordertp FROM ls_so_temp_key TO DATA(ls_so_final_key).

    COMMIT ENTITIES END.
  ENDMETHOD.
ENDCLASS.
