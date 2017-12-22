Contributing to LocalSupport - Cheat Sheet
==========================================

Be sure to read and understand the [CONTRIBUTING.md](https://github.com/AgileVentures/LocalSupport/blob/develop/CONTRIBUTING.md) file first and use this cheat sheet as a quick reference.

Steps for starting a new feature or bug fix
-------------------------------------------

1) Sync your fork to [upstream/develop](https://help.github.com/articles/syncing-a-fork/)

```bash
git pull upstream develop
```

Re-syncing daily (even hourly at very active times) on the feature/bugfix branch to ensure that you are always building on top of very latest develop code.

2) Create feature/bug-fix branche that includes the id of the relevant pivotal tracker ticket, e.g.

```
git checkout -b 112900047_make_capybara_wait_for_javascript_element
```

3) Ensure that each commit in your pull request makes a single coherent change and that the overall pull request only includes commits related to the specific GitHub issue that the pull request is addressing.

4) Ensure that your **pull request description has a hyperlink to the Pivotal Tracker ticket** that it corresponds to, to allow anyone to quickly jump to a description of the story, bug or chore that the pull-request is addressing.

5) Where possible please do add a couple of sentences explaining the approach taken in the pull request.

6) On the final git commit please include a comment in this format:

```
Makes Capybara check for virility more robust [Finishes #112900047]
```

7) This will close the relevant Pivotal Tracker ticket when the pull-request is merged

8) Run tests below before making a pull request.

Tests
-----

1) Run tests

  ```bash
  bundle exec rake jasmine
  ```

  ```bash
  bundle exec rake spec
  ```

  ```rails
  bundle exec rake cucumber
  ```

2) clean up tests

  ```bash
  rake vcr_billy_caches:reset
  ```
