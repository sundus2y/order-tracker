(function () {

    window.service = {};

    service.configDeferred = null;
    service.config = function(callback){
        if(!service.configDeferred){
            service.configDeferred = $.get('/configs', 'json').done(
                function(data) {
                    if(callback){
                        callback(data);
                    }
                });
        }else{
            if(callback){
                service.configDeferred.done(function(data){
                    callback(data);
                });
            }
        }
        return service.configDeferred;
    };

    service.lookupDeferred = null;
    service.lookup = function(callback){
        if(!service.lookupDeferred){
            service.lookupDeferred = $.get('/searches/item_lookup/', 'json').done(
                function(data) {
                    if(callback){
                        callback(data);
                    }
                });
        }else{
            if(callback){
                service.lookupDeferred.done(function(data){
                    callback(data);
                });
            }
        }
        return service.lookupDeferred;
    };

})();