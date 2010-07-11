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
 
  submit_value = "products="+submit_value + "&authenticity_token="+ $('authenticity_token').value;
  
  new Ajax.Request('/jobs/create', {
    method: 'post',
    asynchronous: false,
    parameters: submit_value ,
    onSuccess: function(transport){
      response = transport.responseText || "no response text";
      //alert("transport: " + transport + ":: response: " + response);
      if(parseInt(response) > 0) {
      	hostname = window.location.hostname;
      	hostport = window.location.port;
      	      	 
      	window.location.href = hostname + (hostport.length > 0 ? ':' + hostport : '') + "/view" + response;
      } else if(update_div.length > 0) {
        displayError(response);
        //document.getElementById(update_div).innerHTML = response;
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

function validateAndUpdateJobProduct(unique_product) {
	var m = /p(\d+)b(\d+)j(\d+)/.exec(unique_product);
	if (m.length != 4) {
		return false;
	}
	product_id = m[1];
	bunker_id = m[2];
	job_id = m[3];
	new_value = $('val_'+unique_product).value;
	if (isNaN(new_value)) {
		displayError("Please Enter a numeric Value");	
	} else if (new_value < 0) {
		displayError("Please Enter a positive Value");
	}
	
	submit_value = "job_id="+job_id+ "&product_id=" + product_id + "&bunker_id="+bunker_id+"&quantity="+new_value
	submit_value = submit_value + "&authenticity_token="+ $('authenticity_token').value;
	
	new Ajax.Request('/jobs/update_product', {
    method: 'post',
    asynchronous: false,
    parameters: submit_value,
    onSuccess: function(transport){
      response = transport.responseText || "no response text";
      if(parseInt(response) > 0) {//update value on screen
      	$('avail_'+unique_product).update(response);
			$('curr_'+unique_product).update(new_value);
    	} else {
        displayError(response);
      }
    },
    onFailure: function(){ alert('Something went wrong...') }
  });	
}

function removeProductFromJob(unique_product) {
	var m = /p(\d+)b(\d+)j(\d+)/.exec(unique_product);
	if (m.length != 4) {
		return false;
	}
	product_id = m[1];
	bunker_id = m[2];
	job_id = m[3];
	
	submit_value = "job_id="+job_id+ "&product_id=" + product_id + "&bunker_id="+bunker_id;
	submit_value = submit_value + "&authenticity_token="+ $('authenticity_token').value;
	
	new Ajax.Request('/jobs/remove_product', {
    method: 'post',
    asynchronous: false,
    parameters: submit_value,
    onSuccess: function(transport){
      response = transport.responseText || "no response text";
      if(response == 'SUCCESS') {//update value on screen
      	window.location.reload();
    	} else {
        displayError(response);
      }
    },
    onFailure: function(){ alert('Something went wrong...') }
  });		  
}

function addProductsToExistingJob() {
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
  job_id = $('job_id').value;
  submit_value = "products="+ submit_value + "&job_id="+ job_id +"&authenticity_token="+ $('authenticity_token').value;
  
  new Ajax.Request('/jobs/add_products', {
    method: 'post',
    asynchronous: false,
    parameters: submit_value ,
    onSuccess: function(transport){
      response = transport.responseText || "no response text";
      //alert("transport: " + transport + ":: response: " + response);
      if(response == 'SUCCESS') {
      	window.location.reload();
      } else {
        displayError(response);
      }
    },
    onFailure: function(){ alert('Something went wrong...') }

  });
  //alert(response);
  return response;
}

function validateAndClose() {
	quantities = $$('input[name="quantity[]"]');
	if(quantities.length == 0) {
		bypass_checks = true;
	}
	job_id = $('job_id').value;
	submit_val = 'job_id=' + job_id + "&";
	sep_str = '';
	
	quantities.each(function(s, index) {
		submit_val = submit_val + sep_str;
		sep_str = '||'; 

  		unique_id = s.id.replace('quantity_', '');
		quantity = s.value;
		consumed = parseInt($('consumed_'+unique_id).value.strip());
		junk = parseInt($('junk_'+unique_id).value.strip());
		signin = parseInt($('signin_'+unique_id).value.strip());
		
		consumed = (isNaN(consumed) ? 0 : consumed );
		junk = (isNaN(junk) ? 0 : junk );
		signin = (isNaN(signin) ? 0 : signin );
				
		total = consumed + junk + signin;
		query_str = "C"+consumed+":J"+junk+":S"+signin;
		alert(query_str);
		
		if(quantity != total) {
			displayError("Quantitites do not match");
			break;
			return false;
		}
		submit_val = submit_val + unique_id + "|" + query_str;
	});	
	alert(submit_val);
	return;
	
}