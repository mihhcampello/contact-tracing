public with sharing class CTLocationController {
    
    public static List<Location__c> getRecentHealthChanger(){
        return [SELECT Id, Name, Pincode__c, Address__c, Status_Update_Date__c, Status__c
                FROM Location__c
                ORDER BY Status_Update_Date__c DESC LIMIT 100];
    }

    public static list<Location__c> searchLocations(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Pincode__c, Address__c, Status_Update_Date__c, Status__c
                FROM Location__c
                WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm
                ORDER BY Status_Update_Date__c DESC];
    }

    public static Location__c getLocationById(String locationId){
        List<Location__c> locations = [SELECT Id, Name, Pincode__c, Address__c, Status_Update_Date__c, Status__c 
                                        FROM Location__c
                                        WHERE Id =: locationId];
        if(locations != null && locations.size() > 0){
            return locations[0];
        }else {
            return null;
        }
    }

    public static getStatusCount(){

        Map<String, Integer> statusCountMap = new Map<String, Integer>();

        for(AggregateResult result : [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c]){
            String statusLocation = String.valueOf(result.get('Status__c'));
            Integer totalLocations = Integer.valueOf(result.get('total'));
            statusCountMap.put(statusLocation,totalLocations);
        }
        return statusCountMap;
    }
}
