public class ElevatedAccessRequestController {
    @AuraEnabled
    public static List<LoginHistory> fetchLoginHistory(List<String> lIds) {
        Elevated_Access_Request__c earList = [select Id, For_User__c, From_Date__c, To_Date__c 
                                              from Elevated_Access_Request__c 
                                              where id = :lIds
                                              limit 1
                                             ];
        
        List<LoginHistory> lhList = [select id, userid, loginTime, logintype, sourceip, loginurl, status, browser 
                                     from 	loginhistory 
                                     where 	userid = :earList.For_User__c 
                                     and   	loginTime >= :earList.From_Date__c
                                     and   	loginTime <= :earList.To_Date__c
                                     order by loginTime desc
                                     limit 100];

        system.debug('### ret ' + lhList);   

        //return list of login history
        return lhList;
    }
    
    @AuraEnabled
    public static List<SetupAuditTrail> fetchSAT(List<String> lIds) {
        Elevated_Access_Request__c earList = [select Id, For_User__c, From_Date__c, To_Date__c 
                                              from	 Elevated_Access_Request__c 
                                              where  id = :lIds
                                              limit 1
                                             ];
        
        List<SetupAuditTrail> satList = new List<SetupAuditTrail>();
        try {
            satList = [select 	id, section, createddate, createdbyid, display, delegateuser
                       from 	setupaudittrail 
                       where 	createdbyid = :earList.For_User__c 
                       and   	createddate >= :earList.From_Date__c
                       and   	createddate <= :earList.To_Date__c
                       order by createddate desc
                       limit 100
                      ];                 
        } catch (exception e) {
        	System.Debug('Failed to read SetupAuditTrail: ' + e.getMessage());   
        }

        system.debug('### ret ' + satList); 

        //return list of setup audit trail
        return satList;
    }
}