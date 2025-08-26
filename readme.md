# @capire/xflights

The XFlights application manages master data like Airlines, Airports, and Flights.
Client applications can consume this via the `@capire/xflights` package like so:

1. Add the API package

```sh
npm login --scope=@capire --registry=https://npm.pkg.github.com
npm add @capire/xflights
```

[Learn how to authenticate to GitHub packages.](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry#authenticating-to-github-packages)

2. Add consumption views

```cds
using { sap.capire.flights.data as external } from '@capire/xflights';
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

## Get Help

- Visit the [*capire* docs](https://cap.cloud.sap) to learn about CAP.
- Especially [*Getting Started in a Nutshell*](https://cap.cloud.sap/docs/get-started/in-a-nutshell).
- Visit our [*SAP Community*](https://answers.sap.com/tags/9f13aee1-834c-4105-8e43-ee442775e5ce) to ask questions.

## Get Support

In case you have a question, find a bug, or otherwise need support, please use our [community](https://answers.sap.com/tags/9f13aee1-834c-4105-8e43-ee442775e5ce). See the documentation at [https://cap.cloud.sap](https://cap.cloud.sap) for more details about CAP.

## License

Copyright (c) 2022 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
