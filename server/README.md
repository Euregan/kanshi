# Root server source folder

## Setting up

Start by installing the npm dependencies

```shell
npm install
```

Then start the watcher to run the server and reload it on any code change

```shell
npm run watch
```

## Files

This folder contains the basic modules used by the API to work.

### ` index.js`

The entry point of the app. It handles the instantiation of impure modules (found in `sideEffects`), and starts the express server. It exposes a function to allow a more flexible setup when distributing.

### `api.js`

The API in itself, listing the routes, and forwarding the parameters to the correct module.

### `providers.js`

Returns a simple factory to instantiate data providers.

### `fetcher.js`

Handles the standalones and packages information data fetching through the providers.

### `dev.js`

A simple wrapper around `index.js` to make it work in a development environment.
