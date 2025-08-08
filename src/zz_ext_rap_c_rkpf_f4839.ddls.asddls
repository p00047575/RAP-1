extend view entity C_ReservationDocTP_F4839 with
{
  @UI: {
   selectionField: [ { position: 100 } ],
   lineItem: [ { position: 100, importance: #HIGH } ],
   fieldGroup: [ { qualifier: 'Resvn_Det', position: 100} ]
   }
  @Consumption.filter.selectionType: #RANGE
  _ReservationDocument.zz_text_f4839
}
