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

    # 1. If PR, create ENV and run all migrations
    # 2. If push to PR, create ENV (if it doesnt exist already) and run all migrations
    # 3. If push to primary ENV branch, run all migrations

    # -----

    if ENV['TRAVIS_PULL_REQUEST'] != 'false'
      env = Environments.new.create!(ENV['TRAVIS_PULL_REQUEST_BRANCH'])
      if env
        ContentfulMigrations::Migrator.migrate(env_id: env)
        Environments.new.destroy!(ENV['TRAVIS_PULL_REQUEST_BRANCH'])
      end
    elsif %w(development release master).include?(ENV['TRAVIS_BRANCH'])
      branch_name = ENV['TRAVIS_BRANCH']
      branches = { development: 'int', release: 'demo', master: 'master' }
      ContentfulMigrations::Migrator.migrate(env_id: branches[branch_name])
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