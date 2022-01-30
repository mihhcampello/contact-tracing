public with sharing class CTLocationTracingController {
    
    public static List<Location_Tracing__c> getVitors(String locationId){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c 
                FROM Location_Tracing__c 
                WHERE Id =:locationId
                ORDER BY Visit_Date__c DESC];
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c 
                FROM Location_Tracing__c 
                WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        return [SELECT Id, Name, Person__c, Location__c, Visit_Date__c, Person__r.Token__c, Person__r.Health_Status__c 
                FROM Location_Tracing__c 
                WHERE Location__c IN :locationIds 
                    AND Person__r.Health_Status__c = 'Green' 
                    AND Visit_Date__c = LAST_N_DAYS:10];
    }

    public static List<Location_Tracing__c> chechDuplicates(List<Location_Tracing__c> locationTraces){
        Map<Id, Set<Id>> locationByPersonsMap = new Map<Id,Set<Id>>();
        Set<Id> personIds = new Set<Id>();
        Set<Id> locationIds = new Set<Id>();
        List<Location_Tracing__c> duplicateLocationTracing = new List<Location_Tracing__c>();

        for(Location_Tracing__c newTrace : locationTraces){
            locationIds.add(newTrace.Location__c);
            personIds.add(newTrace.Person__c);
        }

        List<Location_Tracing__c> existingRecord = [SELECT Id, Person__c, Location__c
                                                    FROM Location_Tracing__c
                                                    WHERE Person__c IN :personIds 
                                                    AND Location__c IN :locationIds];
                
        if(existingRecord != null  && existingRecord.size() > 0){
            for(Location_Tracing__c traceExisting : existingRecord){
                if(!locationByPersonsMap.containsKey(traceExisting.Location__c)){
                    locationByPersonsMap.put(traceExisting.Location__c,new Set<Id>());                    
                }
                locationByPersonsMap.get(traceExisting.Location__c).add(traceExisting.Person__c);
            }
            for(Location_Tracing__c newTrace: locationTraces){
                if(locationByPersonsMap.containsKey(newTrace.Location__c) 
                    && locationByPersonsMap.get(newTrace.Location__c).contains(newTrace.Person__c)){
                    duplicateLocationTracing.add(newTrace);        
                }
            }
        }
        return duplicateLocationTracing;
    }
    
}
