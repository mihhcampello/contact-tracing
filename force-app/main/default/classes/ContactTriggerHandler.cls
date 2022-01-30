public with sharing class ContactTriggerHandler {
    
    public static void afterInsertTriggerHandler(List<Contact> newContacts){
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact : newContacts){
            If(contact.Active__c){
               accountIds.add(contact.AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }
    public static void afterUpdateTriggerHandler(List<Contact> contacts,Map<Id,Contact> oldContactsMap){
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact : contacts){
            Contact oldContact = oldContactsMap.get(contact.Id);
            If(contact.Active__c && contact.Active__c != oldContact.Active__c){
               accountIds.add(contact.AccountId);
            }
            If(contact.AccountId != oldContact.AccountId){
                accountIds.add(oldContact.AccountId);                
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
    }
    public static void afterDeleteTriggerHandler(List<Contact> oldContacts){
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact : oldContacts){
            If(contact.Active__c){
               accountIds.add(contact.AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
        //mais granular-repedido para incrementos futuros aqui

    }
    public static void afterUndeleteTriggerHandler(List<Contact> contactsUndeleted){
        Set<Id> accountIds = new Set<Id>();
        for(Contact contact : contactsUndeleted){
            If(contact.Active__c){
               accountIds.add(contact.AccountId);
            }
        }
        AccountContactService.updateActiveContacts(accountIds);
        //mais granular-repedido para incrementos futuros aqui
    }
}
