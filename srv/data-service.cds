using { sap, sap.capire.flights as my } from '../db/schema';

/**
 * Master data service providing flight-related data, e.g. Flights, Airlines,
 * Airports, and Supplements (e.g. extra luggage, meals, etc.).
 */
@data.product service sap.capire.flights.data {

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
}


// Alternative protocols to serve the data
annotate sap.capire.flights.data 
with @hcql @rest @odata;


// Add custom events
extend service sap.capire.flights.data {

  // inbound and outbound events
  aspect FlightKeys {
    flightNumber : String;
    flightDate : Date;
  }
  @outbound event Flights.Updated : FlightKeys {
    occupied_seats : Integer;
    free_seats : Integer;
  }
  @inbound event BookingCreated : FlightKeys { seats : array of Integer; }
  @inbound event BookingCancelled : FlightKeys { seats : array of Integer; }

}



//////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Workarounds for @cds.autoexpose kicking in too eagerly ...
//
//  - cds.autoexpose should only apply to UI/Fiori backend services, not API services
//  - cds.autoexpose should be supported on individual assocs, not only targets
//  - associations should stay in models for non-exposed targets -> currently taken out by 4odata
//
    annotate sap.common.Currencies with @cds.autoexpose:false;
    annotate sap.common.Countries with @cds.autoexpose:false;
    annotate sap.common.Languages with @cds.autoexpose:false;
//
//////////////////////////////////////////////////////////////////////////////////////////////////
