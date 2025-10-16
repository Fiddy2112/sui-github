module sui_nft::nft_marketplace {
    use std::string;
    use sui::object::{Self, UID};
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui_nft::sui_nft::MyNFT;

    public struct Listing has key {
        id: UID,
        nft: MyNFT,
        price: u64,
        seller: address,
    }

    public fun list_nft(nft: MyNFT, price: u64, ctx: &mut TxContext): Listing {
        Listing {
            id: object::new(ctx),
            nft,
            price,
            seller: tx_context::sender(ctx),
        }
    }

    public entry fun buy_nft(listing: Listing, mut payment: Coin<SUI>, ctx: &mut TxContext) {
        let buyer = tx_context::sender(ctx);
        let Listing { id, nft, price, seller } = listing;

        let pay_coin = coin::split(&mut payment, price, ctx);

        transfer::public_transfer(pay_coin, seller);

        transfer::public_transfer(nft, buyer);

        transfer::public_transfer(payment, buyer);

        object::delete(id);
    }
}
