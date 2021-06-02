public with sharing class AccountService {
    
    public static void reverseNameOnAccounts(List<Account> newAccounts) {
        for (Account newAccount : newAccounts) {
            newAccount.Name = newAccount.Name.reverse();
        }
    }

    public static void changeRelatedContactNames(List<Account> Accounts) {
        Map<Id, List<Contact>> contactsByAccountId = generateContactsByAccountIdMap(Accounts);

        List<Contact> contactsToUpdate = generateContactsToUpdateList(contactsByAccountId);

        updateContacts(contactsToUpdate);
    }
    
    private static Map<Id, List<Contact>> generateContactsByAccountIdMap(List<Account> Accounts) {

        Map<Id, List<Contact>> contactsByAccountId  = new Map<Id, List<Contact>>();

        for (Contact cont : selectContactsByAccountIds(Accounts)) {
            if (contactsByAccountId.containsKey(cont.AccountId)
                    && contactsByAccountId.size()<2) {
                contactsByAccountId.get(cont.AccountId).add(cont);
            } else {
                contactsByAccountId.put(cont.AccountId, new List<Contact>{cont});
            }
        }
        return contactsByAccountId;
    }



    private static List<Contact> generateContactsToUpdateList(Map<Id, List<Contact>> contactsByAccountId) {
        List<Contact> contactsToUpdate = new List<Contact>();

        for (Id accountId : contactsByAccountId.keySet()) {
            List<Contact> relatedContacts = contactsByAccountId.get(accountId);

            for (Contact contact : relatedContacts) {
                    contact.FirstName = contact.Account.Owner.FirstName;
                    contact.LastName = contact.Account.Owner.LastName;

                    contactsToUpdate.add(
                            contact
                    );
                }
            }
        return contactsToUpdate;
    }

    private static void updateContacts(List<Contact> contactsToUpdate) {
        if (contactsToUpdate.size() > 0) {
            update contactsToUpdate;
        }
    }

    private static List<Contact> selectContactsByAccountIds(List<Account> Accounts) {
        return [
                SELECT Id, CreatedDate, Account.Owner.FirstName, Account.Owner.LastName, AccountId
                FROM Contact
                WHERE AccountId IN :Accounts
                ORDER BY CreatedDate DESC
        ];
    }
}