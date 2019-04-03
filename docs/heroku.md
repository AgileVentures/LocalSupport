Installing on Heroku
--------------------

Assuming you have checked out the code locally you can cd into that directory and then use the following commands:

```sh
$ heroku create <YOUR_HEROKU_APP_NAME_HERE>
$ heroku config:set DEVISE_SECRET_KEY=1234
$ heroku buildpacks:add heroku/nodejs 
$ heroku buildpacks:add heroku/ruby 
$ git push heroku develop:master
$ heroku run rails db:migrate
$ heroku restart
```

If you want to generate a secure secret key you can use the SecureRandom.hex function in irb:

```sh
$ irb
2.5.3 :001 > require 'securerandom'
 => true 
2.5.3 :002 > SecureRandom.hex(16)
 => "55c2b898f77af547af33eb2f5665a2ab" 
2.5.3 :003 > 
```

see https://stackoverflow.com/a/5967114/316729 for more details

To get the maps working we need to get a Google maps API KEY, by creating a project at https://console.cloud.google.com, creating an API key and then enabling the JavaScript API key.




