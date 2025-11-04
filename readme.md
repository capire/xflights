# @capire/xflights

This is a reuse package to manage and serve master data like _Airlines_, _Airports_, and _Flights_.
It publishes a [pre-built client package](#publishing-apis), that is used in the [xtravels](https://github.com/capire/xtravels) application.

##### Table of Contents

- [Domain Model](#domain-model)
- [Service Interfaces](#service-interfaces)
- [Exporting APIs](#exporting-apis)
- [Publishing APIs](#publishing-apis)
- [Consuming APIs](#consuming-apis)




## Domain Model

The domain model is defined in [_db/schema.cds_](./db/schema.cds). It centers around normalized `FlightConnections`, which connect two `Airports` operated by an `Airline`, while entity `Flights` represents scheduled flights on specific dates with a specific aircraft and price.

![](_docs/domain-model.drawio.svg)


## Service Interfaces

Two service interfaces are defined in [_srv/admin-service.cds_](./srv/admin-service.cds), and [_srv/data-service.cds_](./srv/data-service.cds), to serve different use cases: One to _maintain_ the master data from UIs or remote systems, and one to _consume_ it from remote applications, as shown below:

![](_docs/services.drawio.svg)


> [!tip] 
>
> <details> <summary> Serving denormalized views </summary>
>The data service exposes a denormalized view of `Flights` and associated `FlightConnections` data, essentially declared like that: 
>
> ```cds
>entity Flights as projection on my.Flights { 
> *,          // all elements from Flights
> flight.*,   // all elements from FlightConnections
> }
> ```
> 
> With that consumers aren't bothered with normalized data but can just consume flat data, looking like that:
>
> ![](_docs/data-service.drawio.svg)
>
> </details>



## Exporting APIs

Given the respective service definition, we create a pre-built client package for the data API, which can be used from consuming apps in a plug-and-play fashion.

![](_docs/client-packages.drawio.svg)

We use `cds export` to create the API package:

```sh
cds export srv/data-service.cds
```

This generates a separate CAP reuse package within subfolder [_apis/data-service_](./apis/data-service/) that contains only the effective service API definitions, accompanied by automatically derived test data and i18n bundles. 

![](_docs/data-service-api.drawio.svg)

Initially, `cds export` also adds a `package.json`, which we can modify as appropriate, and did so by changing the package name to `@capire/xflights-data`:

```diff
{
- "name": "@capire/xflights-data-service",
+ "name": "@capire/xflights-data",
  ...
}
```



## Publishing APIs

We can finally share this package with consuming applications using standard ways, like `npm publish`:

```sh
cd apis/data-service
npm publish
```


> [!tip]
>
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



## Consuming APIs

Use the published client package in your consuming application by installing it via `npm`:

```sh
npm add @capire/xflights-data
```

With that, we can use the imported models as usual, and as if they were local in mashups with our own entities like so:

```cds
using { sap.capire.flights.data as imported } from '@capire/xflights-data';
entity TravelBookings { //...
  flight : Association to imported.Flights;
}
```

▷ Learn more about consuming APIs and CAP-level data integration in the [_xtravels_ application](https://github.com/capire/xtravels/blob/main/db/master-data.cds).



## License

Copyright (c) 2022 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
