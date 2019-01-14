require 'contentful_migrations'
require 'environments'
namespace :contentful_migrations do

  task :ci do
    if ENV['TRAVIS_DEBUG']
      puts "Travis Branch: #{ENV['TRAVIS_BRANCH']}"
      puts "Pull Request: #{ENV['TRAVIS_PULL_REQUEST']}"
      puts "Pull Request Branch: #{ENV['TRAVIS_PULL_REQUEST_BRANCH']}"
      puts "Commit: #{ENV['TRAVIS_COMMIT']}"
      puts "Range: #{ENV['TRAVIS_COMMIT_RANGE']}"
      puts "PR SHA: #{ENV['TRAVIS_PULL_REQUEST_SHA']}"
      puts "Message: #{ENV['TRAVIS_COMMIT_MESSAGE']}"
    end

    # -----

    is_pr = (ENV['TRAVIS_PULL_REQUEST'] != 'false')
    regex = /^Merge\spull\srequest\s#[0-9]+\sfrom\scrdschurch\/([a-zA-Z0-9\-\/]+)$/
    matches = ENV['TRAVIS_COMMIT_MESSAGE'].match(regex) rescue nil

    # If this build results from push who's
    # commit message looks like a merged PR destroy the
    # environment who's ID matches the previously merged branch.
    if !is_pr && matches
      branch_name = matches[1]
      Environments.new.destroy!(branch_name)

    # If this build is tied to a PR, create a new
    # ENV based on the name of this branch and run
    # any pending migrations.
    elsif is_pr && !%w(development release master).include?(ENV['TRAVIS_BRANCH'])
      env = Environments.new.create!(ENV['TRAVIS_BRANCH'])
      if env
        ContentfulMigrations::Migrator.migrate(env_id: env)
      end

    # If this build is tied to an actual environment,
    # run any pending migrations.
    elsif !is_pr && %w(development release master).include?(ENV['TRAVIS_BRANCH'])
      ContentfulMigrations::Migrator.migrate(env_id: ENV['TRAVIS_BRANCH'])
    end
  end

  namespace :env do
    desc 'Create a new Contentful environment'
    task :create, [:id] do |_t, _args|
      if env = _args['id']
        Environments.new.create!(env)
      end
    end

    desc 'Destroy a Contentful environment'
    task :destroy, [:id] do |_t, _args|
      if env = _args['id']
        Environments.new.destroy!(env)
      end
    end

    desc 'List all Contentful environments'
    task :ls do |_t, _args|
      Environments.new.ls
    end
  end

  desc 'Migrate the contentful space, runs all pending migrations'
  task :migrate, [:contentful_space]  do |_t, _args|
    ContentfulMigrations::Migrator.migrate
  end

  desc 'Rollback previous contentful migration'
  task :rollback, [:contentful_space] do |_t, _args|
    ContentfulMigrations::Migrator.rollback
  end

  desc 'List any pending contentful migrations'
  task :pending, [:contentful_space]  do |_t, _args|
    ContentfulMigrations::Migrator.pending
  end
end