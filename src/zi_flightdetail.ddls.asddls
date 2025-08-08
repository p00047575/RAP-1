@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@EndUserText.label: 'Flugdetail'
@Metadata.allowExtensions: true
define view entity ZI_FlightDetail
  with parameters
    P_TargetCurrency : abap.cuky( 5 )
  as select from ZI_Flight
  association [1] to /DMO/I_Carrier    as _Carrier 
    on  $projection.CarrierId = _Carrier.AirlineID
  association [1] to /DMO/I_Connection as _Connection
    on  $projection.ConnectionId = _Connection.ConnectionID
    and $projection.CarrierId    = _Connection.AirlineID
{
  key CarrierId,
  key ConnectionId,
  key FlightDate,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      Price,
      CurrencyCode,

      PlaneTypeId,
      SeatsMax,
      SeatsOccupied,

      SeatsMax - SeatsOccupied as SeatsFree,

      case SeatsOccupied
       when SeatsMax
          then 'X'
          else ''
        end                    as FlightOccupied,

      @Semantics.amount.currencyCode: 'TargetCurrency'
      currency_conversion(
        amount => Price,
        source_currency => CurrencyCode,
        round => 'X',
        target_currency => $parameters.P_TargetCurrency,
        exchange_rate_date => FlightDate
      )                        as PriceInTargetCurrency,

      cast($parameters.P_TargetCurrency
        as vdm_v_target_currency
        preserving type)       as TargetCurrency,
        
        
        
@ObjectModel.virtualElement: true
@ObjectModel.virtualElementCalculatedBy:
            'ABAP:ZCL_FLIGHTDETAIL_CALC_EXIT'
 cast ( '' as langt ) as FlightDateWeekday,
//virtual  FlightDateWeekday : langt ,       
        
        

      _Carrier,
      _Connection
}
where
  FlightDate >= $session.system_date
  
  
  
  
  
  
  
