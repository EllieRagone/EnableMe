# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
open("seedfile.txt") do |users|
  users.read.each_line do |user|
    steam_name, email, password = user.chomp.split(",")
    User.create!(steam_name: steam_name, 
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

User.first.toggle!(:admin)
User.all.each { |u| u.save(validate: false) }