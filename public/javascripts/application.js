// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//gets updated quantity of a product, bunker pair. also updates a div if provided.
function updateQuantity(part_id, bunker_id, update_div)
{
    var response = 0;
    new Ajax.Request('/products/get_existing_quantity', {
    method: 'get',
    asynchronous: false,
    parameters: {part_id: part_id, bunker_id: bunker_id},
    onSuccess: function(transport){
      response = transport.responseText || "no response text";
      //alert("transport: " + transport + ":: response: " + response);
      if(update_div.length > 0) {
        document.getElementById(update_div).innerHTML = response;
      }
      //alert("Success! \n\n" + response);
    },
    onFailure: function(){ alert('Something went wrong...') }

  });
  //alert(response);
  return response;
}

function updateProductDescription(product_id, update_div) {
  desc = document.getElementById("product_"+product_id).value;
  if(typeof(update_div) != 'undefined' && update_div.length > 0) {
    document.getElementById(update_div).innerHTML = desc.truncate(20);
  }
  return desc;
}

function addProductToList() {
  $('product-list');
  var product_id = $('products').value;
  var bunker_id = $('bunkers').value;
  var quantity = $('quantity').value;
  var available_quantity = parseInt(updateQuantity(product_id, bunker_id));
  //alert("product: "+ product_id + "::bunker: " + bunker_id + "::quantity: " + quantity + "::available: " + available_quantity);

  var product_detail = updateProductDescription(product_id).truncate();
  var bunker_name = $('bunker_'+bunker_id).value;

  if (available_quantity < parseInt(quantity)) {
    $('error').replace("<span class='error' id='error'>Requested Quantity is more than available quantity!</span>");
    return;
  }
  if (quantity.strip() == '') {
    //$('error').replace("<span class='error' id='error'>Requested Quantity is more than available quantity!</span>");
    displayError("Quantity cannot be empty");
    return;
  }
  unique_id = "product"+product_id+"bunker"+bunker_id;
  unique_value = "product"+product_id+"|bunker"+bunker_id+"|quantity"+quantity;

  if( $(unique_id) && $(unique_id).value.length > 0) {
    $("dis_" + unique_id).remove();  
    $(unique_id).remove();  
  }

  $('product-list-hid').insert("<input type='hidden' value='"+ unique_value +"' name='products[]' id='" + unique_id + "' />", { position : "bottom" });
  $('product-list').insert("<div id='dis_" + unique_id + "'><span>"+ product_detail + "</span><span>" + bunker_name + "</span><span>" + quantity 
    + "</span><span><a href='javascript:;' onclick='removeProduct(\""+unique_id+"\");'>Remove</a></span></div>", { position : "bottom" });

}

function createJob() {
  var total_count = $$("input[name='products[]']").length;
  if(total_count == 0) {
    //$('error').replace("<span class='error' id='error'>Select atleast one product first!</span>");
    displayError("Select atleast one product first!");
    return;
  }
  submit_value = "";

  $$("input[name='products[]']").each(function(s, index) {
    submit_value = submit_value + s.value;
    if(index + 1 < total_count) {
      submit_value = submit_value + "||";
    }
  });
  
  alert(submit_value);
  new Ajax.Request('/jobs/create', {
    method: 'get',
    //asynchronous: false,
    parameters: { products: submit_value },
    onSuccess: function(transport){
      response = transport.responseText || "no response text";
      //alert("transport: " + transport + ":: response: " + response);
      if(update_div.length > 0) {
        document.getElementById(update_div).innerHTML = response;
      }
      //alert("Success! \n\n" + response);
    },
    onFailure: function(){ alert('Something went wrong...') }

  });
  //alert(response);
  return response;

}

function removeProduct(unique_id) {
  if( $(unique_id) && $(unique_id).value.length > 0) {
    $("dis_" + unique_id).remove();  
    $(unique_id).remove();  
  }
}

function displayError(error_string) {
  $('error').replace("<span class='error' id='error'>" + error_string + "</span>");
}
