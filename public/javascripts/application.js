// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function updateQuanity()
{
    alert("function called");
    new Ajax.Request('/products/get_existing_quantity', {
    method: 'get',
    parameters: {part_id: 1, bunker_id: 1},
    onSuccess: function(transport){
      var response = transport.responseText || "no response text";
      alert("Success! \n\n" + response);
    },
    onFailure: function(){ alert('Something went wrong...') }

  });

}