
function addMoreField(){
  var new_page_field = $('#more_field .field').clone();
      new_page_field.insertAfter('.search:last');
}

function fillFields(){
    $("#P1").val("P FORD CAR REVIEW");
    $("#P2").val("P REVIEW CAR");
    $("#P3").val("P REVIEW FORD");
    $("#Q1").val("Q FORD REVIEW");
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

})