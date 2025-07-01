using { Currency, Country, cuid, sap.common.CodeList } from '@sap/cds/common';

namespace sap.capire.flights;

entity Airlines : cuid {
  name     : String(44);
  icon     : String;
  currency : Currency;
}

entity Airports : cuid {
  name    : String(44);
  city    : String(44);
  country : Country;
}

entity FlightConnections {
  key ID        : String(10); // e.g. LH4711
  airline       : Association to Airlines;
  departure     : Association to Airports;
  destination   : Association to Airports;
  departureTime : Time;
  arrivalTime   : Time;
  distance      : Integer; // in kilometers
}

entity Flights {
  key connection  : Association to FlightConnections;
  key flightDate  : Date;
  planeType       : String(10);
  price           : Decimal(16,3);
  currency        : Currency;
  maximumSeats    : Integer;
  occupiedSeats   : Integer; // partly transactional
  freeSeats       : Integer = maximumSeats - occupiedSeats;
};

entity Supplements : cuid {
  type     : Association to SupplementTypes;
  descr    : localized String(1024);
  price    : Decimal(16,3);
  currency : Currency;
}

entity SupplementTypes : CodeList {
  key code : String(2) enum {
    Beverage = 'BV';
    Meal = 'ML';
    Luggage = 'LU';
    Extra = 'EX';
  }
}
