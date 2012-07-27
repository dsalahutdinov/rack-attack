# NB: `req` is a Rack::Request object (basically an env hash with friendly accessor methods)

# Throttle 10 requests/ip/second
# NB: return value of block is key name for counter
#     falsy values bypass throttling
Rack::Attack.throttle("req/ip", :limit => 10, :period => 1) { |req| req.ip }

# Throttle attempts to a particular path. 2 POSTs to /login per second per IP
Rack::Attack.throttle "logins/ip", :limit => 2, :period => 1 do |req|
  req.ip if req.post? && req.path_info =~ /^login/
end

# Throttle login attempts per email, 10/minute/email
Rack::Attack.throttle "logins/email", :limit => 2, :period => 60 do |req|
  req.params['email'] unless req.params['email'].blank?
end


# Block cloud IPs from accessing PATH regexp
Rack::Attack.block "bad_ips from logging in" do |req|
  req.path =~ /^login/ && bad_ips.include?(req.ip)
end

# Throttle login attempts
Rack::Attack.throttle "logins/ip", :limit => 2, :period => 1.second do | req|
  req.ip if req.post? && req.path_info =~ /^login/
end

# Whitelist a User-Agent
Rack::Attack.whitelist 'internal user agent' do |req|
  req.user_agent =~ 'InternalUserAgent'
end