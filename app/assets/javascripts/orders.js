// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
var setup_search_item = function setup_search_item() {
    $('form').on('blur keyup', '.ui-autocomplete-input', function() {
        var selected_item = $('#search_item_id');
        if(selected_item.val() == ""){
            $('.add_fields').attr('disabled',true);
        }
        else {
            $('.add_fields').attr('disabled',false);
        }
    });
};

var setup_add_item = function setup_add_item(){
    $('form').on('click', '.add_fields', function() {
        var item_name = $('.ui-autocomplete-input').val();
        var item_id = $('#search_item_id').val();
        var found = $("input.hidden[value=" + item_id + "]");
        if (found.size() > 0) {
            flash_message("Duplicate", "The Item you are trying to add is already in this order.", "danger");
        } else {
            check_duplicate(this,item_name,item_id);
        }

        event.preventDefault();
    });
};

var setup_remove_item = function setup_remove_item(){
    $('form').on('click', '.remove-item', function() {
        //$(this).closest('tr').remove();
        //event.preventDefault();
    });
};

$(document).ready(function () {
    setup_search_item();
    setup_add_item();
    setup_remove_item();
});

$(document).on("page:load", function(){
    setup_search_item();
    setup_add_item();
    setup_remove_item();
});

var flash_message = function flash_message(name,message,type){
    var body = "<div class='alert alert-"+type+"'>"+
                    "<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>X</button>"+
                    "<div id='flash_"+name+"'>"+message+"</div>"
                "</div>"
    $('main').prepend(body);
}

var check_duplicate = function check_duplicate(elem,item_name,item_id){
    dom_data = {
        elem: elem,
        item_name: item_name,
        item_id: item_id
    }
    $.ajax({
        url: "/check_duplicate/"+item_id+".json",
        from_dom: dom_data
    }).done(function(data) {
        if($.isEmptyObject(data)) {
            render_new_item(dom_data['elem'], dom_data['item_name'], dom_data['item_id']);
        }else{
            flash_message("Duplicate", "The Item you are trying to add is already in <a href='"+data[item_id]['url']+"' >order#"+data[item_id]['id']+"</a>", "danger");
        }
    });
}

var render_new_item = function render_new_item(elem, item_name, item_id) {
    var t = new Date().getTime();
    var regexp = new RegExp($(elem).data('id'), 'g');
    $(elem).closest('tbody').find('tr.search-box').after($(elem).data('fields').replace(regexp, t));
    $('#order_order_items_attributes_' + t + '_item').attr('value',item_name);
    $('#order_order_items_attributes_' + t + '_item').val(item_name);
    $('#order_order_items_attributes_' + t + '_item_id').attr('value',item_id);
    $('#order_order_items_attributes_' + t + '_item_id').val(item_id);
}