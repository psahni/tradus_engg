
function addMoreField(){
  var new_page_field = $('#more_field .field').clone();
      new_page_field.insertAfter('.search:last');
      new_page_field.addClass('search');
}

function fillFields(){
    $("#P1").val("P FORD CAR REVIEW");
    $("#P2").val("P REVIEW CAR");
    $("#P3").val("P REVIEW FORD");
    $("#Q1").val("Q FORD REVIEW");
    $("#Q2").val("Q FORD CAR");
}

$(function(){

    $(".add_more").click(function(e){
        e.preventDefault();
        addMoreField();
    });

   $('.fill').click(function(e){
       e.preventDefault();
       fillFields();
   });

   $("#search_form").bind("ajax:beforeSend", function(){
      $("#output-area").html("<h1>Fetching Output...</h1>")
    })
   .bind("ajax:error", function(evt, xhr, status, error){
      alert("No results fetched. Please check the Input");
      $("#output-area").html('');
    });

})