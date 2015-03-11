// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require jquery_nested_form

$(document).ready(function(){

  // login page
  $("#login-form").submit(function(){

    $("#login-form div.has-error").removeClass("has-error");
    $("#login-form span.help-block").remove();
    flag = true;

    // login
    if($("#session_login").val() == ""){
      $("div.session_login").addClass("has-error");
      $("#session_login").after("<span class='help-block'>不能为空！</span>");
      flag = false;
    }

    //password
    if($("#session_password").val() == ""){
      $("div.session_password").addClass("has-error");
      $("#session_password").after("<span class='help-block'>不能为空！</span>");
      flag = false;
    }

    return flag;
  });


  // product units edit page
  $("#edit-units-list").on("click", ".unit_is_default", function(){
    $(".unit_is_default").prop('checked', false);
    $(this).prop('checked', true);
  });

  $("#edit-units-list").on("click", ".unit_is_base", function(){
    $(".unit_is_base").prop('checked', false);
    $(this).prop('checked', true);
  });

  // product sub_products edit page
  $("#edit-sub_products-list").on("change", ".sub_product_product_id", function(){
    var select = $(this).parents("tr.fields").find(".sub_product_unit_id");
    select.empty();
    if($(this).val() != ""){
      $.get("/products/" + $(this).val() + "/get_units.json" ,function(data, status){
        for(var i in data){
          select.append(
            $("<option></option>").attr("value", data[i]['id']).text(data[i]['name'])
          );
        }
      });
    }
  });

});
