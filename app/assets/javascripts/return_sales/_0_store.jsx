var returnSalesApp = returnSalesApp || {};

(function () {

    returnSalesApp.Store = React.createClass({

        handleStoreSelect: function(event){
            this.props.onStoreSelect(event.target.selectedOptions[0].value);
        },

        render: function() {
            var stores = this.props.data;
            var selectOptions = stores.map(function(store,index){
                return(
                  <option key={index} value={store[1]}>{titilize(store[0])}</option>
                );
            },this);

            return (
                <div className="col-md-3">
                    <div className="field form-group">
                        <label htmlFor="store" >Store</label>
                        <select id="store" className="form-control" onChange={this.handleStoreSelect}>
                            {selectOptions}
                        </select>
                    </div>
                </div>

            );
        }
    });
})();