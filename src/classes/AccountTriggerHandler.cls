public with sharing class AccountTriggerHandler {


    public static void beforeInsert(List<Account> newAccounts) {
        AccountService.reverseNameOnAccounts(newAccounts);

    }
    public static void beforeUpdate(List<Account> newAccounts) {
        AccountService.reverseNameOnAccounts(newAccounts);
    }

    public static void afterUpdate(List<Account> newAccounts) {
        AccountService.changeRelatedContactNames(newAccounts);
    }
}