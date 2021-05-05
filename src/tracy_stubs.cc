
#include <caml/mlvalues.h>
#include <caml/memory.h>

#include <stdint.h>
#include <stdbool.h>

// needed for macros to do anything
#define TRACY_ENABLE 1

#include "tracy/TracyC.h"

extern "C" {

// controls if tracy is enabled
static bool enabled = false;

// return the unique uint32 for this zone
CAMLprim value ml_tracy_enter(value file, value fun, value line, value name) {
  CAMLparam4(file, fun, line, name);

  if (!enabled) {
    CAMLreturn(Val_int(0));
  }

  ___tracy_init_thread(); // idempotent

  // declare a srcloc
  uint32_t c_line = (uint32_t) Int_val(line);

  char const * c_file = String_val(file);
  size_t c_file_len = caml_string_length(file);

  char const * c_fun = String_val(fun);
  size_t c_fun_len = caml_string_length(fun);

  char const * c_name = String_val(name);
  size_t c_name_len = caml_string_length(name);

  uint64_t srcloc =
    ___tracy_alloc_srcloc_name(c_line, c_file, c_file_len, c_fun,
      c_fun_len, c_name, c_name_len);

  // enter zone
  TracyCZoneCtx ctx =
    ___tracy_emit_zone_begin_alloc(srcloc, true);

  uint32_t id = ctx.id;

  CAMLreturn (Val_int((int) id));
}

// exit using the value returned by `ml_tracy_enter`
CAMLprim value ml_tracy_exit(value id) {
  CAMLparam1(id);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  uint32_t c_id = (uint32_t) Int_val(id);
  TracyCZoneCtx ctx = { .id =  c_id, .active =  true };

  ___tracy_emit_zone_end(ctx);

  CAMLreturn (Val_unit);

}

CAMLprim value ml_tracy_enable(value _void) {
  CAMLparam1(_void);
  enabled = true;
  CAMLreturn (Val_unit);
}

CAMLprim value ml_tracy_enabled(value _void) {
  CAMLparam1(_void);
  CAMLreturn (Val_bool(enabled));
}

CAMLprim value ml_tracy_name_thread(value name) {
  CAMLparam1(name);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  char const * c_name = String_val(name);
  TracyCSetThreadName(c_name);

  CAMLreturn (Val_unit);
}

CAMLprim value ml_tracy_msg(value name) {
  CAMLparam1(name);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  char const * c_name = String_val(name);
  size_t c_len = caml_string_length(name);

  TracyCMessage(c_name, c_len);

  CAMLreturn (Val_unit);
}

CAMLprim value ml_tracy_plot(value name, value x) {
  CAMLparam2(name, x);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  char const * c_name = String_val(name);
  //size_t c_len = caml_string_length(name);

  double c_x = Double_val(x);

  TracyCPlot(c_name, c_x);

  CAMLreturn (Val_unit);
}

}
