# Root source folder

## Setting up

To set up the project, first run npm to install elm

```shell
npm install
```

Then run elm to install the dependencies

```shell
npx elm install
```

Once that's done, you can either run the build manually

```shell
npm run build:dev
```

Or start a watcher

```shell
npm run watch
```

Once you have some built files, run the server to access the site

```shell
npm run serve
```

## Files

### Main

This is where the whole app is bootstrapped. It contains every standard part of an Elm app:

#### The model - `Model`

The model holds every basic piece of information necessary to run the app.

#### The message - `Msg`

The messages of every action of the app. Since everything is handled here, there is no mapping to the pages' sub actions.

#### The view - `view`

This is the function that computes a view for a given model. It basically calls the ` view` function of the page on display, and wraps its return in the site scaffold.

#### The initialization - `init`

This is the function called when the application starts. It initializes the model, and calls the api to get the standalones and packages information. It also starts a timed callback ticking every second.

#### The update - `update`

The update function is called every time a message is sent in the application. It handles the update of the application model.

### Page

This is a module listing every page of the site, also providing `layout`, a function used to build the site skeleton.

### Route

This module is responsible for listing, parsing and creating links to every route of the site.
