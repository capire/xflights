namespace sap.capire.flights.data;
using {
  sap.capire.flights.data as FlightsService,
  sap.capire.flights.data.Flights
} from './data-products';

aspect FlightKeys {
  flightNumber : Flights:flightNumber;
  flightDate : Flights:flightDate;
}

extend service FlightsService {

  // inbound events
  event BookingCreated : FlightKeys { seats : array of Integer; }
  event BookingCancelled : BookingCreated {}

  // outbound events
  event Flights.Updated : projection on Flights {
    flightNumber,
    flightDate,
    occupiedSeats,
  }

}
