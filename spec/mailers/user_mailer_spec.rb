require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }
  describe "#account_activation" do
    before do
      @mail = UserMailer.account_activation(user)
    end
    context 'when send_mail' do
      it { expect(@mail.to).to eq [user.email] }
      it { expect(@mail.subject).to eq 'Account activation' }
    end
  end

  # describe "#password_reset" do
  #   before do
  #      @mail = UserMailer.password_reset(user)
  #   end
  #   context 'when send_mail' do
  #     user.reset_token = User.new_token
  #     it {expect(@mail.to).to eq [user.email]}
  #     it { expect(@mail.subject).to eq 'Password reset' }
  #   end
  # end

end
