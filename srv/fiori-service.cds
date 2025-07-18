using { sap.capire.flights as my } from '../db/schema';

@fiori service FlightsService {
  entity Flights as projection on my.Flights;
  entity Routes as projection on my.Routes;
  entity Airlines as projection on my.Airlines;
  entity Airports as projection on my.Airports;
  entity Supplements as projection on my.Supplements;
}
