using { Currency, Country, cuid, sap.common.CodeList } from '@sap/cds/common';

namespace sap.capire.flights;

/**
 * A scheduled flight on a specific date with a specific aircraft and price.
 */
entity Flights {
  key flight     : Association to FlightConnections;
  key date       : Date;
  aircraft       : String;
  price          : Decimal(9,4);
  currency       : Currency;
  maximum_seats  : Integer;
  occupied_seats : Integer; // partly transactional
  free_seats     : Integer = maximum_seats - occupied_seats; 
}

/**
 * A flight connection between two airports operated by an airline.
 */
entity FlightConnections {
  key ID      : String(11); // e.g. LH4711
  airline     : Association to Airlines;
  origin      : Association to Airports;
  destination : Association to Airports;
  departure   : Time;
  arrival     : Time;
  distance    : Integer; // in kilometers
}

entity Airlines : cuid {
  name     : String;
  icon     : String;
  currency : Currency;
  flights  : Association to many FlightConnections on flights.airline = $self;
}

entity Airports : cuid {
  name    : String;
  city    : String;
  country : Country;
  arrivals : Association to many FlightConnections on arrivals.destination = $self;
  departures : Association to many FlightConnections on departures.origin = $self;
}

entity Supplements : cuid {
  type     : Association to SupplementTypes;
  descr    : localized String(1111);
  price    : Decimal(9,4);
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
