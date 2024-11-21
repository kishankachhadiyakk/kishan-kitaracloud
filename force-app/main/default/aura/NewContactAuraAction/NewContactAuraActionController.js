({
    handleSuccess : function(component, event, helper) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Contact Created",
            "message": ""
        });
        
        var recordId  = event.getParam("id");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId ,
            "slideDevName": "detail"
        });
        navEvt.fire();
    },
    handleCancel : function(component,event,helper){
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "listViewId": "Recent",
            "listViewName": "Recently Viewed",
            "scope": "Contact"
        });
        navEvent.fire();
    },
    handleError: function (cmp, event, helper) {
        /*
        event.preventDefault();
        var error = event.getParam("error");
        var errMsg = event.getParam("message");
        var errorMessage = error.message;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:event.getParam("message"),
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
        */
        cmp.find('notifLib').showToast({
            "title": "Something has gone wrong!",
            "message": event.getParam("message"),
            "variant": "error"
        });
    }
})