require 'rails_helper'

 RSpec.describe Cocktail do
   it 'exists and has attributes' do
     attributes = {
       name: "Margarita",
       instructions: "Rub the rim of the glass with the lime slice to make the salt stick to it. Take care to moisten only the outer rim and sprinkle the salt on it.",
       image_url: 'https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg',
       ingredients: {
        "Tequila" => "1 1/2 oz ",
        "Triple sec" => "1/2 oz ",
        "Lime juice" => "1 oz ",
        "Salt" => nil}}

     cocktail = Cocktail.new(attributes)

     expect(cocktail).to be_an_instance_of(Cocktail)
     expect(cocktail.name).to eq("Margarita")
     expect(cocktail.instructions).to eq("Rub the rim of the glass with the lime slice to make the salt stick to it. Take care to moisten only the outer rim and sprinkle the salt on it.")
     expect(cocktail.image_url).to eq('https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg')
     expect(cocktail.ingredients).to eq({
      "Tequila" => "1 1/2 oz ",
      "Triple sec" => "1/2 oz ",
      "Lime juice" => "1 oz ",
      "Salt" => nil})
   end
 end
