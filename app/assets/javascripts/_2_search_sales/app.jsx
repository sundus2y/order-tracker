var searchSaleApp = searchSaleApp || {};
window.globalSearchSaleApp = window.globalSearchSaleApp || {};

(function () {

    var Sale = searchSaleApp.Sale;

    var SearchSaleApp = React.createClass({
        getInitialState: function () {
            return {
                sales: []
            };
        },

        componentWillMount: function(){
            window.globalSearchSaleApp.callback = function(data) {
                this.setState({sales: data});
            }.bind(this);
        },

        render: function() {

            var salesResultRow = this.state.sales.map(function (sale,index) {
                return (
                    <Sale key={sale.id} data={sale} />
                );
            }, this);

            var noResultRow = (
                <tr>
                    <td colSpan="6" className="center-aligned">
                        No Sales Found for the given criteria.
                    </td>
                </tr>
            );

            return (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th width="13%">Sales Order #</th>
                        <th>Customer</th>
                        <th>Created At</th>
                        <th width="5%">Status</th>
                        <th>Grand Total</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                        {this.state.sales.length == 0 ? noResultRow : salesResultRow}
                    </tbody>
                </table>
            );
        }
    });

    function render(container) {
        React.render(
            <SearchSaleApp />,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('#sales_search_results').length != 0){render($('#sales_search_results'));}
    });
})();