@IsTest
private class AccountTriggerHandlerTest {

    public static final String ACCOUNT_TEST_NAME = 'ACCOUNT_TEST_NAME';
    public static final String ACCOUNT_TEST_NAME_REVERSE = ACCOUNT_TEST_NAME.reverse();
    public static final String TEST_OLD_CONTACT_FIRST_NAME = 'OLD FIRST NAME';
    public static final String TEST_OLD_CONTACT_LAST_NAME = 'OLD LAST NAME';
    public static final String TEST_NEW_CONTACT_FIRST_NAME = 'NEW FIRST NAME';
    public static final String TEST_NEW_CONTACT_LAST_NAME = 'NEW LAST NAME';

    @IsTest
    static void testAccountNameReverse() {
        Account testAccount = new Account(Name = ACCOUNT_TEST_NAME);

        Test.startTest();
        insert testAccount;
        Test.stopTest();

        testAccount = [SELECT Name FROM Account WHERE Id = :testAccount.Id].get(0);

        System.assertEquals(ACCOUNT_TEST_NAME_REVERSE, testAccount.Name, 'Name should be reversed.');
    }

    @IsTest
    static void testAccountRelatedContactsNameChange() {
        String runningUserName = [SELECT Name FROM User WHERE Id = :UserInfo.getUserId()].get(0).Name;
        Account testAccountOne = createTestAccount(ACCOUNT_TEST_NAME);
        Account testAccountTwo = createTestAccount(ACCOUNT_TEST_NAME);

        List<Contact> oldContacts = createTestContacts(TEST_OLD_CONTACT_FIRST_NAME, TEST_OLD_CONTACT_LAST_NAME, testAccountOne.Id,5);
        List<Contact> newContacts = createTestContacts(TEST_NEW_CONTACT_FIRST_NAME, TEST_NEW_CONTACT_LAST_NAME, testAccountTwo.Id,5);

        Test.startTest();
        testAccountOne.NumberOfEmployees = 5;
        testAccountTwo.NumberOfEmployees = 5;

        update new List<Account>{testAccountOne, testAccountTwo};
        Test.stopTest();

        oldContacts = [SELECT Id, Name FROM Contact WHERE Id IN :oldContacts];
        newContacts = [SELECT Id, Name FROM Contact WHERE Id IN :newContacts];

        Set<Contact> contactsWithUpdatedName = new Set<Contact>();
        for (Contact newContact : oldContacts) {
            if (newContact.Name == runningUserName) {
                contactsWithUpdatedName.add(newContact);
            }
        }
        System.assertEquals(2, contactsWithUpdatedName.size(), 'Contact Name should be the same to running user');

        contactsWithUpdatedName.clear();

        for (Contact newContact : newContacts) {
            if (newContact.Name == runningUserName) {
                contactsWithUpdatedName.add(newContact);
            }
        }
        System.assertEquals(2, contactsWithUpdatedName.size(), 'Contact Name should be the same to running user');

    }

    private static Account createTestAccount(String accountName) {
        Account testAccount = new Account(Name = accountName);
        insert testAccount;

        return testAccount;
    }

    private static List<Contact> createTestContacts(String contactFirstName, String contactLastName, Id accountId, Integer numberOfContacts) {
        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < numberOfContacts; i ++) {
            contacts.add(
                    new Contact(FirstName = contactFirstName, LastName = contactLastName, AccountId = accountId)
            );
        }

        insert contacts;
        return contacts;
    }

}