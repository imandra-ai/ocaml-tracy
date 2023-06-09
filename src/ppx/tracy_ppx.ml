open Ppxlib

let tr _ctx str =
  let inserted = ref false in
  let loc = Location.none in
  let traverse = object
    inherit Ast_traverse.map

    method! structure l =
      if !inserted then l
      else (
        inserted := true;
        [%stri let() = Tracy.enable()] :: l
      )
  end in
  traverse#structure str

let instrument = Driver.Instrument.V2.make tr ~position:Before


let () =
  Driver.register_transformation ~instrument "tracy"
