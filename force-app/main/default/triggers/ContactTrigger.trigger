trigger ContactTrigger on Contact (After insert, After update, After delete, After undelete) {

    private String contexto = String.valueOf(Trigger.OperationType);
    switch on Trigger.OperationType {
        when AFTER_INSERT {
            System.debug('Contexto do after: '+contexto);
            ContactTriggerHandler.afterInsertTriggerHandler(Trigger.new);
        }
        when AFTER_UPDATE {
            System.debug('Contexto do after: '+contexto);
            ContactTriggerHandler.afterUpdateTriggerHandler(Trigger.new, Trigger.oldMap);
        }
        when AFTER_DELETE{
            System.debug('Contexto do after: '+contexto);
            ContactTriggerHandler.afterDeleteTriggerHandler(Trigger.old);
        }
        when AFTER_UNDELETE{
            System.debug('Contexto do after: '+contexto);
            ContactTriggerHandler.afterUndeleteTriggerHandler(Trigger.new);
        }
    }
}