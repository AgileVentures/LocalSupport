require 'rails_helper'

describe 'UserReports', :type => :request, :helpers => :requests do
  let(:nonsuperadmin){FactoryGirl.create :user, :email => "nonsuperadmin@nonsuperadmin.com", :superadmin => false}
  let(:deleted_user){usr = FactoryGirl.create :user , :email => 'regularjoe@blah.com'; usr.destroy; usr}

  describe 'PUT /user_reports/undo_delete/:id' do
    it 'nonsuperadmin unable to undo delete' do
      login(nonsuperadmin)
      expect {
        put undo_delete_users_report_path(deleted_user.id)
      }.to change(User, :count).by(0)
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include I18n.t('authorize.superadmin')
    end
  end

  describe 'GET /user_reports/deleted' do
    it 'nonsuperadmin unable to see deleted users' do
      login(nonsuperadmin)
      get deleted_users_report_path
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include I18n.t('authorize.superadmin')
    end
  end
end
