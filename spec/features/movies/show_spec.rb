require 'rails_helper'

 RSpec.describe 'movie show page' do
   describe 'contents' do
     before(:each) do
       @movie = Movie.new({original_title: 'Fight Club',
                   overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
                   vote_average: '8.4',
                   genres: ["Drama"],
                   cast: [{name: "Edward Norton", character: "The Narrator"}, {name: "Brad Pitt", character: "Tyler Durden"}],
                   reviews: [{author: "Goddard", review: "Pretty awesome movie.  It shows what one crazy person can convince other crazy people to do.  Everyone needs something to believe in.  I recommend Jesus Christ, but they want Tyler Durden."}, {author: "Brett Pascoe", review: "In my top 5 of all time favourite movies. Great story line and a movie you can watch over and over again."}],
                   id: '550',
                   genres: ['Drama'],
                   runtime: '139'})

        allow_any_instance_of(MovieFacade).to receive(:create_movie).and_return(@movie)
     end

     it 'displays a link to create a viewing party' do
       visit '/discover'

       click_button("Find Top Rated Movies")

       expect(current_path).to eq('/movies')

       within(first('.movie')) do
         click_on "The Suicide Squad"
       end

       expect(current_path).to eq("/movies/436969")

       expect(page).to have_link('Create a Viewing Party for Movie')
     end

     it 'can display movie information' do
       visit '/movies/550'

       expect(page).to have_content(@movie.title)
       expect(page).to have_content(@movie.description)
       expect(page).to have_content(@movie.rating)
       expect(page).to have_content(@movie.runtime)
       expect(page).to have_content("Goddard")
       expect(page).to have_content("Brett Pascoe")
       expect(page).to have_content("Edward Norton")
       expect(page).to have_content("Brad Pitt")
       expect(page).to have_content("The Narrator")
       expect(page).to have_content("Tyler Durden")
       expect(page).to have_content("Drama")
     end

     it 'can display movie search results' do
       movies = MovieService.new.movie_search('fight club')

       visit '/discover'

       fill_in :search, with: "fight club"
       click_on "Search Movies!"

       expect(current_path).to eq('/movies')

       within(first('.movies-search')) do
         click_on movies[0][:original_title]
       end

       expect(current_path).to eq('/movies/550')
       expect(page).to have_content(@movie.title)
       expect(page).to have_content(@movie.description)
       expect(page).to have_content(@movie.rating)
       expect(page).to have_content(@movie.runtime)
       expect(page).to have_content("Goddard")
       expect(page).to have_content("Brett Pascoe")
       expect(page).to have_content("Edward Norton")
       expect(page).to have_content("Brad Pitt")
       expect(page).to have_content("The Narrator")
       expect(page).to have_content("Tyler Durden")
       expect(page).to have_content("Drama")
     end
   end
 end
