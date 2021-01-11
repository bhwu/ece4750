// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See VSingleCoreVRTL_0x30790e83be4b4066.h for the primary calling header

#ifndef _VSingleCoreVRTL_0x30790e83be4b4066___024unit_H_
#define _VSingleCoreVRTL_0x30790e83be4b4066___024unit_H_

#include "verilated.h"
#include "VSingleCoreVRTL_0x30790e83be4b4066__Inlines.h"
#include "VSingleCoreVRTL_0x30790e83be4b4066__Dpi.h"

class VSingleCoreVRTL_0x30790e83be4b4066__Syms;
class VerilatedVcd;

//----------

VL_MODULE(VSingleCoreVRTL_0x30790e83be4b4066___024unit) {
  public:
    // CELLS
    
    // PORTS
    
    // LOCAL SIGNALS
    
    // LOCAL VARIABLES
    
    // INTERNAL VARIABLES
  private:
    //char	__VpadToAlign12[4];
    VSingleCoreVRTL_0x30790e83be4b4066__Syms*	__VlSymsp;		// Symbol table
  public:
    
    // PARAMETERS
    
    // CONSTRUCTORS
  private:
    VSingleCoreVRTL_0x30790e83be4b4066___024unit& operator= (const VSingleCoreVRTL_0x30790e83be4b4066___024unit&);	///< Copying not allowed
    VSingleCoreVRTL_0x30790e83be4b4066___024unit(const VSingleCoreVRTL_0x30790e83be4b4066___024unit&);	///< Copying not allowed
  public:
    VSingleCoreVRTL_0x30790e83be4b4066___024unit(const char* name="TOP");
    ~VSingleCoreVRTL_0x30790e83be4b4066___024unit();
    void trace (VerilatedVcdC* tfp, int levels, int options=0);
    
    // USER METHODS
    
    // API METHODS
    
    // INTERNAL METHODS
    void __Vconfigure(VSingleCoreVRTL_0x30790e83be4b4066__Syms* symsp, bool first);
    static void traceInit (VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceFull (VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceChg  (VerilatedVcd* vcdp, void* userthis, uint32_t code);
} VL_ATTR_ALIGNED(128);

#endif  /*guard*/
