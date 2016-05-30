var searchSaleApp = searchSaleApp || {};
window.globalSalesIndexApp = window.globalSalesIndexApp || {};

(function () {

    var Sale2 = searchSaleApp.Sale;

    var SalesIndexApp = React.createClass({
        getInitialState: function () {
            return {
                sales: []
            };
        },

        componentWillMount: function(){
            window.globalSalesIndexApp.callback = function(data) {
                this.setState({sales: data});
            }.bind(this);
        },

        render: function() {

            var salesResultRow = this.state.sales.map(function (sale,index) {
                return (
                    <Sale2 key={sale.id} data={sale} />
                );
            }, this);

            var noResultRow = (
                <tr>
                    <td colSpan="6" className="center-aligned">
                        No Sales Found for the selected store.
                    </td>
                </tr>
            );

            return (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th width="5%">Att #</th>
                        <th>Customer</th>
                        <th>Created at</th>
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
            <SalesIndexApp />,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('#store_sales').length != 0){render($('#store_sales'));}
    });
})();