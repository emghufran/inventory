require 'test_helper'

class BunkersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bunkers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bunker" do
    assert_difference('Bunker.count') do
      post :create, :bunker => { }
    end

    assert_redirected_to bunker_path(assigns(:bunker))
  end

  test "should show bunker" do
    get :show, :id => bunkers(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => bunkers(:one).id
    assert_response :success
  end

  test "should update bunker" do
    put :update, :id => bunkers(:one).id, :bunker => { }
    assert_redirected_to bunker_path(assigns(:bunker))
  end

  test "should destroy bunker" do
    assert_difference('Bunker.count', -1) do
      delete :destroy, :id => bunkers(:one).id
    end

    assert_redirected_to bunkers_path
  end
end
