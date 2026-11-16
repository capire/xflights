using sap.capire.flights as x from '../db/schema';
namespace sap.capire.flights;

/**
 * Master data service providing flight-related data, e.g. Flights, Airlines,
 * Airports, and Supplements (e.g. extra luggage, meals, etc.).
 */
@hcql @rest @odata @graphql @mcp
service FlightsService {

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
  @readonly entity Supplements as projection on x.Supplements {
    *, type.name as type,
  } excluding { createdAt, createdBy, modifiedBy };

  /**
   * Custom actions and events for managing flight seat availability from a leading
   * application like the Xtravels app. Do not call these actions directly from UIs
   * or agents.
   */
  action reserveSeats ( flight: Flights:ID, date: Flights:date, seats: array of Integer );
  action releaseSeats ( flight: Flights:ID, date: Flights:date, seats: array of Integer );
  event FlightsUpdated { flight: Flights:ID; date: Flights:date; };

  /**
   * Use this action to book a flight for a passenger with the specified seats.
   * It calls the reserveSeats action internally.
   */
  action bookFlight (
    @mandatory passenger: x.Bookings:passenger,
    @mandatory flight: Flights:ID,
    @mandatory date: Flights:date,
    @mandatory seats: array of Integer
  ) returns {
    bookingId: x.Bookings:ID;
    total: x.Bookings:total;
    currency: Flights:currency.code;
  };

  /**
   * Use this action to cancel a booking.
   * It calls the releaseSeats action internally if applicable.
   */
  action cancelBooking ( bookingId: UUID );
}


// Temporary workarounds
using from './.workarounds';
