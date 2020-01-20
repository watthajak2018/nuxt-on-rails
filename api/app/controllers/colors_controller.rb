class ColorsController < ApplicationController
  def index
    examples = Color.all.select :id, :color
    render json: examples
  end
end
