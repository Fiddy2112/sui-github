module managed::managed {
    use std::string;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::coin_registry;
    use sui::transfer;
    use sui::object;


    public struct MANAGED has drop {}


    public struct ManagedToken has key {
        id: object::UID,
        owner: address,
        paused: bool,
        total_supply: u64,
    }


    fun init(witness: MANAGED, ctx: &mut TxContext) {
        let (currency_init, treasury_cap) = coin_registry::new_currency_with_otw<MANAGED>(
            witness,
            9u8, // decimals
            string::utf8(b"MGD"),
            string::utf8(b"Managed Token V2"),
            string::utf8(b"Token with admin control and total supply"),
            string::utf8(b"https://example.com/icon.png"),
            ctx
        );

        transfer::public_freeze_object(currency_init);


        let admin = ManagedToken {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            paused: false,
            total_supply: 0,
        };


        transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
        transfer::public_transfer(admin, tx_context::sender(ctx));
    }


    fun assert_owner(admin: &ManagedToken, ctx: &TxContext) {
        assert!(admin.owner == tx_context::sender(ctx), 0);
    }

    fun assert_not_paused(admin: &ManagedToken) {
        assert!(!admin.paused, 1);
    }


    public entry fun toggle_pause(admin: &mut ManagedToken, ctx: &TxContext) {
        assert_owner(admin, ctx);
        admin.paused = !admin.paused;
    }

    /// 🪙 Mint token mới (chỉ owner)
    public entry fun mint_and_send(
        admin: &mut ManagedToken,
        cap: &mut TreasuryCap<MANAGED>,
        amount: u64,
        recipient: address,
        ctx: &mut TxContext,
    ) {
        assert_owner(admin, ctx);
        assert_not_paused(admin);
        coin::mint_and_transfer(cap, amount, recipient, ctx);
        admin.total_supply = admin.total_supply + amount;
    }
    public entry fun burn(
        admin: &mut ManagedToken,
        cap: &mut TreasuryCap<MANAGED>,
        coin_obj: Coin<MANAGED>,
        ctx: &mut TxContext,
    ) {
        assert_owner(admin, ctx);
        assert_not_paused(admin);
        let burned = coin::burn(cap, coin_obj);
        admin.total_supply = admin.total_supply - burned;
    }


    public fun get_total_supply(admin: &ManagedToken): u64 {
        admin.total_supply
    }


    public entry fun transfer_coin(c: Coin<MANAGED>, to: address) {
        transfer::public_transfer(c, to);
    }
}
