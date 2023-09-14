// #import "./types.mligo" "Types"
#import "./errors.mligo" "Errors"

type numbers = (nat, address) map

type storage = {
    admin : address;
    winner : address option;
    numbers : numbers
}

type return = operation list * storage 

type parameter =
  SubmitNumber of nat
| CheckWinner of nat

let submit_number (n : nat) (store : storage) : storage =
    let () = if (Tezos.get_sender() = store.admin) then (failwith Errors.admin_can_not_play) in
    let () = if (n < 1n) || (n > 100n) then (failwith Errors.number_out_of_bounds) in
    let map_opt : address option = Map.find_opt n store.numbers in
    match map_opt with
        | Some (_) -> failwith Errors.number_already_picked
        | None -> 
        let new_numbers = Map.add n (Tezos.get_sender()) store.numbers in
        { store with numbers = new_numbers }

let check_winner (n : nat) (store : storage) : storage =
    let () = if (store.admin <> Tezos.get_sender()) then (failwith Errors.only_admin) in
    let map_opt : address option = Map.find_opt n store.numbers in
    match map_opt with
        | None -> failwith Errors.number_not_picked
        | Some (n) -> { store with winner = Some(n) }

let main (action : parameter )(store : storage) : return =
    ([] : operation list), (match action with
        | SubmitNumber (n) -> submit_number n store
        | CheckWinner (n) -> check_winner n store)

[@view] let check_winner (n : nat) (store : storage) : address =
            let map_opt : address option = Map.find_opt n store.numbers in
            match map_opt with
                | None -> failwith Errors.number_not_picked
                | Some (addr) -> addr