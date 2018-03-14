class HandlersController < ApplicationController

  def show
    render params[:id]
  end
end
