# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @me = users(:bob)
    @my_report = reports(:report_by_bob)
    @she = users(:alice)
    @her_report = reports(:report_by_alice)
  end

  test "#editable? returns true when target user == the report's user" do
    assert @my_report.editable?(@me)
  end

  test "#editable? returns false when target user != the report's user" do
    assert_not @her_report.editable?(@me)
  end

  test '#created_on returns Date class' do
    # created_at のままだと Dateクラス ではないことを一応確認
    assert_not_instance_of Date, @my_report.created_at

    assert_instance_of Date, @my_report.created_on
  end
end
