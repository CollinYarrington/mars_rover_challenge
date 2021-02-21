class PlateauController < ApplicationController
  def index
    if params[:x] && params[:y]
      @x_axis = params[:x].to_i - 1
      @y_axis = params[:y].to_i - 1
    else
      @x_axis = 0
      @y_axis = 0
    end

    # Build the string for the css grid to be used on the frontend
    @css_auto_grid = "" 
    (0..@x_axis).each do |x_axis| 
      @css_auto_grid += "auto "
    end
    
    # Sets the width of the plateau
    @width = 100 * @x_axis
    
    # Builds the array that is used to map out the grid
    @grid_hash = []
    range = @x_axis..0
    (0..@y_axis).each do |y_axis| 
      (range.first).downto(range.last).each do |x_axis| 
        @grid_hash << {:location => "#{x_axis}  #{y_axis}", :rover_id => nil, :direction => nil}  
      end
    end
    # Defining globel variables that contains all the rovers information
    $rover_id = 0
    $rover = [{:id => 0, :path => nil, :facing => nil, :directions => nil, :degrees => nil}]
    $grid_hash = @grid_hash
    $rotation = 0
  end

  def create
    $rover_id = $rover_id.next
    $rover << {:id => $rover_id, :path => nil, :facing => nil, :directions => nil, :degrees => nil}
    respond_to do |format|
      format.js
    end
  end

  # Here we set the starting point and the path the rover will take
  def set_up_rover
    $rover.each_with_index do |rover,id|
      array = params["path#{id}"].split(" ")
      direction_facing = array.pop
      position = array
      start_at = "#{position[0]},#{position[1]} "

      rover[:path] = start_at.split(" ")
      rover[:facing] = direction_facing
      rover[:directions] = params["directions#{id}"].upcase.split("")
    end
  end

  def start
    $rover.each_with_index do |rover, index|
    array = []
    $rover_orientation = ""



    # compass_direction = $rotation/90 % 4
    cardinal_compass_points = []

    # compass_direction << cardinal_compass_points.index(rover[:facing])

    # count = cardinal_compass_points.index(rover[:facing])

    
      # $rotation = 0
      # rover[:degrees] = array << $rotation
    if rover[:facing] == "N"
      $rotation = 0
      rover[:degrees] = array << $rotation
      cardinal_compass_points << cardinal_compass_points.index(rover[:facing])
    elsif rover[:facing] == "E"
      $rotation = 90
      rover[:degrees] = array << $rotation
      cardinal_compass_points << cardinal_compass_points.index(rover[:facing])
    elsif rover[:facing] == "S"
      $rotation = 180
      rover[:degrees] = array << $rotation
      cardinal_compass_points << cardinal_compass_points.index(rover[:facing])
    elsif rover[:facing] == "W"
      $rotation = 270
      rover[:degrees] = array << $rotation
      cardinal_compass_points << cardinal_compass_points.index(rover[:facing])
    end


      rover[:directions].each do |directions|
      
        if directions == "L"
          $rotation -= 90
          rover[:degrees] = array << $rotation
        elsif directions == "R"
          $rotation += 90
          rover[:degrees] = array << $rotation
        end
        
        if $rotation / 90 % 4 == 0
          $rover_orientation = "N"
        elsif $rotation / 90 % 4 == 1
          $rover_orientation = "E"
        elsif $rotation / 90 % 4 == 2 
          $rover_orientation = "S"
        elsif $rotation / 90 % 4 == 3
          $rover_orientation = "W"
        elsif $rotation / 90 % 4 == -1
          $rover_orientation = "W"
        elsif $rotation / 90 % 4 == -2
          $rover_orientation = "S"
        elsif $rotation / 90 % 4 == -3
          $rover_orientation = "E"
        end
        
        if directions == "M" && $rover_orientation == "N"
          # just increases the value on the y-axis
          rover[:degrees] = array << "M"
          rover[:path] << "#{rover[:path].last.split(",")[0].to_i},#{rover[:path].last.split(",")[1].to_i + 1}"
        elsif directions == "M" && $rover_orientation == "E"
          # just increases the value on the x-axis
          rover[:degrees] = array << "M"
          rover[:path] << "#{rover[:path].last.split(",")[0].to_i + 1},#{rover[:path].last.split(",")[1].to_i}"
        elsif directions == "M" && $rover_orientation == "S"
          # just decreases the value on the y-axis
          rover[:degrees] = array << "M"
          rover[:path] << "#{rover[:path].last.split(",")[0].to_i},#{rover[:path].last.split(",")[1].to_i - 1}"
        elsif directions == "M" && $rover_orientation == "W"  
          # just decreases the value on the x-axis
          rover[:degrees] = array << "M"
          rover[:path] << "#{rover[:path].last.split(",")[0].to_i - 1},#{rover[:path].last.split(",")[1].to_i}"
        end
      end
      
      
    end
    p @rover_array_of_hashes = $rover
    respond_to do |format|
      format.json {render json: @rover_array_of_hashes}
    end
  end 

end