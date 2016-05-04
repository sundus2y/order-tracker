var itemDataTable = null;

(function (){
    $(document).ready(function () {
        var changeTimer = false;
        itemDataTable = $('#item-results-table').DataTable({
            data: [],
            columns: [
                { data: "actions" },
                { data: "name" },
                { data: "original_number" },
                { data: "item_number" },
                { data: "prev_number" },
                { data: "next_number" },
                { data: "description" },
                { data: "car" },
                { data: "model" },
                { data: "sale_price" },
                { data: "dubai_price" },
                { data: "korea_price" },
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
                debugger;
                itemDataTable.rows.add(result).draw();
            })
    };
})();
