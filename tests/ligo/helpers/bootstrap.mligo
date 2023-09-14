#import "../../../contracts/main.mligo" "Contract"

type originated = (
    address * 
    (Contract.parameter, Contract.storage) typed_address *
    Contract.parameter contract
)

let bootstrap_accounts () = 
    let () = Test.reset_state 5n ([] : tez list) in 
    let accounts = 
        Test.nth_bootstrap_account 1,
        Test.nth_bootstrap_account 2,
        Test.nth_bootstrap_account 3
    in
    accounts

let initial_storage(initial_admin : address) = {
    admin = initial_admin ;
    winner = (None : address option);
    numbers = (Map.empty : Contract.numbers)
}

let initial_balance = 0mutez

let originate_contract (admin : address) : originated = 
    let init_storage = (Test.eval(initial_storage(admin))) in
    let (addr, _code, _nonce) = 
        Test.originate_from_file "../../../contracts/main.mligo" "main" (["check-winner"] : string list) init_storage initial_balance in
    let typed_address = Test.cast_address addr in
    let actual_storage = Test.get_storage typed_address in  
    let () = assert(init_storage = actual_storage) in
    let contr = Test.to_contract typed_address in
    (addr, typed_address, contr)