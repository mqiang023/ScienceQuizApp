require "test_helper"

class UserTest < ActiveSupport::TestCase
  #Contexts
  context "Given context" do
    setup do 
      create_organizations
      create_users
    end

  # YOUR METHOD TEST CODE HERE
  should "have role methods and recognize all roles" do
    assert @alex.role?(:admin)
    deny @alex.role?(:leader)
    assert @ralph.role?(:leader)
    deny @ralph.role?(:admin)
  end

  should "have 'name' methods for users" do
    assert_equal "Chuck Wilson", @chuck.proper_name
    assert_equal "Crawford, Cindy", @cindy.name
  end

  #test the method 'make_active'
  should "show that an inactive event becomes active" do
    inactive_user = FactoryBot.build(:user, organization: @acac, username: 'bongo', active: false)
    inactive_user.make_active
    assert_equal true, inactive_user.active
  end

  #test the method 'make_inactive'
  should "show that an active event becomes inactive" do
    active_user = FactoryBot.build(:user, organization: @millvale, username: 'maracas')
    active_user.make_inactive
    assert_equal false, active_user.active
  end

end
end