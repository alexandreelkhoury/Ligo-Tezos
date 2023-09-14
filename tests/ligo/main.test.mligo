#import "./helpers/bootstrap.mligo" "Bootstrap"
#import "../../contracts/errors.mligo" "Contract_Errors"

let () = Test.log("[MAIN] testing entrypoints for contracts")

let test_success_submitNumber = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    Test.transfer_to_contract contr (SubmitNumber(23n)) 0mutez

let test_failure_submitNumber_duplicateNumber = 
    let (admin, user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source user1 in
    let _ = Test.transfer_to_contract contr (SubmitNumber(23n)) 0mutez in
    let test_result : test_exec_result = Test.transfer_to_contract contr (SubmitNumber(23n)) 0mutez in
    let () = match test_result with
        | Fail (Rejected (actual, _)) -> assert(actual = Test.eval "Number already picked")
        | Fail (Balance_too_low _) -> failwith("Balance is too low")
        | Fail (Other _p) -> failwith("p")
        | Success (_) -> Test.failwith("Test should have failed")
    in
    ()

let test_failure_submitNumber_adminSubmitting = 
    let (admin, _user1, _user2) = Bootstrap.bootstrap_accounts() in
    let (_addr, _t_addr, contr) = Bootstrap.originate_contract(admin) in
    let () = Test.set_source admin in
    let test_result : test_exec_result = Test.transfer_to_contract contr (SubmitNumber(23n)) 0mutez in
    let () = match test_result with
        | Fail (Rejected (actual, _)) -> assert(actual = (Test.eval "Admin cannot submit number"))
        | Fail (Balance_too_low _) -> failwith("Balance is too low")
        | Fail (Other _p) -> failwith("p")
        | Success (_) -> Test.failwith("Test should have failed")
    in
    ()
