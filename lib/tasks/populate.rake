require 'ffaker'
namespace :populate do
  desc 'Create admin user'
  task admin: :environment do
    AdminUser.create(email: 'admin@eldebate.com', password: 'supersecret1')
  end

  desc 'Create random debates'
  task debates: :environment do
    3.times do
      DebateMaker.call(topic: FFaker::HipsterIpsum.sentence.tr(?., ??))
    end
  end
end
