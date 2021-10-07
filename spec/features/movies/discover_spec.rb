require 'rails_helper'
RSpec.describe 'can find certain movies based off of criteria' do
  before :each do
    visit "/discover"
  end

  it 'search for a movie through the movie search bar', :vcr do
    expect(page).to have_field(:search)
  end

  it 'can click the link to go to top rated movies', :vcr do
    expect(page).to have_button("Find Top Rated Movies")

    click_button("Find Top Rated Movies")

    expect(current_path).to eq('/movies')
  end

  it 'gets redirected back to the discover page if the search is blank', :vcr do
    fill_in :search, with: ''

    click_on 'Search Movies!'

    expect(current_path).to eq('/discover')
    expect(page).to have_content("Movie Search can not be blank")
  end
end


