var CustomerCarApp = CustomerCarApp || {};

(function () {

    var Car = CustomerCarApp.Car;

    CustomerCarApp.App = React.createClass({
        getInitialState: function () {
            return {
                data: [],
                loadingCars: false
            };
        },

        getCars: function(customerId){
            var deferred = $.Deferred();
            this.setState({loadingCars: true});
            if(customerId){
                $.ajax({
                    type: "GET",
                    url: "/customers/"+customerId+"/cars/",
                    dataType: 'json',
                    success: function(data,response){
                        deferred.resolve({context:this,data:data,message:response});
                        this.setState({loadingCars: false});
                    }.bind(this),
                    error: function(err) {
                        this.setState({loadingCars: false});
                        deferred.reject({context:this,err:err,message:'Error'});
                    }
                });
            } else {
                this.setState({loadingCars: false});
                deferred.resolve({context:this, data:[], message:''})
            }

            return deferred.promise();
        },

        handleCarRemove: function(carToRemove){
            var updatedData = this.state.data.map(function(car){
                if((carToRemove.id && (car.id === carToRemove.id)) || (JSON.stringify(car) === JSON.stringify(carToRemove))) {
                    car._destroy = true;
                    car.markedForDeletion = true;
                }
                return car;
            });
            this.setState({data: updatedData});
        },

        handleCarAdd: function(event) {
            var newCar = {
                vin_no: '',
                plate_no: '',
                year: '',
                brand: '',
                model: ''
            };
            var newDataCopy = JSON.parse(JSON.stringify(this.state.data));
            var updatedData = newDataCopy.concat([newCar]);
            this.setState({data: updatedData});
        },

        componentDidMount: function(){
            var customerId = $('#customer_id').val();
            this.getCars(customerId).done(function(response) {
                var self = response.context;
                self.setState({data: response.data});
            }).fail(function(response){
                alert("Error While Trying to Load Cars" + response);
            });
        },

        render: function(){
            var main;
            var carsList = this.state.data;
            var carsListUI = carsList.map(function (car,index) {
                return (
                    <Car
                        lineNumber={index+1}
                        key={index+1}
                        carData={car}
                        onCarRemove={this.handleCarRemove}
                        viewOnly={this.props.viewOnly}
                    />
                );
            }, this);

            var loadingCarsUI = (
                <tr>
                    <td colSpan="6" className="center-aligned">
                        <i className="fa fa-spinner fa-spin fa-3x fa-fw" aria-hidden="true"></i>
                        <span className="searching">Loading . . .</span>
                    </td>
                </tr>
            );

            var addNewCarUI = (
                <tr>
                    <td colSpan="6" className="center-aligned">
                        <span className="fa fa-plus btn btn-success" onClick={this.handleCarAdd}> Add New Car</span>
                    </td>
                </tr>
            )

            var noCarsUI = (
                <tr>
                    <td colSpan="6" className="center-aligned">
                        <span className>No Registered Cars</span>
                    </td>
                </tr>
            );

            var mainUI = (
                <table className="table-responsive display table table-striped table-bordered">
                    <thead>
                        <tr>
                            <td>
                                <div className="field form-group">
                                    No.
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    VIN No
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Plate No
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Year
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Brand
                                </div>
                            </td>
                            <td>
                                <div className="field form-group">
                                    Model
                                </div>
                            </td>
                        </tr>
                    </thead>
                    <tbody>
                        {!this.props.viewOnly ? addNewCarUI : null}
                        {this.state.loadingCars ? loadingCarsUI : this.state.data.length === 0 ? noCarsUI : carsListUI }
                    </tbody>
                </table>
            );

            return (
                <div>
                    {mainUI}
                </div>
            );
        }
    });

    function render(viewMode,container) {
        var App = CustomerCarApp.App;
        ReactDOM.render(
            <App viewOnly={viewMode}/>,
            container[0]
        );
    }
    $(document).ready(function(){
        if ($('.customer_cars_app').length != 0){render(false,$('.customer_cars_app'));}
        if ($('.customer_cars_show_app').length != 0){render(true,$('.customer_cars_show_app'));}
    });
})();