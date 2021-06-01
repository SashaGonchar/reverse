public with sharing class AccountTriggerHandler {


    public static void beforeInsert(List<Account> newAccounts) {
        new AccountService().reverseNameOnAccounts(newAccounts);
    }
    public static void beforeUpdate(List<Account> newAccounts) {
        new AccountService().reverseNameOnAccounts(newAccounts);
    }
    public static void afterInsert(List<Account> newAccounts) {
//        new AccountService().changeRelatedContactNames(newAccounts);
    }

    public static void afterUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountById) {
        new AccountService().changeRelatedContactNames(newAccounts); 
    }
}