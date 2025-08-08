@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gültige Materialien, Suchhilfe'
@Metadata.ignorePropagatedAnnotations: true @ObjectModel.usageType:{
     serviceQuality: #X,
     sizeCategory: #S,
     dataClass: #MIXED
}
// Wertehilfe als Dropdown darstellen
//@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_RAP_PO_ProductActive_VH
  as select from ZI_RAP_PO_Product
{
      @ObjectModel.text.association: '_ProductText'
  key Product,
      _Product.BaseUnit,
      @Consumption.hidden: true
      _Product.Product as ProductForText,
      _Product._Text   as _ProductText
}
where
  IsActive = 'X'
