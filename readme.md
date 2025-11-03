# @capire/xflights


This is a reuse package to manage and serve master data like _Airlines_, _Airports_, and _Flights_.
It publishes a [pre-built client package](#published-apis), that is used in the [xtravels](https://github.com/capire/xtravels) application.

#### Table of Contents

- [Domain Model](#domain-model)
- [Service Interfaces](#service-interfaces)
- [Published APIs](#published-apis)
- [Service Integration](#service-integration)




## Domain Model

The domain model is defined in [_db/schema.cds_](./db/schema.cds):

![](_docs/domain-model.drawio.svg)


## Service Interfaces

Two service interfaces are provided: One to _maintain_ the master data from UIs or remote systems, and one to _consume_ it from remote applications, as shown below:

![](_docs/services.drawio.svg)

Find the respective service definitions in:
- [_srv/admin-service.cds_](./srv/admin-service.cds)
- [_srv/data-service.cds_](./srv/data-service.cds)


> [!tip] 
>
> <details> <summary>Using Denormalized Views</summary>
>
> The latter exposes a denormalized view of `Flights` data, in essence declared like that: 
>
> ```cds
> entity Flights as projection on my.Flights { 
>   *,          // exposing all own elements, plus...
>   flight.*,  // flattened elements from flight connections
> }
> ```
>
> So the consumer doesn't need to care about normalized flight connections but just consume a conceptual model that is easier to work with, and looks like that:
>
> ![](_docs/data-service.drawio.svg)
>
> </details>

### Published APIs

The data API is published as a pre-built client package using `cds export`:

```sh
cds export srv/data-service.cds
```

This creates a separate CAP package within subfolder [_apis/data-service_](./apis/data-service/) that contains only the service interface, accompanied by automatically derived test data and i18n bundles, which allows it to be used in consuming apps in a plug-and-play fashion. 

Initially, it also adds a `package.json` with this content:

```json [package.json]
{
  "name": "@capire/xflights-data-service",
  "version": "0.1.6",
  "cds": {
    "requires": {
      "sap.capire.flights.data": true
    }
  }
}
```

We can modify that as appropriate, and did so by changing the package name to `@capire/xflights-data`:

```diff
-   "name": "@capire/xflights-data-service",
+   "name": "@capire/xflights-data",
```



We can finally share this package with consuming applications using standard ways, like `npm publish`:

```sh
cd apis/data-service
npm publish
```


> [!tip]
> <details> <summary>Using GitHub Packages</summary>
>
> Within the [_capire_](https://github.com/capire) org, we're publishing to [GitHub Packages](https://docs.github.com/packages), which requires you to npm login once like that:
>
> ```sh
> npm login --scope=@capire --registry=https://npm.pkg.github.com
> ```
>
> As password you're using a Personal Access Token (classic) with `read:packages` scope. Read more about that in [Authenticating to GitHub Packages](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry#authenticating-to-github-packages).
> </details>



## Service Integration

Use the published package in your consuming application by installing it via npm:

```sh
npm add @capire/xflights-data
```



Then, you can use the imported models as usual, and as if they were local in mashups with your own entities. Here's an example from the [_xtravels_ application](https://github.com/capire/xtravels/blob/main/db/master-data.cds):

```cds
using { sap.capire.flights.data as external } from '@capire/xflights-data';

// declare a consumption view to capture what we really need
@federated entity Flights as projection on external.Flights {
  *,
  airline.icon     as icon,
  airline.name     as airline,
  origin.name      as origin,
  destination.name as destination,
}
```
```cds
entity Booking {
  flight : Association to /* federated */ Flights;
}
```

## License

Copyright (c) 2022 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
