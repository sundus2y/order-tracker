var app = app || {};

(function () {


    var SaleItemFooter = app.SaleItemFooter;
    var SaleItem = app.SaleItem;

    function bindSearchSelectEvent() {
        $('#search_item_field').on('railsAutocomplete.select', function (event, object) {
            $('#search_item_id').val(object.item.id);
            $(this).val('');
        });
        $('#search_item_field').on('autocompleteopen', function (event, object) {
            var results = $('ul.ui-autocomplete').find('li');
            $('ul.ui-autocomplete').prepend("" +
                "<li class='autocomplete-header'>" +
                    "<div class='row'>" +
                    "<div class='col-sm-3'>Item Number</div>" +
                    "<div class='col-sm-5'>Name</div>" +
                    "<div class='col-sm-2'>Inventory</div>" +
                    "<div class='col-sm-1'>Brand</div>" +
                    "<div class='col-sm-1'>Origin</div>" +
                    "</div>" +
                "</li>").css('width','80%');
            var indices = [0,1,2,3,4];
            var widths = ['col-sm-3','col-sm-5','col-sm-2','col-sm-1','col-sm-1'];
            renderAutoCompleteResults(results, indices, widths);
        });
    }

    function clearSearchFields(){
        $('#search_item_id').val('');
    }

    var App = React.createClass({
        getInitialState: function () {
            return {
                data: [],
                loadingSaleItems: false
            };
        },

        saveSaleItem: function(saleId,itemId){
            var deferred = $.Deferred();
            var newSaleItem = {
                sale_item: {
                    sale_id: saleId,
                    item_id: itemId,
                    qty: 1,
                    unit_price: 0
                }
            }
            $.ajax({
                type: "POST",
                url: "/sale_items/",
                data: newSaleItem,
                dataType: 'json',
                success: function (data,response) {
                    deferred.resolve({context:this,data:data,message:response});
                }.bind(this),
                error: function(err) {
                    deferred.reject({context:this,err:err,message:'Error'});
                }
            });
            return deferred.promise();
        },

        updateSaleItem: function(saleItem){
            var deferred = $.Deferred();
            var newQtyAndUnitPrice = {
                _method: 'PATCH',
                sale_item: {
                    qty: saleItem.qty,
                    unit_price: saleItem.unit_price
                }
            }
            $.ajax({
                type: "POST",
                url: "/sale_items/"+saleItem.id,
                data: newQtyAndUnitPrice,
                dataType: 'json',
                success: function (data,response) {
                    deferred.resolve({context:this,data:data,message:response});
                }.bind(this),
                error: function(err) {
                    deferred.reject({context:this,err:err,message:'Error'});
                }
            });
            return deferred.promise();
        },

        destroySaleItem: function(saleItem){
            var deferred = $.Deferred();
            $.ajax({
                type: "DELETE",
                url: "/sale_items/"+saleItem.id,
                dataType: 'json',
                success: function (data,response) {
                    deferred.resolve({context:this,data:data,message:response});
                }.bind(this),
                error: function(err) {
                    deferred.reject({context:this,err:err,message:'Error'});
                }
            });
            return deferred.promise();
        },

        getSaleItems: function(saleId){
            var deferred = $.Deferred();
            this.setState({loadingSaleItems: true});
            $.ajax({
                type: "GET",
                url: "/sales/"+saleId+"/sale_items/",
                dataType: 'json',
                success: function(data,response){
                    deferred.resolve({context:this,data:data,message:response});
                    this.setState({loadingSaleItems: false});
                }.bind(this),
                error: function(err) {
                    this.setState({loadingSaleItems: false});
                    deferred.reject({context:this,err:err,message:'Error'});
                }
            });
            return deferred.promise();
        },

        handleSaleItemCreate: function(){
            var itemId = $('#search_item_id').val();
            var saleId = parseInt($('#sale_id').val());
            if (itemId != '') {
                itemId = parseInt(itemId)
                var foundSaleItem = this.state.data.find(function(saleItem){return saleItem.item.id === itemId});
                if (foundSaleItem) {
                    clearSearchFields();
                    alert('Item Already Exists');
                } else {
                    this.saveSaleItem(saleId, itemId).done(function (response) {
                        var self = response.context;
                        var updatedData = [response.data].concat(self.state.data);
                        self.setState({data: updatedData});
                    }).fail(function (response){
                        alert("Error While Trying to Save Sale Item" + response);
                    }).always(clearSearchFields);
                }
            }
        },

        handleSaleItemRemove: function(saleItemToRemove){
            this.destroySaleItem(saleItemToRemove).done(function(response){
                var self = response.context;
                var updatedData = self.state.data.filter(function(saleItem){
                    return saleItem.id != response.data.id;
                });
                self.setState({data: updatedData});
            })
        },

        handleSaleItemUpdate: function(updatedSaleItem){
            this.updateSaleItem(updatedSaleItem).done(function(response){
                var self = response.context;
                var updatedData = self.state.data.map(function(saleItem){
                    if (saleItem.id === response.data.id) {
                        saleItem.qty = response.data.qty;
                        saleItem.unit_price = response.data.unit_price;
                    }
                    return saleItem;
                });
                self.setState({data: updatedData});
            });
        },

        componentDidMount: function(){
            var saleId = $('#sale_id').val();
            bindSearchSelectEvent();
            this.getSaleItems(saleId).done(function(response) {
                var self = response.context;
                self.setState({data: response.data});
            }).fail(function(response){
                alert("Error While Trying to Save Sale Item" + response);
            });
        },

        render: function(){
            var main;
            var saleItemList = this.state.data;
            var grandTotalQty = saleItemList.reduce(function(accum,saleItem){
                var qty = (isNaN(saleItem.qty))? 0 : saleItem.qty;
                return accum + qty;
            },0);
            var grandTotalPrice = saleItemList.reduce(function(accum,saleItem){
                var qty = (isNaN(saleItem.qty))? 0 : saleItem.qty;
                var price = (isNaN(saleItem.unit_price))? 0 : saleItem.unit_price;
                return accum + (qty * price);
            },0);
            var saleItems = saleItemList.map(function (saleItem,index) {
                return (
                    <SaleItem
                        lineNumber={index+1}
                        key={saleItem.id}
                        saleItemData={saleItem}
                        onItemUpdate={this.handleSaleItemUpdate}
                        onSaleItemRemove={this.handleSaleItemRemove}
                        viewOnly={this.props.viewOnly}
                    />
                );
            }, this);

            var loadingItems = (
                <tr>
                    <td colSpan="7" className="center-aligned">
                        <i className="fa fa-spinner fa-spin fa-3x fa-fw" aria-hidden="true"></i>
                        <span className="searching">Loading . . .</span>
                    </td>
                </tr>
            );

            var search = (
                <div id="item_search_row" className="row">
                    <div className="col-sm-4">
                        <div className="field form-group">
                            <input id="search_item_field"
                                   type="text"
                                   className="form-control"
                                   data-autocomplete="/items/autocomplete_item_sale_order"
                                   data-name-element="#search_item_id"
                                   placeholder="Enter item to search. . ."
                                   onSelect={this.handleSaleItemCreate}/>
                            <div className="form-group hidden">
                                <input type="text" id="search_item_id" />
                            </div>
                        </div>
                    </div>
                </div>
            );

            main = (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td>
                                No.
                            </td>
                            <td>
                                <div className="field form-group">
                                    Item Name
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Item Number
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Original Number
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Brand
                                </div>
                            </td>
                            <td width="9%">
                                <div className="field form-group">
                                    Qty
                                </div>
                            </td>
                            <td width="9%">
                                <div className="field form-group">
                                    Unit Price
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Total Price
                                </div>
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        {this.state.loadingSaleItems ? loadingItems : saleItems }
                        <SaleItemFooter
                            grandTotalQty={grandTotalQty}
                            grandTotalPrice={grandTotalPrice}
                        />
                    </tbody>
                </table>
            );

            return (
                <div>
                    {this.props.viewOnly ? '' : search}
                    {main}
                </div>
            );
        }
    });

    function render(viewMode,container) {
        ReactDOM.render(
            <App viewOnly={viewMode}/>,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('.sales_item_app').length != 0){render(false,$('.sales_item_app'));}
        if ($('.sales_item_show_app').length != 0){render(true,$('.sales_item_show_app'));}
    });
})();