# teched2018-cro2
TechEd 2018 Session Journey For Track CRO2

## Base Flight model for cdsSpaceTrip

The FlightData model acts as the base model for the TechEd CR02 sessions.



## Entities for Read-Only Master Data

The following entities represent master data that will only ever be accessed in a read-only manner (unless of course you plan on building a new airport or the Death Star...)

### Entity `Airports`

Lists almost all known airports.

#### Definition

```javascript
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
```

#### Structure

| Field Name | Key | Description
|---|---|---|
| `IATA3` | ![Tick](./img/tick.png) | The 3-character IATA location code.<br>E.G. London's Heathrow Airport = "LHR", New York's John F. Kennedy Airport = "JFK".
| `Name` | | Airport name in English as a UTF-8 character string
| `City` | | The name of the town or city served by this airport
| `Country` | | The country in which the airport is located
| `Elevation` | | The airport's height above Mean Sea Level (MSL) measured in feet
| `Latitude` | | The airports's latitude in decimal notation
| `Longitude` | | The airports's longitude in decimal notation

All coordinates are given in decimal notation rather than DMS notation (Degrees, Minutes, Seconds).  By convention, positive longitude is East and positive latitude is North.

Longitude coordinate values must range between ±180.0˚ and latitude values must range between ±90.0˚.

#### Content

