# teched2018-cro2
TechEd 2018 Session Journey For Track CRO2

## Extension Space model for cdsSpaceTrip

The `space-model` extends `flight-model` in order to represent journeys taken into space.

## Entities for Read-Only Master Data

### Entity `AstronomicalBodies`

Any planet or moon that could act as a travel destination.

#### Definition

```javascript
entity AstronomicalBodies {
  key ID             : Integer;
      Name           : String(100) @title: "Astronomical Body";
      SolarDistance  : Decimal(10, 8);
      SurfaceGravity : Decimal(10, 6);
      Arrivals       : Association to many SpaceRoutes on Arrivals.DestinationPlanet=$self;
      Departures     : Association to many SpaceRoutes on Departures.StartingPlanet=$self;
      Spaceports     : Association to many Spaceports  on Spaceports.OnPlanet=$self;
};
```

#### Structure

The key value used to identify an astronomical body is an arbitrary integer.

`SolarDistance` is that body's average distance from the Sun and is measured in astronomical units (where 1.0 AU is the distance from the Earth to the Sun)

`SurfaceGravity` is that fraction of Earth's gravity experienced on the surface of this body.

#### Content

Only the 8 planets in our solar system, plus Pluto and the Moon are represented here.

---

### Entity `SpaceFlightCompanies`

This entity performs the same role as `Airlines` in the base data model, but is used exclusively to represent companies operating launch vehicles suitable for Lunar space travel or beyond.

#### Definition

```javascript
entity SpaceFlightCompanies {
  key ID            : Integer;
      Name          : String(100) @title: "Space Flight Company";
      OperatesFrom1 : Association to Spaceports;
      OperatesFrom2 : Association to Spaceports;
      OperatesFrom3 : Association to Spaceports;
};
```

#### Structure

The key value used to identify each space company is an arbitrary integer.

A space flight company can operate from up to three different spaceports


#### Content

7 companies are currently listed that are all capable of launching vehicles that can travel to the Moon or beyond.

---

### Entity `Spaceports`

This entity performs the same role as `Airports` in the base data model, but is used exclusively to represent launch sites for space flights.

These launch sites are not necessarily located on Earth.

#### Definition

```javascript
entity Spaceports {
  key ID         : Integer;
      Name       : String(100) @title: "Spaceport";
      OnPlanet   : Association to AstronomicalBodies;
      Latitude   : Decimal(12, 9) ;
      Longitude  : Decimal(12, 9) ;
      OperatedBy : Association to many SpaceFlightCompanies
        on OperatedBy.OperatesFrom1=$self
        or OperatedBy.OperatesFrom2=$self
        or OperatedBy.OperatesFrom3=$self;
};
```

#### Structure

The key value used to identify each spaceport is an arbitrary integer.

#### Content

9 spaceports are currently listed from vehicle capable of lunar or trans-lunar flight can take off.

To allow for future (fictitious) expansion of this data to include Spaceports on other astronomical bodies, this entity also includes the field "OnPlanet" which holds the ID of the Astronomical Body on which the Spaceport is located.  3 non-terrestrial Spaceports have been added; 1 on the Moon at Tranquility Base (the Apollo 11 landing site) and 2 on Mars (two proposed sites for the Mars 2020 mission)

---

### Entity `Spaceroutes`

Lists all the routes that involve some aspect of space travel.  For ease of understanding, each space route can be grouped into one of four general categories:

1. Vehicle launch into low planetary orbit
1. Entering some type of transfer orbit (this will take you to your destination planet)
1. Transition from transfer orbit into low planetary orbit
1. Descent to planetary surface

Not all of these routes start or finish on the surface of a planet.

#### Definition

