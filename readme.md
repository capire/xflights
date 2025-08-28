# @capire/xflights

The XFlights application manages master data like Airlines, Airports, and Flights.
Client applications can consume this via the `@capire/xflights` package like so:

1. Add the API package

```sh
npm add @capire/xflights
```

<details>
<summary>

  _Requires to login once to [GitHub Packages](https://docs.github.com/packages) like that: (&rarr; click to show)_

</summary>

  ```sh
  npm login --scope=@capire --registry=https://npm.pkg.github.com
  ```

  As password you're using a Personal Access Token (classic) with `read:packages` scope. Read more about it in [Authenticating to GitHub Packages](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry#authenticating-to-github-packages)

</details>


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


## License

Copyright (c) 2022 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
