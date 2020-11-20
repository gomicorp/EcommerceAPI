namespace :db do
  namespace :seed do
    Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |seed_file|
      task_name = File.basename(seed_file, '.rb')
      desc "Seed " + task_name + ", based on the file with the same name in `db/seeds/*.rb`"
      task task_name.to_sym => :environment do
        load(seed_file) if File.exist?(seed_file)
      end
    end
  end
end