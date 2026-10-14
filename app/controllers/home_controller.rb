class HomeController < ApplicationController
  def index
    @teachers = Teacher.all
  end
end