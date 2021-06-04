public class RevertElevatedAccess {
    @InvocableMethod(label='Update user to previous Profile for list of UserIDs' description='Update user to previous Profile for list of UserIDs')
    public static void updateToPreviousProfile(List<ID> ids) {
        System.Debug('***** IDs: ' + ids);
        for (Elevated_Access_Request__c ear : [select For_User__c, Current_Profile_ID__c from Elevated_Access_Request__c where id = :ids]) {
            doActualUserProfileUpdate(ear.For_User__c, ear.Current_Profile_ID__c);
        }

        return;
    }
    
    @future
    public static void doActualUserProfileUpdate(ID uid, ID pid) {
        System.Debug('Updating User ' + uid + ' with Profile ' + pid);
        User u = new User();
        u.id = uid;
        u.profileid = pid;
        update u;
	}    
}