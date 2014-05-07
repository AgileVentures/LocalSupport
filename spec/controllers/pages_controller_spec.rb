require 'spec_helper'

describe PagesController do
  let(:page) { mock_model Page, id: '2' }

  before { controller.stub(:admin?) { true } }

  describe 'GET index' do
    it 'is restricted' do
      controller.should_receive(:admin?) { false }
      get :index, {}
      response.status.should eq 302
    end

    it 'uses a full-width layout' do
      get :index, {}
      response.should render_template 'layouts/full_width'
    end

    it "assigns the pages in alphabetical order by default" do
      pages = double Array
      Page.should_receive(:order).with('name ASC').and_return pages
      get :index, {}
      assigns(:pages).should eq(pages)
    end
  end

  describe 'GET show' do
    let(:about_page) { double :page,
                              name: 'About Us',
                              permalink: 'about',
                              content: 'blah blah'
    }
    let(:user) { double :user }

    describe 'assigns site admin status of current_user to @admin' do
      it 'NIL when there is no current_user' do
        get :show, {id: 'about'}
        assigns(:admin).should be nil
      end
      it 'FALSE when current_user is NOT admin' do
        user.stub(:admin?) { false }
        controller.stub(:current_user) { user }
        get :show, {id: 'about'}
        assigns(:admin).should be false
      end

      it 'TRUE when current_user is admin' do
        user.stub(:admin?) { true }
        controller.stub(:current_user) { user }
        get :show, {id: 'about'}
        assigns(:admin).should be true
      end
    end

    it 'assigns a persisted page as @page' do
      Page.should_receive(:find_by_permalink!).with('about') { about_page }
      get :show, {id: 'about'}
      assigns(:page).should eq about_page
    end

    before do
      controller.stub(:current_user)
      Page.stub(:find_by_permalink!)
    end

    describe 'assigns site admin status of current_user to @admin' do
      it 'NIL when there is no current_user' do
        get :show, {id: 'about'}
        assigns(:admin).should be nil
      end
      it 'FALSE when current_user is NOT admin' do
        user.stub(:admin?) { false }
        controller.stub(:current_user) { user }
        get :show, {id: 'about'}
        assigns(:admin).should be false
      end

      it 'TRUE when current_user is admin' do
        user.stub(:admin?) { true }
        controller.stub(:current_user) { user }
        get :show, {id: 'about'}
        assigns(:admin).should be true
      end
    end

    it 'assigns a persisted page as @page' do
      Page.should_receive(:find_by_permalink!).with('about') { about_page }
      get :show, {id: 'about'}
      assigns(:page).should eq about_page
    end

    it 'is NOT restricted' do
      controller.should_not_receive(:admin?)
      get :show, {id: 'about'}
      response.status.should eq 200
    end

    it 'uses a full-width layout' do
      get :show, {id: 'about'}
      response.should render_template 'layouts/full_width'
    end
  end

  describe 'GET new' do
    before { Page.stub(:new) }

    it 'assigns a new page as @page' do
      Page.should_receive(:new) { page }
      get :new, {}
      assigns(:page).should eq page
    end

    it 'is restricted' do
      controller.should_receive(:admin?) { false }
      get :new, {}
      response.status.should eq 302
    end

    it 'uses a full-width layout' do
      get :new, {}
      response.should render_template 'layouts/full_width'
    end
  end

  describe 'GET edit' do
    before { Page.stub(:find_by_permalink!) }

    it 'assigns the requested page as @page' do
      Page.should_receive(:find_by_permalink!).with(page.id) { page }
      get :edit, {id: page.id}
      assigns(:page).should eq page
    end

    it 'is restricted' do
      controller.should_receive(:admin?) { false }
      get :edit, {id: page.id}
      response.status.should eq 302
    end

    it 'uses a full-width layout' do
      get :edit, {id: page.id}
      response.should render_template 'layouts/full_width'
    end
  end

  describe 'POST create' do
    let(:attributes) { {name: 'Yoohoo!', permalink: 'yoohoo', content: 'yada yada'} }

    before do
      Page.stub(:new) { page }
      page.stub(:save)
    end

    it 'assigns a newly created page to @page' do
      Page.should_receive(:new).with(attributes.stringify_keys) { page }
      post :create, {page: attributes}
      assigns(:page).should eq page
    end

    it 'if created page is valid, it redirects to show it' do
      page.should_receive(:save) { true }
      post :create, {page: attributes}
      response.should redirect_to page
      flash[:notice].should eq 'Page was successfully created.'
    end

    it 'if created page is INVALID, it re-renders the "new" template' do
      page.should_receive(:save) { false }
      post :create, {page: attributes}
      response.should render_template 'new'
    end

    it 'is restricted' do
      controller.should_receive(:admin?) { false }
      post :create, {page: attributes}
      response.status.should eq 302
    end

    it 'uses a full-width layout' do
      post :create, {page: attributes}
      response.should render_template 'layouts/full_width'
    end
  end

  describe 'PUT update' do
    let(:attributes) { {name: 'Yoohoo!', permalink: 'yoohoo', content: 'yada yada'} }

    before do
      Page.stub(:find_by_permalink!) { page }
      page.stub(:update_attributes)
    end

    it 'assigns the updated page to @page' do
      Page.should_receive(:find_by_permalink!).with(page.id) { page }
      put :update, {id: page.id, page: attributes}
      assigns(:page).should eq page
    end

    it 'if updated page is valid, it redirects to show it' do
      page.should_receive(:update_attributes).with(attributes.stringify_keys) { true }
      put :update, {id: page.id, page: attributes}
      response.should redirect_to page
      flash[:notice].should eq 'Page was successfully updated.'
    end

    it 'if updated page is INVALID, it re-renders the "edit" template' do
      page.should_receive(:update_attributes).with(attributes.stringify_keys) { false }
      put :update, {id: page.id, page: attributes}
      response.should render_template 'edit'
    end

    it 'is restricted' do
      controller.should_receive(:admin?) { false }
      put :update, {id: page.id, page: attributes}
      response.status.should eq 302
    end

    it 'uses a full-width layout' do
      put :update, {id: page.id, page: attributes}
      response.should render_template 'layouts/full_width'
    end
  end
  
  describe 'DELETE destroy' do
    before do
      Page.stub(:find_by_permalink!) { page }
      page.stub(:destroy)
    end

    it 'assigns the page to be destroyed to @page' do
      Page.should_receive(:find_by_permalink!).with(page.id) { page }
      delete :destroy, {id: page.id}
      assigns(:page).should eq page
    end

    it 'destroys the page' do
      page.should_receive(:destroy)
      delete :destroy, {id: page.id}
    end

    it 'redirects to the index of pages' do
      delete :destroy, {id: page.id}
      response.should redirect_to pages_path
    end

    it 'is restricted' do
      controller.should_receive(:admin?) { false }
      delete :destroy, {id: page.id}
      response.status.should eq 302
    end
  end
end
