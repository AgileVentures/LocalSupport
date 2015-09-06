# geocoder stubs http://stackoverflow.com/questions/18640007/testing-with-geocoder-gem
Geocoder.configure(lookup: :test)


addresses = [
    ["30 pinner road, ",
     [{
          'latitude' => 51.58154320,
          'longitude' => -0.3450920,
          'address' => '30 Pinner Road, Harrow, Greater London HA1 4HZ, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["30 pinner road, HA1 4HZ",
     [{
          'latitude' => 51.58154320,
          'longitude' => -0.3450920,
          'address' => '30 Pinner Road, Harrow, Greater London HA1 4HZ, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["30 pinner road, HA1 4HF",
     [{
          'latitude' => 51.58154320,
          'longitude' => -0.3450920,
          'address' => '30 Pinner Road, Harrow, Greater London HA1 4HF, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["30 pinner road, HA5 4HZ",
     [{
          'latitude' => 51.58154320,
          'longitude' => -0.3450920,
          'address' => '30 Pinner Road, Harrow, Greater London HA5 4HZ, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["30 pinner road, HA1 4JD",
     [{
          'latitude' => 51.58154320,
          'longitude' => -0.3450920,
          'address' => '30 Pinner Road, Harrow, Greater London HA1 4JD, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["34 pinner road",
     [{
          'latitude' => 51.58140930,
          'longitude' => -0.3439080,
          'address' => '34 Pinner Road, Harrow, Greater London HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["34 pinner road, ",
      [{
          'latitude' => 51.58140930,
          'longitude' => -0.3439080,
          'address' => '34 Pinner Road, Harrow, Greater London HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["34 pinner road, HA1 4HF",
      [{
          'latitude' => 51.58140930,
          'longitude' => -0.3439080,
          'address' => '34 Pinner Road, Harrow, Greater London HA1 4HF, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["34 pinner road, HA1",
     [{
          'latitude' => 51.58140930,
          'longitude' => -0.3439080,
          'address' => '34 Pinner Road, Harrow, Greater London HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["34 pinner road, HA1 1AA",
      [{
          'latitude' => 51.5813964,
          'longitude' => -0.3440141,
          'address' => '34 Pinner Road, Harrow, Greater London HA1 1AA, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["34 pinner road, HA1 4HZ",
      [{
          'latitude' => 51.5814093,
          'longitude' => -0.343908,
          'address' => '34 Pinner Road, Harrow, Greater London HA1 4HZ, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["34 pinner road, HA5 4HZ",
      [{
          'latitude' => 51.5813964,
          'longitude' => -0.3440141,
          'address' => '34 Pinner Road, Harrow, Greater London HA5 4HZ, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["64 pinner road, ",
      [{
          'latitude' => 51.58134110,
          'longitude' => -0.34680750,
          'address' => '64 Pinner Road, Harrow, Middlesex HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["64 pinner road, HA1 4HZ",
     [{
          'latitude' => 51.58134110,
          'longitude' => -0.34680750,
          'address' => '64 Pinner Road, Harrow, Middlesex HA1 4HZ, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["64 pinner road, HA1 4HA",
     [{
          'latitude' => 51.58134110,
          'longitude' => -0.34680750,
          'address' => '64 Pinner Road, Harrow, Middlesex HA1 4HA, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["83 pinner road",
     [{
          'latitude' => 51.58102020,
          'longitude' => -0.34690070,
          'address' => '83 Pinner Road, Harrow, Greater London HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["83 pinner road, ",
     [{
          'latitude' => 51.58102020,
          'longitude' => -0.34690070,
          'address' => '83 Pinner Road, Harrow, Greater London HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["83 pinner road, HA1 4HZ",
     [{
          'latitude' => 51.58102020,
          'longitude' => -0.34690070,
          'address' => '83 Pinner Road, Harrow, Greater London HA1 4HZ, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["83 pinner road, HA1 4HF",
     [{
          'latitude' => 51.58102020,
          'longitude' => -0.34690070,
          'address' => '83 Pinner Road, Harrow, Greater London HA1 4HF, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["83 pinner road, HA1 4ET",
     [{
          'latitude' => 51.58102020,
          'longitude' => -0.34690070,
          'address' => '83 Pinner Road, Harrow, Greater London HA1 4ET, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["84 pinner road, ",
     [{
          'latitude' => 51.58125769999999,
          'longitude' => -0.34730780,
          'address' => '84 Pinner Road, Harrow, Greater London HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["84 pinner road, HA1",
     [{
          'latitude' => 51.58125769999999,
          'longitude' => -0.34730780,
          'address' => '84 Pinner Road, Harrow, Greater London HA1, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
    ["84 pinner road, HA1 4HF",
     [{
          'latitude' => 51.58125769999999,
          'longitude' => -0.34730780,
          'address' => '84 Pinner Road, Harrow, Greater London HA1 4HF, UK',
          'country' => 'United Kingdom',
          'country_code' => 'UK'
      }]],
]

Geocoder.configure(:lookup => :test)
addresses.each {|addr| Geocoder::Lookup::Test.add_stub(addr[0], addr[1])}
