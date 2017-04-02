var returnSalesApp = returnSalesApp || {};

(function () {

    returnSalesApp.Item = React.createClass({

        handleItemSelect: function(){
            var itemId = $('#search_item_id').val();
            if (itemId != '') {
                this.props.onItemSelect(itemId);
            }
        },

        componentDidMount: function(){
            $('#search_item_field').on('railsAutocomplete.select', function (event, object) {
                $('#search_item_id').val(object.item.id);
                $(this).val('');
            });

            $('#search_item_field').on('autocompleteopen', function (event, object) {
                var results = $('ul.ui-autocomplete').find('li');
                $('ul.ui-autocomplete').prepend("" +
                    "<li class='autocomplete-header'>" +
                    "<div class='row'>" +
                    "<div class='col-sm-4' data-index='0'>Origninal Number</div>" +
                    "<div class='col-sm-8' data-index='1'>Name</div>" +
                    "</div>" +
                    "</li>").css('width','40%');
                var indices = [0,1];
                var widths = ['col-sm-4','col-sm-8'];
                renderAutoCompleteResults(results, indices, widths);
            });
        },

        render: function() {
            return (
                <div className="col-sm-9">
                    <div className="field form-group">
                        <label>Item</label>
                        <span id="item-autocomplete">
                            <input className="form-control" id="search_item_field"
                                   type="text"
                                   data-autocomplete="/items/autocomplete_item_sale_price"
                                   data-name-element="#search_item_id"
                                   placeholder="Enter item to return. . ."
                                   disabled={this.props.disabled}
                                   onSelect={this.handleItemSelect}/>
                            <div className="form-group hidden">
                                <input type="text" id="search_item_id" />
                            </div>
                        </span>
                        <span className="input-group" id="selected-item">
                            <input className="form-control" readOnly="true"/>
                        <span id="selected-item-close" className="selected-ac-close input-group-addon">X</span>
                    </span>
                    </div>
                </div>
            );
        }
    });
})();