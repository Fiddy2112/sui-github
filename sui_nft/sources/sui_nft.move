module sui_nft::sui_nft{
    use std::string;
    use sui::object;
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    public struct MyNFT has key,store{
        id: object::UID,
        name: string::String,
        description: string::String,

    }

    public entry fun mint_NFT(name:string::String, description:string::String, ctx: &mut TxContext){
        let nft = MyNFT {
            id: object::new(ctx),
            name: name,
            description: description,
        };
        transfer::transfer(nft, tx_context::sender(ctx));
    }

    public fun get_name(nft: &MyNFT): &string::String{
        &nft.name
    }

    public fun get_description(nft: &MyNFT): &string::String{
        &nft.description
    }
}