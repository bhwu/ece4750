// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Symbol table implementation internals

#include "VSingleCoreVRTL_0x30790e83be4b4066__Syms.h"
#include "VSingleCoreVRTL_0x30790e83be4b4066.h"
#include "VSingleCoreVRTL_0x30790e83be4b4066___024unit.h"

// FUNCTIONS
VSingleCoreVRTL_0x30790e83be4b4066__Syms::VSingleCoreVRTL_0x30790e83be4b4066__Syms(VSingleCoreVRTL_0x30790e83be4b4066* topp, const char* namep)
	// Setup locals
	: __Vm_namep(namep)
	, __Vm_activity(false)
	, __Vm_didInit(false)
	// Setup submodule names
	, TOP____024unit                 (Verilated::catName(topp->name(),"$unit"))
{
    // Pointer to top level
    TOPp = topp;
    // Setup each module's pointers to their submodules
    TOPp->__PVT____024unit          = &TOP____024unit;
    // Setup each module's pointer back to symbol table (for public functions)
    TOPp->__Vconfigure(this, true);
    TOP____024unit.__Vconfigure(this, true);
    // Setup scope names
    __Vscope_v__verilog_module.configure(this,name(),"v.verilog_module");
    __Vscope_v__verilog_module__dcache.configure(this,name(),"v.verilog_module.dcache");
    __Vscope_v__verilog_module__dcache__cachereq_msg_trace.configure(this,name(),"v.verilog_module.dcache.cachereq_msg_trace");
    __Vscope_v__verilog_module__dcache__cacheresp_msg_trace.configure(this,name(),"v.verilog_module.dcache.cacheresp_msg_trace");
    __Vscope_v__verilog_module__dcache__memreq_msg_trace.configure(this,name(),"v.verilog_module.dcache.memreq_msg_trace");
    __Vscope_v__verilog_module__dcache__memresp_msg_trace.configure(this,name(),"v.verilog_module.dcache.memresp_msg_trace");
    __Vscope_v__verilog_module__icache.configure(this,name(),"v.verilog_module.icache");
    __Vscope_v__verilog_module__icache__cachereq_msg_trace.configure(this,name(),"v.verilog_module.icache.cachereq_msg_trace");
    __Vscope_v__verilog_module__icache__cacheresp_msg_trace.configure(this,name(),"v.verilog_module.icache.cacheresp_msg_trace");
    __Vscope_v__verilog_module__icache__memreq_msg_trace.configure(this,name(),"v.verilog_module.icache.memreq_msg_trace");
    __Vscope_v__verilog_module__icache__memresp_msg_trace.configure(this,name(),"v.verilog_module.icache.memresp_msg_trace");
    __Vscope_v__verilog_module__proc.configure(this,name(),"v.verilog_module.proc");
    __Vscope_v__verilog_module__proc__dmemreq_trace.configure(this,name(),"v.verilog_module.proc.dmemreq_trace");
    __Vscope_v__verilog_module__proc__dmemresp_trace.configure(this,name(),"v.verilog_module.proc.dmemresp_trace");
    __Vscope_v__verilog_module__proc__dpath__imul.configure(this,name(),"v.verilog_module.proc.dpath.imul");
    __Vscope_v__verilog_module__proc__imemreq_trace.configure(this,name(),"v.verilog_module.proc.imemreq_trace");
    __Vscope_v__verilog_module__proc__imemresp_trace.configure(this,name(),"v.verilog_module.proc.imemresp_trace");
    // Setup export functions
    for (int __Vfinal=0; __Vfinal<2; __Vfinal++) {
	__Vscope_v__verilog_module.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__dcache.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__dcache__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__dcache__cachereq_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__dcache__cacheresp_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__dcache__memreq_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__dcache__memresp_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__icache.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__icache__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__icache__cachereq_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__icache__cacheresp_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__icache__memreq_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__icache__memresp_msg_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__proc.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__proc__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__proc__dmemreq_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__proc__dmemresp_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__proc__dpath__imul.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__proc__imemreq_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__line_trace_TOP));
	__Vscope_v__verilog_module__proc__imemresp_trace.exportInsert(__Vfinal,"line_trace", (void*)(&VSingleCoreVRTL_0x30790e83be4b4066::__Vdpiexp_v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__line_trace_TOP));
    }
}
