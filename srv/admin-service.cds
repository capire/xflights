using { sap.capire.flights as my } from '../db/schema';
namespace sap.capire.flights;

@fiori @odata @hcql service AdminService {
  entity FlightConnections as projection on my.FlightConnections;
  entity Flights as projection on my.Flights;
  entity Airlines as projection on my.Airlines;
  entity Airports as projection on my.Airports;
  entity Supplements as projection on my.Supplements;
}
