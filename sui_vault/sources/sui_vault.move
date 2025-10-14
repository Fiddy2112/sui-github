module sui_vault::sui_vault {

    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::transfer;
    use sui::tx_context;
    use sui::sui::SUI;
    use sui::object::{Self, UID};

    public struct Vault has key, store {
        id: UID,
        total_balance: Balance<SUI>,
        owner: address,
    }

    public entry fun create(ctx: &mut TxContext) {
        let vault = Vault {
            id: object::new(ctx),
            total_balance: balance::zero<SUI>(),
            owner: tx_context::sender(ctx),
        };
        transfer::public_transfer(vault, tx_context::sender(ctx));
    }

    public entry fun deposit(vault: &mut Vault, coin: Coin<SUI>, ctx: &mut TxContext) {
        let bal = coin::into_balance(coin);
        balance::join<SUI>(&mut vault.total_balance, bal);
    }

    public entry fun withdraw(vault: &mut Vault, amount: u64, ctx: &mut TxContext) {
        assert!(tx_context::sender(ctx) == vault.owner, 0);

        let withdrawn = balance::split<SUI>(&mut vault.total_balance, amount);
        let coin = coin::from_balance<SUI>(withdrawn, ctx);

        transfer::public_transfer(coin, vault.owner);
    }
}
