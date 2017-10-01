var searchCustomerApp = searchCustomerApp || {};
window.globalSearchCustomerApp = window.globalSearchCustomerApp || {};

(function () {

    var Customer = searchCustomerApp.Customer;

    var SearchCustomerApp = React.createClass({
        getInitialState: function () {
            return {
                result: [],
                searching: false,
                params: {}
            };
        },

        componentWillMount: function(){
            window.globalSearchCustomerApp.callback = function(data) {
                this.setState({result: data});
                this.setState({searching: false});
            }.bind(this);
        },

        handleSubmit: function(event) {
            this.setState({searching: true});
        },

        render: function() {

            var searchForm = (
                <form id="search_customer_form" data-remote="true" acceptCharset="UTF-8" method="get" action="/searches/customers" onSubmit={this.handleSubmit}>
                    <div className="container-fluid">
                        <div className="row">
                            <div className="col-sm-3">
                                <div className="form-group">
                                    <label htmlFor="name">Customer Name: </label>
                                    <input id="name" type="search" className='form-control' name="name" placeholder="Customer Name"></input>
                                </div>
                            </div>
                            <div className="col-sm-3">
                                <div className="form-group">
                                    <label htmlFor="name">Company: </label>
                                    <input id="company" type="search" className='form-control' name="company" placeholder="Company"></input>
                                </div>
                            </div>
                            <div className="col-sm-3">
                                <div className="form-group">
                                    <label htmlFor="phone">Phone Numbers: </label>
                                    <input id="phone" className="form-control" name="phone" placeholder="Phone Number"></input>
                                </div>
                            </div>
                            <div className="col-sm-3">
                                <div className="form-group">
                                    <label htmlFor="tin_no">TIN No: </label>
                                    <input id="tin_no" className="form-control" name="tin_no" placeholder="TIN No"></input>
                                </div>
                            </div>
                        </div>
                        <button id="customer-search-button" className="btn btn-primary btn-block">Search</button>
                    </div>
                    <hr></hr>
                </form>
            );

            var customersResultRow = this.state.result.map(function (customer,index) {
                return (
                    <Customer lineNumber={index+1}
                          key={customer.id}
                          data={customer}/>
                );
            }, this);

            var noResultRow = (
                <tr>
                    <td colSpan="17" className="center-aligned">
                        No Customers Found.
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
                            <th>ID</th>
                            <th>Name</th>
                            <th>Company</th>
                            <th>Phone Number</th>
                            <th>TIN No</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        {this.state.searching ? searchingRow : this.state.result.length == 0 ? noResultRow : customersResultRow}
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
            <SearchCustomerApp />,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('#search-customer-app').length != 0){render($('#search-customer-app'));}
    });
})();