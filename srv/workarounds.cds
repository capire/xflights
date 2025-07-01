using { sap.capire.flights.data.Flights } from './data-products';

// REVISIT: workaround for compiler limitation
extend Flights with columns {
  maximumSeats - occupiedSeats as freeSeats : Integer,
}
