({
    fetchLHHelper : function(component, event, helper) {
        component.set('v.mycolumns', [
            	{label: 'Login Date', fieldName: 'LoginTime', type: 'date', 
                 initialWidth: 175,
                 typeAttributes: {
                    weekday: 'short',
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                }},
            	{label: 'Login Type', fieldName: 'LoginType', type: 'text', initialWidth: 200 },
            	{label: 'Browser', fieldName: 'Browser', type: 'text', initialWidth: 200},
                {label: 'Status', fieldName: 'Status', type: 'text', initialWidth: 400}
        ]);
        
        var action = component.get("c.fetchLoginHistory");
        action.setParams({
            "lIds": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                var dataList = response.getReturnValue();
                component.set("v.lhList", dataList);
            }
        });
        $A.enqueueAction(action);
    }
})