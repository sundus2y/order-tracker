var searchItemApp = searchItemApp || {};
window.globalSearchItemApp = window.globalSearchItemApp || {};

(function () {

    var Item = searchItemApp.Item;

    var SearchItemApp = React.createClass({
        getInitialState: function () {
            return {
                result: [],
                params: {},
                lookup: {cars:[],part_classes:[], mades:[], brands:[]},
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

        componentDidMount: function(){
            this.getItemLookup().done(function(response) {
                var self = response.context;
                self.setState({lookup: response.data});
            }).fail(function(response){
                alert("Error While Trying to load lookup" + response);
            });
        },

        componentWillMount: function(){
            window.globalSearchItemApp.callback = function(data) {
                this.setState({result: data});
            }.bind(this);
        },

        render: function() {

            var selectOptions = function(item,index){
                return (
                    <option key={index}>{item}</option>
                )
            };

            var searchForm = (
                <form id="search_item_form" data-remote="true" acceptCharset="UTF-8" method="get" action="/search/items">
                    <div className="row">
                        <div className="col-md-4">
                            <div className="form-group">
                                <label htmlFor="name">Name: </label>
                                <input id="name" className='form-control' name="name" placeholder="Item Name"></input>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="item_number">Item Number: </label>
                                <input id="item_number" className="form-control" name="item_number" placeholder="Item Number"></input>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="original_number">Original Number: </label>
                                <input id="original_number" className="form-control" name="original_number" placeholder="Original Number"></input>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="prev_number">Prev Number: </label>
                                <input id="prev_number" className="form-control" name="prev_number" placeholder="Previous Number"></input>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="next_number">Next Number: </label>
                                <input id="next_number" className="form-control" name="next_number" placeholder="Next Number"></input>
                            </div>
                        </div>
                    </div>
                    <div className="row">
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="car">Car: </label>
                                <select id="car" className="form-control" name="car" placeholder="Car">
                                    <option value=''></option>
                                    {this.state.lookup.cars.map(selectOptions)}
                                </select>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="brand">Brand: </label>
                                <select id="brand" className="form-control" name="brand" placeholder="Brand">
                                    <option value=''></option>
                                    {this.state.lookup.brands.map(selectOptions)}
                                </select>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="made">Made: </label>
                                <select id="made" className="form-control" name="made" placeholder="Made">
                                    <option value=''></option>
                                    {this.state.lookup.mades.map(selectOptions)}
                                </select>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="next_number">Part Class: </label>
                                <select id="part_class" className="form-control" name="part_class" placeholder="Part Class">
                                    <option value=''></option>
                                    {this.state.lookup.part_classes.map(selectOptions)}
                                </select>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="sale_price">Sale Price: </label>
                                <input id="sale_price" className="form-control" name="sale_price" placeholder="Sale Price"></input>
                            </div>
                        </div>
                        <div className="col-md-2">
                            <div className="form-group">
                                <label htmlFor="korea_price">Korea Price: </label>
                                <input id="korea_price" className="form-control" name="korea_price" placeholder="Korea Price"></input>
                            </div>
                        </div>
                    </div>
                    <button id="item-search-button" className="btn btn-primary btn-block">Search</button>
                    <hr></hr>
                </form>
            );

            var itemsResultRow = this.state.result.map(function (item,index) {
                return (
                    <Item lineNumber={index+1}
                          key={item.id}
                          data={item} />
                );
            }, this);

            var noResultRow = (
                <tr>
                    <td colSpan="11" className="center-aligned">
                        No Items Found.
                    </td>
                </tr>
            );

            var searchResult =  (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th width="3%">ID</th>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Original Number</th>
                        <th>Item Number</th>
                        <th>Prev Number</th>
                        <th>Next Number</th>
                        <th width="4%">Car</th>
                        <th width="10%">Price</th>
                        <th width="9%">Stock</th>
                        <th>Brand</th>
                        <th>Made</th>
                        <th width="6%">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    {this.state.result.length == 0 ? noResultRow : itemsResultRow}
                    </tbody>
                </table>
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