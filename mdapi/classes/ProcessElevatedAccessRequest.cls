public class ProcessElevatedAccessRequest {

    @InvocableMethod(label='Update System Admin Profile for list of UserIDs' description='Sets Admin Access for list of UserIDs')
    public static void updateToSysAdminProfile(List<ID> ids) {
        List<User> ulist = [select id, profileid from user where id = :ids];
        System.Debug('User List: ' + ulist);
        Profile p = [select id from profile where name = 'System Administrator' limit 1];
        System.Debug('System Admin ID: ' + p.Id);
        
        for (Integer i = 0; i < ulist.size(); i++ ) {
            doActualUserProfileUpdate(ulist[i].id, p.id);
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