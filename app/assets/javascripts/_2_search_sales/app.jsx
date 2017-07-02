var searchSaleApp = searchSaleApp || {};
window.globalSearchSaleApp = window.globalSearchSaleApp || {};

(function () {

    var Sale = searchSaleApp.Sale;

    var SearchSaleApp = React.createClass({
        getInitialState: function () {
            return {
                sales: [],
                searching: false,
            };
        },

        componentWillMount: function(){
            window.globalSearchSaleApp.callback = function(data) {
                if(data.searching) {
                    this.setState({searching: true});
                } else {
                    this.setState({searching: false});
                    this.setState({sales: data});
                }
            }.bind(this);
        },

        render: function() {

            var salesResultRow = this.state.sales.map(function (sale,index) {
                return (
                    <Sale key={sale.id} data={sale} />
                );
            }, this);

            var grandTotal = this.state.sales.reduce(function(total,sale){
                if(sale.status_upcase !== 'DRAFT'){
                    total += sale.grand_total;
                }
                return total;
            },0);

            var noResultRow = (
                <tr>
                    <td colSpan="8" className="center-aligned">
                        No Sales Found for the given criteria.
                    </td>
                </tr>
            );

            var searchingRow = (
                <tr>
                    <td colSpan="8" className="center-aligned">
                        <i className="fa fa-spinner fa-spin fa-3x fa-fw" aria-hidden="true"></i>
                        <span className="searching">Loading . . .</span>
                    </td>
                </tr>
            );

            return (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th width="13%">Sales Order #</th>
                        <th>Customer</th>
                        <th>Store</th>
                        <th>Created At</th>
                        <th>Updated At</th>
                        <th width="5%">Status</th>
                        <th>Grand Total</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                        {this.state.searching ? searchingRow : this.state.sales.length == 0 ? noResultRow : salesResultRow}
                    </tbody>
                    <tfoot>
                        <tr>
                            <td className="grand_total" colSpan='6'>
                                <span><b>Grand Total</b></span>
                            </td>
                            <td className="grand_total">
                                <strong>{printCurrency(grandTotal)}</strong>
                            </td>
                            <td></td>
                        </tr>
                    </tfoot>
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