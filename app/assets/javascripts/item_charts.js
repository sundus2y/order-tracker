$('#item_sales_history').ready(function(){
    google.charts.load('current', {packages: ['corechart', 'line', 'bar']});
    google.charts.setOnLoadCallback(drawCharts);
});


function drawCharts() {
    drawSalesChart();
    drawOrdersChart();
}

function drawSalesChart(){
    var data = new google.visualization.DataTable();
    data.addColumn('number', 'X');
    data.addColumn('number', 'Item Sales');

    data.addRows([
        [0, 20],   [1, 5],  [3, 17],  [4, 18],  [5, 9],
        [6, 11],  [7, 27],  [8, 13],  [10, 32], [11, 35],
        [12, 30], [13, 30], [14, 32], [15, 22], [17, 38],
        [18, 22], [19, 24], [20, 22], [21, 25], [22, 12],
        [24, 16], [25, 15], [26, 12], [27, 11], [28, 19], [29, 3]
    ]);

    var options = {
        hAxis: {
            title: 'Date'
        },
        vAxis: {
            title: 'Quantity'
        }
    };

    var chart = new google.visualization.LineChart(document.getElementById('item_sales_history'));

    chart.draw(data, options);
}

function drawOrdersChart(){
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'X');
    data.addColumn('number', 'Item Orders');

    data.addRows([
        ['Jan', 0],  ['Feb', 0],  ['Mar', 300],  ['Apr', 0],  ['May', 0],
        ['Jun', 250],  ['Jul', 0],  ['Aug', 0],  ['Sep', 0],  ['Oct', 350], ['Nov', 0],
        ['Dec', 0]
    ]);

    var options = {
        hAxis: {
            title: 'Month'
        },
        vAxis: {
            title: 'Quantity'
        }
    };

    var chart = new google.visualization.ColumnChart(document.getElementById('item_orders_history'));

    chart.draw(data, options);
}