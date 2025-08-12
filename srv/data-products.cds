using { sap, sap.capire.flights as my } from '../db/schema';

@odata @rest @hcql @data.product
service sap.capire.flights.data {

  // Serve Flights data with inlined connection details
  entity Flights as projection on my.Flights {
    key flight.ID, flight.{*} excluding { ID },
    key date, // preserve the flight date as a key
    *, // include all other fields from my.Flights
  } excluding { flight };

  // Serve Airlines, Airports, and Supplements data as is
  entity Airlines as projection on my.Airlines;
  entity Airports as projection on my.Airports;
  entity Supplements as projection on my.Supplements;

  // Serve data for common entities from @sap/cds/common
  entity Currencies as projection on sap.common.Currencies;
  entity Countries as projection on sap.common.Countries;
  entity Languages as projection on sap.common.Languages;

}
