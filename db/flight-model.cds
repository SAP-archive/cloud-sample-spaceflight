// *********************************************************************************************************************
//                                               F L I G H T   M O D E L
//
// Defines the basic set of entities needed for booking flights and is similar to the ABAP Flight data model
// *********************************************************************************************************************
namespace teched.flight.trip;

using common.Named   from './common';
using common.Managed from './common';

// ---------------------------------------------------------------------------------------------------------------------
// Airports
//
// Each airport is stored using its the 3-character IATA code as the key
// E.G. "LHR" = London, Heathrow; "JFK" = New York, John F. Kennedy, etc
// ---------------------------------------------------------------------------------------------------------------------
entity Airports  : Named {
  key IATA3      : String(3);
      City       : String(30);
      Country    : String(50);
      Altitude   : Integer        default 0 ;
      Latitude   : Decimal(12, 9);
      Longitude  : Decimal(12, 9);
      Departures : Association to many EarthRoutes on Departures.StartingAirport=$self;
      Arrivals   : Association to many EarthRoutes on Arrivals.DestinationAirport=$self;
};

// ---------------------------------------------------------------------------------------------------------------------
// Airlines
//
// Each airline company is stored using its 2-character IATA code as the key
// E.G. "BA" = British Airways, "LH" = Lufthansa, etc
// ---------------------------------------------------------------------------------------------------------------------
entity Airlines : Named {
  key IATA2     : String(2);
      Country   : String(50) ;
      Routes    : Association to many EarthRoutes on Routes.Airline=$self;
};

// ---------------------------------------------------------------------------------------------------------------------
// EarthRoutes
//
// This entity is so named in order to distinguish routes travelled on earth from routes travelled in space
//
// Only direct flights are stored in this entity.  If a journey cannot be made using a direct flight, then the ID of
// each EarthRoute entry will be used to define the legs (or stages) of the journey as stored in EarthItineraries
// ---------------------------------------------------------------------------------------------------------------------
entity EarthRoutes       : Named {
  key ID                 : Integer;
      Airline            : Association to Airlines;
      StartingAirport    : Association to Airports;
      DestinationAirport : Association to Airports;
      Equipment          : String(50);
};

// ---------------------------------------------------------------------------------------------------------------------
// Itineraries
//
// The properties common to EarthRoutes and SpaceRoutes are combined into this abstract entity, which in turn, uses the
// abstract entity "Named"
// ---------------------------------------------------------------------------------------------------------------------
abstract entity Itineraries : Named {
  key ID : Integer;
}

// ---------------------------------------------------------------------------------------------------------------------
// EarthItineraries
//
// This entity represents any journey made on earth and can be broken into a maximum of 5 legs (or stages)
//
// E.G. There is no direct flight from Banaglore, India to the Russian Space Centre at Baikonur, so this journey must
// first be constructed using multiple legs, then named using the starting and ending airports:
//   Name = "Bangalore -> Baikonur"
//   EarthLegs = {
//     leg1 = ID of Bangalore -> Delhi
//     leg2 = ID of Delhi     -> Almaty
//     leg3 = ID of Almaty    -> Yubileyniy
//   }
// ---------------------------------------------------------------------------------------------------------------------
entity EarthItineraries : Itineraries {
  EarthLegs : {
    leg1  : Association to EarthRoutes;
    leg2  : Association to EarthRoutes;
    leg3  : Association to EarthRoutes;
    leg4  : Association to EarthRoutes;
    leg5  : Association to EarthRoutes;
  };

  Bookings : Association to many Bookings on Bookings.EarthItinerary=$self;
};

// ---------------------------------------------------------------------------------------------------------------------
// Bookings
//
// Each booking represents a journey made by one or more travellers
//
// Using the abstract type "Managed", the entries in this entity are keyed using a generated UUID; however, this value
// is not human readable.  Therefore, for the purposes of creating a human readable reference for the booking, the
// BookingNo field will be used.
//
// The value in this field is constructed from a Date-Time stamp, followed by the arbitrary code "-SP-" and then a
// generated UUID value.  Custom code will be written both to generate and then display this value; however, in the
// exercises that first use this data model, this field will be left blank.
// ---------------------------------------------------------------------------------------------------------------------
entity Bookings : Managed {
  BookingNo          : String(34);    // yyyyMMddhhmmss-SP-[UUID]
  EarthItinerary     : Association to EarthItineraries;
  CustomerName       : String(50)     not null;
  EmailAddress       : String(50)     not null;
  DateOfBooking      : DateTime       not null;
  DateOfTravel       : DateTime       not null;
  Cost               : Decimal(10, 2) not null;
  NumberOfPassengers : Integer        default 1;
};
