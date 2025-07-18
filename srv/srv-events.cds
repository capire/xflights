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
  event BookingCancelled : BookingCreated {}
  event BookingCreated : FlightKeys {
    seats : array of Integer;
  }

  // outbound events
  event Flights.Updated : FlightKeys {
    occupied_seats : Integer;
    free_seats : Integer;
  }

}
