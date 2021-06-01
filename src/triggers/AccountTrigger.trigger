trigger AccountTrigger on Account (before insert, before update, after insert, after update) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            AccountTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            AccountTriggerHandler.beforeUpdate(Trigger.new);
        }
        when AFTER_INSERT {
            AccountTriggerHandler.afterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
            AccountTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        when else {
            System.debug('Not Used Trigger Context12.');
        }
    }
}