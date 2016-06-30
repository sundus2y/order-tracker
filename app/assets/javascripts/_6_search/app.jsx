var searchItemApp = searchItemApp || {};
window.globalSearchItemApp = window.globalSearchItemApp || {};

(function () {

    var Item = searchItemApp.Item;

    var SearchItemApp = React.createClass({
        getInitialState: function () {
            return {
                result: {}
            };
        },

        componentWillMount: function(){
            window.globalSearchItemApp.callback = function(data) {
                this.setState({result: data});
            }.bind(this);
        },

        render: function() {

            var itemsResultRow = this.state.sales.data.map(function (item,index) {
                return (
                    <Item key={item.id} data={item} />
                );
            }, this);

            var noResultRow = (
                <tr>
                    <td colSpan="6" className="center-aligned">
                        No Items Found.
                    </td>
                </tr>
            );

            return (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th rowspan="2">Actions</th>
                        <th rowspan="2">Name</th>
                        <th rowspan="2">Original number</th>
                        <th rowspan="2">Item number</th>
                        <th rowspan="2">Description</th>
                        <th rowspan="2">Car</th>
                        <th rowspan="2">Model</th>
                        <th colspan="3">Price</th>
                        <th rowspan="2">Inventory</th>
                        <th rowspan="2">Brand</th>
                        <th rowspan="2">Made</th>
                    </tr>
                    <tr>
                        <th>S-Price</th>
                        <th>D-Price</th>
                        <th>K-Price</th>
                    </tr>
                    </thead>
                    <tbody>
                    {this.state.result.data.length == 0 ? noResultRow : itemsResultRow}
                    </tbody>
                </table>
            );
        }
    });

    function render(container) {
        React.render(
            <SearchItemApp />,
            container[0]
        );
    }
    $(document).ready(function(){
        //if ($('#search-items-result').length != 0){render($('#search-items-result'));}
    });
})();