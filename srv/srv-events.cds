namespace sap.capire.flights.data;
using {
  sap.capire.flights.data as FlightsService,
  sap.capire.flights.data.Flights
} from './data-products';

aspect FlightKeys {
  flightNumber : Flights:ID;
  flightDate : Flights:date;
}

extend service FlightsService {

  // inbound events
  event BookingCreated : FlightKeys {
    seats : array of Integer;
  }
  event BookingCancelled : BookingCreated {}

  // outbound events
  event Flights.Updated : FlightKeys {
    occupied_seats : Integer;
    free_seats : Integer;
  }

}
