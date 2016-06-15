trigger CaseTrigger on Case (before insert, before update, after insert) {
    String salesowner = null;
    if(Trigger.isBefore){
        If(Trigger.isInsert || Trigger.isUpdate){
            for(Case mycase : Trigger.new){
                salesowner = mycase.OwnerId;
                if(salesowner.startsWith('005')){
                    mycase.SalesRep__c = mycase.OwnerId;
                }
            }
        }
    }
    if(Trigger.isAfter && Trigger.isInsert){
        AssignmentRule AR = new AssignmentRule();
        AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true limit 1];
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
        List<case> caseLst = new List<case>();
        for(Case mycase : Trigger.new){
            Case tcase = new Case();
            tcase.Id = mycase.Id;
            tcase.setOptions(dmlOpts);
            caseLst.add(tcase);
        }
        update caseLst;
    }
}