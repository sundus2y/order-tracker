$(document).ready(function (){
    $('#duplicate_items_modal').modal('show');
    $('#duplicate_items_modal').on("click", ".ignore-import", function(event) {
        var row = $(this).closest('tr');
        $(row).animate({backgroundColor:'gray'},500).fadeOut(500,function() {
            $(row).remove();
        });
        event.preventDefault();
    });
});