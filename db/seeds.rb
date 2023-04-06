# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
u=User.new(email: "ilates@yahoo.com",password: 'Iulian7.',password_confirmation: 'Iulian7.',name: "Iulian Lates",role: 1)
u.save
u=User.new(email: "costelaioanei@yahoo.com",password: '7777777',password_confirmation: '7777777',name: "Costel Aioanei",role: 1)
u.save