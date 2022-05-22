
#include <caml/memory.h>
#include <caml/mlvalues.h>

#include <stdbool.h>
#include <stdint.h>

// needed for macros to do anything
#define TRACY_ENABLE 1

#include "tracy/TracyC.h"

extern "C" {

// controls if tracy is enabled
static bool enabled = false;

#define INT_OF_CTX(ctx) ((((uint64_t)ctx.id) << 1) | ((uint64_t)ctx.active))
#define CTX_OF_INT(i)                                                          \
  { .id = ((uint32_t)(i >> 1)), .active = ((i & 1) != 0), }

// return the unique uint32 for this zone
CAMLprim value ml_tracy_enter(value file, value fun, value line, value name) {
  CAMLparam4(file, fun, line, name);

  if (!enabled) {
    CAMLreturn(Val_int(0));
  }

  // declare a srcloc
  uint32_t c_line = (uint32_t)Int_val(line);

  char const *c_file = String_val(file);
  size_t c_file_len = caml_string_length(file);

  char const *c_fun = String_val(fun);
  size_t c_fun_len = caml_string_length(fun);

  char const *c_name = String_val(name);
  size_t c_name_len = caml_string_length(name);

  uint64_t srcloc = ___tracy_alloc_srcloc_name(
      c_line, c_file, c_file_len, c_fun, c_fun_len, c_name, c_name_len);

  // enter zone
  TracyCZoneCtx ctx = ___tracy_emit_zone_begin_alloc(srcloc, true);

  uint64_t res = INT_OF_CTX(ctx);

  CAMLreturn(Val_int((int)res));
}

// exit using the value returned by `ml_tracy_enter`
CAMLprim value ml_tracy_exit(value span) {
  CAMLparam1(span);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  uint64_t bundle = Int_val(span);
  TracyCZoneCtx ctx = CTX_OF_INT(bundle);

  ___tracy_emit_zone_end(ctx);

  CAMLreturn(Val_unit);
}

CAMLprim value ml_tracy_span_color(value span, value color) {
  CAMLparam2(span, color);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  uint64_t bundle = Int_val(span);
  TracyCZoneCtx ctx = CTX_OF_INT(bundle);

  uint64_t c_color = Int_val(color);

  ___tracy_emit_zone_color(ctx, c_color);

  CAMLreturn(Val_unit);
}

CAMLprim value ml_tracy_span_value(value span, value v) {
  CAMLparam2(span, v);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  uint64_t bundle = Int_val(span);
  TracyCZoneCtx ctx = CTX_OF_INT(bundle);

  uint64_t c_val = Int64_val(v);

  ___tracy_emit_zone_value(ctx, c_val);

  CAMLreturn(Val_unit);
}

CAMLprim value ml_tracy_span_text(value span, value txt) {
  CAMLparam2(span, txt);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  uint64_t bundle = Int_val(span);
  TracyCZoneCtx ctx = CTX_OF_INT(bundle);

  const char *c_text = String_val(txt);
  size_t c_text_len = caml_string_length(txt);

  ___tracy_emit_zone_text(ctx, c_text, c_text_len);

  CAMLreturn(Val_unit);
}

CAMLprim value ml_tracy_enable(value _void) {
  CAMLparam1(_void);
  enabled = true;
  CAMLreturn(Val_unit);
}

CAMLprim value ml_tracy_enabled(value _void) {
  CAMLparam1(_void);
  CAMLreturn(Val_bool(enabled));
}

CAMLprim value ml_tracy_name_thread(value name) {
  CAMLparam1(name);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  char const *c_name = String_val(name);
  TracyCSetThreadName(c_name);

  CAMLreturn(Val_unit);
}

CAMLprim value ml_tracy_msg(value name) {
  CAMLparam1(name);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  char const *c_name = String_val(name);
  size_t c_len = caml_string_length(name);

  TracyCMessage(c_name, c_len);

  CAMLreturn(Val_unit);
}

CAMLprim value ml_tracy_plot(value name, value x) {
  CAMLparam2(name, x);

  if (!enabled) {
    CAMLreturn(Val_unit);
  }

  char const *c_name = String_val(name);
  // size_t c_len = caml_string_length(name);

  double c_x = Double_val(x);

  TracyCPlot(c_name, c_x);

  CAMLreturn(Val_unit);
}
}
