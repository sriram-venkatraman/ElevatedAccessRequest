global class BlockElevatedAccessEventCondition implements TxnSecurity.EventCondition {
    
    public boolean evaluate(SObject event) {
        switch on event {
            when LoginEvent loginEvent {
                return evaluate(loginEvent);
            }
            when null {
                return false;   
            }
            when else{
                return false;
            }
        }
    }
    
    private boolean evaluate(LoginEvent loginEvent) {
        User u = [SELECT Id, Profile.Name, UserName FROM User WHERE Id = :loginEvent.UserId];
        
        if (u != null) {
            // Ensure we are not blocking out every System Admin. Ensure couple of power users can always access the system 
            if ( u.UserName == 'venkatramans@dummyco.com.acctpoc' ) return false;
            
            if ( u.UserName != 'venkatramans@dummyco.com.acctpoc' && 
                u.Profile.Name == 'System Administrator' ) {
                    datetime currentTime = datetime.now();
                    System.Debug('Now: ' + currentTime);
                    
                    List<Elevated_Access_Request__c> earl = [SELECT Id 
                                                             FROM   Elevated_Access_Request__c
                                                             WHERE  From_Date__c <= :currentTime
                                                             AND    To_Date__c >= :currentTime
                                                             AND    For_User__c = :loginEvent.UserId
                                                             AND    Status__c = 'Access Provided'];
                    
                    if ( earl.size() > 0 ) {
                        System.Debug('Allowed Ear: ' + earl[0].Id);

                        // Check for high assurance session; If you are logging in with elevated access, you should have high assurance session
                        if ( loginEvent.SessionLevel != 'HIGH_ASSURANCE' ) {
                                return true;
                        }                       
                    } 
                    else {
                        return true;
                        
                    }
                    
            }
            
        }
        
        return false;  
    }
}