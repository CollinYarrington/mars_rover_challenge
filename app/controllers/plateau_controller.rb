class PlateauController < ApplicationController
  before_action :set_default_values

  def index
    if set_params[:x] && set_params[:y]
      # test = params[:set_top_right_corner].split
      @x_axis = set_params[:x].to_i - 1
      @y_axis = set_params[:y].to_i - 1
    else
      @x_axis = 0
      @y_axis = 0
    end

    # Build the string for the css grid to be used on the frontend
    @css_auto_grid = "" 
    (0..@x_axis).each do |x_axis| 
      @css_auto_grid += "auto "
    end

    @width = 100 * @x_axis

    # Builds the array that is used to map out the grid
    range = @x_axis..0
    (0..@y_axis).each do |y_axis| 
      (range.first).downto(range.last).each do |x_axis| 
        @grid << "X(#{x_axis}) , Y(#{y_axis})"
      end
    end

    # p @grid
  end

  def create
    
    # p @x_axis.to_i , @y_axis.to_i
    # render 'index'
  end

private
  def set_params
    params.permit(:x, :y, :starting_position)
  end


  # Sets the default values
  def set_default_values
    @x_axis = 0
    @y_axis = 0
    @grid = []
  end
end
