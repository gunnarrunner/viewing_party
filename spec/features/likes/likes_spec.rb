require 'rails_helper'

 RSpec.describe 'user like button' do
   describe 'functionality' do
     it 'can like a movie by clicking the like button', :vcr do
       user = create(:user)

       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

       visit '/movies/550'

       within("#likes") do
         find(:css, '.icon').click
       end

       expect(current_path).to eq('/movies/550')

       within(".button_badge") do
         expect(page).to have_content('1')
       end

       within(".dropdown-menu") do
         expect(page).to have_button('Fight Club')

         click_on 'Fight Club'
       end

       expect(current_path).to eq(viewing_parties_new_path)
     end

     it 'can only like a movie once', :vcr do
       user = create(:user)

       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

       visit '/movies/550'

       within("#likes") do
         find(:css, '.icon').click
         find(:css, '.icon').click
         find(:css, '.icon').click
       end

       expect(current_path).to eq('/movies/550')

       within(".button_badge") do
         expect(page).to have_content('1')
       end

       within(".dropdown-menu") do
         expect(page).to have_button('Fight Club', count: 1)
       end
     end
   end
 end
