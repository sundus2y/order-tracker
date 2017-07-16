var app = app || {};

(function () {


    var TransferItemFooter = app.TransferItemFooter;
    var TransferItem = app.TransferItem;

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
                "</li>").css('width','75%');
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
                data: []
            };
        },

        saveTransferItem: function(transferId,itemId){
            var deferred = $.Deferred();
            var newTransferItem = {
                transfer_item: {
                    transfer_id: transferId,
                    item_id: itemId,
                    qty: 1
                }
            }
            $.ajax({
                type: "POST",
                url: "/transfer_items/",
                data: newTransferItem,
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

        updateTransferItem: function(transferItem){
            var deferred = $.Deferred();
            var newQty = {
                _method: 'PATCH',
                transfer_item: {
                    qty: transferItem.qty,
                    location: transferItem.location
                }
            }
            $.ajax({
                type: "POST",
                url: "/transfer_items/"+transferItem.id,
                data: newQty,
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

        destroyTransferItem: function(transferItem){
            var deferred = $.Deferred();
            $.ajax({
                type: "DELETE",
                url: "/transfer_items/"+transferItem.id,
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

        getTransferItems: function(transferId){
            var deferred = $.Deferred();
            $.ajax({
                type: "GET",
                url: "/transfers/"+transferId+"/transfer_items/",
                dataType: 'json',
                success: function(data,response){
                    deferred.resolve({context:this,data:data,message:response});
                }.bind(this),
                error: function(err) {
                    deferred.reject({context:this,err:err,message:'Error'});
                }
            });
            return deferred.promise();
        },

        handleTransferItemCreate: function(){
            var itemId = $('#search_item_id').val();
            var transferId = parseInt($('#transfer_id').val());
            if (itemId != '') {
                itemId = parseInt(itemId)
                var foundTransferItem = this.state.data.find(function(transferItem){return transferItem.item.id === itemId});
                if (foundTransferItem) {
                    clearSearchFields();
                    alert('Item Already Exists');
                } else {
                    this.saveTransferItem(transferId, itemId).done(function (response) {
                        var self = response.context;
                        var updatedData = [response.data].concat(self.state.data);
                        self.setState({data: updatedData});
                    }).fail(function (response){
                        alert("Error While Trying to Save Transfer Item" + response);
                    }).always(clearSearchFields);
                }
            }
        },

        handleTransferItemRemove: function(transferItemToRemove){
            this.destroyTransferItem(transferItemToRemove).done(function(response){
                var self = response.context;
                var updatedData = self.state.data.filter(function(transferItem){
                    return transferItem.id != response.data.id;
                });
                self.setState({data: updatedData});
            })
        },

        handleTransferItemUpdate: function(updatedTransferItem){
            this.updateTransferItem(updatedTransferItem).done(function(response){
                var self = response.context;
                var updatedData = self.state.data.map(function(transferItem){
                    if (transferItem.id === response.data.id) {
                        transferItem.qty = response.data.qty;
                        transferItem.location = response.location;
                    }
                    return transferItem;
                });
                self.setState({data: updatedData});
            });
        },

        componentDidMount: function(){
            var transferId = $('#transfer_id').val();
            bindSearchSelectEvent();
            this.getTransferItems(transferId).done(function(response) {
                var self = response.context;
                self.setState({data: response.data});
            }).fail(function(response){
                alert("Error While Trying to Save Transfer Item" + response);
            });
        },

        render: function(){
            var main;
            var transferItemList = this.state.data;
            var grandTotalQty = transferItemList.reduce(function(accum,transferItem){
                var qty = (isNaN(transferItem.qty))? 0 : transferItem.qty;
                return accum + qty;
            },0);
            var grandTotalPrice = transferItemList.reduce(function(accum,transferItem){
                var qty = (isNaN(transferItem.qty))? 0 : transferItem.qty;
                var price = (isNaN(transferItem.item.sale_price))? 0 : transferItem.item.sale_price;
                return accum + (qty * price);
            },0);

            var transferItems = transferItemList.map(function (transferItem,index) {
                return (
                    <TransferItem
                        lineNumber={index+1}
                        key={transferItem.id}
                        transferItemData={transferItem}
                        onItemUpdate={this.handleTransferItemUpdate}
                        onTransferItemRemove={this.handleTransferItemRemove}
                        viewOnly={this.props.viewOnly}
                    />
                );
            }, this);

            var search = (
                <div className="row">
                    <div className="col-sm-4">
                        <div className="field form-group">
                            <input id="search_item_field"
                                   type="text"
                                   className="form-control"
                                   data-autocomplete="/items/autocomplete_item_sale_order"
                                   data-name-element="#search_item_id"
                                   placeholder="Enter item to search. . ."
                                   onSelect={this.handleTransferItemCreate}/>
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
                                    Description
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Location
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
                        {transferItems}
                        <TransferItemFooter
                            grandTotalQty={grandTotalQty}
                            grandTotalPrice={grandTotalPrice}
                        />
                    </tbody>
                </table>
            );

            return (
                <div className="container-fluid">
                    {this.props.viewOnly ? '' : search}
                    {main}
                </div>
            );
        }
    });

    function render(viewMode,container) {
        React.render(
            <App viewOnly={viewMode}/>,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('.transfer_items_app').length != 0){render(false,$('.transfer_items_app'));}
        if ($('.transfer_items_show_app').length != 0){render(true,$('.transfer_items_show_app'));}
    });
})();