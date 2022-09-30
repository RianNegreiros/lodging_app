user = User.new(
  email: 'user1@test.com',
  name: 'usertest',
  password: 'usertest',
  password_confirmation: 'usertest',
  created_at: DateTime.now
)
user.skip_confirmation!
user.save!

listing = Listing.create!(
  host: user,
  title: "listing title",
  about: "listing about",
  address_line1: "listing address line 1",
  address_line2: "listing address line 2",
  city: "listing city",
  state: "listing state",
  postal_code: "listing postal code",
  country: "listing country",
  status: Random.rand(0...2),
  nightly_price: Random.rand(1...999),
  cleaning_fee: Random.rand(1...999)
)

room = Room.create!(
  listing: listing
)

Bed.create!(
  room: room
)