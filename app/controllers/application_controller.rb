class ApplicationController < ActionController::Base
  
protect_from_forgery
  force_ssl
  helper_method :current_shop, :shopify_session

protected

  def current_shop
    @current_shop ||= Shop.find(session[:shop_id]) if session[:shop_id].present?
  end

  def shopify_session
    if current_shop.nil?
      redirect_to login_url
    else
      begin
        session = ShopifyAPI::Session.new(current_shop.url, current_shop.token)
        ShopifyAPI::Base.activate_session(session)
        yield
      ensure
        ShopifyAPI::Base.clear_session
      end
    end
  end
  # It will re-login if a user tries to access the application from a different shop
  # before_filter :login_again_if_different_shop
  
  # Ask shop to authorize app again if additional permissions are required
  # rescue_from ActiveResource::ForbiddenAccess do
  #   session[:shopify] = nil
  #   flash[:notice] = "This app requires additional permissions, please log in and authorize it."
  #   redirect_to controller: :sessions, action: :create
  # end
end
