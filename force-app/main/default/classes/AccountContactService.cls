public with sharing class AccountContactService {
    
    public static void updateActiveContacts(Set<Id> accountIds){
        List<Account> accountsUpdate = new List<Account>();
        accountsUpdate = [SELECT Id, Active_Contacts__c, 
                            (SELECT Id, Active__c FROM Contacts WHERE Active__c = TRUE) 
                            FROM Account 
                            WHERE Id IN :accountIds];
        Map<Id,Account> accountsMap = new Map<Id,Account>();
        for(Account account : accountsUpdate){
            Integer totalContacts = account.Contacts.size(); 
            account.Active_Contacts__c = totalContacts;
            accountsMap.put(account.Id, account);
        }
        for(Id accountId : accountIds){ 
            if(!accountsMap.containsKey(accountId)){
                accountsMap.put(accountId, new Account(Id=accountId,Active_Contacts__c=0));
            }
        } 
        update accountsMap.values();
    }
}
