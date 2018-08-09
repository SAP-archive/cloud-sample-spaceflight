using BookingService as srv from './booking-service';


annotate srv.Itineraries with {
  ID
	@UI.TextArrangement: #TextOnly
	// Fiori only shows value helps for string-typed fields, so make the ID appear as string
	@odata.Type: 'Edm.String'
	@odata.MaxLength: '8';
  Name
	@title: 'Trip';
};
annotate srv.Itineraries with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);
