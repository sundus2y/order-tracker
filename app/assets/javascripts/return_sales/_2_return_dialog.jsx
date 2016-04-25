var returnSalesApp = returnSalesApp || {};

(function () {

    returnSalesApp.ReturnDialog = React.createClass({

        getInitialState() {
            return {
                showModal: false
            };
        },

        close() {
            this.setState({showModal: false});
        },

        open() {
            this.setState({showModal: true});
        },

        render() {
            var qty_options = [];
            for (var i=1; i <= this.props.data.qty; i++) {
                qty_options.push(<option value={i}>{i}</option>);
            }

            return (
                <div>
                    <a onClick={this.open} href="#" className="btn btn-sm btn-danger fa fa-undo"> Return Sale</a>
                    <ReactBootstrap.Modal show={this.state.showModal || this.props.show} onHide={this.close}>
                        <ReactBootstrap.Modal.Header closeButton>
                            <ReactBootstrap.Modal.Title>Return Item</ReactBootstrap.Modal.Title>
                        </ReactBootstrap.Modal.Header>
                        <ReactBootstrap.Modal.Body>
                            <p>
                                Are you sure you want to return <b>{this.props.data.item_name} </b>
                                 from sale <b>#{this.props.data.sale_id}</b> of customer <b>{this.props.data.customer_name}</b> ?
                            </p>
                            <div className="row">
                                <div className="col-md-3">
                                    <div className="field form-group">
                                        Qunatity: <select className="form-control">{qty_options}</select> <br/>
                                    </div>
                                </div>
                                <div className="col-md-3">
                                    <div className="field form-group">
                                        Unit Price: <input defaultValue={this.props.data.unit_price} disabled="true" className="form-control"/> <br/>
                                    </div>
                                </div>
                                <div className="col-md-6">
                                    <div className="field form-group">
                                        Note: <textarea className="form-control">
                                                This Item was returned because . . .
                                            </textarea>
                                    </div>
                                </div>
                            </div>
                        </ReactBootstrap.Modal.Body>
                        <ReactBootstrap.Modal.Footer>
                            <a href='#' className="btn btn-sm btn-danger fa fa-undo" onClick={this.close}> Return</a>
                            <a href='#' className="btn btn-sm btn-info fa fa-times" onClick={this.close}> Cancel</a>
                        </ReactBootstrap.Modal.Footer>
                    </ReactBootstrap.Modal>
                </div>
            );
        }
    });

})();