Development Process
------------------

Before starting work on a new feature, please ensure you have synced to upstream/develop and do so each time you restart work:

```
git pull upstream/develop
```

Please create feature/bug-fix branches that include the id of the relevant pivotal tracker ticket, e.g.

```
git checkout -b 112900047_make_capybara_wait_for_javascript_element
```

Whatever you are working on, or however far you get please leave a "Work in Progress" (WIP) pull request so that others in the team can comment on your approach.

On your final commit please include a comment in this format:

```
makes Capybara check for visibility more robust [Finishes #112900047]
```

which will close the relevant Pivotal Tracker ticket when the pull-request is merged.


Feature Flags
-------------

When setting up a new [Feature Flag (or 'toggle')](http://martinfowler.com/bliki/FeatureToggle.html) please ensure to:

1. Add a migration to place that feature flag in the database, e.g.

```
class AddSearchInputBarOnOrgPages < ActiveRecord::Migration
  def up
    Feature.create(name: :search_input_bar_on_org_pages)
  end

  def down
    Feature.find_by(name: :search_input_bar_on_org_pages).destroy
  end
end
```

2. Activate the feature in `db/seeds.rb` file like so:

```
Feature.activate('search_input_bar_on_org_pages')
```

Notes from original README:

Run "rake doc:app" to generate API documentation for your models, controllers, helpers, and libraries.



