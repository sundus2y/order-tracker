var SearchProformaApp = SearchProformaApp || {};

(function () {

    var Proforma = SearchProformaApp.Proforma;

    SearchProformaApp.App = createReactClass({
        getInitialState: function () {
            return {
                proformas: [],
                searching: false,
            };
        },

        componentWillMount: function(){
            SearchProformaApp.callback = function(data) {
                if(data.searching) {
                    this.setState({searching: true});
                } else {
                    this.setState({searching: false});
                    this.setState({proformas: data});
                }
            }.bind(this);
        },

        render: function() {

            var proformasResultRow = this.state.proformas.map(function (proforma,index) {
                return (
                    <Proforma key={proforma.id} data={proforma} />
                );
            }, this);

            var grandTotal = this.state.proformas.reduce(function(total,proforma){
                if(proforma.status_upcase !== 'DRAFT'){
                    total += proforma.grand_total;
                }
                return total;
            },0);

            var noResultRow = (
                <tr>
                    <td colSpan="9" className="center-aligned">
                        No Proforma Found for the given criteria.
                    </td>
                </tr>
            );

            var searchingRow = (
                <tr>
                    <td colSpan="9" className="center-aligned">
                        <i className="fa fa-spinner fa-spin fa-3x fa-fw" aria-hidden="true"></i>
                        <span className="searching">Loading . . .</span>
                    </td>
                </tr>
            );

            return (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th width="13%">Proforma #</th>
                        <th>Customer</th>
                        <th>Store</th>
                        <th>Created At</th>
                        <th>Updated At</th>
                        <th>Sold At</th>
                        <th width="5%">Status</th>
                        <th>Grand Total</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                        {this.state.searching ? searchingRow : this.state.proformas.length == 0 ? noResultRow : proformasResultRow}
                    </tbody>
                    <tfoot>
                        <tr>
                            <td className="grand_total" colSpan='7'>
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
        var App = SearchProformaApp.App;
        ReactDOM.render(
            <App />,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('#proformas_search_results').length != 0){render($('#proformas_search_results'));}
    });
})();