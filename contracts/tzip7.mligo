type balances = (address, nat) map
type allowance = (address, nat) map
type allowances = (address, allowance) map

type storage = {
    admin : address;
    balances : balances;
    totalSupply : nat;
    allowances : allowances;
}

type return = operation list * storage 

type parameter =
  transfer of nat
| approve of nat

let transfer (from_ : address) (value : nat) (to_ : address) (store : storage) : storage =
    let () = (store.balances[from_] -= value) in
    let () = (store.balances[to_] += value) in
    store

let approve (spender : address) (value : nat) (store : storage) : storage =
    let owner = (Tezos.sender) in
    let () = (store.allowances[owner][spender] = value) in

let main (action : parameter )(store : storage) : return =
    ([] : operation list), (match action with
        | transfer (n) -> transfer n store
        | approve (n) -> approve n store)

[@view] let getAllowance (owner : address) (spender : address) (store : storage) : nat =
            (store.allowances[owner][spender])

[@view] let getBalance (address : address) (store : storage) : address =
            (store.balances[address])

[@view] let getTotalSupply (store : storage) : nat =
            (store.totalSupply)