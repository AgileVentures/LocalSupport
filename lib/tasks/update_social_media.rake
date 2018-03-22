begin
  desc 'Post new volunteer opportunities to all social media sites'
  task update_social_media: :environment do
    UpdateSocialMedia.new.post_new_volops_from_partner_sites
  end
end
