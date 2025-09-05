using { sap, sap.capire.flights as my } from '../db/schema';

/**
 * Service for data integration
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


// Additionally serve via @hcql, @rest, and @odata, and add events
@hcql @rest @odata extend service sap.capire.flights.data {

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



// ----------------------------------------------------------------------------------------------------
// Workarounds for @cds.autoexpose ...
//
extend service sap.capire.flights.data {
  /**
   * REVISIT: workaround to avoid conflicts due to cds.autoexpose behavior:
   * - cds.autoexpose is primarily for UI/Fiori backend services, but currently applied to all
   * - cds.autoexpose should be supported on individual assocs, not only targets
   * - associations should stay in models for non-exposed targets -> currently taken out by 4odata
   * - cds.api.ignore is currently only supported for elements -> the below don't have any effect
   */
  @cds.autoexpose:false @cds.persistence.skip entity ![(ignore: Currencies)] as projection on sap.common.Currencies;
  @cds.autoexpose:false @cds.persistence.skip entity ![(ignore: Countries)] as projection on sap.common.Countries;
}
