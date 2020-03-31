require "rails_helper"

RSpec.describe "reset password", type: :feature do
  it "works for the happy path" do
    user = create(:cms_admin)

    visit "/admin/passwords"
    fill_in "password_reset_email", with: user.email
    click_on("change password")
    expect(page).to have_content("Password reset!")

    token = REDIS.scan(0).last.first.split(":").last
    visit "/admin/passwords/#{token}"
    expect(page).to have_content("Choose a new password")

    fill_in "password_reset_password", with: "test456"
    fill_in "password_reset_password_confirmation", with: "test456"
    click_on "change password"
    expect(page).to have_content("new password")

    visit "/admin/sign-in"
    fill_in "session_username", with: user.email
    fill_in "session_password", with: "test456"
    click_on "sign in"
    expect(page).to have_content("Welcome, #{user.first_name}")
  end

  it "prompts the user again if the passwords don't match" do
    user = create(:cms_admin)

    visit "/admin/passwords"
    fill_in "password_reset_email", with: user.email
    click_on("change password")

    token = REDIS.scan(0).last.first.split(":").last
    visit "/admin/passwords/#{token}"

    fill_in "password_reset_password", with: "test123"
    fill_in "password_reset_password_confirmation", with: "test456"
    click_on "change password"
    expect(page).to have_content("Password does not match the confirmation password")
  end

  it "redirects to admin sign in if the token is wrong" do
    visit "/admin/passwords/abc123def456"
    expect(page.current_path).to eq("/admin/sign-in")
  end
end
