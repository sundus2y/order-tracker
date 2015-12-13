$(document).ready(function (){
    var item_modal = $('#duplicate_items_modal');
    item_modal.modal('show');
    item_modal.on("click", ".ignore-import", function(event) {
        var row = $(this).closest('tr');
        $(row).animate({backgroundColor:'gray'},500).fadeOut(500,function() {
            $(row).remove();
        });
        event.preventDefault();
    });
});