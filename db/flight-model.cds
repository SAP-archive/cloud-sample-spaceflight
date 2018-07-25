// *********************************************************************************************************************
//                                               F L I G H T   M O D E L
//
// Defines the basic set of entities needed for booking flights and is similar to the ABAP Flight data model
// *********************************************************************************************************************
namespace teched.flight.trip;

using common.Managed from './common';

// ---------------------------------------------------------------------------------------------------------------------
// Airports
//
// Each airport is stored using its the 3-character IATA location code as the key
// E.G. "LHR" = London, Heathrow; "JFK" = New York, John F. Kennedy, etc
//
// Elevation is the airfield's height above mean sea level in feet
//
// ---------------------------------------------------------------------------------------------------------------------
entity Airports {
  key IATA3      : String(3);
      Name       : String(100) @title: "Airport";
      City       : String(30)  @title: "City";
      Country    : String(50)  @title: "Country";
      Elevation  : Integer default 0;
      Latitude   : Decimal(12, 9);
      Longitude  : Decimal(12, 9);
      Departures : Association to many EarthRoutes on Departures.StartingAirport=$self;
      Arrivals   : Association to many EarthRoutes on Arrivals.DestinationAirport=$self;
};

// ---------------------------------------------------------------------------------------------------------------------
// Aircraft Codes
//
// Lists the 3-character IATA equipment codes used to identify different aircraft types and models
// E.G. "320" = Airbus A320, "77W" = Boeing 777-300ER etc
//
// The "Wake" field describes the degree of wake turbulence created behind an aircraft as it flies.
//
// Wingtip vortices are the primary source of wake turbulence and for large aircraft, such turbulent air can persist for
// more than 3 minutes after the aircraft has passed.  This effect is particularly strong during takeoff and landing;
// therefore, an aircraft of a lower wake category must not enter the same airspace (I.E. take off or land) immediately
// behind an aircraft of a higher wake category.  During final approach, this is achieved by pilots maintaining a
// desginated separation (in nautical miles).
//
// The wake categories are defined by Maximum Takeoff Weight (MTOW)  (N.B. helicopters having 2 blade rotors often
// generate higher wake turbulence than their MTOW might indicate):
//   "L" : Low     19,000Kg >= MTOW
//   "M" : Medium  19,000Kg  < MTOW <= 140,000Kg
//   "H" : High                MTOW  > 140,000Kg
//   "J" : Super   Airbus A380
// ---------------------------------------------------------------------------------------------------------------------
entity AircraftCodes {
  key EquipmentCode : String(3);
      Manufacturer  : String(30) @title: "Manufacturer";
      Type_Model    : String(50) @title: "Type/Model";
      Wake          : String(1)  @title: "Wake Category";
};

// ---------------------------------------------------------------------------------------------------------------------
// Airlines
//
// Each airline company is stored using its 2-character IATA airline code as the key
// E.G. "BA" = British Airways, "LH" = Lufthansa, etc
//
// Warning - IATA 2-character airline codes are not guaranteed to be unique!
//
// E.G. Airline code "DJ" has been variously assigned to AirAsia Japan, Air Djibouti, Nordic European Airlines and
// Virgin Blue Airlines
// ---------------------------------------------------------------------------------------------------------------------
entity Airlines {
  key IATA2     : String(2);
      Name      : String(100) @title: "Airline";
      Country   : String(50)  @title: "Country";
      Routes    : Association to many EarthRoutes on Routes.Airline=$self;
};

// ---------------------------------------------------------------------------------------------------------------------
// EarthRoutes
//
// This entity is so named in order to distinguish routes travelled on earth from routes travelled in space.
//
// Only direct flights are stored in this entity.
//
// Because multiple airline companies can operate the same route, this entity requires three key field:
// 1) Starting airport IATA location code
// 2) Destination airport IATA location code
// 3) The airline company's 2-character IATA code
//
// An Airline company can operate up to 9 different aircraft types on a single route
// ---------------------------------------------------------------------------------------------------------------------
entity EarthRoutes {
  key StartingAirport    : Association to Airports;
  key DestinationAirport : Association to Airports;
  key Airline            : Association to Airlines;
      Equipment          : {
        aircraft1 : Association to AircraftCodes;
        aircraft2 : Association to AircraftCodes;
        aircraft3 : Association to AircraftCodes;
        aircraft4 : Association to AircraftCodes;
        aircraft5 : Association to AircraftCodes;
        aircraft6 : Association to AircraftCodes;
        aircraft7 : Association to AircraftCodes;
        aircraft8 : Association to AircraftCodes;
        aircraft9 : Association to AircraftCodes;
      };
};

// ---------------------------------------------------------------------------------------------------------------------
// Itineraries
//
// This entity represents any journey made on earth and can be broken into a maximum of 5 legs (or stages)
//
// Each leg of the journey is identified by a pair of values - the starting and destination IATA location codes
//
// E.G. There is no direct flight from Bangalore, India to the Russian Space Centre at Baikonur in Kazakhstan; therefore
// when creating this itinerary, it must be constructed using multiple legs, then named using the starting and ending
// airports:
//   Name = "Bangalore -> Baikonur (Yubileyniy)"
//   EarthLegs = {
//     leg1 = BLR,DEL  (Bangalore -> Delhi)
//     leg2 = DEL,ALA  (Delhi     -> Almaty)
//     leg3 = ALA,AOX  (Almaty    -> Yubileyniy)
//   }
//
// When this entity is extended to include routes travelled in space, then the name should reflect the starting and
// ending points.  E.G. for a space tourist's trip around the Moon and back, the itinerary could be:
//
//   Name = "Bangalore to Moon via Baikonur (Free Return)"
// ---------------------------------------------------------------------------------------------------------------------
entity Itineraries {
  key ID    : Integer;
  Name      : String(100) @title: "Itinerary";
  EarthLegs : {
    leg1  : Association to EarthRoutes;
    leg2  : Association to EarthRoutes;
    leg3  : Association to EarthRoutes;
    leg4  : Association to EarthRoutes;
    leg5  : Association to EarthRoutes;
  };
  Bookings  : Association to many Bookings on Bookings.Itinerary=$self;
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
      Itinerary          : Association to Itineraries;
      CustomerName       : String(50);
      EmailAddress       : String(50);
      DateOfBooking      : DateTime       not null;
      DateOfTravel       : DateTime       not null;
      Cost               : Decimal(10, 2) not null;
      NumberOfPassengers : Integer        default 1;
};
