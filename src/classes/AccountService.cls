public with sharing class AccountService {

    private static final Integer NUMBER_OF_UPDATED_CONTACTS = 2;

    public void reverseNameOnAccounts(List<Account> newAccounts) {
        for (Account newAccount : newAccounts) {
            newAccount.Name = newAccount.Name.reverse();
        }
    }

    public void changeRelatedContactNames(List<Account> newAccounts) {
        List<Contact> contactsToUpdate = new List<Contact>();

        Map<Id, List<Contact>> contactsByAccountId  = new Map<Id, List<Contact>>();
        for (Contact cont : contactsToUpdate(newAccounts)) {
            if (contactsByAccountId.containsKey(cont.AccountId)) {
                contactsByAccountId.get(cont.AccountId).add(cont);
            } else {
                contactsByAccountId.put(cont.AccountId, new List<Contact>{cont});
            }
        }

        for (Id accountId : contactsByAccountId.keySet()) {
            List<Contact> relatedContacts = contactsByAccountId.get(accountId);
            Integer i = 0;

            for (Contact contact : relatedContacts) {
                if (i == NUMBER_OF_UPDATED_CONTACTS) {
                    break;
                } else {
                    contact.FirstName = contact.Account.Owner.FirstName;
                    contact.LastName = contact.Account.Owner.LastName;

                    contactsToUpdate.add(
                            contact
                    );
                }

                i++;
            }

        }

        if (contactsToUpdate.size() > 0) {
            update contactsToUpdate;
        }
    }

    private List<Contact> contactsToUpdate(List<Account> Accounts) {
        return [
                SELECT Id, CreatedDate, Account.Owner.FirstName, Account.Owner.LastName, AccountId
                FROM Contact
                WHERE AccountId IN :Accounts
                ORDER BY CreatedDate DESC
        ];
    }
}