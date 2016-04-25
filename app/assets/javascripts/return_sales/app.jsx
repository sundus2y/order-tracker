var returnSalesApp = returnSalesApp || {};

(function () {

    var Store = returnSalesApp.Store;
    var Item = returnSalesApp.Item;
    var Sale = returnSalesApp.Sale;
    var ReturnDialog = returnSalesApp.ReturnDialog;

    var ReturnSalesApp = React.createClass({
        getInitialState: function () {
            return {
                stores: [],
                selectedStore: '-1',
                selectedItem: '',
                sales: [],
                loadingSales: false
            };
        },

        getStores: function(){
            var deferred = $.Deferred();
            $.ajax({
                type: "GET",
                url: "/sales/stores/",
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

        getSales: function(){
            var deferred = $.Deferred();
            var storeId = this.state.selectedStore;
            var itemId = this.state.selectedItem;
            $.ajax({
                type: "GET",
                url: "/sale_items/store/"+storeId+"/item/"+itemId,
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

        handleStoreSelect: function(storeId){
            this.setState({selectedStore: storeId});
        },

        handleItemSelect: function(itemId){
            if (this.state.selectedItem != itemId){
                this.setState({loadingSales: true});
                this.setState({selectedItem: itemId},function(){
                    this.getSales().done(function(response){
                        var self = response.context;
                        self.setState({loadingSales: false});
                        self.setState({sales: response.data});
                    }).fail(function(response){
                        alert("Error While Trying to Load Sales");
                        console.log(response);
                    });
                });
            }
        },

        componentDidMount: function(){
            this.getStores().done(function(response) {
                var self = response.context;
                self.setState({stores: [["--Select Store--",-1]].concat(response.data)});
            }).fail(function(response){
                alert("Error While Trying to Load Stores");
                console.log(response);
            });
        },

        render: function(){
            var itemEnabled = false;
            var saleEnabled = false;
            return (
                <div>
                    <div className="row">
                        <Store data={this.state.stores} onStoreSelect={this.handleStoreSelect}/>
                        <Item disabled={this.state.selectedStore == '-1' ? true : false} onItemSelect={this.handleItemSelect} />
                    </div>
                    <Sale data={this.state.sales} loading={this.state.loadingSales}/>
                </div>
            );
        }
    });

    function renderReturnSalesApp(container) {
        React.render(
            <ReturnSalesApp/>,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('.return_sales_app').length != 0){renderReturnSalesApp($('.return_sales_app'));}
    });
})();