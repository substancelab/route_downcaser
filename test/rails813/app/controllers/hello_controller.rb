class HelloController < ApplicationController
  def world
    render plain: "anybody out there?"
  end
end
