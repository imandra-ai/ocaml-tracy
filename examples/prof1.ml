module T = Tracy_client

let rec fib n =
  if n <= 1 then
    1
  else
    fib (n - 1) + fib (n - 2)

let main_loop th_n n =
  T.name_thread (Printf.sprintf "thread_%d" th_n);
  for i = 1 to n do
    let _sp = T.enter ~cs_depth:15 ~__FILE__ ~__LINE__ "outer" in
    T.add_text_f _sp (fun k -> k "outer loop %d/%d" i n);

    for j = 0 to 10 do
      T.with_ ~__FILE__ ~__LINE__ "inner.fib" @@ fun _sp ->
      T.set_color _sp 0xaa000f;

      let fib_param = 20 + ((i + (4 * j) + th_n) mod 19) in
      T.add_text_f _sp (fun k -> k "compute fib(%d)" fib_param);

      let fib_res = fib fib_param in
      Thread.delay 0.001;

      T.message_f (fun k -> k "fib(%d) = %d" fib_param fib_res);

      if j mod 2 = 0 then T.plot "fib" (float fib_res)
    done;
    T.exit _sp;
    Printf.printf "done with step %d/%d\n%!" i n
  done

let () =
  T.set_app_info "prof1: example of application profiled with Tracy";
  let n = try int_of_string @@ Sys.getenv "N" with _ -> 100 in
  let l = CCList.init 3 (fun i -> Thread.create (main_loop i) n) in
  List.iter Thread.join l;
  T.message "all done";
  ()