```javascript
entity SpaceRoutes {
  key ID                       : Integer;
      Name                     : String(100) @title: "Space Route";
      StartingPlanet           : Association to AstronomicalBodies;
      DestinationPlanet        : Association to AstronomicalBodies;
      StartingSpaceport        : Association to Spaceports;
      DestinationSpaceport     : Association to Spaceports;
      StartsFromOrbit          : Boolean    default false;
      LandsOnDestinationPlanet : Boolean    default false;
};
```

#### Structure

The space route categories are identified by the number ranges shown below.  The key field for each route is then an arbitrary integer within the given number range:

| SpaceRoute ID | Route Category |
|:-:|---|
| 000 - 099 | Launch into low planetary orbit
| 100 - 199 | Enter transfer orbit
| 200 - 299 | Enter low planetary orbit
| 300 - 399 | Planetary descent

| Field Name | Description | Can be null? |
|---|---|:-:|
|`StartingPlanet`| The ID of the planet from which this route starts | Yes
|`DestinationPlanet`| The ID of the planet on which this route ends | No
|`StartingSpaceport`| The ID of the Spaceport from which the vehicle is launched | Yes
|`DestinationSpaceport`| The ID of the spaceport to which the vehicle returns | Yes
|`StartsFromOrbit`| Indicates whether this route starts on the surface of a planet or from orbit | No
|`LandsOnDestinationPlanet`| Indicates whether the route terminates on the destination planet | No

#### Content

As described in [the introduction](./dataModel.md), a journey taken in space consists of multiple legs (or stages).  Each leg is stored as a specific space route.

In the following tables, null fields have been left blank for visual clarity. (LEO = Low Earth Orbit)

##### Launches (00 - 99)

| ID | Route Name | Starting Planet | Destination Planet | Starting Spaceport | Destination Spaceport | Starts From Orbit? | Lands On Destination Planet? |
|---|---|---|---|---|---|:-:|:-:|
| 000 | Cape Canaveral to LEO | Earth | Earth | Cape Canaveral | | FALSE | FALSE
| 001 | Baikonur to LEO | Earth | Earth | Baikonur | | FALSE | FALSE
| 002 | Tranquility Base to Low Lunar Orbit | Moon | Moon | Tranquility Base | | FALSE | FALSE
| 003 | Jezero Crater to Low Martian Orbit | Mars | Mars | Jezero Crater | | FALSE | FALSE
| 004 | Columbia Crater to Low Martian Orbit | Mars | Mars | Jezero Crater | | FALSE | FALSE

##### Transfer Orbits (100 - 199)

| ID | Route Name | Starting Planet | Destination Planet | Starting Spaceport | Destination Spaceport | Starts From Orbit? | Lands On Destination Planet? |
|---|---|---|---|---|---|:-:|:-:|
| 100 | Transfer Orbit (Earth to Moon) | Earth | Moon | |  | TRUE | FALSE
| 101 | Transfer Orbit (Earth to Mars) | Earth | Mars | |  | TRUE | FALSE
| 102 | Transfer Orbit (Mars to Earth) | Mars | Earth | |  | TRUE | FALSE
| 103 | Transfer Orbit (Moon to Earth) | Moon | Earth | |  | TRUE | FALSE
| 104 | Free Return Transfer Orbit (Earth via Moon) | Earth | Earth | | | TRUE | FALSE
| 105 | Free Return Transfer Orbit (Earth via Mars) | Earth | Earth | | | TRUE | FALSE

##### Enter Low Planetary Orbit (200 - 299)

| ID | Route Name | Starting Planet | Destination Planet | Starting Spaceport | Destination Spaceport | Starts From Orbit? | Lands On Destination Planet? |
|---|---|---|---|---|---|:-:|:-:|
| 200 | Enter LEO | | Earth | |  | TRUE | FALSE
| 201 | Enter Low Lunar Orbit | | Moon | |  | TRUE | FALSE
| 202 | Enter Low Martian Orbit | | Mars | |  | TRUE | FALSE

##### Planetary Descent (300 - 399)

