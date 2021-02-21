$(document).ready(function() {
    // Keeps track of the rover id
    var rover_id = 0 
    
    var rover_array = []
            
        $(".start_btn").on("click", function(){
            $.ajax({
                    type: 'post',
                    url: '/start',
                    contentType: "application/json", 
                    success:function(array){
                    rover_array = array;
                    count = 0;
                        
                    console.log(rover_array);
                    
                    $(rover_array).each(function( x ) {
                    
                        var starting_point = rover_array[x]["path"][0].replace(',','');
                        var facing =rover_array[x]["degrees"][0]
                        console.log(facing);
                        var array = rover_array[x]["path"]
    
                        // if(rover_array[x]["facing"] == "N"){
                          $("#"+starting_point).html('<img height="50px" style="transform: rotate('+facing+'deg)" id="rover'+count+'" src="/assets/rover_north.png">');
                        // }else if(rover_array[x]["facing"] == "E"){
                        //   $("#"+starting_point).html('<img height="50px" style="transform: rotate('+facing+'deg)" id="rover'+count+'" src="/assets/rover_east.png">');
                        // }else if(rover_array[x]["facing"] == "S"){
                        //   $("#"+starting_point).html('<img height="50px" style="transform: rotate('+facing+'deg)" id="rover'+count+'" src="/assets/rover_south.png">');
                        // }else if(rover_array[x]["facing"] == "W"){
                        //   $("#"+starting_point).html('<img height="50px" style="transform: rotate('+facing+'deg)" id="rover'+count+'" src="/assets/rover_west.png">');
                        // }else{
                        //   $("#"+starting_point).html('<img height="50px" style="transform: rotate('+facing+'deg)" id="rover'+count+'" src="/assets/rover_west.png">');
                        // }
                        
                        
                
                        $(rover_array[x]["degrees"]).each(function( i, value ) {
            
                       
                        
       
                       
                        if (value != "M"){
                          rover_rotation(count,value);
                        } else {
                            // arr = rover_array[x]["path"]
                        //   move_to_new_location(array)
                        }
                        
    
                      
                        });
                        count++
                    });
                    }
                });
        });
    
    
    
                        function rover_rotation(count,value){
                            console.log("Value"+value);
                        setTimeout(() => {
                            // console.log(value);
                            $("#rover"+count).animate(
                            { deg: value },
                            {
                              duration: 1200,
                              step: function(now) {
                                  console.log(now)
                                $(this).css({ transform: 'rotate(' + value + 'deg)', 'transition':'all ease 1s', });
                              }
                            }
                          );
                          }, 3000);
    
                          return



                        }

                        function move_to_new_location(arr){
                            
                            location_arr = arr.shift();
                            new_location = location_arr.replace(',','');
                            console.log(new_location);
                            $("#"+new_location).html('<img height="50px" style="transform: rotate('+90+'deg)" id="rover'+count+'" src="/assets/rover_west.png">');
                        }
    
    
    
    
    
    
    
    
    // Appends a new set of input fields for each rover that exists
    $(".create_rover").on("click", function(){
        rover_id++
        
    $(".rover_instructions").append('<label>Set Starting point :</label> '+
                                    '<input type="hidden" name="rover_id'+rover_id+'" id="rover_id'+rover_id+'" value="'+rover_id+'"> '+
                                    '<input type="text" name="path'+rover_id+'" id="path" autocomplete="off"> '+
                                    '<label>Give directions : </label> <input type="text" name="directions'+rover_id+'" id="directions'+rover_id+'" autocomplete="off"> <br/>');
    });
    });