({
  handleSuccess: function (component, event, helper) {
    component.find("notifLib").showToast({
      variant: "success",
      title: "Opportunity Created",
      message: ""
    });
    var recordId = event.getParam("id");
    var navEvt = $A.get("e.force:navigateToSObject");
    navEvt.setParams({
      recordId: recordId,
      slideDevName: "detail"
    });
    navEvt.fire();
  },
  handleCancel: function (component, event, helper) {
    var navEvent = $A.get("e.force:navigateToList");
    navEvent.setParams({
      listViewId: "Recent",
      listViewName: "Recently Viewed",
      scope: "Opportunity"
    });
    navEvent.fire();
  },
  handleError: function (cmp, event, helper) {
    cmp.find("notifLib").showToast({
      title: "Something has gone wrong!",
      message: event.getParam("message"),
      variant: "error"
    });
  },
  handleSubmit: function (cmp, event, helper) {
    event.preventDefault(); // stop the form from submitting
    var fields = event.getParam("fields");
    var oppType = fields.Type;
    var newBusinessOpp = fields.New_Business_Opportunity__c;
    var newBusinessQuote = fields.New_Business_Quote__c;
    console.log("Opp TYPE", oppType);
    // Validate that New Business Opportunity and New Business Quote are filled if the Type is 'New Business' or 'Renewal'
    if (oppType === "Change Order") {
      if (!newBusinessOpp || !newBusinessQuote) {
        // Display error using toast notification
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: "Error",
          message: 'New Business Opportunity and New Business Quote are required when Type is "Change Order".',
          type: "error"
        });
        toastEvent.fire();
        return;
      }
    }
    cmp.find("myRecordForm").submit(fields);
  }
});