({
	init : function(component, event, helper) {
        var action = component.get("c.cloneRoom");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
			if(component.isValid() && response.getState() === "SUCCESS") {
                var responseVal = response.getReturnValue();
				 
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					"type": responseVal[0],
					"title": responseVal[1],
					"message": responseVal[2]
				});
				
				$A.get("e.force:closeQuickAction").fire();
				$A.get('e.force:refreshView').fire();
				toastEvent.fire();
            }    
        });
        $A.enqueueAction(action); 
    }
})