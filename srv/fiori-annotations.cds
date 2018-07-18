using BookingService as srv from './booking-service';
using teched.flight.trip as flight from '../db/space-model';


annotate flight.Itineraries with {
  ID @UI.TextArrangement: #TextOnly;
};
annotate flight.Itineraries with @(
  UI.Identification:  [ {$Type: 'UI.DataField', Value: Name} ]
);
annotate srv.EarthItineraries with {
  Name @title : 'Earth Itinerary';
};
annotate srv.SpaceItineraries with {
  Name @title : 'Space Itinerary';
};

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
  EarthItinerary
    // @sap.value.list: 'fixed-values'
    @Common: {
      Label : 'Earth Trip',
      FieldControl: #Mandatory,
      Text: {$value: EarthItinerary.Name, "@UI.TextArrangement": #TextOnly},
      ValueList: {
        entity: 'EarthItineraries',
        type: #fixed,
        //CollectionPath: 'EarthItinerary',
        //Label: 'Trip',
        SearchSupported: true,
        //Parameters: [
        //  { $Type: 'Common.ValueListParameterOut', LocalDataProperty: EarthItinerary_ID', ValueListProperty: 'ID'},
        //  { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
        //]
      },
      ValueListWithFixedValues
    };
    SpaceItinerary
      // @sap.value.list: 'fixed-values'
      @Common: {
        Label : 'Space Trip',
        FieldControl: #Mandatory,
        Text: {$value: SpaceItinerary.Name, "@UI.TextArrangement": #TextOnly},
        ValueList: {
          entity: 'SpaceItineraries',
          type: #fixed,
          //CollectionPath: 'SpaceItinerary',
          //Label: 'Trip',
          SearchSupported: true,
          //Parameters: [
          //  { $Type: 'Common.ValueListParameterOut', LocalDataProperty: SpaceItinerary_ID', ValueListProperty: 'ID'},
          //  { $Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'ID'},
          //]
      },
      ValueListWithFixedValues
    };
};

annotate srv.Bookings with @(
  UI.LineItem: [
    {$Type: 'UI.DataField', Value: CustomerName},
    {$Type: 'UI.DataField', Value: EarthItinerary.Name},
    {$Type: 'UI.DataField', Value: SpaceItinerary.Name},
    {$Type: 'UI.DataField', Value: DateOfTravel},
    {$Type: 'UI.DataField', Value: NumberOfPassengers},
    {$Type: 'UI.DataField', Value: Cost},
    {$Type: 'UI.DataField', Value: DateOfBooking},
  ],
);
