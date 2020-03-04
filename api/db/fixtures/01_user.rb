# 5.times do |index|
#   User.create role: '',
#               first_name: Faker::Name.unique.first_name,
#               last_name: Faker::Name.unique.last_name,
#               sex_id: Faker::Gender.binary_type.downcase,
#               birthday: Faker::Date.birthday(min_age: 20, max_age: 60),
#               phone_number: Faker::PhoneNumber.unique.cell_phone,
#               email: "user+#{index}@example.com",
#               password: 'password'
# end
