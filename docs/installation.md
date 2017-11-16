## Installation

Please start by creating an Application.yml file

### Application.yml

Independently of which platform you are developing on please create a file named `config/application.yml` and add the following line:

```
DOIT_HOST: 'http://api.qa2.do-it.org/v2'
```

### Google Map Keys

In order for the Google Map to function locally you should also need to add the following to `config/application.yml` (which does not get checked in):

```
GMAP_API_KEY: <YOUR KEY>
```

You can create a google maps key here:

https://developers.google.com/maps/documentation/javascript/get-api-key

Note: for some people the map seems to function fine without the above setting

### Platform Specific Instructions

Instructions for installation on different OSs:

* [OSX](installation/osx.md)
* [Linux](installation/linux.md)
* [C9](installation/c9.md)
* [Docker](installation/Developing-With-Docker.md)

If you're on Windows, our condolences. Docker or C9 is probably your best option.

We also have some collected notes on [issues encountered during install](installation/issues.md)

[Feature flags](https://github.com/AgileVentures/LocalSupport/wiki/Feature-flags), are automatically activated when you run ```rake db:seed```.
