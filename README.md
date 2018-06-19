CRDS Contentful Migrations
==========

This repo contains Contentful schema migrations for Crossroads. It's built on top of [contentful-migrations.rb](https://github.com/monkseal/contentful-migrations.rb/blob/master/README.md) which provides Rake tasks for managing content-models via the Contentful API.

Usage
----------

Export the following environment variables with values for your space...

```
CONTENTFUL_MANAGEMENT_ACCESS_TOKEN= # Contentful Access token to you management API
CONTENTFUL_SPACE_ID= # Contentful SpaceID value
MIGRATION_PATH=migrations
```

Run migrations with the following:

```
bundle exec rake contentful_migrations:migrate
```

Rollback migrations one at a time, with the following:

```
bundle exec rake contentful_migrations:rollback
```

See what migrations are pending, with the following:

```
bundle exec rake contentful_migrations:pending
```

License
----------

This project is licensed under the [3-Clause BSD License](https://opensource.org/licenses/BSD-3-Clause).
