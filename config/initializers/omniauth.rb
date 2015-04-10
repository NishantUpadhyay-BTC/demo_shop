Rails.application.config.middleware.use OmniAuth::Builder do
  provider :shopify, '4a79d7230e2d479987499994dd82df81', '8226fe1bb817b99bbe331312285920fd',
    scope: 'write_products,write_script_tags,read_orders',
    setup: lambda { |env| params = Rack::Utils.parse_query(env['QUERY_STRING'])
                        env['omniauth.strategy'].options[:client_options][:site] = "http://#{params['shop']}" }
end