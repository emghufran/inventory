require 'test_helper'

class MailManagersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mail_managers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mail_manager" do
    assert_difference('MailManager.count') do
      post :create, :mail_manager => { }
    end

    assert_redirected_to mail_manager_path(assigns(:mail_manager))
  end

  test "should show mail_manager" do
    get :show, :id => mail_managers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => mail_managers(:one).id
    assert_response :success
  end

  test "should update mail_manager" do
    put :update, :id => mail_managers(:one).id, :mail_manager => { }
    assert_redirected_to mail_manager_path(assigns(:mail_manager))
  end

  test "should destroy mail_manager" do
    assert_difference('MailManager.count', -1) do
      delete :destroy, :id => mail_managers(:one).id
    end

    assert_redirected_to mail_managers_path
  end
end
