public with sharing class MapController {
    
    @RemoteAction
    public static List<Case> getAllCases(String accountName) {
        List<Case> caseLst = [Select Subject, Priority, CaseNumber, Owner.Name, OwnerId, Id, Account.Name, AccountId, Asset.Name,  Asset.Device_Loc__c, Asset.Device_Loc__latitude__s, Asset.Device_Loc__longitude__s, Reason FROM Case order by LastModifiedDate DESC];
        return caseLst; 
    }
    
    
    @RemoteAction
    public static List<Asset> getAllDevices(String accountName) {
        List<Asset> assetLst = [Select a.Status, a.hasCases__c, a.SerialNumber, a.Name, a.City__c, a.AccountId, Account.Name, Device_Loc__c, (Select Casenumber from Cases__r) From Asset a order by LastModifiedDate DESC];
        return assetLst; 
    }
    
    @RemoteAction
    public static void insertTemperatureRecord(Integer temperature, Id assetId) {
        Device_Data__c deviceData = new Device_Data__c();
        
        deviceData.Device_Temperature_in_C__c = temperature;
        deviceData.Asset_Device__c = assetId;
       
        Insert deviceData;        
    }

    
    @RemoteAction
    public static List<SalesRep> getAllSalesRep(String accountName) {
        List<SalesRep> salesRepLst = new List<SalesRep> ();
        Set<Id> userIds = new Set<Id>();
        try{
        List<User> userLst = [Select u.UserRoleId, u.UserRole.Name, u.Phone, u.Name, u.Id, u.EmployeeNumber, Location__c From User u limit 5];//where UserRoleId IN ('00E1a000000mhfG')
        for(User usr:userLst){
            SalesRep rep = new SalesRep();
            rep.user = usr;
            userIds.add(usr.Id);
            salesRepLst.add(rep);
        }
        
        
        AggregateResult[] groupedResults = [SELECT count(Id), Owner.Name, ownerId, status from Case group by Owner.Name, ownerId, status having ownerId IN : userIds];
        AggregateResult[] groupedResults1 = [SELECT avg(SLA_Work_Started_Hours__c), SalesRep__c from Case group by SalesRep__c having SalesRep__c IN : userIds];
        AggregateResult[] groupedResults2 = [SELECT count(Id), SLAViolation__c, SalesRep__c from Case group by SalesRep__c, SLAViolation__c having SalesRep__c IN : userIds];
        Integer dnum = 0;
        for(SalesRep sr : salesRepLst){
            for(AggregateResult ar : groupedResults){
                if(sr.user.Id == ar.get('ownerId')){
                    dnum = ar.get('expr0') != null ? Integer.valueOf(ar.get('expr0')) : 0;
                    if(ar.get('status')== 'closed'){
                        sr.numOfClosedCases = sr.numOfClosedCases + dnum; 
                    }else{
                        sr.numOfOpenCases = sr.numOfOpenCases + dnum;
                    }
                }
            }
            for(AggregateResult ar : groupedResults1){
                if(sr.user.Id == ar.get('SalesRep__c')){
                    sr.avgResponseTime = ar.get('expr0') != null ? Integer.valueOf(ar.get('expr0')) : 0;
                }
            }
            for(AggregateResult ar : groupedResults2){
                if(sr.user.Id == ar.get('SalesRep__c')){
                    dnum = ar.get('expr0') != null ? Integer.valueOf(ar.get('expr0')) : 0;
                    if(ar.get('SLAViolation__c') == 'Yes'){
                        sr.numOfCasesSlaMeetFail = dnum;
                    }else{
                        sr.numOfCasesSlaMeet = sr.numOfCasesSlaMeet + dnum;
                    }
                }
            }
        }
        for(SalesRep sr : salesRepLst){
            sr.closewithinSLA = ((sr.numOfCasesSlaMeetFail + sr.numOfCasesSlaMeet)/sr.numOfCasesSlaMeet)*100;
        }
        }catch(Exception e){
            system.debug(e.getmessage());
        }
        return salesRepLst; 
    }
    
    
    class SalesRep{
        User user;
        Integer numOfOpenCases;
        Integer numOfClosedCases;
        Integer avgResponseTime;
        Integer numOfCasesSlaMeet;
        Integer numOfCasesSlaMeetFail;
        Integer closewithinSLA;
    }
    
}