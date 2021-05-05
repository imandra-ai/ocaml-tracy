
module T = Tracy

let () =
  T.name_thread "thread1";
  for _i = 0 to 100 do
    let _sp = T.enter ~file:__FILE__ ~line:__LINE__ ~name:"z1" () in
    for _j = 0 to 10 do
      let _sp = T.enter ~file:__FILE__ ~line:__LINE__ ~name:"z2" () in
      Thread.delay 0.05;

      if _j mod 3 = 0 then T.message "oh hello!";
      if _j mod 2 = 0 then T.plot "x" (float (_i * (1+_j)) /. 100.);

      T.exit _sp;
    done;
    T.exit _sp;
  done

