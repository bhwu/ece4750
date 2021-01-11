// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Implementation of DPI export functions.
//
// Verilator compiles this file in when DPI functions are used.
// If you have multiple Verilated designs with the same DPI exported
// function names, you will get multiple definition link errors from here.
// This is an unfortunate result of the DPI specification.
// To solve this, either
//    1. Call VMultiCoreVRTL_inner_0x4c075e0d1f6aefae::{export_function} instead,
//       and do not even bother to compile this file
// or 2. Compile all __Dpi.cpp files in the same compiler run,
//       and #ifdefs already inserted here will sort everything out.

#include "VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Dpi.h"
#include "VMultiCoreVRTL_inner_0x4c075e0d1f6aefae.h"

#ifndef _VL_DPIDECL_line_trace
#define _VL_DPIDECL_line_trace
void line_trace (svBitVecVal* trace_str) {
    // DPI Export at lab5_mcore/MultiCoreVRTL.v:232
    return VMultiCoreVRTL_inner_0x4c075e0d1f6aefae::line_trace(trace_str);
}
#endif

