# @capire/xflights

The XFlights application manages master data like Airlines, Airports, and Flights.
Client applications can consume this via the `@capire/xflights-api` package like so:

1. Add the API package

```sh
npm add @capire/xflights-api
```

2. Add consumption views

```cds
using { sap.capire.flights.data as external } from '@capire/xflights-api';
entity federated.Flights as projection on external.Flights {
  *,
  airline.icon     as icon,
  airline.name     as airline,
  origin.name      as origin,
  destination.name as destination,
}
```

3. Mashup with local definitions

```cds
entity TravelBookings {
  flight : Association to federated.Flights;
}
```
