@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity for I_RESERVATIONDOCUMENTHEADER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_RESERVATIONDOCUMENTHEADER as select from I_ReservationDocumentHeader
{
    key Reservation,
    ReservationCreationCode,

    LastChangedByUser

}
