Given(/^the following contributors exist:$/) do |c_table|
  #my_hash_contributors = Hash.new
  contributors = Array.new
  c_table.hashes.each do |contributor| # This is just one contributor from our table
   # my_hash_contributors =  {'login' => contributor['login'] , 'avatar_url' => contributor['avatar_url']}
   # for example here since the first call in the loop you'll have
   #     my_hash_contributors["tomas"] = [:login => "Thomas" , :url => "url.com"]
   #
   # check out the correct attributes how the called on the api, and add the other,
    contributors << contributor
  end
 Contributors = contributors
end