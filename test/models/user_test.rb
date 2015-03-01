require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name shouldn't be too long" do
    @user.name = 'A' * 100 + ' ' + 'B' * 100
    assert_not(@user.valid?)
  end
  
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email shouldn't be too long" do
    @user.email = 'a' * 300 + '@example.com'
    assert_not @user.valid?
  end

  test "email validation should accept valid email addresses" do
    %w[ abc@foo.com abc.def@foo.com abc123@foo.com abc+def@foo.com 
        abc@foo.bar.com abc@foo.bar.123.com ].each do |email|
      @user.email = email
      assert @user.valid?, "#{email} should be valid"
    end
  end

  test "email validation should not accept invalid email addresses" do
    %w[ abc_at_foo.com abc@foo,com abc@foo abc@foo_bar.com abc@foo+bar.com ].each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should not be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses are compared in a case-insensitive way" do
    duplicate_user = @user.dup
    @user.save
    duplicate_user.email.upcase!
    assert_not duplicate_user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

end
