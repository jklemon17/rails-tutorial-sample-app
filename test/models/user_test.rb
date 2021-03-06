require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user= User.new(name: "Example User", email: "example@about.com",
                    password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-er@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com USER_at_foo.COM A_US-er@foo.
      first.last@foo_jp.com alice+bob@bar+baz.cn foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@eXample.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal @user.reload.email, mixed_case_email.downcase
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be at least 6 characters" do
    @user.password = @user_password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for user with nil remember digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "deleting user should delete associated microposts" do
    @user.save
    @user.microposts.create!(content: "Something")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow another user" do
    kyle = users(:kyle)
    archer = users(:archer)
    assert_not kyle.following?(archer)
    assert_not archer.followed_by?(kyle)
    kyle.follow(archer)
    assert kyle.following?(archer)
    assert archer.followed_by?(kyle)
    kyle.unfollow(archer)
    assert_not kyle.following?(archer)
    assert_not archer.followed_by?(kyle)
  end

  test "feed should have the right posts" do
    kyle = users(:kyle)
    lana = users(:lana)
    archer = users(:archer)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert kyle.feed.include?(post_following)
    end
    # Posts from self
    kyle.microposts.each do |post_self|
      assert kyle.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.microposts.each do |post_unfollowed|
      assert_not kyle.feed.include?(post_unfollowed)
    end
  end
end
