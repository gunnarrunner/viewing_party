require 'rails_helper'
RSpec.describe 'it can make a view party form' do
  before :each do
    @movie = Movie.new({original_title: 'Fight Club',
      overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
      vote_average: '8.4',
      genres: ["Drama"],
      cast: [{name: "Edward Norton", character: "The Narrator"}, {name: "Brad Pitt", character: "Tyler Durden"}],
      reviews: [{author: "Goddard", review: "Pretty awesome movie.  It shows what one crazy person can convince other crazy people to do.  Everyone needs something to believe in.  I recommend Jesus Christ, but they want Tyler Durden."}, {author: "Brett Pascoe", review: "In my top 5 of all time favourite movies. Great story line and a movie you can watch over and over again."}],
      id: '550',
      genres: ['Drama'],
      runtime: '139'})

      allow(MovieFacade).to receive(:create_movie).and_return(@movie)

      @user1 = create(:user)
      @user2 = create(:user)
      @user3 = create(:user)
      Friendship.create!(user: @user1, friend: @user2)
      Friendship.create!(user: @user1, friend: @user3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit "/movies/#{@movie.id}"
    end

    it 'can visit a viewing party form', :vcr  do

      click_on 'Create a Viewing Party for Movie'

      expect(current_path).to eq("/viewing-parties/new")

      expect(page).to have_content(@movie.title)
      # expect(page).to have_field(:duration, placeholder: @movie.runtime)
      expect(page).to have_field(:date)
      expect(page).to have_field(:start_time)
      expect(page).to have_field("attendees[#{@user2.id}]", checked: false)
      expect(page).to have_field("attendees[#{@user3.id}]", checked: false)
      expect(page).to have_button("Create Party")
    end

    it 'user can fill out form to create a viewing party', :vcr  do

      click_on 'Create a Viewing Party for Movie'

      fill_in :date, with: "20/9/2021"
      fill_in :start_time, with: Time.parse("2021-09-20 19:15")
      page.check "attendees[#{@user2.id}]"

      click_on 'Create Party'

      viewing_party = WatchParty.last
      
      expect(current_path).to eq('/dashboard')
      expect(viewing_party.duration).to eq(139)
      expect(viewing_party.movie).to eq('Fight Club')
      # expect(viewing_party.genre).to eq(['Drama'])
      # expect(viewing_party.host).to eq(user1.id)
      expect(viewing_party.date.to_date).to eq("Mon, 20 Sep 2021".to_date)
      expect(viewing_party.start_time.strftime('%I:%M %P')).to eq(viewing_party.start_time.localtime.strftime('%I:%M %P'))

      expect(Attendee.count).to eq(2)

      attendees = Attendee.last(2)

      expect(attendees[0].watch_party_id).to eq(viewing_party.id)
      expect(attendees[0].user_id).to eq(@user1.id)

      expect(attendees[1].watch_party_id).to eq(viewing_party.id)
      expect(attendees[1].user_id).to eq(@user2.id)
    end

    it 'displays watch party information on users dashboard for host', :vcr  do

          click_on 'Create a Viewing Party for Movie'

          fill_in :date, with: "20/9/2021"
          fill_in :start_time, with: Time.parse("2021-09-20 19:15")
          page.check "attendees[#{@user2.id}]"

          click_on 'Create Party'

          viewing_party = WatchParty.last

      within("#party-#{viewing_party.id}") do
        expect(page).to have_content(viewing_party.movie)
        expect(page).to have_content("Mon, Sep 20")
        expect(page).to have_content(viewing_party.start_time.localtime.strftime('%I:%M %P'))
        expect(page).to have_content('Hosting')
      end
    end

    it 'displays watch party information on users dashboard for an invited user', :vcr  do

      viewing_party = WatchParty.create!(movie: "Fight Club", date: "20/9/2021", start_time: Time.parse("2021-09-20 19:15"), movie_id: '550', user: @user1, duration: 139)

      Attendee.create!(watch_party: viewing_party, user: @user1, status: 0)
      Attendee.create!(watch_party: viewing_party, user: @user2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user2)

        visit '/dashboard'

      within("#party-#{viewing_party.id}") do
        expect(page).to have_content(viewing_party.movie)
        expect(page).to have_content("Mon, Sep 20")
        expect(page).to have_content("07:15 pm")
        expect(page).to have_content('Invited')
      end
    end

    it 'movie will not display on users dashboard if they were not invited', :vcr  do

      viewing_party = WatchParty.create!(movie: "Fight Club", date: "20/9/2021", start_time: Time.parse("2021-09-20 19:15"), movie_id: '550', user: @user1, duration: 139)

      Attendee.create!(watch_party: viewing_party, user: @user1, status: 0)
      Attendee.create!(watch_party: viewing_party, user: @user2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user3)

        visit '/dashboard'

        expect(page).to_not have_css("#party-#{viewing_party.id}")
        expect(page).to have_content("No Viewing Parties Yet")
        expect(page).to have_button("Start A Viewing Party!")
    end

    it 'can fill out half a form and be redirected to the form for not filling out all details', :vcr  do

      click_on 'Create a Viewing Party for Movie'

      fill_in :start_time, with: Time.parse("2021-09-20 19:15")
      page.check "attendees[#{@user2.id}]"

      click_on 'Create Party'

      expect(current_path).to eq("/viewing-parties/new")
      expect(page).to have_content("Form missing details")
    end

    it 'cannot visit a creating a viewing party form if you are not logged in as a user', :vcr  do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
      
      visit('/viewing-parties/new')

      expect(page).to have_content("Must be a user to access!")
      expect(page).to have_link("Log In Here")
    end
end
