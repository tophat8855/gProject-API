require 'rails_helper'

describe User do
  after(:each) do
    User.delete_all
  end
  describe 'users are CRUDded in database' do
    it 'creates and saves a leg' do
      user = User.new(
        :user_name => 'fake',
        :email => 'fake@fake.com',
        :password => '1234',
      )
      user.save
      total = User.all.count

      expect(total).to eq(1)
    end

    it 'deletes a user' do
      user = User.new(
        :user_name => 'fake',
        :email => 'fake@fake.com',
        :password => '1234',
      )
      user.save
      user.delete
      total = User.all.count
      puts User.all

      expect(total).to eq(0)
    end

    it 'edits a user' do
      user = User.new(
        :user_name => 'fake',
        :email => 'fake@fake.com',
        :password => '1234',
      )
      user.save
      user.email = 'jane@doe.com'
      user.password = '5678'
      user.save

      expect(user.user_name).to eq('fake')
      expect(user.email).to eq('jane@doe.com')
      expect(user.password).to eq('5678')
    end
  end

  describe 'validations are in place for user' do
    it 'does not save a blank user' do
      user = User.create
      puts User.all
      expect(User.all.count).to eq(0)
    end

    it 'requires a user to have an email' do
      user = User.create(
        :user_name => 'fake',
        :password => '1234',
      )
      expect(User.all.count).to eq(0)
    end

    it 'requires emails to be unique' do
      user1 = User.create(
        :user_name => 'fake1',
        :email => 'fake@fake.com',
        :password => '1234',
      )
      user2 = User.create(
        :user_name => 'fake2',
        :email => 'fake@fake.com',
        :password => '5678',
      )

      expect(User.all.count).to eq(1)
    end
  end
end
