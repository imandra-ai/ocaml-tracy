
module T = Tracy

let main_loop i n =
  T.name_thread (Printf.sprintf "thread_%d" i);
  for _i = 0 to n do
    let _sp = T.enter ~file:__FILE__ ~line:__LINE__ ~name:"z1" () in
    for _j = 0 to 10 do
      T.with_ ~file:__FILE__ ~line:__LINE__ ~name:"z2" () @@ fun () ->
      Thread.delay 0.05;

      if _j mod 3 = 0 then T.message_f (fun k->k "oh hello from %d!" i);
      if _j mod 2 = 0 then T.plot "x" (float (_i * (1+_j)) /. 100.);
    done;
    T.exit _sp;
  done


let () =
  T.enable();
  let n = 100 in
  let l = CCList.init 3 (fun i -> Thread.create (main_loop i) n) in
  List.iter Thread.join l;
  ()
