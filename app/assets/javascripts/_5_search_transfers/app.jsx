var searchTransferApp = searchTransferApp || {};
window.globalSearchTransferApp = window.globalSearchTransferApp || {};

(function () {

    var Transfer = searchTransferApp.Transfer;

    var SearchTransferApp = createReactClass({
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
                    <td colSpan="9" className="center-aligned">
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
                        <th>Sender</th>
                        <th>To Store</th>
                        <th>Receiver</th>
                        <th width="5%">Status</th>
                        <th width="8%">Total <br/>Item Type</th>
                        <th width="8%">Total <br/>Item Qty</th>
                        <th width="7%">Actions</th>
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
        ReactDOM.render(
            <SearchTransferApp />,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('#transfers_search_results').length != 0){render($('#transfers_search_results'));}
    });
})();