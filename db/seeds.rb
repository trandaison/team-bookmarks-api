# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
password = Settings.default_admin_password
admin = User.find_or_create_by!(admin: true)
admin.update!(email: "admin@api-placeholder.herokuapp.com", password: password, name: "Admin")

# 100.times.each do
#   Blog.create(title: Faker::Movie.title, content: Faker::Lorem.paragraphs.join('\n'))
# end
