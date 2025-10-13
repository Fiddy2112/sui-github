module sui_bank::sui_bank {
    use sui::tx_context;
    use sui::transfer;
    use sui::object;
    use std::debug;

    public struct Account has key {
        id:object::UID,
        balance: u64,
    }

    public fun create_account(ctx: &mut TxContext) {
        let uid = object::new(ctx);
        let account = Account { id:uid, balance: 0 };
        transfer::share_object(account);
        debug::print(&"Account created successfully");
    }

    public fun deposit(account: &mut Account, amount: u64) {
        account.balance = account.balance + amount;
        debug::print(&"Deposit success");
    }

    public fun withdraw(account: &mut Account, amount: u64) {
        assert!(account.balance >= amount, 0);
        account.balance = account.balance - amount;
        debug::print(&"Withdraw success");
    }

    public fun get_balance(account: &Account): u64 {
        account.balance
    }
}
