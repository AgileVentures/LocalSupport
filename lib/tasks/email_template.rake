# rake db:email_template

# Later, with more templates, email_template can be a namespace,
# and each template could have separate task

begin
  namespace :db do
    desc 'Create email template for invitation instructions'
    task :email_template => :environment do
      Logger.new(STDOUT).info 'Start email template generation'

      f = File.read('./db/invitation_instructions.txt').split(/\n---\n/)
      MailTemplate.create!(name: f[1], body: f[2], footnote: f[3], email: f[4])

      Logger.new(STDOUT).info 'Email template generation finished'

    end
  end
end