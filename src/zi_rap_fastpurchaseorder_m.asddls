@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Schnellerfasste Bestellung'
define root view entity ZI_RAP_FastPurchaseOrder_M
  as select from zrap_a_fast_po
  association [1..1] to I_PurchaseOrderAPI01     as _PurchaseOrder     on  _PurchaseOrder.PurchaseOrder = $projection.PurchaseOrder
  association [1..1] to I_PurchaseOrderItemAPI01 as _PurchaseOrderItem on  _PurchaseOrderItem.PurchaseOrder     = $projection.PurchaseOrder
                                                                        and _PurchaseOrderItem.PurchaseOrderItem = $projection.PurchaseOrderItem
  association [1..1] to ZI_RAP_PO_Product        as _POProduct        on  _POProduct.Product = $projection.material
{
  key purchase_order_uuid          as PurchaseOrderUuid,
      purchase_order               as PurchaseOrder,
      purchase_order_item          as PurchaseOrderItem,
      _PurchaseOrder.PurchaseOrderType,
      _PurchaseOrder.CompanyCode,
      _PurchaseOrder.PurchasingOrganization,
      _PurchaseOrder.PurchasingGroup,
      _PurchaseOrder.Supplier,
      _PurchaseOrder.LastChangeDateTime,
      _PurchaseOrderItem.Plant,
      _PurchaseOrderItem.Material,
      _PurchaseOrderItem.OrderQuantity,
      _PurchaseOrderItem.PurchaseOrderQuantityUnit,
      @Semantics.user.createdBy: true
      created_by                   as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                   as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by              as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at              as LastChangedAt,
      _PurchaseOrder,
      _PurchaseOrderItem,
      _POProduct
}
where
  _PurchaseOrderItem.PurchasingDocumentDeletionCode <> 'L'
