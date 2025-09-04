using { sap, sap.capire.flights as my } from '../db/schema';

@hcql @rest @odata @data.product
service sap.capire.flights.data {

  // Serve Flights data with inlined connection details
  @readonly entity Flights as projection on my.Flights {
    key flight.ID, flight.{*} excluding { ID },
    key date, // preserve the flight date as a key
    *, // include all other fields from my.Flights
    maximum_seats - occupied_seats as free_seats : Integer,
  } excluding { flight };

  // Serve Airlines, Airports, and Supplements data as is
  @readonly entity Airlines as projection on my.Airlines;
  @readonly entity Airports as projection on my.Airports;
  @readonly entity Supplements as projection on my.Supplements;

  // inbound and outbound events
  aspect FlightKeys {
    flightNumber : Flights:ID;
    flightDate : Flights:date;
  }
  @outbound event Flights.Updated : FlightKeys {
    occupied_seats : Integer;
    free_seats : Integer;
  }
  @inbound event BookingCreated : FlightKeys { seats : array of Integer; }
  @inbound event BookingCancelled : FlightKeys { seats : array of Integer; }

  // workaround to avoid conflicts with compiler's autoexpose behavior
  @cds.autoexpose:false entity _Currencies as projection on sap.common.Currencies;
  @cds.autoexpose:false entity _Countries as projection on sap.common.Countries;
}
