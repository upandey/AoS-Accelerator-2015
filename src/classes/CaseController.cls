global with sharing class CaseController {

    public CaseController(ApexPages.StandardController controller) {
        Case mycase = (Case)controller.getRecord();
    }

    public String accountName { get; set; }
    public static Account account { get; set; }
    global static MyTimeline myTimeline { get; set; } 
    public CaseController() { } // empty constructor
    
    @RemoteAction
    global static List<Case> getAllCases(String accountName) {
        List<Case> caseLst = [Select Subject, Priority, CaseNumber, Owner.Name, OwnerId, Id, Account.Name, AccountId, System_Generated__c FROM Case order by LastModifiedDate DESC limit 5];
        return caseLst;
    }
    
    
    @RemoteAction
    global static Account getAccount(String accountName) {
        account = [SELECT Id, Name, Phone, Type, NumberOfEmployees 
                   FROM Account WHERE Name = :accountName];
        return account;
    }
    
    @RemoteAction
    global static MyTimeline getTimeLine(String caseId) { 
        system.debug('caseId -------> '+caseId);
        String storyjs_jsonp_data = null;
        List<Case> caseLst = [SELECT Id, CaseNumber, LastModifiedDate, CreatedDate, Description, (Select Name, Communication_Notes__c, Start__c, End__c FROM Communications__r ), (Select Subject, Description, LastModifiedDate, CreatedDate From OpenActivities ), (Select Subject, Description, LastModifiedDate, CreatedDate FROM ActivityHistories) FROM Case where Id =: caseId];
        myTimeline = new MyTimeline();
        for(Case mycase : caseLst){
            myTimeline.Timeline tline = new myTimeline.Timeline();
            tline.headline = 'Timeline for Case #'+mycase.casenumber;
            tline.type = 'default';
            tline.text = ' ';
            List<myTimeline.MyDate> mydateLst = new List<myTimeline.MyDate>();
            List<myTimeline.Era> eraLst = new List<myTimeline.Era>();
            tline.mydate = mydateLst;
            tline.era = eraLst;
            myTimeline.timeline = tline;
            
                myTimeline.MyDate caseCreation = new myTimeline.MyDate();
                caseCreation.classname = 'Activities';
                caseCreation.headline = 'Case Created';
                caseCreation.text = caseLst[0].Description;
                caseCreation.tag = 'Activities';
                caseCreation.startDate = caseLst[0].CreatedDate.format('YYYY,MM,dd');
                caseCreation.endDate = caseLst[0].CreatedDate.format('YYYY,MM,dd');
                mydateLst.add(caseCreation);


            for(Communication__c comm : mycase.Communications__r){
                myTimeline.MyDate mydate = new myTimeline.MyDate();
                mydate.classname = 'Communication';
                mydate.headline = comm.Name;
                mydate.text = comm.Communication_Notes__c;
                mydate.tag = 'Communication';
                mydate.startDate = comm.Start__c.format();
                mydate.endDate = comm.End__c.format();
                mydateLst.add(mydate);
            }
            
            System.debug(mycase.OpenActivities);
            for(OpenActivity act : mycase.OpenActivities){
                myTimeline.MyDate mydate = new myTimeline.MyDate();
                mydate.classname = 'Activities';
                mydate.headline = act.Subject;
                mydate.text = act.Description;
                mydate.tag = 'Activities';
                mydate.startDate = act.CreatedDate.format('YYYY,MM,dd');
                mydate.endDate = act.LastModifiedDate.format('YYYY,MM,dd');
                mydateLst.add(mydate);
            } 
            for(ActivityHistory act : mycase.ActivityHistories){
                myTimeline.MyDate mydate = new myTimeline.MyDate();
                mydate.classname = 'Activities';
                mydate.headline = act.Subject;
                mydate.text = act.Description;
                mydate.tag = 'Activities';
                mydate.startDate = act.CreatedDate.format('YYYY,MM,dd');
                mydate.endDate = act.LastModifiedDate.format('YYYY,MM,dd');
                mydateLst.add(mydate);
            }    
        }
        return myTimeline;
    }
}