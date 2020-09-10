# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

locations = Location.create(name: 'New York City')
Recording.create(location_id: 1, temp: 32, status: 'cloudy')
Recording.create(location_id: 1, temp: 34, status: 'rainy')
Recording.create(location_id: 1, temp: 30, status: 'rainy')
Recording.create(location_id: 1, temp: 28, status: 'cloudy')
Recording.create(location_id: 1, temp: 22, status: 'sunny')
