public with sharing class CTPersonController {
    
    public static String getToken(String mobileNo){
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);

        //get the string value of hash blob
        return EncodingUtil.base64Encode(hash);
    }

    public static List<Person__c> getRecentHealthChanger(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c Order by Status_Update_Date__c 
                DESC LIMIT 100];

    }

    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c 
                WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm
                ORDER BY Status_Update_Date__c ASC];
    }

    public static Person__c getPersonById(String personId){
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c
                WHERE Id=:personId]; // Uso de uma lista ao invés de um único retorno, pois evita estourar uma exceção de Id inválido caso ocorra esse caso, e posso então ser tratado o retorno null (registro não encontrado registro)
        if(people != null && people.size() > 0){
            return people[0];
        }else {
            return null;
        }
    }

    public static Map<String, Integer> getHealthStatusCount(){
        Map<String, Integer> mapHealthStatus = new Map<String,Integer>();

        for(AggregateResult result : [SELECT Health_Status__c, COUNT(Id) totalHealthStatus FROM Person__c GROUP BY Health_Status__c]){

            String healthStatus = String.valueOf(result.get('Health_Status__c'));
            Integer total = Integer.valueOf(result.get('totalHealthStatus'));
            mapHealthStatus.put(healthStatus,total);
        }
        return mapHealthStatus;
    }
}
