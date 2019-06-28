# == Schema Information
#
# Table name: mail_templates
#
#  id         :integer          not null, primary key
#  body       :text
#  email      :string
#  footnote   :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MailTemplate < ApplicationRecord

  
end
