// Estela Solano : Homework 2


public with sharing class OpportunityUtility {

    public static void getOpportunities(integer num){
        integer n = num;
        List<Opportunity> oppList = new List<Opportunity>([SELECT Id, Amount,
                                                            Account.Name, MainCompetitors__c,
                                                            CloseDate, StageName 
                                                            FROM Opportunity 
                                                            ORDER BY Amount DESC, Account.name
                                                            LIMIT :n]);
        System.debug('List of top '+n+' Opps: '+oppList);                                                    
    }

    public static void openOpportunities(){
        List<Opportunity> openOpps = new List<Opportunity>([SELECT Id, OwnerId
                                                            FROM Opportunity
                                                            WHERE isClosed = FALSE and
                                                            CloseDate < TODAY]);

        if(openOpps.size() > 0){
            List<Task> taskList = new List<Task>(); 
            for(Opportunity opp : openOpps){
               Task t = new Task(Subject = 'Update Close Date', Status = 'Open');
               t.OwnerId = opp.OwnerId;
               t.WhatId = opp.Id;
               taskList.add(t); 
            } 
            insert taskList;
            System.debug('Number of open opps: '+openOpps.size()+'. Tasks created are: '+taskList);
        }
        if(openOpps.isEmpty()){
            System.debug('No tasks were created because there are no open opps');
        }     
                                                         
    }

    public static void mapOppsByState(String state){
        String accountState = state;
        List<Opportunity> openOppsInState = new List<Opportunity>([SELECT Id, AccountId FROM Opportunity
                                                            WHERE isClosed = FALSE and 
         
                                                           Account.billingstate = :accountState]);
        
        Map<Id,Opportunity> accIdoppMap = new Map<Id,Opportunity>();
        for(Opportunity opp : openOppsInState){
            accIdoppMap.put(opp.AccountId,opp);
        }
                                                           
        if(accIdoppMap.isEmpty()){
            System.debug('There are no open opps in that state');                                                           
        }
        else {
            System.debug('The open opps'+accIdoppMap.values());
        }     
    }

}