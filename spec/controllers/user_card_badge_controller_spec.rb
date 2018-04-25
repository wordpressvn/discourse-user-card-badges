require 'rails_helper'

describe UserCardBadges::UserCardBadgeController do

  routes { UserCardBadges::Engine.routes }

  describe "update" do
    let(:user) { Fabricate(:user) }
    let(:badge) { Fabricate(:badge) }
    let(:user_badge) { BadgeGranter.grant(badge, user) }

    it "sets the user's card image to the badge" do
      log_in_user user
      put :update, params: {
        user_badge_id: user_badge.id, username: user.username
      }, format: :json

      expect(user.reload.custom_fields['card_image_badge_id']).to be_blank

      badge.update_attributes image: "wat.com/wat.jpg"

      put :update, params: {
        user_badge_id: user_badge.id, username: user.username
      }, format: :json

      expect(user.reload.custom_fields['card_image_badge_id'].to_i).to eq(badge.id)

      # Can set to nothing
      put :update, params: {
        username: user.username
      }, format: :json

      expect(user.reload.custom_fields['card_image_badge_id']).to be_blank
    end
  end
end