require "test_helper"

class EventTest < ActiveSupport::TestCase
  # Matchers
  should belong_to(:organization)
  should validate_presence_of(:organization_id)
  should allow_value(Date.current).for(:date)
  should allow_value(Date.tomorrow).for(:date)
  should allow_value(Date.yesterday).for(:date)
  should_not allow_value(2).for(:date)
  should_not allow_value(2.5).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(nil).for(:date)


  # Context
  context "Given context" do
    setup do 
      create_organizations
      create_events
    end

    should "identify a non-active organization as part of an invalid event" do
      inactive_org = FactoryBot.create(:organization, name: "ghost", short_name: "ghost", active: false)
      invalid_event = FactoryBot.build(:event, organization: inactive_org)
      deny invalid_event.valid?
    end

    should "identify a non-existent organization as part of an invalid event" do
      ghost_org = FactoryBot.build(:organization, name: "ghost", short_name: "ghost", active: true)
      invalid_event = FactoryBot.build(:event, organization: ghost_org)
      deny invalid_event.valid?
    end

    #test the method 'make_active'
    should "show that an inactive event becomes active" do
      inactive_event = FactoryBot.build(:event, organization: @acac, active: false)
      inactive_event.make_active
      assert_equal true, inactive_event.active
    end

    #test the method 'make_inactive'
    should "show that an active event becomes inactive" do
      active_event = FactoryBot.build(:event, organization: @millvale, date: Date.current)
      active_event.make_inactive
      assert_equal false, active_event.active
    end

  end
end