| ID | Route Name | Starting Planet | Destination Planet | Starting Spaceport | Destination Spaceport | Starts From Orbit? | Lands On Destination Planet? |
|---|---|---|---|---|---|:-:|:-:|
| 300 | Earth Re-entry | | Earth | | Baikonur | TRUE | TRUE
| 301 | Lunar Descent | | Moon | | Tranquility Base | TRUE | TRUE
| 302 | Martian Descent (Jezero) | | Mars | | Jezero Crater | TRUE | TRUE
| 303 | Martian Descent (Columbia) | | Mars | | Jezero Crater | TRUE | TRUE


The data is stored in the file `spaceroutes.csv`, which currently contains 16 entries.

## Entities for Modifiable Master Data


### Extension to Entity `Itineraries`

The `Itineraries` entity is extended here to add `SpaceLegs` that consists of up to 9 separate legs (or stages).

#### Definition

```javascript
extend flight.Itineraries {
  SpaceLegs : {
    leg1  : Association to SpaceRoutes;
    leg2  : Association to SpaceRoutes;
    leg3  : Association to SpaceRoutes;
    leg4  : Association to SpaceRoutes;
    leg5  : Association to SpaceRoutes;
    leg6  : Association to SpaceRoutes;
    leg7  : Association to SpaceRoutes;
    leg8  : Association to SpaceRoutes;
    leg9  : Association to SpaceRoutes;
  };
};
```

#### Structure

Each leg of the journey refers to the ID of a space route.


#### Content

The data used to populate the database table generated from this entity has been defined manually.  Entries have been created to represent the following end-to-end journeys:

| ID | Starts from | Destination | Via | Free Return? |
|--:|---|---|---|:-:|
| 1 | London | Moon | Cape Canaveral | ![Tick](./pictures/tick.png) |
| 2 | Bangalore | Moon | Baikonur | ![Tick](./pictures/tick.png) |
| 3 | San Francisco | Moon | Cape Canaveral | ![Tick](./pictures/tick.png) |
| 4 | London | Moon | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 5 | Bangalore | Moon | Baikonur | ![Cross](./pictures/cross.png) |
| 6 | San Francisco | Moon | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 7 | London | Mars | Cape Canaveral | ![Tick](./pictures/tick.png) | 
| 8 | Bangalore | Mars | Baikonur | ![Tick](./pictures/tick.png)  |
| 9 | San Francisco | Mars | Cape Canaveral | ![Tick](./pictures/tick.png) |
| 10 | London | Mars | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 11 | Bangalore | Mars | Baikonur | ![Cross](./pictures/cross.png) |
| 12 | San Francisco | Mars | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 13 | Moon | London | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 14 | Moon | Bangalore | Baikonur | ![Cross](./pictures/cross.png) |
| 15 | Moon | San Francisco | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 16 | Mars (Jezero) | London | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 17 | Mars (Jezero)| Bangalore | Baikonur | ![Cross](./pictures/cross.png) |
| 18 | Mars (Jezero)| San Francisco | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 19 | Mars (Columbia) | London | Cape Canaveral | ![Cross](./pictures/cross.png) |
| 20 | Mars (Columbia) | Bangalore | Baikonur | ![Cross](./pictures/cross.png) |
| 21 | Mars (Columbia) | San Francisco | Cape Canaveral | ![Cross](./pictures/cross.png) |


### Entity `Bookings`

Lists each booking of a journey made by one or more travellers

Using the abstract type "Managed", the entries in this entity are keyed using a generated UUID; however, this value is not human readable.  Therefore, for the purposes of creating a human readable reference for the booking, the BookingNo field will be used.

The value in this field is constructed from a Date-Time stamp, followed by the arbitrary code `-SP-` and then a generated UUID value.  Custom code will be written both to generate and then display this value; however, in the exercises that first use this data model, this field will be left blank.

#### Definition

```javascript
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
```

#### Content

The Bookings table is currently not pre-populated.

