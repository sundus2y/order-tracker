// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
var setup_add_item = function setup_add_item(){
    $('form').on('click', '.add_fields', function(e,a) {
        var item_name = $('.ui-autocomplete-input').val();
        var item_id = $('#search_item_id').val();
        var item_description = $('#search_item_description').val();
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

    $('#search_item_field').on('railsAutocomplete.select', function(event,object){
        $('#search_item_id').val(object.item.id);
        $('#search_item_name').val(object.item.name);
        $('#search_item_number').val(object.item.item_number);
        $('#search_original_number').val(object.item.original_number);
        $('#search_description').val(object.item.description);
        $('.add_fields').click();
    });

    $('.select').on('click', function(){
        var check_boxes = $('.select:checked');
        if (check_boxes.size() > 0) {
            $('.open-selected').removeAttr('disabled');
        }
        else{
            $('.open-selected').attr('disabled',true);
        }
    });

    $('.open-selected').on('click', function(event){
        var selected = $('.select:checked');
        event.preventDefault();
    });

    var previous_brand;
    $('#order_brand').on('focus',function(){
         previous_brand = this.value;
    }).change(function(event){
        var item_ids = []
        var order_id = $('#order-id').val();
        $('input.item-id').each(function(){
            item_ids.push(this.value);
        });
        var elem = this;
        item_ids = item_ids.join(',');
        $.ajax({
            url: "/check_duplicate/"+item_ids+"/"+elem.value+"/"+order_id+".json",
            elem: elem
        }).done(function(data){
            if(!$.isEmptyObject(data)) {
                var warning_msg = "The following Item/s where found on other orders, so you can't change the brand.<br>";
                warning_msg += "<ul>";
                $.each(data,function(index,item){
                    warning_msg += "<li>";
                    warning_msg += item['item_name']+" is already in <a class='btn btn-xs btn-warning' href='"+item['url']+"' >order #"+item['order_id']+"</a>";
                    warning_msg += "</li>";
                });
                show_duplicate_warning(warning_msg);
                $(elem).val(previous_brand);
            }
        })
    });
});

var show_duplicate_warning = function flash_message(message){
    var duplicate_modal = $('#duplicate_order_item');
    duplicate_modal.find('.modal-body')[0].innerHTML = message;
    duplicate_modal.modal();
};

var check_duplicate = function check_duplicate(elem,item_name,item_id){
    var brand = $('#order_brand').val();
    var dom_data = {
        elem: elem,
        item_name: item_name,
        item_id: item_id
    };
    var order_id = $('#order-id').val();
    $.ajax({
        url: "/check_duplicate/"+item_id+"/"+brand+"/"+order_id+".json",
        from_dom: dom_data
    }).done(function(data) {
        if($.isEmptyObject(data)) {
            render_new_item(dom_data['elem'], dom_data['item_name'], dom_data['item_id']);
        }else{
            show_duplicate_warning("The Item <b>("+data[0]['item_name']+")</b> you are trying to add is already in <a class='btn btn-xs btn-warning' href='"+data[0]['url']+"' >order #"+data[0]['order_id']+"</a>");
        }
    });
};

var render_new_item = function render_new_item(elem, item_name, item_id) {
    var t = new Date().getTime();
    var regexp = new RegExp($(elem).data('id'), 'g');
    $(elem).closest('tbody').find('tr.search-box').after($(elem).data('fields').replace(regexp, t));
    $(elem).closest('tbody').find('tr.search-box').next().velocity("fadeIn", { duration: 900 });
    var _item = ['item_name','item_id','item_number','original_number','description'];

    $.each(_item,function(index,item){
        var _item_field = $('#order_order_items_attributes_' + t + '_' + item);
        var _item_value = $('#search_'+item).val();
        _item_field.attr('value',_item_value);
        _item_field.val(_item_value);
        _item_field.attr('readonly','readonly');
    });

    $('.ui-autocomplete-input').val('');
    $('#order_order_items_attributes_' + t + '_quantity').focus();
};