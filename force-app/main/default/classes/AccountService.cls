public with sharing class AccountService {
    public static Account getAccountById(Id targetId) {
        return getAccountMapByIds(new Set<Id>{ targetId }).get(targetId);
    }

    public static Map<Id, Account> getAccountMapByIds(Set<Id> targetIds) {
        return new Map<Id, Account>(
            [
                SELECT Id, Name, ParentId, Parent.Name
                FROM Account
                WHERE Id IN :targetIds
            ]
        );
    }

    public static Database.SaveResult[] updateAccounts(
        List<Account> accountList,
        Boolean allOrNone
    ) {
        return ServiceUtil.generalUpdate(accountList, allOrNone);
    }
}