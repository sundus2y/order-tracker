var searchItemApp = searchItemApp || {};
window.globalSearchItemApp = window.globalSearchItemApp || {};

(function () {

    var Item = searchItemApp.Item;

    var SearchItemApp = React.createClass({
        getInitialState: function () {
            return {
                result: [],
                searching: false,
                params: {},
                lookup: {cars:[],part_classes:[], mades:[], brands:[]},
                config: {}
            };
        },

        getItemLookup: function(){
            var deferred = $.Deferred();
            $.ajax({
                type: "GET",
                url: "/search/item_lookup/",
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

        getConfig: function(){
            var deferred = $.Deferred();
            $.ajax({
                type: "GET",
                url: "/configs",
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

        componentDidMount: function(){
            this.getItemLookup().done(function(response) {
                var self = response.context;
                self.setState({lookup: response.data});
            }).fail(function(response){
                alert("Error While Trying to load lookup" + response);
            });
            this.getConfig().done(function(response){
                var self = response.context;
                self.setState({config: response.data});
            }).fail(function(response){
                alert('Error While Trying to Load Config Values' + response);
            });
        },

        componentWillMount: function(){
            window.globalSearchItemApp.callback = function(data) {
                this.setState({result: data});
                this.setState({searching: false});
            }.bind(this);
        },

        handleSubmit: function(event) {
            this.setState({searching: true});
        },

        render: function() {

            var selectOptions = function(item,index){
                return (
                    <option key={index}>{item}</option>
                )
            };

            var searchForm = (
                <form id="search_item_form" data-remote="true" acceptCharset="UTF-8" method="get" action="/search/items" onSubmit={this.handleSubmit}>
                    <div className="container-fluid">
                        <div className="row">
                            <div className="col-sm-4">
                                <div className="form-group">
                                    <label htmlFor="name">Name: </label>
                                    <input id="name" type="search" results='5'  autosave='name_search_hs' className='form-control' name="name" placeholder="Item Name"></input>
                                </div>
                            </div>
                            <div className="col-sm-2">
                                <div className="form-group">
                                    <label htmlFor="item_number">Item Number: </label>
                                    <input id="item_number" className="form-control" name="item_number" placeholder="Item Number"></input>
                                </div>
                            </div>
                            <div className="col-sm-3">
                                <div className="form-group">
                                    <label htmlFor="other_numbers">Other Numbers: </label>
                                    <input id="other_numbers" className="form-control" name="other_numbers" placeholder="Original/Prev/Next Number or Description"></input>
                                </div>
                            </div>
                            <div className="col-sm-1">
                                <div className="form-group">
                                    <label htmlFor="other_numbers">Size: </label>
                                    <input id="size" className="form-control" name="size" placeholder="Size"></input>
                                </div>
                            </div>
                            <div className="col-sm-1">
                                <div className="form-group">
                                    <label htmlFor="made">Made: </label>
                                    <input id="made" name="made" className='form-control' list="mades"/>
                                    <datalist id="mades">
                                        {this.state.lookup.mades.map(selectOptions)}
                                    </datalist>
                                </div>
                            </div>
                            <div className="col-sm-1">
                                <div className="checkbox">
                                    <label>
                                        <input id="inventory" name="inventory" type="checkbox"/>Show only Items with Inventory
                                    </label>
                                </div>
                            </div>
                        </div>
                        <div className="row">
                            <div className="col-sm-2">
                                <div className="form-group">
                                    <label htmlFor="car">Car: </label>
                                    <input id="car" name="car" className='form-control' list="cars"/>
                                    <datalist id="cars">
                                        {this.state.lookup.cars.map(selectOptions)}
                                    </datalist>
                                </div>
                            </div>
                            <div className="col-sm-2">
                                <div className="form-group">
                                    <label htmlFor="brand">Brand: </label>
                                    <input id="brand" name="brand" className='form-control' list="brands"/>
                                    <datalist id="brands">
                                        {this.state.lookup.brands.map(selectOptions)}
                                    </datalist>
                                </div>
                            </div>
                            <div className="col-sm-2">
                                <div className="form-group">
                                    <label htmlFor="part_class">Part Class: </label>
                                    <input id="part_class" name="part_class" className='form-control' list="part_classes"/>
                                    <datalist id="part_classes">
                                        {this.state.lookup.part_classes.map(selectOptions)}
                                    </datalist>
                                </div>
                            </div>
                            <div className="col-sm-2">
                                <div className="form-group">
                                    <label htmlFor="sale_price">Sale Price: </label>
                                    <input id="sale_price" className="form-control" name="sale_price" placeholder="Sale Price"></input>
                                </div>
                            </div>
                            <div className="col-sm-2">
                                <div className="form-group">
                                    <label htmlFor="dubai_price">Dubai Price: </label>
                                    <input id="dubai_price" className="form-control" name="dubai_price" placeholder="Dubai Price"></input>
                                </div>
                            </div>
                            <div className="col-sm-2">
                                <div className="form-group">
                                    <label htmlFor="korea_price">Korea Price: </label>
                                    <input id="korea_price" className="form-control" name="korea_price" placeholder="Korea Price"></input>
                                </div>
                            </div>
                        </div>
                        <button id="item-search-button" className="btn btn-primary btn-block">Search</button>
                    </div>
                    <hr></hr>
                </form>
            );

            var itemsResultRow = this.state.result.map(function (item,index) {
                return (
                    <Item lineNumber={index+1}
                          key={item.id}
                          data={item}
                          config={this.state.config}/>
                );
            }, this);

            var noResultRow = (
                <tr>
                    <td colSpan="17" className="center-aligned">
                        No Items Found.
                    </td>
                </tr>
            );

            var searchingRow = (
                <tr>
                    <td colSpan="17" className="center-aligned">
                        <i className="fa fa-spinner fa-spin fa-3x fa-fw" aria-hidden="true"></i>
                        <span className="searching">Loading . . .</span>
                    </td>
                </tr>
            );

            var searchResult =  (
                <div className="table-container">
                    <table className="table-responsive display table table-striped table-bordered">
                        <thead>
                        <tr>
                            <th width="3%" rowSpan="2">ID</th>
                            <th rowSpan="2">Name</th>
                            <th rowSpan="2">Description</th>
                            <th rowSpan="2">Original Number</th>
                            <th rowSpan="2">Item Number</th>
                            <th rowSpan="2">Prev Number</th>
                            <th rowSpan="2">Next Number</th>
                            <th width="4%" rowSpan="2">Car</th>
                            <th colSpan="4" className="center-aligned">Price</th>
                            <th width="9%" rowSpan="2">Stock</th>
                            <th width="9%" rowSpan="2">Order</th>
                            <th rowSpan="2">Brand</th>
                            <th rowSpan="2">Made</th>
                            <th width="7%" rowSpan="2">Actions</th>
                        </tr>
                        <tr>
                            <th>Sale</th>
                            <th>Dubai</th>
                            <th>Korea</th>
                            <th>Cost</th>
                        </tr>
                        </thead>
                        <tbody>
                        {this.state.searching ? searchingRow : this.state.result.length == 0 ? noResultRow : itemsResultRow}
                        </tbody>
                    </table>
                </div>
            );

            return (
                <div>
                    {searchForm}
                    {searchResult}
                </div>
            )
        }
    });

    function render(container) {
        React.render(
            <SearchItemApp />,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('#search-item-app').length != 0){render($('#search-item-app'));}
    });
})();