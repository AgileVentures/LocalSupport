## Installation

Instructions for installation on different OSs:

* [OSX](installation/osx.md)
* [Linux](installation/linux.md)
* [C9](installation/c9.md)

If you're on Windows, our condolences.  [C9](https://c9.io/) is probably your best option.

We also have some collected notes on [issues encountered during install](installation/issues.md)

[Feature flags](https://github.com/AgileVentures/LocalSupport/wiki/Feature-flags), are automatically activated when you run ```rake db:seed```.

### Google Map Keys

In order for the Google Map to function locally you MAY also need to create an `application.yml` (which does not get checked in) and add the following:

```
GMAP_API_KEY: <YOUR KEY>
```

You can create a google maps key here:

https://developers.google.com/maps/documentation/javascript/get-api-key

Note: for some people the map seems to function fine without the above setting