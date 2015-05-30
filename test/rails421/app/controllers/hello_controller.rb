class HelloController < ApplicationController
  def world
    render :text => "anybody out there?"
  end
end
