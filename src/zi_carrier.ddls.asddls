@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED  
}
@EndUserText.label: 'Fluggesellschaft'  
define view entity ZI_Carrier as select from /DMO/I_Carrier
  association [0..*] to /DMO/I_Connection as _Connection
    on $projection.AirlineID = _Connection.AirlineID 
{
    key AirlineID,
    _Connection.DepartureAirport   
}





