require 'rails_helper'

RSpec.describe 'movie page' do
  describe 'contents' do
    it 'can display top 40 movies', :vcr do
      visit '/discover'

      click_on "Find Top Rated Movies"

      expect(page).to have_css('.movie', count: 40)

      within(first('.movie')) do
        expect(page).to have_css('.title')
        expect(page).to have_css('.rating')
      end
    end
  end
end
