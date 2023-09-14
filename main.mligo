type storage = int list

type parameter =
  Increment of int
| Decrement of int

type return = operation list * storage

let add (delta : int)(store : storage) : int = 
  let head : int = 
    match List.head_opt store with
      None -> Failwith "Empty list"
      | Some (x) -> x
  in
  tail + delta

let sub (delta : int)(store : storage) : int =
   let head : int = 
    match List.head_opt store with
      None -> Failwith "Empty list"
      | Some (x) -> x
  in
  tail - delta

(* Main access point that dispatches to the entrypoints according to
   the smart contract parameter. *)

let main (action, store : parameter * storage) : return =
  let new_number : int = match action with
      Increment (n) -> add n store
    | Decrement (n) -> sub n store
  in
  let new_store : storage = new_number :: store in
  ([] : operation list), new_store