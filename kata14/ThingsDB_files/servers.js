$(document).ready(function(){
  $('#server_dc_rack_id').change(function(event){server.suggest_hostname();});
  $('#server_rack_unit').keyup(function(event){server.suggest_hostname();});
  $('#server_server_id').change(function(event){server.suggest_hostname();});
});

var server = {
  suggest_hostname : function() {
    args = {}
    args['rack_unit']        = $("#server_rack_unit").val();
    args['dc_rack_id']       = $("#server_dc_rack_id").val();
    args['parent_server_id'] = $("#server_server_id").val();

    $.getJSON('/generated_name.json', args, function(data){
      $("#server_hostname").val(data["suggested_name"]);
    });
  }
}

;
