3.times do |i|
  User.create! email: "user#{i}@g.g", name: "user#{i}", password: '123456'
end


100.times do |i|
  Message.create! content: i.to_s, user_id: [4, 2 ,3].sample, room_id: 7
  sleep 1
end
