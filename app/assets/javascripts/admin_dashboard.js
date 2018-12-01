$(function () {
    // -----------------------
    // - MONTHLY SALES CHART -
    // -----------------------
    function drawSalesChart(data){
        // Get context with jQuery - using jQuery's .get() method.
        var salesChartCanvas = document.getElementById('salesChart');

        var salesChartOptions = {
            responsive: true,
            hover :{
                animationDuration:10
            }
        };

        var salesChartData = {
            labels: data['dates'],
            datasets: [
                {
                    label: 'Monthly Sales',
                    fillColor: 'rgb(210, 214, 222)',
                    strokeColor: 'rgb(210, 214, 222)',
                    pointColor: 'rgb(210, 214, 222)',
                    pointStrokeColor: '#c1c7d1',
                    pointHighlightFill: '#fff',
                    pointHighlightStroke: 'rgb(220,220,220)',
                    data: data['sales_data']
                }
            ]
        };

        var salesChart = new Chart(salesChartCanvas, {
            type: 'line',
            data: salesChartData,
            options: salesChartOptions
        });

    }
    //TODO:  Make sure this doesn't run for non-admin accounts
    if($.find('.dashboard_index').length) {
        $('.dashboard_index').ready(function () {
            $.get('/dashboard/sales_chart_data', function (data) {
                data['sales_data'] = data['sales_data'].map(function (s) {
                    return parseFloat(s);
                });
                drawSalesChart(data);
            });
        });
    }
});

