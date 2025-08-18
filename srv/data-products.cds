using { sap, sap.capire.flights as my } from '../db/schema';

@hcql @rest @odata @data.product
service sap.capire.flights.data {

  // Serve Flights data with inlined connection details
  @readonly entity Flights as projection on my.Flights {
    key flight.ID, flight.{*} excluding { ID },
    key date, // preserve the flight date as a key
    *, // include all other fields from my.Flights
  } excluding { flight };

  // Serve Airlines, Airports, and Supplements data as is
  @readonly entity Airlines as projection on my.Airlines;
  @readonly entity Airports as projection on my.Airports;
  @readonly entity Supplements as projection on my.Supplements;

  // Serve data for common entities from @sap/cds/common
  @readonly entity Currencies as projection on sap.common.Currencies;
  @readonly entity Countries as projection on sap.common.Countries;
  @readonly entity Languages as projection on sap.common.Languages;

}
