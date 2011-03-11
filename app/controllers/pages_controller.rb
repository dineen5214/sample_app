class PagesController < ApplicationController
  def home
    @title = "Home"
    # put a feed on our home page
    # make a feed_items, we added the :feed method to users
    if signed_in?
      @micropost = Micropost.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end
  def contact
    @title = "Contact"
  end
  def about
    @title = "About"
  end
  def help
    @title = "Help"
  end
end
