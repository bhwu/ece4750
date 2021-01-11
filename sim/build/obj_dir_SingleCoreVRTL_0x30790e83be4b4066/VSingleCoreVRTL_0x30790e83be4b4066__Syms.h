// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table internal header
//
// Internal details; most calling programs do not need this header

#ifndef _VSingleCoreVRTL_0x30790e83be4b4066__Syms_H_
#define _VSingleCoreVRTL_0x30790e83be4b4066__Syms_H_

#include "verilated.h"

// INCLUDE MODULE CLASSES
#include "VSingleCoreVRTL_0x30790e83be4b4066.h"
#include "VSingleCoreVRTL_0x30790e83be4b4066___024unit.h"

// DPI TYPES for DPI Export callbacks (Internal use)
typedef void (*VSingleCoreVRTL_0x30790e83be4b4066__Vcb_line_trace_t) (VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, WData (& trace_str)[128]);

// SYMS CLASS
class VSingleCoreVRTL_0x30790e83be4b4066__Syms : public VerilatedSyms {
  public:
    
    // LOCAL STATE
    const char* __Vm_namep;
    bool	__Vm_activity;		///< Used by trace routines to determine change occurred
    bool	__Vm_didInit;
    //char	__VpadToAlign10[6];
    
    // SUBCELL STATE
    VSingleCoreVRTL_0x30790e83be4b4066* TOPp;
    VSingleCoreVRTL_0x30790e83be4b4066___024unit TOP____024unit;
    
    // COVERAGE
    
    // SCOPE NAMES
    VerilatedScope __Vscope_v__verilog_module;
    VerilatedScope __Vscope_v__verilog_module__dcache;
    VerilatedScope __Vscope_v__verilog_module__dcache__cachereq_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__dcache__cacheresp_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__dcache__memreq_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__dcache__memresp_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__icache;
    VerilatedScope __Vscope_v__verilog_module__icache__cachereq_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__icache__cacheresp_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__icache__memreq_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__icache__memresp_msg_trace;
    VerilatedScope __Vscope_v__verilog_module__proc;
    VerilatedScope __Vscope_v__verilog_module__proc__dmemreq_trace;
    VerilatedScope __Vscope_v__verilog_module__proc__dmemresp_trace;
    VerilatedScope __Vscope_v__verilog_module__proc__dpath__imul;
    VerilatedScope __Vscope_v__verilog_module__proc__imemreq_trace;
    VerilatedScope __Vscope_v__verilog_module__proc__imemresp_trace;
    
    // CREATORS
    VSingleCoreVRTL_0x30790e83be4b4066__Syms(VSingleCoreVRTL_0x30790e83be4b4066* topp, const char* namep);
    ~VSingleCoreVRTL_0x30790e83be4b4066__Syms() {};
    
    // METHODS
    inline const char* name() { return __Vm_namep; }
    inline bool getClearActivity() { bool r=__Vm_activity; __Vm_activity=false; return r;}
    
} VL_ATTR_ALIGNED(64);

#endif  /*guard*/
