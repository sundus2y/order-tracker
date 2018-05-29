//noinspection JSUnresolvedFunction

var CustomerCarApp = CustomerCarApp || {};

(function () {

    CustomerCarApp.Car = React.createClass({
        
        handleCarRemove: function(event){
            this.props.onCarRemove(this.props.carData);
        },

        render: function(){
            var deleteButton = (<span className="fa fa-trash btn btn-danger"
                                     onClick={this.handleCarRemove}/>);
            return(
                <tr className={this.props.carData.markedForDeletion ? 'car_marked_for_delete' : ''}>
                    <td>
                        <div className="field form-group">
                            {(this.props.viewOnly || this.props.carData.markedForDeletion) ? '' : deleteButton}
                            <span className="line_number">{this.props.lineNumber}</span>
                            <input type="hidden" value={this.props.carData.id} name={"customer[cars_attributes]["+this.props.lineNumber+"][id]"}/>
                            <input type="hidden" value={this.props.carData._destroy} name={"customer[cars_attributes]["+this.props.lineNumber+"][_destroy]"}/>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            <input className="form-control focus"
                                   defaultValue={this.props.carData.vin_no}
                                   required
                                   disabled={this.props.viewOnly || this.props.carData.markedForDeletion} name={"customer[cars_attributes]["+this.props.lineNumber+"][vin_no]"}/>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            <input className="form-control focus"
                                   defaultValue={this.props.carData.plate_no}
                                   required
                                   disabled={this.props.viewOnly || this.props.carData.markedForDeletion} name={"customer[cars_attributes]["+this.props.lineNumber+"][plate_no]"}/>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            <input className="form-control focus"
                                   defaultValue={this.props.carData.year}
                                   disabled={this.props.viewOnly || this.props.carData.markedForDeletion} name={"customer[cars_attributes]["+this.props.lineNumber+"][year]"}/>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            <input className="form-control focus"
                                   defaultValue={this.props.carData.brand}
                                   disabled={this.props.viewOnly || this.props.carData.markedForDeletion} name={"customer[cars_attributes]["+this.props.lineNumber+"][brand]"}/>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            <input className="form-control focus"
                                   defaultValue={this.props.carData.model}
                                   disabled={this.props.viewOnly || this.props.carData.markedForDeletion} name={"customer[cars_attributes]["+this.props.lineNumber+"][model]"}/>
                        </div>
                    </td>
                </tr>
            );
       }
    });
})();