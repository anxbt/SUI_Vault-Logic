module hello_world::vault {

use sui::coin::{Self, Coin};
    use sui::sui::SUI;



    /// The Vault object that will store coins
    public struct Vault has key {
        id:sui::object::UID,
        balance: Coin<SUI>,
    }

    /// Initializes a new Vault
    public fun new_vault(ctx: &mut TxContext): Vault {
        Vault {
            id: object::new(ctx),
            balance: coin::zero<SUI>(ctx),
        }
    }

    /// Deposits a specific amount from the user's Coin into the Vault
    public fun deposit(
        vault: &mut Vault,
        user_coin: Coin<SUI>,
        amount: u64,
        ctx: &mut TxContext
    ): Coin <SUI>{
         let user_balance = coin::value(&user_coin);
         assert!(user_balance >= amount, EINSUFFICIENT_BALANCE);


        // Split the user's coin to get the desired amount
        let (deposit_coin, remainder_coin) = coin::split(user_coin, amount, ctx);

        // Merge the deposit_coin into the vault's balance
        coin::join(&mut vault.balance, deposit_coin);

        // Return the remainder to the user
        remainder_coin
    }
}
