// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
var setup_add_item = function setup_add_item(){
    $('form').on('click', '.add_fields', function() {
        var item_name = $('.ui-autocomplete-input').val();
        var item_id = $('#search_item_id').val();
        var found = $("input.hidden[value=" + item_id + "]");
        if (found.size() > 0) {
            show_duplicate_warning("The Item you are trying to add is already in this order.");
        } else {
            check_duplicate(this,item_name,item_id);
        }
        event.preventDefault();
    });
};

$(document).ready(function () {
    setup_add_item();

    $('#search_item_field').on('railsAutocomplete.select', function(){
        $('.add_fields').click();
    });
});

var show_duplicate_warning = function flash_message(message){
    var duplicate_modal = $('#duplicate_order_item');
    duplicate_modal.find('.modal-body')[0].innerHTML = message;
    duplicate_modal.modal();
};

var check_duplicate = function check_duplicate(elem,item_name,item_id){
    var dom_data = {
        elem: elem,
        item_name: item_name,
        item_id: item_id
    };
    $.ajax({
        url: "/check_duplicate/"+item_id+".json",
        from_dom: dom_data
    }).done(function(data) {
        if($.isEmptyObject(data)) {
            render_new_item(dom_data['elem'], dom_data['item_name'], dom_data['item_id']);
        }else{
            show_duplicate_warning("The Item you are trying to add is already in <a class='btn btn-xs btn-warning' href='"+data[item_id]['url']+"' >order #"+data[item_id]['id']+"</a>");
        }
    });
};

var render_new_item = function render_new_item(elem, item_name, item_id) {
    var t = new Date().getTime();
    var regexp = new RegExp($(elem).data('id'), 'g');
    $(elem).closest('tbody').find('tr.search-box').after($(elem).data('fields').replace(regexp, t));
    var _item = $('#order_order_items_attributes_' + t + '_item');
    var _item_id = $('#order_order_items_attributes_' + t + '_item_id');
    _item.attr('value',item_name);
    _item.val(item_name);
    _item.attr('disabled',true);
    _item_id.attr('value',item_id);
    _item_id.val(item_id);
    $('.ui-autocomplete-input').val('');
    $('#order_order_items_attributes_' + t + '_quantity').focus();
};