using { Currency, Country, cuid, sap.common.CodeList } from '@capire/common';

namespace sap.capire.flights;

/**
 * A scheduled flight on a specific date with a specific aircraft and price.
 */
entity Flights {
  key flight     : Association to FlightConnections;
  key date       : Date;
  aircraft       : String;
  price          : Price;
  currency       : Currency;
  maximum_seats  : Integer;
  occupied_seats : Integer; // partly transactional
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
}

entity Airports : cuid {
  name    : String;
  city    : String;
  country : Country;
}

entity Supplements : cuid {
  type     : Association to SupplementTypes;
  descr    : localized String(1111);
  price    : Price;
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

type Price : Decimal(9,4);
