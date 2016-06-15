public with sharing class TimelineController {

    @RemoteAction
    public static List<Task> getTask(String caseName) {
        List<Task> taskList= [SELECT Id, Subject FROM Task WHERE WhatId = :caseName];
        return taskList;
    }    
        
}