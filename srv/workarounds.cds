using { sap.capire.flights.data.Flights } from './data-products';

// REVISIT: workaround for compiler limitation
extend Flights with columns {
  maximum_seats - occupied_seats as free_seats : Integer,
}
