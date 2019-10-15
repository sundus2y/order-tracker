//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function (){
    $('.file').fileinput({'showPreview':false});

    window.itemAnalysis = window.itemAnalysis || {};

    window.itemAnalysis.getData = function() {
        showGlobalLoading();
        var itemId = $('#item_id').val();
        var dateFrom = $('#date_from').val();
        var dateTo = $('#date_to').val();
        $.get('/items/'+itemId+'/analysis_data', {
            date_from: dateFrom,
            date_to: dateTo
        }).then(function(data) {
            hideGlobalLoading();
            window.itemAnalysis.renderSalesChart(data.sales_data);
            window.itemAnalysis.renderGrandTotal(data.grand_total);
        }, function(e){
            hideGlobalLoading();
            alert('Error Loading: '+e);
        });
    };

    window.itemAnalysis.renderSalesChart = function(salesData) {
        var dateTimeFormat = 'MM/DD/YYYY HH:mm::ss';
        var salesChartConfig = {
            type: 'bar',
            data: {
                labels: [],
                datasets: []
            },
            options: {
                title: {
                    display: true,
                    text: 'Sales/Inventory Chart',
                    position: 'top',
                    stacked: false,
                },
                scales: {
                    xAxes: [{
                        type: 'time',
                        time: {
                            parser: dateTimeFormat,
                            tooltipFormat: dateTimeFormat,
                            unit: 'month'
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'Date/Time'
                        },
                        stacked: true
                    }],
                    yAxes: [
                        {
                            id: 'yqty',
                            type: 'linear',
                            position: 'left',
                            display: true,
                            scaleLabel: {
                                labelString: 'Quantity'
                            },
                        },
                        // {
                        //     id: 'yavg',
                        //     type: 'linear',
                        //     display: false,
                        //     position: 'right',
                        //     scaleLabel: {
                        //         labelString: 'Average Price'
                        //     },
                        //     gridLines: {
                        //         drawOnChartArea: false
                        //     }
                        // },
                        {
                            id: 'yrev',
                            type: 'linear',
                            display: false,
                            position: 'right',
                            scaleLabel: {
                                labelString: 'Revenue'
                            },
                            gridLines: {
                                drawOnChartArea: false
                            }
                        },
                        {
                            id: 'yinv',
                            type: 'linear',
                            display: true,
                            position: 'right',
                            scaleLabel: {
                                labelString: 'Inventory'
                            },
                            stacked: true
                            // gridLines: {
                            //     drawOnChartArea: false
                            // }
                        }
                    ]
                },
            }
        };
        var ctx = $('#salesChart')[0].getContext('2d');
        if(window.salesChartObj) salesChartObj.destroy();
        window.salesChartObj = new Chart(ctx, salesChartConfig);
        var qtyDataset = {
            type: 'line',
            label: 'Quantity',
            borderColor: 'rgba(19,35,255,0.5)',
            backgroundColor: 'rgba(19,35,255,0.5)',
            fill: false,
            spanGaps: false,
            data: salesData.map(function(salesD) {
                return {
                    x: moment(salesD.date).format(dateTimeFormat),
                    y: salesD.total_qty
                }
            }),
            yAxisID: 'yqty'
        };
        var revDataset = {
            type: 'line',
            label: 'Revenue',
            borderColor: 'rgba(255,166,79,0.5)',
            backgroundColor: 'rgba(255,166,79,0.5)',
            fill: false,
            spanGaps: false,
            data: salesData.map(function(salesD) {
                return {
                    x: moment(salesD.date).format(dateTimeFormat),
                    y: salesD.total_revenue
                }
            }),
            yAxisID: 'yrev'
        };
        var avgPriceDataset = {
            type: 'line',
            label: 'Average Price',
            borderColor: 'rgba(255,91,86,0.5)',
            backgroundColor: 'rgba(255,91,86,0.5)',
            fill: false,
            spanGaps: false,
            data: salesData.map(function(salesD) {
                return {
                    x: moment(salesD.date).format(dateTimeFormat),
                    y: salesD.average_price
                }
            }),
            yAxisID: 'yavg'
        };
        var inventoryDataset = {
            label: 'Shop Inventory',
            borderColor: 'rgba(0,0,0,0.72)',
            backgroundColor: 'rgba(0,0,0,0.72)',
            spanGaps: false,
            data: salesData.map(function(salesD) {
                return {
                    x: moment(salesD.date).format(dateTimeFormat),
                    y: salesD.shop_inventory
                }
            }),
            yAxisID: 'yinv'

        };
        var inventoryDataset2 = {
            label: 'Store Inventory',
            borderColor: 'rgba(45,45,45,0.5)',
            backgroundColor: 'rgba(45,45,45,0.5)',
            spanGaps: false,
            data: salesData.map(function(salesD) {
                return {
                    x: moment(salesD.date).format(dateTimeFormat),
                    y: salesD.store_inventory
                }
            }),
            yAxisID: 'yinv'

        };
        salesChartConfig.data.datasets = [qtyDataset, revDataset, inventoryDataset, inventoryDataset2];
        salesChartObj.update();
    };

    window.itemAnalysis.renderGrandTotal = function(grandTotal) {
        var gtField = $('#grand_total')[0];
        gtField.innerHTML = "The Total Revenue is: " + printCurrency(grandTotal);
    }
});