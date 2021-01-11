// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VMultiCoreVRTL_inner_0x4c075e0d1f6aefae.h for the primary calling header

#ifndef _VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit_H_
#define _VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit_H_

#include "verilated.h"
#include "VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Inlines.h"
#include "VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Dpi.h"

class VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Syms;
class VerilatedVcd;

//----------

VL_MODULE(VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit) {
  public:
    // CELLS
    
    // PORTS
    
    // LOCAL SIGNALS
    
    // LOCAL VARIABLES
    
    // INTERNAL VARIABLES
  private:
    //char	__VpadToAlign12[4];
    VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Syms*	__VlSymsp;		// Symbol table
  public:
    
    // PARAMETERS
    
    // CONSTRUCTORS
  private:
    VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit& operator= (const VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit&);	///< Copying not allowed
    VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit(const VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit&);	///< Copying not allowed
  public:
    VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit(const char* name="TOP");
    ~VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit();
    void trace (VerilatedVcdC* tfp, int levels, int options=0);
    
    // USER METHODS
    
    // API METHODS
    
    // INTERNAL METHODS
    void __Vconfigure(VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Syms* symsp, bool first);
    static void traceInit (VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceFull (VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceChg  (VerilatedVcd* vcdp, void* userthis, uint32_t code);
} VL_ATTR_ALIGNED(128);

#endif  /*guard*/
