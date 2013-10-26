require 'test_helper'

class DanceTrainingRegistrationsControllerTest < ActionController::TestCase
  setup do
    @dance_training_registration = dance_training_registrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dance_training_registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dance_training_registration" do
    assert_difference('DanceTrainingRegistration.count') do
      post :create, dance_training_registration: { amount: @dance_training_registration.amount, email: @dance_training_registration.email, first_name: @dance_training_registration.first_name, last_name: @dance_training_registration.last_name }
    end

    assert_redirected_to dance_training_registration_path(assigns(:dance_training_registration))
  end

  test "should show dance_training_registration" do
    get :show, id: @dance_training_registration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dance_training_registration
    assert_response :success
  end

  test "should update dance_training_registration" do
    put :update, id: @dance_training_registration, dance_training_registration: { amount: @dance_training_registration.amount, email: @dance_training_registration.email, first_name: @dance_training_registration.first_name, last_name: @dance_training_registration.last_name }
    assert_redirected_to dance_training_registration_path(assigns(:dance_training_registration))
  end

  test "should destroy dance_training_registration" do
    assert_difference('DanceTrainingRegistration.count', -1) do
      delete :destroy, id: @dance_training_registration
    end

    assert_redirected_to dance_training_registrations_path
  end
end
