public with sharing class CTPeopleTracingController {
    
    public static List<People_Tracing__c> getTraces(String recordId){
        List<People_Tracing__c> traces = [SELECT Id, Name, Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c, 
                                            Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, 
                                            Contact_Type__c, Contact_Date__c
                                            FROM People_Tracing__c
                                            WHERE Person_1__c =:recordId OR Person_2__c =:recordId
                                            ORDER BY Contact_Date__c DESC];
        if(traces != null && traces.size() > 0){
            return traces;
        }
        return null;
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> tracesCompare){

        Set<Id> personIds = new Set<Id>();
        List<People_Tracing__c> duplicateTraces = new List<People_Tracing__c>();
        List<People_Tracing__c> traceExisting = new List<People_Tracing__c>(); 
        Map<Id, Set<Id>> traceExistingMap = new Map<Id, Set<Id>>();

        for(People_Tracing__c traces : tracesCompare){
            personIds.add(traces.Person_1__c);
            personIds.add(traces.Person_2__c);
        }

        traceExisting = [SELECT Id, Name, Person_2__c, Person_2__r.Health_Status__c, Person_2__r.Token__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Contact_Type__c, Contact_Date__c
                            FROM People_Tracing__c
                            WHERE Person_1__c IN :personIds OR Person_2__c IN :personIds];
        if(traceExisting != null && traceExisting.size() > 0){            
            for(People_Tracing__c traces : traceExisting){
                if(!traceExistingMap.containsKey(traces.Person_1__c)){
                    traceExistingMap.put(traces.Person_1__c,new Set<Id>());                    
                }
                traceExistingMap.get(traces.Person_1__c).add(traces.Person_2__c);
            }
            for(People_Tracing__c newTrace: tracesCompare){
                if(traceExistingMap.containsKey(newTrace.Person_1__c) 
                    && traceExistingMap.get(newTrace.Person_1__c).contains(newTrace.Person_2__c)){
                        duplicateTraces.add(newTrace);        
                }
            }
        }
    
       return duplicateTraces;
    }
}
