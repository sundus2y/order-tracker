var searchTransferApp = searchTransferApp || {};
window.globalSearchTransferApp = window.globalSearchTransferApp || {};

(function () {

    var Transfer = searchTransferApp.Transfer;

    var SearchTransferApp = React.createClass({
        getInitialState: function () {
            return {
                transfers: []
            };
        },

        componentWillMount: function(){
            window.globalSearchTransferApp.callback = function(data) {
                this.setState({transfers: data});
            }.bind(this);
        },

        render: function() {

            var transfersResultRow = this.state.transfers.map(function (transfer,index) {
                return (
                    <Transfer key={transfer.id} data={transfer} />
                );
            }, this);

            var noResultRow = (
                <tr>
                    <td colSpan="6" className="center-aligned">
                        No Transfers Found for the given criteria.
                    </td>
                </tr>
            );

            return (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                    <tr>
                        <th width="6%">Tran #</th>
                        <th>From Store</th>
                        <th>To Store</th>
                        <th width="5%">Status</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                        {this.state.transfers.length == 0 ? noResultRow : transfersResultRow}
                    </tbody>
                </table>
            );
        }
    });

    function render(container) {
        React.render(
            <SearchTransferApp />,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('#transfers_search_results').length != 0){render($('#transfers_search_results'));}
    });
})();