@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gültiges Produkt für Schnellerfassung'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RAP_PO_Product
  as select from zrap_a_po_prod
  association [0..1] to I_Product  as _Product  on _Product.Product = $projection.Product
  association [0..1] to I_Supplier as _Supplier on _Supplier.Supplier = $projection.Supplier
{
  key product         as Product,
      supplier        as Supplier,
      is_active       as IsActive,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      _Product,
      _Supplier
}
