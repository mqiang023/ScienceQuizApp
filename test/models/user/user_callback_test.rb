require "test_helper"

class UserCallbackTest < ActiveSupport::TestCase
  context "Within context" do
    setup do
      create_organizations
      create_users
    end

  # YOUR CALLBACK TEST CODE HERE

  # test the callback is working 'reformat_phone'
  should "shows that Ben's phone is stripped of non-digits" do
    assert_equal "4122682323", @ben.phone
  end
end
end