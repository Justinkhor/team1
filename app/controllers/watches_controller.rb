class WatchesController < ApplicationController

  def index
    @user = User.new
    @item = Item.all
  end
end
