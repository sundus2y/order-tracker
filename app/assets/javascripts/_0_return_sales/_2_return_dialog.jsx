var returnSalesApp = returnSalesApp || {};

(function () {

    returnSalesApp.ReturnDialog = React.createClass({

        getInitialState() {
            return {
                showModal: false
            };
        },
        
        setStateValues(data){
            this.setState({qty: (data.qty - data.totalReturnedQty)});
            this.setState({unitPrice: data.unitPrice});
            this.setState({totalPrice: (data.qty * data.unitPrice).toFixed(2)});
            this.setState({returnableQty: (data.qty - data.totalReturnedQty)});
            if (data.qty === data.totalReturnedQty){
                this.setState({returnLabel: ' View Returns'});
            }
            else {
                this.setState({returnLabel: ' Return Sale'});
            }
        },

        close(event) {
            if (event !== undefined) {
                var action = $(event.target).attr('action');
                if (action === "return") {
                    var returnItem = { qty: this.state.qty,
                        sale_item_id: this.props.data.saleItemId,
                        note: this.state.note
                    };
                    this.props.onReturn(returnItem);
                }
            }
            this.setState({showModal: false});
        },

        open() {
            this.setState({showModal: true});
        },

        handleQtyChange(event){
            this.setState({qty: parseInt(event.target.value)});
            this.setState({totalPrice: (parseInt(event.target.value) * this.state.unitPrice).toFixed(2)});
        },

        handleNoteChange(event){
            this.setState({note: $(event.target).val()})
        },

        componentDidMount: function(){
            this.setStateValues(this.props.data);
        },

        componentWillReceiveProps: function(props) {
            this.setStateValues(props.data);
        },

        render() {
            var qtyOptions = [];
            for (var i=1; i <= this.state.returnableQty; i++) {
                qtyOptions.push(<option key={i-1} value={i}>{i}</option>);
            }

            var returnedItemRows = this.props.data.returnedItems.map(function(returnedItem,index){
                return (
                    <tr key={returnedItem.id}>
                        <td>
                            {returnedItem.id}
                        </td>
                        <td>
                            {returnedItem.qty}
                        </td>
                        <td>
                            {returnedItem.note}
                        </td>
                        <td>
                            {returnedItem.created_at}
                        </td>
                    </tr>
                );
            },this);

            var returnedItemsHead = (
                <thead>
                <tr>
                    <td>
                        Id.
                    </td>
                    <td>
                        Qty
                    </td>
                    <td>
                        Note
                    </td>
                    <td>
                        Date
                    </td>
                </tr>
                </thead>
            );

            return (
                <div>
                    <a onClick={this.open} href="#" className="btn btn-sm btn-danger fa fa-undo">{this.state.returnLabel}</a>
                    <ReactBootstrap.Modal show={this.state.showModal || this.props.show} onHide={this.close}>
                        <ReactBootstrap.Modal.Header closeButton>
                            <ReactBootstrap.Modal.Title>Return Item</ReactBootstrap.Modal.Title>
                        </ReactBootstrap.Modal.Header>
                        <ReactBootstrap.Modal.Body>
                            <div className={this.state.returnLabel === ' Return Sale' ? '' : 'hidden'}>
                                <p>
                                    Are you sure you want to return <b>{this.props.data.itemName} </b>
                                    from sale <b>#{this.props.data.saleId}</b> of customer <b>{this.props.data.customerName}</b> ?
                                </p>
                                <div className="row">
                                    <div className="col-sm-3">
                                        <div className="field form-group">
                                            Qunatity: <select className="form-control"
                                                              defaultValue={this.state.returnableQty}
                                                              onChange={this.handleQtyChange}>{qtyOptions}</select> <br/>
                                        </div>
                                    </div>
                                    <div className="col-sm-3">
                                        <div className="field form-group">
                                            Unit Price: <input defaultValue={this.state.unitPrice} disabled="true" className="form-control"/> <br/>
                                        </div>
                                        <div className="field form-group">
                                            Total Price: <input value={this.state.totalPrice} disabled="true" className="form-control"/> <br/>
                                        </div>
                                    </div>
                                    <div className="col-sm-6">
                                        <div className="field form-group">
                                            Note: <textarea rows="5" className="form-control" placeholder="Please type reason for return." onChange={this.handleNoteChange}>
                                                </textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <h4>Already Returned Items</h4>
                            <hr/>
                            <div className="row">
                                <div className="col-sm-12">
                                    <table className="table-responsive display table table-striped table-bordered">
                                        {returnedItemsHead}
                                        <tbody>
                                        {returnedItemRows}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </ReactBootstrap.Modal.Body>
                        <ReactBootstrap.Modal.Footer>
                            {this.state.returnLabel === ' Return Sale' ? <a href='#' className="btn btn-sm btn-danger fa fa-undo" action="return" onClick={this.close}> Return</a> : ''}
                            <a href='#' className="btn btn-sm btn-info fa fa-times" action="cancel" onClick={this.close}> Cancel</a>
                        </ReactBootstrap.Modal.Footer>
                    </ReactBootstrap.Modal>
                </div>
            );
        }
    });

})();