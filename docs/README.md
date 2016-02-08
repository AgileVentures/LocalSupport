Development Process
------------------

Our default working branch is `develop`.  We do work by creating branches off `develop` for new features and bugfixes.  Each developer will usually work with a [fork of the main repository](https://help.github.com/articles/fork-a-repo/)

Before starting work on a new feature or bugfix, please ensure you have [synced your fork to upstream/develop](https://help.github.com/articles/syncing-a-fork/):

```
git pull upstream/develop
```

Note that you should be re-syncing daily (even hourly at very active times) on your feature/bugfix branch to ensure that you are always building on top of very latest develop code.

We use [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/742821) to manage our work on features, chores and bugfixes, and we have an [integrated Pivotal/GitHub workflow](https://blog.pivotal.io/pivotal-labs/labs/level-up-your-development-workflow-with-github-pivotal-tracker) that requires the following procedures:

Please create feature/bug-fix branches that include the id of the relevant pivotal tracker ticket, e.g.

```
git checkout -b 112900047_make_capybara_wait_for_javascript_element
```

Whatever you are working on, or however far you get please open a "Work in Progress" (WIP) [pull request](https://help.github.com/articles/creating-a-pull-request/) so that others in the team can comment on your approach.  Even if you hate your horrible code :-) please throw it up there; you'll get automated feedback on code style from [hound](https://houndci.com/) and we'll help guide your code to fit in with the rest of the project.

On your final commit please include a comment in this format:

```
makes Capybara check for visibility more robust [Finishes #112900047]
```

which will close the relevant Pivotal Tracker ticket when we merge in your pull-request.


Feature Flags
-------------

We use Feature Flags to allow a feature to be turned off and on at will.  This allows us to deploy the code to production and check for side effects, before we actually make it available to end users.  We can then enable it at a precise time of our choosing (since merges to develop, staging and master are auto-deployed to each of http://develop.harrowcn.org.uk, http://staging.harrowcn.org.uk and http://harrowcn.org.uk), and can also switch the feature off just as easily if problems occur. 

Please ask for advice on whether a feature you are working on requires a feature flag.  If you do set up a new [Feature Flag (or 'toggle')](http://martinfowler.com/bliki/FeatureToggle.html) please ensure to:

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

So that new developers will be set up with the activated features when they first check out a copy of the project and run `rake db:seed`

Notes from original README:

Run "rake doc:app" to generate API documentation for your models, controllers, helpers, and libraries.