The data used to populate the database table generated from this entity has been derived from a filtered and reduced version of the file [airports-extended.dat](https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports-extended.dat) available from the [Open Flights](https://openflights.org/data.html) website.

The data is stored in the file `airports.csv`, which currently contains just over 6000 entries.

---

### Entity `AircraftCodes`

Lists the 3-character IATA equipment codes used to identify different aircraft makes, types and models.

#### Definition

```javascript
entity AircraftCodes {
  key EquipmentCode : String(3);
      Manufacturer  : String(30) @title: "Manufacturer";
      Type_Model    : String(50) @title: "Type/Model";
      Wake          : String(1)  @title: "Wake Category";
};
```

#### Structure

| Field Name | Key | Description
|---|---|---|
| `EquipmentCode` | ![](./img/tick.png) | The 3-character IATA equipment code.<br>E.G. Airbus A320 = "320", Boeing 777-8 = "778"
| `Manufacturer` | | The name of the aircraft manufacturer
| `Type_Model` | | The type and model of aircraft
| `Wake` | | The aircraft's wake category.  See below for details

The `Wake` field describes the degree of wake turbulence created behind an aircraft as it flies.

Wingtip vortices are the primary source of wake turbulence and for large aircraft, such turbulent air can persist for more than 3 minutes after the aircraft has passed.  This effect is particularly strong during takeoff and landing; therefore, an aircraft of a lower wake category must not enter the same airspace (I.E. take off or land) immediately behind an aircraft of a higher wake category.  During final approach, this is achieved by pilots maintaining a designated separation (in nautical miles).

The wake categories are defined by aircraft's Maximum Takeoff Weight (MTOW)  (N.B. helicopters having 2 blade rotors often generate higher wake turbulence than their MTOW might indicate):

| Wake Category | Description | Definition |
|---|---|---|
| L | Low | <= 19,000Kg |
| M | Medium | Between 19,000Kg and 140,000Kg |
| H | High | > 140,000Kg |
| J | Super | Airbus A380 |

#### Content

The data used to populate the database table generated from this entity has been derived from [flugzeuginfo.net](http://www.flugzeuginfo.net/table_accodes_iata_en.php).

The data is stored in the file `aircraftcodes.csv`, which currently contains about 350 entries.

---

### Entity `Airlines`

Lists information about each airline company.

#### Definition

```javascript
entity Airlines {
  key IATA2     : String(2);
      Name      : String(100) @title: "Airline";
      Country   : String(50)  @title: "Country";
      Routes    : Association to many EarthRoutes on Routes.Airline=$self;
};
```

#### Structure

| Field Name | Key | Description
|---|---|---|
| `IATA2` | ![](./img/tick.png) | The 2-character IATA airline code.<br>E.G. Lufthansa = "LH", British Airways = "BA"
| `Name` | | The airline company's name
| `Country` | | The country in which the airline company is based

#### Content

The data used to populate the database table generated from this entity has been derived from a filtered and reduced version of the file [airlines.dat](https://raw.githubusercontent.com/jpatokal/openflights/master/data/airlines.dat) available from the [Open Flights](https://openflights.org/data.html) website.

The data is stored in the file `airlines.csv`, which currently contains about 900 entries.


***IMPORTANT***
In reality, 2-character IATA Airline codes are not guaranteed to be unique!

E.G. The airline code `DJ` has been variously assigned to AirAsia Japan, Air Djibouti, Nordic European Airlines and Virgin Blue Airlines.  However, for simplicity, the data held in the CSV file has been filtered such that all `IATA2` values can be treated as unique.

---


### Entity `Earthroutes`

Lists all direct flights between two airports, the airline company that operates that route, and the different aircraft types flown on that route.

#### Definition

```javascript
entity EarthRoutes {
  key StartingAirport    : Association to Airports;
  key DestinationAirport : Association to Airports;
  key Airline            : Association to Airlines;
      Equipment : {
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
```

#### Structure

Only direct flights are stored in this entity.

Due to the fact that multiple airline companies can operate the same route, this entity requires three key fields.

| Field Name | Key | Description
|---|---|---|
| `StartingAirport` | ![](./img/tick.png) | The starting airport's 3-character IATA location code
| `DestinationAirport` | ![](./img/tick.png) | The destination airport's 3-character IATA location code
| `Airline` | ![](./img/tick.png) | The 2-character IATA code of the airline that operates this route
| `Equipment` | | A compound data structure holding the equipment codes of up to 9 different aircraft used on this route
| `aircraft[1..9]` | | The 3-character IATA equipment code of an aircraft used on this route


#### Content

The data used to populate the database table generated from this entity has been derived from a filtered and reduced version of the file [routes.dat](https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat) available from the [Open Flights](https://openflights.org/data.html) website.

The data is stored in the file `earthroutes.csv`, which currently contains about 57600 entries.




## Entities for Modifiable Master Data

The following entities represent master data that can be created by an end-user such as a Travel Agent.


### Entity `Itineraries`

Lists all the end-to-end journeys made on earth and can be broken into a maximum of 5 legs (or stages)

#### Definition

```javascript
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
```

#### Structure

| Field Name | Key | Description
|---|---|---|
| `ID` | ![](./img/tick.png) | Each itinerary is identified using an arbitrary integer
| `Name` | | The name of the end-to-end journey.<br>Before being extended by the `spaceModel`, this table holds only those journeys that take place on earth
| `EarthLegs` | | Compound data structure holding the key fields needed to identify one leg of this journey on Earth
| `leg[1..5]` | | The keys values needed to identify a single route on earth. I.E. The key structure for entity `EarthRoutes`

#### Content

The pre-populated content exists only for the extended version of this entity.



## Entities for Transactional Data

These entities represent data created as a result of the Travel Agent conducting their business

### Entity `Bookings`

Lists each booking of a journey made by one or more travellers

Using the abstract type "Managed", the entries in this entity are keyed using a generated UUID; however, this value is not human readable.  Therefore, for the purposes of creating a human readable reference for the booking, the BookingNo field will be used.

The value in this field is constructed from a Date stamp, followed by a short alphanumeric string.  Custom code will be written both to generate and then display this value; however, in the exercises that first use this data model, this field will be left blank.

#### Definition

```javascript
entity Bookings : Managed {
      BookingNo          : String(25);    // e.g. "20180726/GA1B6"
      Itinerary          : Association to Itineraries;
      CustomerName       : String(50);
      EmailAddress       : String(50);
      DateOfTravel       : DateTime       not null;
      Cost               : Decimal(10, 2) not null;
      NumberOfPassengers : Integer        default 1;
};
```

#### Structure

| Field Name | Key | Description
|---|---|---|
| `ID` | ![](./img/tick.png) | The UUID of this booking
|`BookingNo`| | Human readable identifier for the booking.<br>The value used in this field must be generated by custom code
| `Itinerary` | | The `ID` of the itinerary being booked
| `CustomerName` | | The name of the person making the booking
| `EmailAddress` | | Contact email address for the person making the booking
| `DateOfTravel` | | The journey's start date
| `Cost` | | Total cost of this journey
| `NumberOfPassengers` | | The number of people making this journey


#### Content

The Bookings table is currently not pre-populated.

