$(document).ready(function() {
// Keeps track of the rover id
var rover_id = 0 

var rover_array = []
        
    $(".start_btn").on("click", function(){
        $.ajax({
                type: 'GET',
                url: '/start',
                contentType: "application/json", 
                success:function(array){
                rover_array = array

                $(rover_array).each(function( x ) {

                    console.log(first = rover_array[x]["path"][0].replace(',',''));
                    $(rover_array[x]["degrees"]).each(function( i, value ) {
                    
                    $("#"+first).html('<img height="50px" style="transform: rotate('+value+'deg);" src="/assets/rover_facing_north.png">');
                    console.log(value);
                    });
                });
                }
            });
    });

// Appends a new set of input fields for each rover that exists
$(".create_rover").on("click", function(){
    rover_id++
    
$(".rover_instructions").append('<label>Set Starting point :</label> '+
                                '<input type="hidden" name="rover_id'+rover_id+'" id="rover_id'+rover_id+'" value="'+rover_id+'"> '+
                                '<input type="text" name="path'+rover_id+'" id="path" autocomplete="off"> '+
                                '<label>Give directions : </label> <input type="text" name="directions'+rover_id+'" id="directions'+rover_id+'" autocomplete="off"> <br/>');
});
});