class PeopleControllerTest < ActionController::TestCase

  tests PeopleController

  test "create without dynamic attributes" do
    post :create, person: { name: "Nobody" }

    assert_response :success
    assert Person.find_by(name: 'Nobody').present?
  end

  test "create with declared dynamic attributes" do
    post :create, person: { name: "Nobody", hometown: "Nowhere" }

    assert_response :success
    assert Person.find_by(name: 'Nobody').present?
  end

  test "create with arbitrary dynamic attributes" do
    post :create, person: { name: "Nobody", magic_level: "over 9000" }

    assert_response :success
    assert Person.find_by(name: 'Nobody').present?
  end

  test "create with valid but forbidden attributes fails" do
    post :create, person: { name: "Nobody", father_id: 17 }

    assert_response :bad_request
  end

end

