using { sap.capire.flights as my } from '../db/schema';

@fiori service FlightsService {
  entity Connections as projection on my.Connections;
  entity Flights as projection on my.Flights;
  entity Airlines as projection on my.Airlines;
  entity Airports as projection on my.Airports;
  entity Supplements as projection on my.Supplements;
}
