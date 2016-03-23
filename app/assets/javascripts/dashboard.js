var itemDataTable = null;
$(document).ready(function () {
    var changeTimer = false;
    itemDataTable = $('#item-results-table').DataTable({
        data: [],
        columns: [
            { data: "name" },
            { data: "original_number" },
            { data: "item_number" },
            { data: "prev_number" },
            { data: "next_number" },
            { data: "description" },
            { data: "car" },
            { data: "model" },
            { data: "make_from" },
            { data: "make_to" },
            { data: "part_class" },
            { data: "t_shop" },
            { data: "l_shop" },
            { data: "l_store" },
            { data: "brand" },
            { data: "made" }
        ]
    });
    $('#dashboard_search').on('keyup',function(){
        var self = this
        if (changeTimer !== false) clearTimeout(changeTimer);
        changeTimer = setTimeout(function(){
            if ($(self).val() == ""){
                $('div.search-result').hide();
                $('div.main-content').show();
            } else {
                $('div.search-result').show();
                $('div.main-content').hide();
                search($(self).val());
            }
            changeTimer = false;
        },500);
    });
});

var search = function search(term){
    $.get('/search/items',{search_term:term})
        .done(function(result){
            itemDataTable.clear().draw();
            itemDataTable.rows.add(result).draw();
        })
}
