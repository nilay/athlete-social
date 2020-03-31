require "rails_helper"

RSpec.describe CmsAdmin, type: :model do
  it_behaves_like "uniqueable"
  it_behaves_like "avatarable"
  it_behaves_like "inviter"

  it "should not select anyone's account who is not opted in " do
    vernon = create :cms_admin, opt_in_to_emails: false
    not_vernon = create :cms_admin, opt_in_to_emails: true
    cms_admins = CmsAdmin.email_opted
    expect(cms_admins).not_to include(vernon)
  end
end
