class PlateauController < ApplicationController
  def index
    if params[:x] && params[:y]
      @x_axis = params[:x].to_i 
      @y_axis = params[:y].to_i 
    else
      @x_axis = 0
      @y_axis = 0
    end

    # Builds the string for the css grid to be used on the front-end
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
        @grid_hash << "#{x_axis}  #{y_axis}"
      end
    end

    # Defining globel variables that contains all the rovers information
    $rover_id = 0
    $rover = [{:id => 0, :path => nil, :facing => nil, :directions => nil, :degrees => nil , :cardinal_compass_points => nil}]
    p $grid_hash = @grid_hash
    $rotation = 0
  end

  # Creates a new rover and adds it to the array of existing rovers
  def create
    $rover_id = $rover_id.next
    $rover << {:id => $rover_id, :path => nil, :facing => nil, :directions => nil, :degrees => nil, :cardinal_compass_points => nil}
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

  # builds the array that provides the rotation/path/cardinal compass point for each rover
  def start
    
    # $rover.each_with_index do |rover, index|
    array = []
    $rover_orientation = ""
    cardinal_compass_points = []
    index = params[:pass_rover].to_i

    if $rover[index][:facing] == "N"
      $rotation = 0
      $rover[index][:degrees] = array << $rotation
      cardinal_compass_points << "North"
    elsif $rover[index][:facing] == "E"
      $rotation = 90
      $rover[index][:degrees] = array << $rotation
      cardinal_compass_points << "East"
    elsif $rover[index][:facing] == "S"
      $rotation = 180
      $rover[index][:degrees] = array << $rotation
      cardinal_compass_points << "South"
    elsif $rover[index][:facing] == "W"
      $rotation = 270
      $rover[index][:degrees] = array << $rotation
      cardinal_compass_points << "West"
    end

      $rover[index][:directions].each do |directions|
      
        if directions == "L"
          $rotation -= 90
          $rover[index][:degrees] = array << $rotation
        elsif directions == "R"
          $rotation += 90
          $rover[index][:degrees] = array << $rotation
        end
        
        if $rotation / 90 % 4 == 0
          $rover_orientation = "N"
          cardinal_compass_points << "North"
        elsif $rotation / 90 % 4 == 1
          $rover_orientation = "E"
          cardinal_compass_points << "East"
        elsif $rotation / 90 % 4 == 2 
          $rover_orientation = "S"
          cardinal_compass_points << "South"
        elsif $rotation / 90 % 4 == 3
          $rover_orientation = "W"
          cardinal_compass_points << "West"
        elsif $rotation / 90 % 4 == -1
          $rover_orientation = "W"
          cardinal_compass_points << "West"
        elsif $rotation / 90 % 4 == -2
          $rover_orientation = "S"
          cardinal_compass_points << "South"
        elsif $rotation / 90 % 4 == -3
          $rover_orientation = "E"
          cardinal_compass_points << "East"
        end
        

        if directions == "M" && $rover_orientation == "N"
          # just increases the value on the y-axis
          $rover[index][:degrees] = array << "M"
          p $rover[index][:path] << "#{$rover[index][:path].last.split(",")[0].to_i},#{$rover[index][:path].last.split(",")[1].to_i + 1}"
        elsif directions == "M" && $rover_orientation == "E"
          # just increases the value on the x-axis
          $rover[index][:degrees] = array << "M"
          p $rover[index][:path] << "#{$rover[index][:path].last.split(",")[0].to_i + 1},#{$rover[index][:path].last.split(",")[1].to_i}"
        elsif directions == "M" && $rover_orientation == "S"
          # just decreases the value on the y-axis
          $rover[index][:degrees] = array << "M"
          p $rover[index][:path] << "#{$rover[index][:path].last.split(",")[0].to_i},#{$rover[index][:path].last.split(",")[1].to_i - 1}"
        elsif directions == "M" && $rover_orientation == "W"  
          # just decreases the value on the x-axis
          $rover[index][:degrees] = array << "M"
          p $rover[index][:path] << "#{$rover[index][:path].last.split(",")[0].to_i - 1},#{$rover[index][:path].last.split(",")[1].to_i}"
        end
        
      end
      
      $rover[index][:cardinal_compass_points] = cardinal_compass_points
    # end
    
     @rover_array_of_hashes = $rover
    respond_to do |format|
      format.json {render json: @rover_array_of_hashes[params[:pass_rover].to_i]}
    end
  end 

end