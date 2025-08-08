@EndUserText.label: 'Meine Bestellungen'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_RAP_FastPurchaseOrderOwn_M
  provider contract transactional_query
  as projection on ZI_RAP_FastPurchaseOrder_M
{
  key PurchaseOrderUuid,
      PurchaseOrder,
      PurchaseOrderItem,
      PurchaseOrderType,
      LastChangeDateTime,
      Plant,
      _PurchaseOrder.PurchaseOrderDate,
      @ObjectModel.text.element: ['ProductName']
      Material,
      _POProduct._Product._Text.ProductName : localized,
      OrderQuantity,
      PurchaseOrderQuantityUnit,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _PurchaseOrder,
      _PurchaseOrderItem,
      _POProduct
}
where
  CreatedBy = $session.user
