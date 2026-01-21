using sap.capire.flights as x from '../db/schema';

/**
 * Master data service providing flight-related data, e.g. Flights, Airlines,
 * Airports, and Supplements (e.g. extra luggage, meals, etc.). 
 * Served as SAP data product, and protocols supported by CAP. 
 */
@data.product @hcql @rest @odata @graphql
service sap.capire.flights.data {

  // Serve Flights data via denormalized view with flattened FlightConnections
  @readonly entity Flights as projection on x.Flights {
    key flight.ID,              // key required for OData
    key date,                   // key required for OData
    *,                          // all fields from Flights
    flight.{*} excluding {ID},  // all fields from FlightConnection
  } excluding { flight };       // which we flattened above

  // Serve Airlines, Airports, and Supplements data as is
  @readonly entity Airlines as projection on x.Airlines;
  @readonly entity Airports as projection on x.Airports;
  @readonly entity Supplements as projection on x.Supplements;

  // PARKED for later use ...
  // Custom events to sync with consumers about flight seat availability
  // @inbound  event Booking.Created : FlightKeys { seats : array of Integer; }
  // @inbound  event Booking.Deleted : FlightKeys { seats : array of Integer; }
  // @outbound event Flights.Updated : FlightKeys { free_seats : Integer; }
  // Reuse type for referencing flights by compound key
  // type FlightKeys : {
  //   flightNumber : type of Flights:ID;
  //   flightDate   : type of Flights:date;
  // }
}





//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Workarounds for @cds.autoexpose kicking in too eagerly ...
//
//  - cds.autoexpose should only apply to UI/Fiori backend services, not API services
//  - cds.autoexpose should be supported on individual assocs, not only targets
//  - associations to stay in models for non-exposed targets -> currently skipped by 4odata
//
    annotate sap.common.Currencies with @cds.autoexpose:false;
    annotate sap.common.Countries with @cds.autoexpose:false;
    annotate sap.common.Languages with @cds.autoexpose:false;
//
//////////////////////////////////////////////////////////////////////////////////////////////////
