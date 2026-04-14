using sap.capire.flights as x from '../db/schema';
using from './workaround';

/**
 * Master data service providing flight-related data, e.g. Flights, Airlines,
 * Airports, and Supplements (e.g. extra luggage, meals, etc.).
 * Served as SAP data product, and protocols supported by CAP.
 */
@data.product @hcql @rest @odata @graphql
service sap.capire.flights.data {

  // Serve Flights data via denormalized view with flattened FlightConnections
  @readonly entity Flights as select from x.Flights left join x.FlightConnections on ID = flight.ID {
    key ID, key date, *
  } excluding { flight, createdAt, createdBy, modifiedBy } // as flight details are flattened

  // Serve Airlines with redirected association to Flights view
  @readonly entity Airlines as projection on x.Airlines { *,
    flights : redirected to Flights
  } excluding { createdAt, createdBy, modifiedBy };

  // Serve Airports with redirected associations to Flights view
  @readonly entity Airports as projection on x.Airports { *,
    departures : redirected to Flights,
    arrivals   : redirected to Flights
  } excluding { createdAt, createdBy, modifiedBy };

  // Serve Supplements data as is
  @readonly entity Supplements as projection on x.Supplements
  excluding { createdAt, createdBy, modifiedBy };

  // Custom actions and events to sync with consumers about flight seat availability
  action BookingCreated ( flight: Flights:ID, date: Flights:date, seats: array of Integer);
  action BookingDeleted ( flight: Flights:ID, date: Flights:date, seats: array of Integer);
  event FlightsUpdated  { flight: Flights:ID; date: Flights:date; free_seats: Integer; }
}
