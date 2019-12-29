# lib/tasks/my_task.rake

task :gomisa_task => :environment do
    @service = Gomisa::Zoho::MigrationService.new
    @service.call
end
