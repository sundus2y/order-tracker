var returnSalesApp = returnSalesApp || {};

(function () {

    var ReturnItem = returnSalesApp.ReturnItem;

    returnSalesApp.Sale = React.createClass({

        render: function() {
            var loadingRow = (
                <tr>
                    <td colSpan="7" className="center-aligned">
                        <i className="fa fa-spinner fa-pulse fa-3x fa-fw margin-bottom"></i>
                    </td>
                </tr>
            );

            var noResultRow = (
                <tr>
                    <td colSpan="7" className="center-aligned">
                        No Sales Found for the selected Item.
                    </td>
                </tr>
            );

            var resultsRow = this.props.data.map(function(sale_item,index){
                return (
                    <ReturnItem saleItem={sale_item} index={index+1}/>
                );
            },this);

            var tHead = (
                <thead>
                    <tr>
                        <td>
                            No.
                        </td>
                        <td>
                            <div className="field form-group">
                                Customer
                            </div>
                        </td>
                        <td>
                            <div className="field form-group">
                                Item
                            </div>
                        </td>
                        <td>
                            <div className="field form-group">
                                Sale Number
                            </div>
                        </td>
                        <td>
                            <div className="field form-group">
                                Sale Date
                            </div>
                        </td>
                        <td>
                            <div className="field form-group">
                                Sale Detail
                            </div>
                        </td>
                        <td>
                            <div className="field form-group">
                                Action
                            </div>
                        </td>
                    </tr>
                </thead>
            );
            return (
                <div className="field form-group">
                    <label>Sales With Selected Item and Store</label>
                    <table className="table-responsive display table table-striped table-bordered">
                        {tHead}
                        <tbody>
                            {this.props.loading ? loadingRow : (this.props.data.length == 0 ? noResultRow : resultsRow) }
                        </tbody>
                    </table>
                </div>
            );
        }
    });
})();