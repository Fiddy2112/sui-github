module managed::managed {
    use sui::coin;
    use sui::coin_registry;
    use sui::tx_context;
    use sui::transfer;
    use std::string;


    public struct MANAGED has drop {}


    fun init(witness: MANAGED, ctx: &mut tx_context::TxContext) {

        let (init, cap) = coin_registry::new_currency_with_otw<MANAGED>(
            witness,
            string::utf8(b"Managed Token"), // name
            string::utf8(b"MGD"),           // symbol
            9,                              // decimals
            true,                           // icon display
            string::utf8(b"https://ibb.co/LDxs7LP0"), // icon_url
            ctx
        );


        transfer::public_freeze_object(init);

        transfer::public_transfer(cap, tx_context::sender(ctx));
    }


    public fun burn(cap: &mut coin::TreasuryCap<MANAGED>, coin_obj: coin::Coin<MANAGED>): u64 {
        coin::burn(cap, coin_obj)
    }

    public fun simple_transfer(c: coin::Coin<MANAGED>, to: address) {
        transfer::public_transfer(c, to);
    }
}
