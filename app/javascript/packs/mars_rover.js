$(document).ready(function() {
    
    var rover_id = 0;
    var fetch_rover = 0;
    
    
    $(".start_btn").on("click", function(){
        // grid is being set on the index.erb.html page
        // Clears the grid
        $(grid).each(function(i){
            $("#"+ grid[i].replace("  ","")).html("");
        });

        $("#log").html('');

        fetch_rover = 0
        setTimeout( function(){
        $.ajax({
                type: 'get',
                url: '/start',
                data: {pass_rover: fetch_rover},
                contentType: "application/json", 
                success:function(array){
                rover = array;

            try{
                if (grid.includes(rover['path'][rover['path'].length - 1])){
                    // Returns true
                    animate_rover(rover);
                }else{
                    // Returns false
                    alert("rover " + fetch_rover + " will end up going off the plateau! Check the Logs.");
                    $("#log").append("<p style='color:red;'>Rover "+(fetch_rover)+" - will end up going off the plateau! Terminating process...  <span style='font-size: 20px;'>💥&#128545;💥<span> </p>");
                    return
                }  
            } catch {console.log("we have no more paths to follow");}
            }
        });
    },1000);
    });
    
    // Controls the rotation and the steps each rover takes
    function animate_rover(rover){
    try {
        var starting_point = rover["path"][0];
        var facing =rover["degrees"][0];
        var array = rover["path"];
        var id = rover["id"];
        var time = 1500;
        var prev_rotation = 0;

        var rover_moved = 0
                
                $("#"+starting_point).html('<img height="50px" style="transform: rotate('+facing+'deg)" id="rover'+id+'" src="/assets/rover.png">');
            
                    $(rover["degrees"]).each(function( i, value ) {
                        
                    get_next_rover_after = rover["degrees"].length
                    setTimeout( function(){
                        if (value != "M"){
                            // rover_rotation(count,value);
                            $("#rover"+rover["id"]).animate(
                                
                                { deg: value },
                                {
                                    duration: 1200,
                                    step: function(now) {
                                    $(this).css({ transform: 'rotate(' + value + 'deg)', 'transition':'all ease 1s', });
                                    }
                                }
                                
                            );
                            prev_rotation = value;
                        } else { 
                            move_to_new_location(array,prev_rotation,id);
                        }
                        rover_moved++
                        if(get_next_rover_after == rover_moved){
                            next();
                        }

                    }, time)
                    time += 1500;
                    });
                    fetch_rover++
    } catch(err) {
        console.log("No more data to process");
    }               
    }

    // Gets the next rover
    function next(){
        
    try {
        $.ajax({
            type: 'get',
            url: '/start',
            data: {pass_rover: fetch_rover},
            contentType: "application/json", 
            success:function(array){
            rover = array;

            try{
                if (grid.includes(rover['path'][rover['path'].length - 1].replace(",","  "))){
                    // Returns true
                    animate_rover(rover);
                }else{
                    // Returns false
                    alert("rover " + fetch_rover + " will end up going off the plateau!");
                    return
                }  
            } catch {console.log("we have no more paths to follow");}      
        }
        });
    } catch(err) {
        console.log("No more data to process");
    } finally {
        ended_at = rover['path'][rover['path'].length - 1].split("_");
        pointing = rover['cardinal_compass_points'][rover['cardinal_compass_points'].length - 1];
        $("#log").append("<p>Rover "+(fetch_rover-1)+" - went to block X("+ended_at[0]+") , Y("+ended_at[1]+") and is facing "+pointing+" </p>");}
    }

    // Sets the path
    function move_to_new_location(path_arr,prev_rotation,id){
        var remove_location = path_arr.shift();
        var new_location = path_arr[0];
        
        
        $("#"+new_location).html('<img height="50px" style="transform: rotate(' + prev_rotation + 'deg)"  id="rover'+id+'" src="/assets/rover.png">');
        $("#"+remove_location).html(''); 
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