require 'seeder'

desc 'Seed Contentful with test data'
task :seed_data do
  Seeder.seed!
end
