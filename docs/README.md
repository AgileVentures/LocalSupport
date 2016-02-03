Feature Flags
-------------

When setting up a new feature following steps should be taken

1. Feature is activated in db/seeds.sb file

    for example if the new feature is called 'New Feature' then this can be activated by adding a line in db/seeds.rb as below
    
    Feature.activate('New Feature')

2.  A migration script for that feature should be created


For further ducumentation please refer to http://martinfowler.com/bliki/FeatureToggle.html



