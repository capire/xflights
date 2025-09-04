# @capire/xflights

This is a reuse package that manages master data like Airlines, Airports, and Flights.
It is used in the [xtravels](https://github.com/capire/xtravels) application.

## Reuse

You can reuse this package by embedding it in your CAP app:

```sh
npm add @capire/xflights
```

<details>
<summary>

   _Using GitHub Packages..._

</summary>

  The samples are published to the [GitHub Packages](https://docs.github.com/packages) registry,
  which requires you to npm login once like that:

  ```sh
  npm login --scope=@capire --registry=https://npm.pkg.github.com
  ```

  As password you're using a Personal Access Token (classic) with `read:packages` scope.
  Read more about it in [Authenticating to GitHub Packages](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-npm-registry#authenticating-to-github-packages)

</details>


## Usage

Then you can import and use the entities in your CDS models like this:

```cds
using { sap.capire.flights.data.Flights } from '@capire/xflights';
// mashup with your own entities ...
```

## Using Github Packages

You can also use this package from the GitHub Package Registry. To do this, you need to authenticate with GitHub Packages and then install the package using npm:

```sh
npm install @capire/xflights --registry=https://npm.pkg.github.com
```

## License

Copyright (c) 2022 SAP SE or an SAP affiliate company. All rights reserved. This file is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
