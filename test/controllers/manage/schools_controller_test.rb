require 'test_helper'

class Manage::SchoolsControllerTest < ActionController::TestCase

  setup do
    @school = create(:school)
  end

  context "while not authenticated" do
    should "redirect to sign in page on manage_schools#index" do
      get :index
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools datatables api" do
      post :datatable, format: :json
      assert_response 401
    end

    should "not allow access to manage_schools#show" do
      get :show, id: @school
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#new" do
      get :new, id: @school
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#edit" do
      get :edit, id: @school
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#create" do
      post :create, school: { name: "My Test School" }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#update" do
      patch :update, id: @school, school: { name: "My Test School" }
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end

    should "not allow access to manage_schools#destroy" do
      patch :destroy, id: @school
      assert_response :redirect
      assert_redirected_to new_user_session_path
    end
  end

  context "while authenticated as a user" do
    setup do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create(:user)
      sign_in @user
    end

    should "not allow access to manage_schools#index" do
      get :index
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools datatables api" do
      post :datatable, format: :json
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#new" do
      get :new, id: @school
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#show" do
      get :show, id: @school
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#edit" do
      get :edit, id: @school
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#create" do
      post :create, school: { name: "My Test School" }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#update" do
      patch :update, id: @school, school: { name: "My Test School" }
      assert_response :redirect
      assert_redirected_to root_path
    end

    should "not allow access to manage_schools#destroy" do
      patch :destroy, id: @school
      assert_response :redirect
      assert_redirected_to root_path
    end
  end

  context "while authenticated as a limited access admin" do
    setup do
      @user = create(:limited_access_admin)
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in @user
    end

    should "allow access to manage_schools#index" do
      get :index
      assert_response :success
    end

    should "allow access to manage_schools datatables api" do
      post :datatable, format: :json
      assert_response :success
    end

    should "allow access to manage_schools#show" do
      get :show, id: @school
      assert_response :success
    end

    should "not allow access to manage_schools#new" do
      get :new
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#edit" do
      get :edit, id: @school
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#create" do
      post :create, school: { name: "My Test School" }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#update" do
      patch :update, id: @school, school: { name: "My Test School" }
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end

    should "not allow access to manage_schools#destroy" do
      patch :destroy, id: @school
      assert_response :redirect
      assert_redirected_to manage_schools_path
    end
  end

  context "while authenticated as an admin" do
    setup do
      @user = create(:admin)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
    end

    should "allow access to manage_schools#index" do
      get :index
      assert_response :success
    end

    should "not create an school with duplicate names" do
      create(:school, name: "Existing School")
      assert_difference('School.count', 0) do
        post :create, school: { name: "Existing School" }
      end
    end

    should "not allow access to manage_schools#new" do
      get :new, id: @school
      assert_response :success
    end

    should "allow access to manage_schools#show" do
      get :show, id: @school
      assert_response :success
    end

    should "allow access to manage_schools#edit" do
      get :edit, id: @school
      assert_response :success
    end

    should "update school" do
      patch :update, id: @school, school: { name: "New school name" }
      assert_redirected_to manage_schools_path
    end

    should "destroy school" do
      assert_difference('School.count', -1) do
        patch :destroy, id: @school
      end
      assert_redirected_to manage_schools_path
    end
  end
end
