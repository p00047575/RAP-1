@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flug und Währung'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FlightCurr
  as select from ZI_Flight
{
  key CarrierId,
  key ConnectionId,
  key FlightDate,
      CurrencyCode,
      // _Currency.CurrencyISOCode,
      _Currency[Currency = 'EUR'] as _FlightCurrency
}
