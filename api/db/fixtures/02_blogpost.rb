if Rails.env.development?
  User.all.each do |user|
    3.times do
      Blogpost.create user: user, title: Faker::Movies::StarWars.quote,
                      body: Faker::Lorem.paragraphs(number: rand(2..8)).join('.')
    end
  end
end
