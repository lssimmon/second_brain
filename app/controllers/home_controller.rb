class HomeController < ApplicationController

  allow_unauthenticated_access only: [:index]
  before_action :resume_session


  def index
  end
end
