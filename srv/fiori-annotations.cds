using BookingService as srv from './booking-service';


annotate srv.Itineraries with {
  ID   @UI.TextArrangement: #TextOnly;
  Name @title: 'Trip';
};
annotate srv.Itineraries with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);

annotate srv.Bookings with {
  ID
    @title: 'Id';
  CustomerName
    @title: 'Customer';
  NumberOfPassengers
    @title: 'Passengers';
  EmailAddress
    @title: 'Email'
    @Common.FieldControl: #Optional;
  DateOfBooking
    @title: 'Booking date'
    @odata.on.insert: #now;
  DateOfTravel
    @title: 'Travel date'
    @Common.FieldControl: #Mandatory;
  Cost
    @title: 'Cost'
    @Common.FieldControl: #Mandatory;
  Itinerary
    // @sap.value.list: 'fixed-values'
    @Common: {
      Label : 'Trip',
      FieldControl: #Mandatory,
      Text: {$value: Itinerary.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: {
        entity: 'Itineraries',
        type: #fixed,
        //CollectionPath: 'Itinerary',
        //Label: 'Trip',
        SearchSupported: true,
        //Parameters: [
        //  { $Type: 'Common.ValueListParameterOut', LocalDataProperty: Itinerary_ID', ValueListProperty: 'ID'},
        //  { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
        //]
      },
      ValueListWithFixedValues
    };
};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: CustomerName},
    {$Type: 'UI.DataField', Value: Itinerary.Name},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: DateOfBooking},
  ],
);
