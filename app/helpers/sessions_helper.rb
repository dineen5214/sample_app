module SessionsHelper

  def sign_in(user)
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]     # TWO ARGS set in :remember_token
      current_user =  user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    ###@current_user =  @current_user || user_from_remember_token     <-- refactored using ||=
    @current_user ||= user_from_remember_token
  end

  def signed_in?
      # when current_user is not nil, is already signed in
    !current_user.nil?     # should return true is no signed in   # this works without self. prefix

  end

  def sign_out
    cookies.delete(:remember_token)
    #current_user = nil
    ####self.current_user = nil
    current_user = nil
  end

  def deny_access
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end


  private

    def user_from_remember_token
      #User.authenticate_with_salt(remember_token)
      User.authenticate_with_salt( *remember_token )    # now can reference TWO ARGS
    end

    def remember_token
      cookies.signed[:remember_token] ||  [nil, nil]
    end
end
