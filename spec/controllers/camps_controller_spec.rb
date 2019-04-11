require 'rails_helper'
require 'faker'
I18n.reload!

describe CampsController do
  let(:email) { Faker::Internet.email }
  let(:user) { User.create! email: email, password: Faker::Internet.password, ticket_id: '6687' }
  let(:camp_leader) { Faker::Name.name }

  let(:camp_attributes){
    {
        name: 'Burn something',
        subtitle: 'Subtitle',
        description: 'We will build something and then burn it',
        electricity: 'Big enough for a big fire',
        light: 'There sill be need of good ventilation',
        fire: '2 to build and 3 to burn',
        noise: 'The fire consumes everything',
        nature: 'Well - it will burn....',
        budgetplan: '50 bucks',
        water: 'one bucket',
        neighbors: 'will be invited over for snacks',
        contact_email: 'burn@example.com',
        contact_name: camp_leader,
        minbudget: 100,
        minbudget_realcurrency: 100,
        maxbudget: 1000,
        maxbudget_realcurrency: 1000
    }
  }

  describe "camp creation" do
    before do
      sign_in user
    end

    it 'got a form' do
      get :new

      expect(response).to have_http_status(:success)
    end

    it 'creates a camp' do
      post :create, camp: camp_attributes
      c = Camp.find_by_contact_name camp_leader

      expect( c.name ).to eq 'Burn something'
    end
  end

  context 'update permissions' do
    let!(:camp) { Camp.create!(camp_attributes.merge(creator: user)) }

    shared_examples_for 'should fail' do
      it 'should not succeed updating' do
        post :update, camp: camp_attributes, id: camp.id

        expect(flash[:alert]).to_not be_nil
      end
    end

    shared_examples_for 'should succeed' do
      it 'should succeed updating' do
        post :update, camp: camp_attributes, id: camp.id

        expect(flash[:alert]).to be_nil
        expect(flash[:notice]).to be_nil
      end
    end

    describe 'not logged in' do
      it_behaves_like 'should fail'
    end

    context 'logged in' do
      let(:guide) { false }
      let(:admin) { false }
      let(:current_user) {
        User.create!(email: 'mr@robot.me', password: 'badpassword', guide: guide, admin: admin)
      }

      before :each do
        sign_in current_user
      end

      context 'another user' do
        it_behaves_like 'should fail'
      end

      context 'dream owner' do
        let(:current_user) { user }
        it_behaves_like 'should succeed'
      end

      context 'guide' do
        let(:guide) { true }
        it_behaves_like 'should succeed'
      end

      context 'admin' do
        let(:admin) { true }
        it_behaves_like 'should succeed'
      end
    end
  end

  describe "PATCH #update_grants" do
    let!(:camp) { Camp.create!(camp_attributes.merge(
      creator: user
    )) }
    let(:action) { put :update_grants,  id: camp.id, grants: grants }

    before do
      sign_in user
    end

    context "all is good" do
      let(:grants) { 1 }

      it 'creates a new grant' do
        expect { action }.to change(Grant, :count).by(1)
      end
    end

    context "too many grants" do
      describe "vote with 6 grants" do
        let(:grants) { 6 }

        it 'does not create a new grant' do
          action
          expect { action }.to change(Grant, :count).by(0)
        end

        it 'sets the flash' do
          action
          expect(flash[:alert]).not_to be_empty
        end
      end

      describe "vote with 1 grant but 5 have already been submitted" do
        let(:grants) { 1 }

        before do
          camp.grants.new({user_id: user.id, amount: 5}).save!
        end

        it 'does not create a new grant' do
          action
          expect { action }.to change(Grant, :count).by(0)
        end

        it 'sets the flash' do
          action
          expect(flash[:alert]).not_to be_empty
        end
      end
    end
  end
end
