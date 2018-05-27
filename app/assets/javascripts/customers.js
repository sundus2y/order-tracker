$(document).ready(function(){
    // new Vue({
    //     el: '#app',
    //     data: function data() {
    //         return {
    //             search: '',
    //             customerDialog: false,
    //             totalItems: 0,
    //             items: [],
    //             loading: true,
    //             pagination: {},
    //             rpg: [15,30,50,{"text":"All","value":-1}],
    //             headers: [
    //                 { text: 'Name', align: 'left', value: 'name', width: '30%' },
    //                 { text: 'Company', align: 'left', value: 'company', width: '30%' },
    //                 { text: 'Phone', align: 'left', value: 'phone', width: '5%' },
    //                 { text: 'TIN No', align: 'left', value: 'tin_no', width: '5%' },
    //                 { text: 'Category', align: 'left', value: 'category', width: '8%' },
    //                 { text: 'Actions', value: 'name', sortable: false, width: '5%' }
    //             ],
    //             editedIndex: -1,
    //             disableEdit: false,
    //             editedItem: {name: '', company: '', phone: '', tin_no: '',  category: ''},
    //             defaultItem: {name: '', company: '', phone: '', tin_no: '',  category: ''},
    //             rules: {
    //                 required: function(value) { return !!value || 'Required.'},
    //             },
    //             lorem: 'lkasdfjlksd lkasdfjlksd lkasdfjlksd lkasdfjlksd lkasdfjlksd lkasdfjlksd lkasdfjlksd lkasdfjlkasdfjlksd lkasdfjlksd lkasdfjlksd lkasdfj lkasdfjlksd lkasdfjlksd lkasdfjlksd lkasdfj'
    //         };
    //     },
    //     computed: {
    //         formTitle: function formTitle() {
    //             return this.editedIndex === -1 ? 'New Customer' : 'Edit Customer';
    //         }
    //     },
    //     watch: {
    //         pagination: {
    //             handler: function handler() {
    //                 var _this = this;
    //                 this.getItemsFromApi().then(function (data) {
    //                     _this.items = data.items;
    //                     _this.totalItems = data.total;
    //                 });
    //             },
    //             deep: true
    //         },
    //         customerDialog: function customerDialog(val) {
    //             var _this = this;
    //             val || _this.close();
    //         }
    //     },
    //     mounted: function mounted() {
    //         var _this2 = this;
    //         this.getItemsFromApi().then(function (data) {
    //             _this2.items = data.items;
    //             _this2.totalItems = data.total;
    //         });
    //     },
    //     methods: {
    //         getItemsFromApi: function getItemsFromApi() {
    //             var _this3 = this;
    //             this.loading = true;
    //             return new Promise(function (resolve, reject) {
    //                 var _pagination = _this3.pagination,
    //                     sortBy = _pagination.sortBy,
    //                     descending = _pagination.descending,
    //                     page = _pagination.page,
    //                     rowsPerPage = _pagination.rowsPerPage;
    //                 $.getJSON("/customers",{
    //                     paginate: true,
    //                     sortBy: sortBy,
    //                     descending: descending,
    //                     page: page,
    //                     rowsPerPage: rowsPerPage
    //                 },function(data){
    //                     _this3.loading = false;
    //                     resolve({items: data.items,total: data.total});
    //                 });
    //             });
    //         },
    //         saveItemWithApi: function saveItemWithApi() {
    //             var _this = this;
    //             return new Promise(function (resolve, reject){
    //                 $.ajax({
    //                     method:'PATCH',
    //                     url:'/customers/'+_this.editedItem.id+'.json',
    //                     data:{customer:_this.editedItem}
    //                     }).done(function(data){
    //                     resolve({item: data.item, errors: data.errors});
    //                 });
    //             });
    //         },
    //         createItemWithApi: function createItemWithApi() {
    //             var _this = this;
    //             return new Promise(function (resolve, reject){
    //                 $.ajax({
    //                     method:'POST',
    //                     url:'/customers.json',
    //                     data:{customer:_this.editedItem}
    //                 }).done(function(data){
    //                     resolve({item: data.item, errors: data.errors});
    //                 });
    //             });
    //         },
    //         deleteItemWithApi: function deleteItemWithApi(id) {
    //             var _this = this;
    //             return new Promise(function (resolve, reject){
    //                 $.ajax({
    //                     method:'DELETE',
    //                     url:'/customers/'+id+'.json',
    //                 }).done(function(data){
    //                     resolve({item: data.item, errors: data.errors});
    //                 });
    //             });
    //         },
    //         editItem: function editItem(item) {
    //             this.editedIndex = this.items.indexOf(item);
    //             this.editedItem = Object.assign({}, item);
    //             this.disableEdit = false;
    //             this.customerDialog = true;
    //         },
    //         viewItem: function viewItem(item) {
    //             this.editedIndex = this.items.indexOf(item);
    //             this.editedItem = Object.assign({}, item);
    //             this.disableEdit = true;
    //             this.customerDialog = true;
    //         },
    //         deleteItem: function deleteItem(item) {
    //             var _this = this;
    //             var index = _this.items.indexOf(item);
    //             if(confirm('Are you sure you want to delete this Customer?')){
    //                 this.deleteItemWithApi(item.id).then(function (data) {
    //                     _this.items.splice(index, 1);
    //                 });
    //             }
    //         },
    //         close: function close() {
    //             var _this = this;
    //             this.customerDialog = false;
    //             setTimeout(function () {
    //                 _this.editedItem = Object.assign({}, _this.defaultItem);
    //                 _this.editedIndex = -1;
    //                 Object.keys(_this.defaultItem).forEach(function (item) {
    //                     _this.$refs[item].reset();
    //                 })
    //             }, 300);
    //         },
    //         save: function save(event) {
    //             var _this = this, formHasErrors = false;
    //             Object.keys(_this.defaultItem).forEach(function (item) {
    //                 if (!_this.$refs[item].validate(true)) formHasErrors = true;
    //             });
    //             var callBackErrorHandler = function callBackErrorHandler(_this,data){
    //                 if (!$.isEmptyObject(data.errors)) {
    //                     Object.keys(data.errors).forEach(function(error){
    //                         _this.$refs[error].errorMessages = data.errors[error][0];
    //                     });
    //                     return true;
    //                 }
    //             };
    //             if(!formHasErrors){
    //                 if (this.editedIndex > -1) {
    //                     this.saveItemWithApi().then(function (data) {
    //                         if(!callBackErrorHandler(_this,data)){
    //                             Object.assign(_this.items[_this.editedIndex], data.item);
    //                             _this.close();
    //                         }
    //                     });
    //                 } else {
    //                     this.createItemWithApi().then(function (data) {
    //                         if(!callBackErrorHandler(_this,data)){
    //                             _this.items.push(data.item);
    //                             _this.close();
    //                         }
    //                     });
    //                 }
    //             }
    //         }
    //     }
    // });
});