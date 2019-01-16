CRDS Contentful Migrations
==========

This repo contains Contentful schema migrations for Crossroads. It's built on top of [contentful-migrations.rb](https://github.com/monkseal/contentful-migrations.rb) which provides Rake tasks for managing content models via the [Contentful Management API](https://www.contentful.com/developers/docs/references/content-management-api/).

Usage
----------

First, ensure the following environment variables should be set with the appropriate values:

- `CONTENTFUL_MANAGEMENT_ACCESS_TOKEN`: A [content management token](https://www.contentful.com/developers/docs/references/authentication/#the-content-management-api) from Contentful. This is specific to your user and can only be retrieved from Contentful once.
- `CONTENTFUL_SPACE_ID`: The ID of the space for which you want to run the migrations.
- `CONTENTFUL_ENV`: The environment of the space for which you want to run the migrations. This defaults to `master` if it isn't set.
- `MIGRATION_PATH`: The path to the directory containing the migrations. The value should be `migrations` for this project.

All tasks can be accessed from the command line using Rake.

To create a new (blank) migration, where `name_of_migration` is the name of your migration:

    $ bundle exec rake contentful_migrations:new name_of_migration

To see which migrations are pending:

    $ bundle exec rake contentful_migrations:pending

To run all pending migrations:

    $ bundle exec rake contentful_migrations:migrate

To rollback migrations one at a time:

    $ bundle exec rake contentful_migrations:rollback

To seed the database with test data:

    $ bundle exec rake seed_data

Migrations
----------

The migrations are built on top of [contentful-migrations.rb](https://github.com/monkseal/contentful-migrations.rb). Refer to [its API docs](https://github.com/monkseal/contentful-migrations.rb#migration-api) for information on setting up and writing migrations.

Note that contentful-migrations.rb is built on top of [contentful-management.rb](https://github.com/contentful/contentful-management.rb). This means that once you are inside a `with_space` or `with_editor_interfaces` block, the syntax and methods available are derived primarily from contentful-management.rb. Refer to [the library's README](https://github.com/contentful/contentful-management.rb#usage) for its API docs.

This library adds a few extra features on top of contentful-migrations.rb, documented below.

### Revertible Migrations

If you are creating a new content model with your migration, you can make use of the `RevertibleMigration` class. A revertible migration automatically provides a `down` method to delete the content type when the migration is rolled back.

Newly generated migrations inherit from `ContentfulMigrations::Migration` (from contentful-migrations.rb) by default. If you want a revertible migration, your migration must inherit from `RevertibleMigration`. And it must specify `content_type_id` as the ID of the content type you are creating.

Here is a simple example that creates a `Post` content type with a single `title` field:

```rb
class CreatePost < RevertableMigration

  self.content_type_id = 'post'

  def up
    with_space do |space|
      content_type = space.content_types.create(name: 'Post', id: content_type_id)
      content_type.fields.create(id: 'title', name: 'Title', type: 'Symbol', required: true)
      content_type.save
      content_type.publish
    end
  end
end
```

### Custom Validations

Supported custom validations are:

- `items_of_type`
- `require_mime_type`
- `uniqueness_of`
- `validation_of_type`

When you want to add one of these validations you must either inherit from `RevertibleMigration` (see above) or include `MigrationUtils` within your migration.

#### `items_of_type`

When an entry should link to an array of other entries, you can lock down the type of entries allowed by adding this validation. For example, let's say we have a content type store in a `content_type` variable and we want to add a `meta` field that can add either `tag` or `category` types of entries. That might look like this:

```rb
content_type.fields.create(id: 'meta', name: 'Meta', type: 'Array', items: items_of_type('Entry', 'tag', 'category'))
```

#### `require_mime_type`

Asset fields can lock down the required MIME type. Here's an example:

```rb
content_type.fields.create(id: 'video', name: 'Video File', type: 'Link', link_type: 'Asset', validations: [require_mime_type(:video)])
```

#### `uniqueness_of`

If the field should be unique among entries in the content type, there's a shorthand method for achieving this. Consider a case where a `slug` field should be unique:

```rb
content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', validations: [uniqueness_of])
```

#### `validation_of_type`

When an entry links to a single entry (not to an array) we can specify which type it should be. Using the example from above (with the `meta` field), but only allowing a `tag` content type, we may have something like this:

```rb
content_type.fields.create(id: 'meta', name: 'Meta', type: 'Link', link_type: 'Entry', validations: [validation_of_type('tag')])
```

### Adding Slugs

If you want to add a slug, you have to initialize the editor after first adding the field and saving the content type. Then, typically it's a good idea to save the content type again after applying the editor, since it is a change to the model. Here's an example:

```rb
content_type.fields.create(id: 'slug', name: 'Slug', type: 'Symbol', required: true, validations: [uniqueness_of])
# ...
content_type.save
content_type.publish
apply_editor(space, 'slug', 'slugEditor')
content_type.save
content_type.publish
```

Data Seeds
----------

In addition to running schema migrations, this library also supports seeding the Contentful database with test data. This enables QA engineers to automatically populate the database with repeatable test cases when environments are created from the `master` environment.

Seeds are sowed in the `data` directory prior to being harvested into Contentful. Each seed should be its own markdown file with a `.md` file extension and a unique filename.

Seed file consist of two parts:

1. Frontmatter
2. Body content

Frontmatter belongs at the top of the file and is contained within three hyphens, and follows the [YAML](https://yaml.org/) syntax. **Frontmatter is required.**

Body content falls two lines below the YAML frontmatter and should be written as [markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet). Body content is optional.

Here is the simplest of examples. (See below for usage docs.)

```markdown
---
_content_type: article
title: Hello World
---

This is the body content
```

This would create (and _attempt_ to publish) an article with "Hello World" as the title. More information follows on frontmatter usage.

### Frontmatter

The frontmatter in seeds represents the meta data and fields to associate with the entry when it is created in Contentful.

#### Meta Data

All meta data begin with an underscore. If a frontmatter key does not begin with an underscore, it is considered a field (see below). There are two meta fields available:

- `_content_type`: The ID of the content type for the entry that should be created. **This is required** of every seed.
- `_body_field`: If you are including body content in the seed and the field for which the body should be saved **is not called `body`**, then you should include this option, which maps the seed's body content to a field on the model. For example:

    ```markdown
    ---
    _content_type: article
    _body_field: description
    title: Hello World
    ---

    This content would be mapped to the `description` field, not the `body` field.
    ```

#### Fields

All other fields (all fields that don't begin with an underscore) are mapped directly to fields in Contentful. For example, this would create an article with `Hello World` as the `title` and `hello-world` as the `slug`:

```markdown
---
_content_type: article
title: Hello World
slug: hello-world
---
```

#### Linking Entries and Assets

In Contentful, some fields can act as a link or array of links to either entries or assets. Consider an example in which an article has many tags. A tag is a content type containing multiple entries that can be linked to an article entry.

The seeder is intelligent enough to know when a field is a link (or array of links). All it requires is that you reference the ID of the linked item.

When creating environments in Contentful off the `master` environment, the other environments begin as an exact clone, down to each entry's and asset's `id` value. Therefore, we can maintain these seeds over time without needing to change the `id` value, because as long as that value exists in the `master` environment, it will be available in other cloned environments (assuming it was created _before_ the environment was clone and that it hasn't since been deleted).

Let's look at an example. Consider that we have an article we want to seed with two linked fields:

1. `image`: An asset link.
2. `tags`: An array of linked entries.

For `image`, we'll pass the `id` value of the image we want to attach, and for `tags` we'll do the same, but as a YAML array. The resulting frontmatter will look something like this:

```yaml
_content_type: article
title: Hello World
image: 4Zxm0bwR9eWSiuw442WAqS
tags:
  - luZPICyHVQUYQYSAa6Imu
  - 1JWjoImLpWAeWMCWI2WOaM
  - 31xMlxGaBWKw0aYK2ESgQA
```

License
----------

This project is licensed under the [3-Clause BSD License](https://opensource.org/licenses/BSD-3-Clause).
