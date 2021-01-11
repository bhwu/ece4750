// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "VSingleCoreVRTL_0x30790e83be4b4066__Syms.h"


//======================

void VSingleCoreVRTL_0x30790e83be4b4066::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    VSingleCoreVRTL_0x30790e83be4b4066* t=(VSingleCoreVRTL_0x30790e83be4b4066*)userthis;
    VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp = t->__VlSymsp; // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
	t->traceChgThis (vlSymsp, vcdp, code);
    }
}

//======================


void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 0x12U))))) {
	    vlTOPp->traceChgThis__2(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				| (vlTOPp->__Vm_traceActivity 
				   >> 0x12U)) | (vlTOPp->__Vm_traceActivity 
						 >> 0x13U))))) {
	    vlTOPp->traceChgThis__3(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & (((vlTOPp->__Vm_traceActivity 
				 | (vlTOPp->__Vm_traceActivity 
				    >> 0x12U)) | (vlTOPp->__Vm_traceActivity 
						  >> 0x13U)) 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 0x14U))))) {
	    vlTOPp->traceChgThis__4(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & (((vlTOPp->__Vm_traceActivity 
				 | (vlTOPp->__Vm_traceActivity 
				    >> 0x12U)) | (vlTOPp->__Vm_traceActivity 
						  >> 0x13U)) 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 0x15U))))) {
	    vlTOPp->traceChgThis__5(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				| (vlTOPp->__Vm_traceActivity 
				   >> 0x12U)) | (vlTOPp->__Vm_traceActivity 
						 >> 0x14U))))) {
	    vlTOPp->traceChgThis__6(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 0x13U))))) {
	    vlTOPp->traceChgThis__7(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				| (vlTOPp->__Vm_traceActivity 
				   >> 0x13U)) | (vlTOPp->__Vm_traceActivity 
						 >> 0x15U))))) {
	    vlTOPp->traceChgThis__8(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 0x14U))))) {
	    vlTOPp->traceChgThis__9(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & (vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 0x15U))))) {
	    vlTOPp->traceChgThis__10(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((2U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__11(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				>> 1U) | (vlTOPp->__Vm_traceActivity 
					  >> 2U))))) {
	    vlTOPp->traceChgThis__12(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				>> 1U) | (vlTOPp->__Vm_traceActivity 
					  >> 8U))))) {
	    vlTOPp->traceChgThis__13(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1U & ((vlTOPp->__Vm_traceActivity 
				>> 1U) | (vlTOPp->__Vm_traceActivity 
					  >> 0xdU))))) {
	    vlTOPp->traceChgThis__14(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((8U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__15(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x10U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__16(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x20U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__17(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x40U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__18(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x80U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__19(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x200U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__20(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x400U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__21(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x800U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__22(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x1000U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__23(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x4000U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__24(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x8000U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__25(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x10000U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__26(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x20000U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__27(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x40000U & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__28(vlSymsp, vcdp, code);
	}
	vlTOPp->traceChgThis__29(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0U;
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__2(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+5,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__ostall_W));
	vcdp->chgBus  (c+4,((3U & ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__full)
				    ? 0U : ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__empty)
					     ? 2U : 
					    (((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr) 
					      > (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr))
					      ? ((IData)(2U) 
						 - 
						 ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr) 
						  - (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr)))
					      : (((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr) 
						  > (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr))
						  ? 
						 ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr) 
						  - (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr))
						  : 0U)))))),2);
	vcdp->chgBus  (c+7,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr_inc),1);
	vcdp->chgArray(c+8,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__dpath__DOT__read_data),77);
	vcdp->chgBit  (c+6,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__empty));
	vcdp->chgBus  (c+13,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rf_read_data0),32);
	vcdp->chgBus  (c+14,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rf_read_data1),32);
	vcdp->chgBus  (c+11,(((0U == (0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					       >> 0xfU)))
			       ? 0U : vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rf_read_data0)),32);
	vcdp->chgBus  (c+12,(((0U == (0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					       >> 0x14U)))
			       ? 0U : vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rf_read_data1)),32);
	vcdp->chgBus  (c+17,((vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__a_reg_out 
			      << (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__shift_bits))),32);
	vcdp->chgBus  (c+16,((vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__b_reg_out 
			      >> (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__shift_bits))),32);
	vcdp->chgBus  (c+15,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__shift_bits),3);
	vcdp->chgBus  (c+18,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__shift_bits),6);
	vcdp->chgBus  (c+19,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBit  (c+3,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__br_cond_lt_X));
	vcdp->chgBit  (c+2,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__br_cond_ltu_X));
	vcdp->chgBit  (c+1,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__br_cond_eq_X));
	vcdp->chgBus  (c+20,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+21,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+22,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+23,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+24,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+25,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__w_byte_en),16);
	vcdp->chgBus  (c+26,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT____Vcellinp__data_array__write_addr),4);
	vcdp->chgBus  (c+27,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+28,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+29,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+30,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+31,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+32,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__w_byte_en),16);
	vcdp->chgBus  (c+33,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT____Vcellinp__data_array__write_addr),4);
	vcdp->chgBus  (c+34,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+35,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+36,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+37,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+38,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__vc_trace__DOT__cycles),32);
	vcdp->chgBus  (c+39,(vlTOPp->v__DOT__verilog_module__DOT__vc_trace__DOT__cycles),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__3(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+46,((1U & ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_drop_unit__DOT__state)
				     ? (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__eot))
				     : ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__squash_F) 
					& (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__eot)))))));
	vcdp->chgBit  (c+47,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_F) 
			      & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_val_drop)))));
	vcdp->chgBit  (c+48,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_D) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_D))) 
			      & (1U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__j_type_D)))));
	vcdp->chgBit  (c+49,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_D) 
			      & (1U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__j_type_D)))));
	vcdp->chgBit  (c+50,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_F) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_F))) 
			      & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__squash_F)))));
	vcdp->chgBit  (c+51,(((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs1_en_D) 
				  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X)) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_X)) 
				& ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					     >> 0xfU)) 
				   == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			       & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			      & (0U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X)))));
	vcdp->chgBit  (c+52,(((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs1_en_D) 
				  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X)) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_X)) 
				& ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					     >> 0xfU)) 
				   == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			       & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			      & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X)))));
	vcdp->chgBit  (c+53,((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs1_en_D) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_M)) 
				& (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_M)) 
			       & ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					    >> 0xfU)) 
				  == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_M))) 
			      & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_M)))));
	vcdp->chgBit  (c+54,((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs1_en_D) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_W)) 
				& (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_W)) 
			       & ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					    >> 0xfU)) 
				  == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rf_waddr_W))) 
			      & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rf_waddr_W)))));
	vcdp->chgBit  (c+55,(((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs2_en_D) 
				  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X)) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_X)) 
				& ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					     >> 0x14U)) 
				   == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			       & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			      & (0U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X)))));
	vcdp->chgBit  (c+56,(((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs1_en_D) 
				  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X)) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_X)) 
				& ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					     >> 0x14U)) 
				   == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			       & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
			      & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X)))));
	vcdp->chgBit  (c+57,((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs2_en_D) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_M)) 
				& (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_M)) 
			       & ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					    >> 0x14U)) 
				  == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_M))) 
			      & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_M)))));
	vcdp->chgBit  (c+58,((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs2_en_D) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_W)) 
				& (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_W)) 
			       & ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					    >> 0x14U)) 
				  == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rf_waddr_W))) 
			      & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rf_waddr_W)))));
	vcdp->chgBit  (c+59,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_D) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_D))) 
			      & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__squash_D)))));
	vcdp->chgBit  (c+60,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X) 
			      & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_X)))));
	vcdp->chgBit  (c+61,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_M) 
			      & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_M)))));
	vcdp->chgBus  (c+62,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_enq) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_bypass)))
			       ? (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr_inc)
			       : (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr))),1);
	vcdp->chgBus  (c+63,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_deq) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_bypass)))
			       ? ((2U != (1U & ((IData)(1U) 
						+ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr)))) 
				  & ((IData)(1U) + (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr)))
			       : (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr))),1);
	vcdp->chgBit  (c+64,(((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_enq) 
				& (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_deq))) 
			       & ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr_inc) 
				  == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr))) 
			      | ((~ ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_deq) 
				     & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__full))) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__full)))));
	vcdp->chgBit  (c+65,(((~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_deq)) 
			      & (((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_enq) 
				  & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_bypass))) 
				 | (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__full)))));
	vcdp->chgQuad (c+44,(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg),47);
	vcdp->chgBus  (c+67,((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg)),32);
	vcdp->chgBit  (c+68,((1U & (IData)((VL_ULL(1) 
					    & (((QData)((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__pc_D)) 
						+ (QData)((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imm_D))) 
					       >> 0x20U))))));
	vcdp->chgBus  (c+66,((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_msg)),32);
	vcdp->chgBus  (c+69,((7U & (IData)((vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg 
					    >> 0x2cU)))),3);
	vcdp->chgBus  (c+70,((0xffU & (IData)((vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg 
					       >> 0x24U)))),8);
	vcdp->chgBus  (c+71,((3U & (IData)((vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg 
					    >> 0x22U)))),2);
	vcdp->chgBus  (c+72,((3U & (IData)((vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg 
					    >> 0x20U)))),2);
	vcdp->chgBus  (c+73,((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg)),32);
	vcdp->chgBus  (c+74,((7U & (IData)((vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_msg 
					    >> 0x2cU)))),3);
	vcdp->chgBus  (c+75,((0xffU & (IData)((vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_msg 
					       >> 0x24U)))),8);
	vcdp->chgBus  (c+76,((3U & (IData)((vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_msg 
					    >> 0x22U)))),2);
	vcdp->chgBus  (c+77,((3U & (IData)((vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_msg 
					    >> 0x20U)))),2);
	vcdp->chgBus  (c+78,((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_msg)),32);
	vcdp->chgBus  (c+79,((0xffU & (((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid_act) 
					& (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__victim)))
				        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid0) 
					   | ((IData)(1U) 
					      << (7U 
						  & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
						     >> 4U))))
				        : (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid0)))),8);
	vcdp->chgBus  (c+80,((0xffU & (((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid_act) 
					& (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__victim))
				        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid1) 
					   | ((IData)(1U) 
					      << (7U 
						  & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
						     >> 4U))))
				        : (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid1)))),8);
	vcdp->chgBit  (c+81,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_act)
			       ? (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val0)
			       : (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit0))));
	vcdp->chgBit  (c+82,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_act)
			       ? (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val1)
			       : (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit1))));
	vcdp->chgBus  (c+83,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_addr_mux_sel)
			       ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_addr_mux_sel)
				   ? (0xfffffff0U & vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out)
				   : 0U) : vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__evict_addr_reg_out)),32);
	vcdp->chgQuad (c+40,(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_msg),47);
	vcdp->chgBus  (c+84,((0xffU & (((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid_act) 
					& (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__victim)))
				        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid0) 
					   | ((IData)(1U) 
					      << (7U 
						  & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
						     >> 4U))))
				        : (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid0)))),8);
	vcdp->chgBus  (c+85,((0xffU & (((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid_act) 
					& (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__victim))
				        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid1) 
					   | ((IData)(1U) 
					      << (7U 
						  & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
						     >> 4U))))
				        : (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid1)))),8);
	vcdp->chgBit  (c+86,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_act)
			       ? (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val0)
			       : (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit0))));
	vcdp->chgBit  (c+87,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_act)
			       ? (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val1)
			       : (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit1))));
	vcdp->chgBus  (c+88,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_addr_mux_sel)
			       ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_addr_mux_sel)
				   ? (0xfffffff0U & vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out)
				   : 0U) : vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__evict_addr_reg_out)),32);
	vcdp->chgQuad (c+42,(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_msg),47);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__4(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+89,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_D) 
			       & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_mul_D)) 
			      & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imul_req_rdy_D)))));
	vcdp->chgBit  (c+90,(((((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs1_en_D) 
				    & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X)) 
				   & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_X)) 
				  & ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					       >> 0xfU)) 
				     == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
				 & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
				& (0U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X))) 
			       | ((((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs2_en_D) 
				      & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X)) 
				     & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_X)) 
				    & ((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
						 >> 0x14U)) 
				       == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
				   & (0U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X))) 
				  & (0U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X)))) 
			      | (((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_D) 
				  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_mul_D)) 
				 & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imul_req_rdy_D))))));
	vcdp->chgBus  (c+91,(((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__op1_byp_sel_D))
			       ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__op1_byp_sel_D))
				   ? vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__wb_result_W
				   : vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__wb_result_M)
			       : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__op1_byp_sel_D))
				   ? vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__ex_result_X
				   : ((0U == (0x1fU 
					      & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
						 >> 0xfU)))
				       ? 0U : vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rf_read_data0)))),32);
	vcdp->chgBus  (c+92,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__b_mux_sel)
			       ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__b_mux_sel)
				   ? (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul_req_msg_D)
				   : 0U) : (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__b_reg_out 
					    >> (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__shift_bits)))),32);
	vcdp->chgBus  (c+93,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__a_mux_sel)
			       ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__a_mux_sel)
				   ? (IData)((vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul_req_msg_D 
					      >> 0x20U))
				   : 0U) : (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__a_reg_out 
					    << (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__shift_bits)))),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__5(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+94,(((~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_deq)) 
			      & (((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_enq) 
				  & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_bypass))) 
				 | (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__full)))));
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__6(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+95,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_W) 
			      & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_W)))));
	vcdp->chgBus  (c+97,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__result_mux_sel)
			       ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__result_mux_sel)
				   ? 0U : 0U) : ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__add_mux_sel)
						  ? 
						 ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__add_mux_sel)
						   ? vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__result_reg_out
						   : 0U)
						  : 
						 (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__a_reg_out 
						  + vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__result_reg_out)))),32);
	vcdp->chgBus  (c+96,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__add_mux_sel)
			       ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__add_mux_sel)
				   ? vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__result_reg_out
				   : 0U) : (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__a_reg_out 
					    + vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__result_reg_out))),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__7(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+131,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__eot));
	vcdp->chgBit  (c+132,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__ostall_D));
	vcdp->chgBit  (c+133,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__ostall_M));
	vcdp->chgBit  (c+134,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_F));
	vcdp->chgBit  (c+135,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_D));
	vcdp->chgBit  (c+136,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_X));
	vcdp->chgBit  (c+137,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_M));
	vcdp->chgBit  (c+138,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__osquash_X));
	vcdp->chgBit  (c+139,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__squash_D));
	vcdp->chgBit  (c+140,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_val_D));
	vcdp->chgBus  (c+141,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__br_type_D),3);
	vcdp->chgBus  (c+142,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__j_type_D),2);
	vcdp->chgBit  (c+143,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs1_en_D));
	vcdp->chgBit  (c+144,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rs2_en_D));
	vcdp->chgBus  (c+145,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__alu_fn_D),4);
	vcdp->chgBus  (c+146,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__dmemreq_type_D),2);
	vcdp->chgBus  (c+147,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__ex_result_sel_D),2);
	vcdp->chgBit  (c+148,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__wb_result_sel_D));
	vcdp->chgBit  (c+149,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_D));
	vcdp->chgBit  (c+150,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__csrr_D));
	vcdp->chgBit  (c+151,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__csrw_D));
	vcdp->chgBit  (c+152,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__proc2mngr_val_D));
	vcdp->chgBit  (c+153,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__mngr2proc_rdy_D));
	vcdp->chgBit  (c+154,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stats_en_wen_D));
	vcdp->chgBit  (c+155,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_mul_D));
	vcdp->chgBit  (c+113,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_enq_val));
	vcdp->chgBit  (c+157,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_enq));
	vcdp->chgBit  (c+158,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_deq));
	vcdp->chgBit  (c+159,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_bypass));
	vcdp->chgBit  (c+156,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_enq) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__do_bypass)))));
	vcdp->chgArray(c+110,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_enq_msg),77);
	vcdp->chgBit  (c+114,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_enq_val));
	vcdp->chgBit  (c+161,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_enq));
	vcdp->chgBit  (c+162,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_deq));
	vcdp->chgBit  (c+163,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_bypass));
	vcdp->chgBit  (c+160,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_enq) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__do_bypass)))));
	vcdp->chgBit  (c+164,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_deq));
	vcdp->chgBit  (c+165,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_bypass));
	vcdp->chgBit  (c+115,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_val_drop));
	vcdp->chgBit  (c+116,((1U & ((~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_F)) 
				     | (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__squash_F)))));
	vcdp->chgBit  (c+117,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__squash_F));
	vcdp->chgBit  (c+118,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__reg_en_F));
	vcdp->chgBus  (c+119,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__pc_sel_F),2);
	vcdp->chgBus  (c+109,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__pc_next_F),32);
	vcdp->chgBit  (c+120,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__reg_en_D));
	vcdp->chgBus  (c+124,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imm_type_D),3);
	vcdp->chgBus  (c+126,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__op1_byp_sel_D),2);
	vcdp->chgBus  (c+127,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__op2_byp_sel_D),2);
	vcdp->chgBit  (c+121,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__op1_sel_D));
	vcdp->chgBus  (c+123,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__csrr_sel_D),2);
	vcdp->chgBus  (c+122,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__op2_sel_D),2);
	vcdp->chgBus  (c+167,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imm_D),32);
	vcdp->chgBus  (c+170,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__op1_D),32);
	vcdp->chgBus  (c+171,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__op2_D),32);
	vcdp->chgBus  (c+166,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__jal_target_D),32);
	vcdp->chgBus  (c+168,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__op2_byp_sel_out),32);
	vcdp->chgBit  (c+128,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_X)))));
	vcdp->chgQuad (c+172,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul_req_msg_D),64);
	vcdp->chgBus  (c+174,((IData)((vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul_req_msg_D 
				       >> 0x20U))),32);
	vcdp->chgBus  (c+175,((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul_req_msg_D)),32);
	vcdp->chgBit  (c+125,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imul_req_val_D));
	vcdp->chgBit  (c+129,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imul_resp_rdy_X));
	vcdp->chgBus  (c+176,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__ctrl__DOT__state_next),2);
	vcdp->chgBit  (c+130,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_M)))));
	vcdp->chgBus  (c+169,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__wb_result_M),32);
	vcdp->chgBus  (c+177,((7U & (vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[2U] 
				     >> 0xaU))),3);
	vcdp->chgBus  (c+178,((0xffU & (vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[2U] 
					>> 2U))),8);
	vcdp->chgBus  (c+179,(((vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[2U] 
				<< 0x1eU) | (vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[1U] 
					     >> 2U))),32);
	vcdp->chgBus  (c+180,((3U & vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[1U])),2);
	vcdp->chgBus  (c+181,(vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[0U]),32);
	vcdp->chgBit  (c+202,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid_act));
	vcdp->chgBus  (c+203,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty_next0),8);
	vcdp->chgBus  (c+204,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty_next1),8);
	vcdp->chgBus  (c+205,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty_act),2);
	vcdp->chgBit  (c+206,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_act));
	vcdp->chgBit  (c+207,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__victim_next));
	vcdp->chgBit  (c+208,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__victim_act));
	vcdp->chgBus  (c+209,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__used_next),8);
	vcdp->chgBit  (c+210,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__used_act));
	vcdp->chgBit  (c+211,((0U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_type))));
	vcdp->chgBit  (c+212,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val0));
	vcdp->chgBit  (c+213,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val1));
	vcdp->chgBus  (c+196,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_type),3);
	vcdp->chgBus  (c+197,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_type),3);
	vcdp->chgArray(c+224,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out),128);
	vcdp->chgBus  (c+228,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__mkaddr_mux_sel)
				 ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__mkaddr_mux_sel)
				     ? vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1_read_data_out
				     : 0U) : vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0_read_data_out) 
			       << 4U)),32);
	vcdp->chgBus  (c+229,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__mkaddr_mux_sel)
			        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__mkaddr_mux_sel)
				    ? vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1_read_data_out
				    : 0U) : vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0_read_data_out)),28);
	vcdp->chgBus  (c+231,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_data_mux_sel)
			        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_data_mux_sel)
				    ? ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_word_mux_sel))
				        ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_word_mux_sel))
					    ? vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[3U]
					    : vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[2U])
				        : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_word_mux_sel))
					    ? vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[1U]
					    : vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[0U]))
				    : 0U) : 0U)),32);
	vcdp->chgBus  (c+232,((0xffU & (vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[2U] 
					>> 2U))),8);
	vcdp->chgBus  (c+233,((7U & (vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[2U] 
				     >> 0xaU))),3);
	vcdp->chgBus  (c+234,(((vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[2U] 
				<< 0x1eU) | (vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[1U] 
					     >> 2U))),32);
	vcdp->chgBus  (c+235,(vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg[0U]),32);
	vcdp->chgBit  (c+182,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_en));
	vcdp->chgBit  (c+183,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_en));
	vcdp->chgBit  (c+184,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__write_data_mux_sel));
	vcdp->chgBit  (c+186,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__tag_array_wen0));
	vcdp->chgBit  (c+185,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__tag_array_ren));
	vcdp->chgBit  (c+187,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__tag_array_wen1));
	vcdp->chgBit  (c+188,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__data_array_ren));
	vcdp->chgBit  (c+189,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__data_array_wen));
	vcdp->chgBus  (c+190,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__data_array_wben),16);
	vcdp->chgArray(c+214,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array_mux_out),128);
	vcdp->chgBit  (c+192,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_data_reg_en));
	vcdp->chgArray(c+220,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array_read_data_out),128);
	vcdp->chgBit  (c+191,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_data_mux_sel));
	vcdp->chgBit  (c+200,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__tag_match0));
	vcdp->chgBit  (c+201,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__tag_match1));
	vcdp->chgBit  (c+193,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__evict_addr_reg_en));
	vcdp->chgBus  (c+218,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0_read_data_out),28);
	vcdp->chgBus  (c+219,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1_read_data_out),28);
	vcdp->chgBit  (c+199,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__mkaddr_mux_sel));
	vcdp->chgBit  (c+195,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_addr_mux_sel));
	vcdp->chgBus  (c+236,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[0U]),32);
	vcdp->chgBus  (c+237,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[1U]),32);
	vcdp->chgBus  (c+238,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[2U]),32);
	vcdp->chgBus  (c+239,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[3U]),32);
	vcdp->chgBus  (c+194,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_word_mux_sel),2);
	vcdp->chgBus  (c+230,(((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_word_mux_sel))
			        ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_word_mux_sel))
				    ? vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[3U]
				    : vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[2U])
			        : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__read_word_mux_sel))
				    ? vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[1U]
				    : vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_mux_out[0U]))),32);
	vcdp->chgBit  (c+198,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_data_mux_sel));
	vcdp->chgBit  (c+101,(vlTOPp->v__DOT__verilog_module__DOT__icache_req_val));
	vcdp->chgBit  (c+102,(vlTOPp->v__DOT__verilog_module__DOT__icache_req_rdy));
	vcdp->chgArray(c+98,(vlTOPp->v__DOT__verilog_module__DOT__icache_req_msg),77);
	vcdp->chgBit  (c+103,(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_val));
	vcdp->chgBit  (c+104,(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_rdy));
	vcdp->chgBit  (c+260,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid_act));
	vcdp->chgBus  (c+261,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty_next0),8);
	vcdp->chgBus  (c+262,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty_next1),8);
	vcdp->chgBus  (c+263,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty_act),2);
	vcdp->chgBit  (c+264,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_act));
	vcdp->chgBit  (c+265,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__victim_next));
	vcdp->chgBit  (c+266,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__victim_act));
	vcdp->chgBus  (c+267,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__used_next),8);
	vcdp->chgBit  (c+268,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__used_act));
	vcdp->chgBit  (c+269,((0U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_type))));
	vcdp->chgBit  (c+270,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val0));
	vcdp->chgBit  (c+271,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val1));
	vcdp->chgBit  (c+272,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__eot));
	vcdp->chgBus  (c+254,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_type),3);
	vcdp->chgBus  (c+255,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_type),3);
	vcdp->chgArray(c+283,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out),128);
	vcdp->chgBus  (c+287,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__mkaddr_mux_sel)
				 ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__mkaddr_mux_sel)
				     ? vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1_read_data_out
				     : 0U) : vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0_read_data_out) 
			       << 4U)),32);
	vcdp->chgBus  (c+288,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__mkaddr_mux_sel)
			        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__mkaddr_mux_sel)
				    ? vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1_read_data_out
				    : 0U) : vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0_read_data_out)),28);
	vcdp->chgBus  (c+290,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_data_mux_sel)
			        ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_data_mux_sel)
				    ? ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_word_mux_sel))
				        ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_word_mux_sel))
					    ? vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[3U]
					    : vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[2U])
				        : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_word_mux_sel))
					    ? vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[1U]
					    : vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[0U]))
				    : 0U) : 0U)),32);
	vcdp->chgBit  (c+240,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_en));
	vcdp->chgBit  (c+241,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_en));
	vcdp->chgBit  (c+242,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__write_data_mux_sel));
	vcdp->chgBit  (c+244,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__tag_array_wen0));
	vcdp->chgBit  (c+243,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__tag_array_ren));
	vcdp->chgBit  (c+245,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__tag_array_wen1));
	vcdp->chgBit  (c+246,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__data_array_ren));
	vcdp->chgBit  (c+247,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__data_array_wen));
	vcdp->chgBus  (c+248,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__data_array_wben),16);
	vcdp->chgArray(c+273,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array_mux_out),128);
	vcdp->chgBit  (c+250,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_data_reg_en));
	vcdp->chgArray(c+279,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array_read_data_out),128);
	vcdp->chgBit  (c+249,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_data_mux_sel));
	vcdp->chgBit  (c+258,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__tag_match0));
	vcdp->chgBit  (c+259,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__tag_match1));
	vcdp->chgBit  (c+251,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__evict_addr_reg_en));
	vcdp->chgBus  (c+277,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0_read_data_out),28);
	vcdp->chgBus  (c+278,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1_read_data_out),28);
	vcdp->chgBit  (c+257,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__mkaddr_mux_sel));
	vcdp->chgBit  (c+253,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_addr_mux_sel));
	vcdp->chgBus  (c+291,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[0U]),32);
	vcdp->chgBus  (c+292,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[1U]),32);
	vcdp->chgBus  (c+293,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[2U]),32);
	vcdp->chgBus  (c+294,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[3U]),32);
	vcdp->chgBus  (c+252,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_word_mux_sel),2);
	vcdp->chgBus  (c+289,(((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_word_mux_sel))
			        ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_word_mux_sel))
				    ? vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[3U]
				    : vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[2U])
			        : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__read_word_mux_sel))
				    ? vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[1U]
				    : vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_mux_out[0U]))),32);
	vcdp->chgBit  (c+256,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_data_mux_sel));
	vcdp->chgBit  (c+105,(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_val));
	vcdp->chgBit  (c+106,(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_rdy));
	vcdp->chgBit  (c+107,(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_val));
	vcdp->chgBit  (c+108,(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_rdy));
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__8(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+295,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_enq) 
			       & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_bypass)))));
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__9(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+304,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_W));
	vcdp->chgBit  (c+305,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__pc_redirect_X));
	vcdp->chgBus  (c+306,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__pc_sel_X),2);
	vcdp->chgArray(c+297,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_enq_msg),77);
	vcdp->chgBit  (c+300,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_enq_val));
	vcdp->chgBit  (c+302,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imul_req_rdy_D));
	vcdp->chgBit  (c+303,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imul_resp_val_X));
	vcdp->chgBit  (c+308,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__b_mux_sel));
	vcdp->chgBit  (c+309,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__a_mux_sel));
	vcdp->chgBit  (c+310,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__result_mux_sel));
	vcdp->chgBit  (c+312,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__result_en));
	vcdp->chgBit  (c+311,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__add_mux_sel));
	vcdp->chgBus  (c+313,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__ctrl__DOT__count_plus_shifted),6);
	vcdp->chgBus  (c+314,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__ctrl__DOT__count_next),6);
	vcdp->chgBus  (c+296,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__alu_result_X),32);
	vcdp->chgBus  (c+307,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__ex_result_X),32);
	vcdp->chgBit  (c+301,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stall_W)))));
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__10(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+318,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__ostall_X));
	vcdp->chgBit  (c+319,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__do_enq));
	vcdp->chgBus  (c+320,((7U & (vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[2U] 
				     >> 0xaU))),3);
	vcdp->chgBus  (c+321,((0xffU & (vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[2U] 
					>> 2U))),8);
	vcdp->chgBus  (c+322,(((vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[2U] 
				<< 0x1eU) | (vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[1U] 
					     >> 2U))),32);
	vcdp->chgBus  (c+323,((3U & vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[1U])),2);
	vcdp->chgBus  (c+324,(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[0U]),32);
	vcdp->chgBus  (c+325,((0xffU & (vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[2U] 
					>> 2U))),8);
	vcdp->chgBus  (c+326,((7U & (vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[2U] 
				     >> 0xaU))),3);
	vcdp->chgBus  (c+327,(((vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[2U] 
				<< 0x1eU) | (vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[1U] 
					     >> 2U))),32);
	vcdp->chgBus  (c+328,(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg[0U]),32);
	vcdp->chgArray(c+315,(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_msg),77);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__11(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+329,(vlTOPp->v__DOT__verilog_module__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+330,(vlTOPp->v__DOT__verilog_module__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+331,(vlTOPp->v__DOT__verilog_module__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__12(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgArray(c+332,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__str),4096);
	vcdp->chgBus  (c+460,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__rs1_str),24);
	vcdp->chgBus  (c+461,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__rs2_str),24);
	vcdp->chgBus  (c+462,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__rd_str),24);
	vcdp->chgArray(c+463,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__csr_str),72);
	vcdp->chgBus  (c+466,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__rs1),5);
	vcdp->chgBus  (c+467,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__rs2),5);
	vcdp->chgBus  (c+468,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__rd),5);
	vcdp->chgBus  (c+469,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rv2isa__DOT__csr),12);
	vcdp->chgBus  (c+470,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+471,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+472,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__13(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+473,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+474,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+475,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__14(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+476,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+477,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+478,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__15(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgArray(c+479,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__str),4096);
	vcdp->chgBus  (c+607,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+608,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+609,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+610,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__16(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+611,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__type_str),16);
	vcdp->chgArray(c+612,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__str),4096);
	vcdp->chgBus  (c+740,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+741,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+742,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+743,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemreq_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__17(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+744,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__type_str),16);
	vcdp->chgArray(c+745,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__str),4096);
	vcdp->chgBus  (c+873,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+874,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+875,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+876,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__18(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+877,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__type_str),16);
	vcdp->chgArray(c+878,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__str),4096);
	vcdp->chgBus  (c+1006,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1007,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1008,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1009,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imemresp_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__19(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1010,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__type_str),16);
	vcdp->chgArray(c+1011,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__str),4096);
	vcdp->chgBus  (c+1139,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1140,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1141,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1142,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemresp_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__20(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1143,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+1144,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+1272,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1273,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1274,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1275,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__21(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1276,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+1277,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+1405,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1406,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1407,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1408,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__22(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1409,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+1410,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+1538,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1539,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1540,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1541,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__23(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1542,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+1543,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+1671,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1672,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1673,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1674,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__24(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1675,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+1676,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+1804,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1805,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1806,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1807,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cachereq_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__25(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1808,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+1809,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+1937,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+1938,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+1939,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+1940,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__cacheresp_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__26(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1941,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+1942,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+2070,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+2071,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+2072,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+2073,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memreq_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__27(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+2074,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__type_str),16);
	vcdp->chgArray(c+2075,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__str),4096);
	vcdp->chgBus  (c+2203,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__len0),32);
	vcdp->chgBus  (c+2204,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__len1),32);
	vcdp->chgBus  (c+2205,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__idx0),32);
	vcdp->chgBus  (c+2206,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__memresp_msg_trace__DOT__vc_trace__DOT__idx1),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__28(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Variables
    VL_SIGW(__Vtemp664,127,0,4);
    VL_SIGW(__Vtemp665,127,0,4);
    // Body
    {
	vcdp->chgBit  (c+2208,((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X))));
	vcdp->chgBit  (c+2223,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_drop_unit__DOT__state));
	vcdp->chgBit  (c+2224,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_F));
	vcdp->chgBit  (c+2225,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_D));
	vcdp->chgBit  (c+2226,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_X));
	vcdp->chgBit  (c+2227,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_M));
	vcdp->chgBit  (c+2228,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_W));
	vcdp->chgBus  (c+2233,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_X),32);
	vcdp->chgBit  (c+2234,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__wb_result_sel_X));
	vcdp->chgBit  (c+2235,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_X));
	vcdp->chgBus  (c+2236,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_X),5);
	vcdp->chgBit  (c+2237,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__proc2mngr_val_X));
	vcdp->chgBit  (c+2238,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stats_en_wen_X));
	vcdp->chgBus  (c+2239,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__br_type_X),3);
	vcdp->chgBus  (c+2240,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__j_type_X),2);
	vcdp->chgBit  (c+2241,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_mul_X));
	vcdp->chgBus  (c+2242,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_M),32);
	vcdp->chgBus  (c+2243,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__dmemreq_type_M),2);
	vcdp->chgBit  (c+2244,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_M));
	vcdp->chgBus  (c+2245,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_waddr_M),5);
	vcdp->chgBit  (c+2246,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__proc2mngr_val_M));
	vcdp->chgBit  (c+2247,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__stats_en_wen_M));
	vcdp->chgBus  (c+2248,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__inst_W),32);
	vcdp->chgBit  (c+2249,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__proc2mngr_val_W));
	vcdp->chgBit  (c+2250,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_W));
	vcdp->chgBus  (c+2251,((0x7fU & vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D)),7);
	vcdp->chgBus  (c+2252,((7U & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
				      >> 0xcU))),3);
	vcdp->chgBit  (c+2207,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__full)))));
	vcdp->chgBit  (c+2255,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__full));
	vcdp->chgBus  (c+2256,((1U & ((IData)(1U) + (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr)))),1);
	vcdp->chgBus  (c+2257,(((2U != (1U & ((IData)(1U) 
					      + (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr)))) 
				& ((IData)(1U) + (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr)))),1);
	vcdp->chgBus  (c+2258,((1U & ((IData)(1U) + (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr)))),1);
	vcdp->chgBus  (c+2254,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__deq_ptr),1);
	vcdp->chgBus  (c+2253,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__ctrl__DOT__enq_ptr),1);
	vcdp->chgArray(c+2259,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__dpath__DOT__qstore__DOT__rfile[0]),77);
	vcdp->chgArray(c+2262,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__imem_queue__DOT__genblk2__DOT__dpath__DOT__qstore__DOT__rfile[1]),77);
	vcdp->chgBit  (c+2221,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__full)))));
	vcdp->chgBit  (c+2265,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__full));
	vcdp->chgArray(c+2266,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__dpath__DOT__qstore),77);
	vcdp->chgBit  (c+2210,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmem_queue__DOT__genblk1__DOT__ctrl__DOT__full)))));
	vcdp->chgBit  (c+2222,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__full)))));
	vcdp->chgBit  (c+2269,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__full));
	vcdp->chgBus  (c+2270,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__dpath__DOT__qstore),32);
	vcdp->chgBit  (c+2212,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__proc2mngr_queue__DOT__genblk1__DOT__ctrl__DOT__full)))));
	vcdp->chgBus  (c+2215,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_type_X),2);
	vcdp->chgBus  (c+2281,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__stats_en_W),32);
	vcdp->chgBus  (c+2272,(((IData)(4U) + vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__pc_F)),32);
	vcdp->chgBus  (c+2271,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__pc_F),32);
	vcdp->chgBus  (c+2229,((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					 >> 7U))),5);
	vcdp->chgBus  (c+2232,((0xfffU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					  >> 0x14U))),12);
	vcdp->chgBus  (c+2220,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D),32);
	vcdp->chgBus  (c+2230,((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					 >> 0xfU))),5);
	vcdp->chgBus  (c+2231,((0x1fU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__inst_D 
					 >> 0x14U))),5);
	vcdp->chgBit  (c+2218,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_W) 
				& (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__rf_wen_pending_W))));
	vcdp->chgBus  (c+2217,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__rf_waddr_W),5);
	vcdp->chgBus  (c+2282,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[0]),32);
	vcdp->chgBus  (c+2283,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[1]),32);
	vcdp->chgBus  (c+2284,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[2]),32);
	vcdp->chgBus  (c+2285,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[3]),32);
	vcdp->chgBus  (c+2286,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[4]),32);
	vcdp->chgBus  (c+2287,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[5]),32);
	vcdp->chgBus  (c+2288,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[6]),32);
	vcdp->chgBus  (c+2289,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[7]),32);
	vcdp->chgBus  (c+2290,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[8]),32);
	vcdp->chgBus  (c+2291,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[9]),32);
	vcdp->chgBus  (c+2292,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[10]),32);
	vcdp->chgBus  (c+2293,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[11]),32);
	vcdp->chgBus  (c+2294,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[12]),32);
	vcdp->chgBus  (c+2295,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[13]),32);
	vcdp->chgBus  (c+2296,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[14]),32);
	vcdp->chgBus  (c+2297,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[15]),32);
	vcdp->chgBus  (c+2298,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[16]),32);
	vcdp->chgBus  (c+2299,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[17]),32);
	vcdp->chgBus  (c+2300,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[18]),32);
	vcdp->chgBus  (c+2301,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[19]),32);
	vcdp->chgBus  (c+2302,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[20]),32);
	vcdp->chgBus  (c+2303,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[21]),32);
	vcdp->chgBus  (c+2304,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[22]),32);
	vcdp->chgBus  (c+2305,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[23]),32);
	vcdp->chgBus  (c+2306,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[24]),32);
	vcdp->chgBus  (c+2307,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[25]),32);
	vcdp->chgBus  (c+2308,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[26]),32);
	vcdp->chgBus  (c+2309,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[27]),32);
	vcdp->chgBus  (c+2310,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[28]),32);
	vcdp->chgBus  (c+2311,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[29]),32);
	vcdp->chgBus  (c+2312,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[30]),32);
	vcdp->chgBus  (c+2313,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__rf__DOT__rfile__DOT__rfile[31]),32);
	vcdp->chgBus  (c+2273,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__br_target_X),32);
	vcdp->chgBus  (c+2274,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__pc_D),32);
	vcdp->chgBus  (c+2209,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dmemreq_msg_data),32);
	vcdp->chgBus  (c+2317,((0xfU & (vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__b_reg_out 
					>> 1U))),4);
	vcdp->chgBus  (c+2315,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__b_reg_out),32);
	vcdp->chgBus  (c+2316,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__a_reg_out),32);
	vcdp->chgBus  (c+2318,((vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__a_reg_out 
				+ vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__result_reg_out)),32);
	vcdp->chgBus  (c+2320,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__ctrl__DOT__state_reg),2);
	vcdp->chgBit  (c+2314,((1U & vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__b_reg_out)));
	vcdp->chgBit  (c+2321,((1U & (~ vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__b_reg_out))));
	vcdp->chgBus  (c+2319,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__ctrl__DOT__count),6);
	vcdp->chgBus  (c+2277,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__pc_X),32);
	vcdp->chgBus  (c+2213,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__alu_fn_X),4);
	vcdp->chgBus  (c+2275,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__op1_X),32);
	vcdp->chgBus  (c+2276,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__op2_X),32);
	vcdp->chgBus  (c+2279,(((IData)(4U) + vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__pc_X)),32);
	vcdp->chgBus  (c+2278,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__imul__DOT__dpath__DOT__result_reg_out),32);
	vcdp->chgBus  (c+2214,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ex_result_sel_X),2);
	vcdp->chgBus  (c+2280,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__ex_result_M),32);
	vcdp->chgBit  (c+2216,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__wb_result_sel_M));
	vcdp->chgBus  (c+2211,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__dpath__DOT__wb_result_W),32);
	vcdp->chgBit  (c+2219,(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__stats_en_wen_W));
	vcdp->chgBus  (c+2327,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid0),8);
	vcdp->chgBus  (c+2328,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__valid1),8);
	vcdp->chgBus  (c+2329,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty0),8);
	vcdp->chgBus  (c+2330,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty1),8);
	vcdp->chgBit  (c+2331,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit0));
	vcdp->chgBit  (c+2332,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit1));
	vcdp->chgBus  (c+2333,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__used),8);
	vcdp->chgBus  (c+2334,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg),4);
	vcdp->chgBus  (c+2335,((0xffU & ((IData)(1U) 
					 << (7U & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
						   >> 4U))))),8);
	vcdp->chgBit  (c+2336,((1U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out))));
	vcdp->chgBit  (c+2337,((2U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out))));
	vcdp->chgBus  (c+2338,((3U & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
				      >> 2U))),2);
	vcdp->chgBit  (c+2339,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__victim)))));
	vcdp->chgBit  (c+2322,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit0) 
				| (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit1))));
	vcdp->chgBit  (c+2323,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__victim));
	vcdp->chgBus  (c+2340,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_opaque_reg_out),8);
	vcdp->chgBus  (c+2341,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_data_reg_out),32);
	__Vtemp664[0U] = vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_data_reg_out;
	__Vtemp664[1U] = vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_data_reg_out;
	__Vtemp664[2U] = vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_data_reg_out;
	__Vtemp664[3U] = vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_data_reg_out;
	vcdp->chgArray(c+2347,(__Vtemp664),128);
	vcdp->chgBus  (c+2355,((0xfffffff0U & vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out)),32);
	vcdp->chgBus  (c+2324,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out),3);
	vcdp->chgBus  (c+2325,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out),32);
	vcdp->chgArray(c+2342,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__memresp_data_reg_out),128);
	vcdp->chgBus  (c+2357,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[0]),28);
	vcdp->chgBus  (c+2358,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[1]),28);
	vcdp->chgBus  (c+2359,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[2]),28);
	vcdp->chgBus  (c+2360,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[3]),28);
	vcdp->chgBus  (c+2361,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[4]),28);
	vcdp->chgBus  (c+2362,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[5]),28);
	vcdp->chgBus  (c+2363,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[6]),28);
	vcdp->chgBus  (c+2364,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array0__DOT__mem[7]),28);
	vcdp->chgBus  (c+2326,((7U & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
				      >> 4U))),3);
	vcdp->chgBus  (c+2365,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[0]),28);
	vcdp->chgBus  (c+2366,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[1]),28);
	vcdp->chgBus  (c+2367,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[2]),28);
	vcdp->chgBus  (c+2368,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[3]),28);
	vcdp->chgBus  (c+2369,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[4]),28);
	vcdp->chgBus  (c+2370,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[5]),28);
	vcdp->chgBus  (c+2371,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[6]),28);
	vcdp->chgBus  (c+2372,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__tag_array1__DOT__mem[7]),28);
	vcdp->chgBus  (c+2373,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__victim) 
				 << 3U) | (7U & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
						 >> 4U)))),4);
	vcdp->chgArray(c+2374,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[0]),128);
	vcdp->chgArray(c+2378,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[1]),128);
	vcdp->chgArray(c+2382,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[2]),128);
	vcdp->chgArray(c+2386,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[3]),128);
	vcdp->chgArray(c+2390,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[4]),128);
	vcdp->chgArray(c+2394,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[5]),128);
	vcdp->chgArray(c+2398,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[6]),128);
	vcdp->chgArray(c+2402,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[7]),128);
	vcdp->chgArray(c+2406,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[8]),128);
	vcdp->chgArray(c+2410,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[9]),128);
	vcdp->chgArray(c+2414,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[10]),128);
	vcdp->chgArray(c+2418,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[11]),128);
	vcdp->chgArray(c+2422,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[12]),128);
	vcdp->chgArray(c+2426,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[13]),128);
	vcdp->chgArray(c+2430,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[14]),128);
	vcdp->chgArray(c+2434,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__data_array__DOT__mem[15]),128);
	vcdp->chgArray(c+2351,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__read_data_reg_out),128);
	vcdp->chgBus  (c+2346,((0xfffffffU & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
					      >> 4U))),28);
	vcdp->chgBus  (c+2356,(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__evict_addr_reg_out),32);
	vcdp->chgBus  (c+2443,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid0),8);
	vcdp->chgBus  (c+2444,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__valid1),8);
	vcdp->chgBus  (c+2445,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty0),8);
	vcdp->chgBus  (c+2446,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty1),8);
	vcdp->chgBit  (c+2447,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit0));
	vcdp->chgBit  (c+2448,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit1));
	vcdp->chgBus  (c+2449,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__used),8);
	vcdp->chgBus  (c+2450,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg),4);
	vcdp->chgBus  (c+2451,((0xffU & ((IData)(1U) 
					 << (7U & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
						   >> 4U))))),8);
	vcdp->chgBit  (c+2452,((1U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out))));
	vcdp->chgBit  (c+2453,((2U != (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out))));
	vcdp->chgBus  (c+2454,((3U & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
				      >> 2U))),2);
	vcdp->chgBit  (c+2455,((1U & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__victim)))));
	vcdp->chgBit  (c+2438,(((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit0) 
				| (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit1))));
	vcdp->chgBit  (c+2439,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__victim));
	vcdp->chgBus  (c+2456,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_opaque_reg_out),8);
	vcdp->chgBus  (c+2457,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_data_reg_out),32);
	__Vtemp665[0U] = vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_data_reg_out;
	__Vtemp665[1U] = vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_data_reg_out;
	__Vtemp665[2U] = vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_data_reg_out;
	__Vtemp665[3U] = vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_data_reg_out;
	vcdp->chgArray(c+2463,(__Vtemp665),128);
	vcdp->chgBus  (c+2471,((0xfffffff0U & vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out)),32);
	vcdp->chgBus  (c+2440,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out),3);
	vcdp->chgBus  (c+2441,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out),32);
	vcdp->chgArray(c+2458,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__memresp_data_reg_out),128);
	vcdp->chgBus  (c+2473,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[0]),28);
	vcdp->chgBus  (c+2474,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[1]),28);
	vcdp->chgBus  (c+2475,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[2]),28);
	vcdp->chgBus  (c+2476,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[3]),28);
	vcdp->chgBus  (c+2477,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[4]),28);
	vcdp->chgBus  (c+2478,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[5]),28);
	vcdp->chgBus  (c+2479,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[6]),28);
	vcdp->chgBus  (c+2480,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array0__DOT__mem[7]),28);
	vcdp->chgBus  (c+2442,((7U & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
				      >> 4U))),3);
	vcdp->chgBus  (c+2481,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[0]),28);
	vcdp->chgBus  (c+2482,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[1]),28);
	vcdp->chgBus  (c+2483,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[2]),28);
	vcdp->chgBus  (c+2484,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[3]),28);
	vcdp->chgBus  (c+2485,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[4]),28);
	vcdp->chgBus  (c+2486,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[5]),28);
	vcdp->chgBus  (c+2487,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[6]),28);
	vcdp->chgBus  (c+2488,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__tag_array1__DOT__mem[7]),28);
	vcdp->chgBus  (c+2489,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__victim) 
				 << 3U) | (7U & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
						 >> 4U)))),4);
	vcdp->chgArray(c+2490,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[0]),128);
	vcdp->chgArray(c+2494,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[1]),128);
	vcdp->chgArray(c+2498,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[2]),128);
	vcdp->chgArray(c+2502,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[3]),128);
	vcdp->chgArray(c+2506,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[4]),128);
	vcdp->chgArray(c+2510,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[5]),128);
	vcdp->chgArray(c+2514,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[6]),128);
	vcdp->chgArray(c+2518,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[7]),128);
	vcdp->chgArray(c+2522,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[8]),128);
	vcdp->chgArray(c+2526,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[9]),128);
	vcdp->chgArray(c+2530,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[10]),128);
	vcdp->chgArray(c+2534,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[11]),128);
	vcdp->chgArray(c+2538,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[12]),128);
	vcdp->chgArray(c+2542,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[13]),128);
	vcdp->chgArray(c+2546,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[14]),128);
	vcdp->chgArray(c+2550,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__data_array__DOT__mem[15]),128);
	vcdp->chgArray(c+2467,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__read_data_reg_out),128);
	vcdp->chgBus  (c+2462,((0xfffffffU & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
					      >> 4U))),28);
	vcdp->chgBus  (c+2472,(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__evict_addr_reg_out),32);
    }
}

void VSingleCoreVRTL_0x30790e83be4b4066::traceChgThis__29(VSingleCoreVRTL_0x30790e83be4b4066__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    VSingleCoreVRTL_0x30790e83be4b4066* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Variables
    VL_SIGW(__Vtemp666,127,0,4);
    VL_SIGW(__Vtemp667,127,0,4);
    VL_SIGW(__Vtemp668,127,0,4);
    VL_SIGW(__Vtemp669,127,0,4);
    VL_SIGW(__Vtemp670,127,0,4);
    VL_SIGW(__Vtemp671,127,0,4);
    // Body
    {
	vcdp->chgBit  (c+2555,(vlTOPp->commit_inst));
	vcdp->chgBit  (c+2574,(vlTOPp->icache_miss));
	vcdp->chgBit  (c+2573,(vlTOPp->icache_access));
	vcdp->chgBit  (c+2557,(vlTOPp->dcache_miss));
	vcdp->chgBit  (c+2556,(vlTOPp->dcache_access));
	vcdp->chgBit  (c+2592,(vlTOPp->mngr2proc_val));
	vcdp->chgBit  (c+2591,(vlTOPp->mngr2proc_rdy));
	vcdp->chgBit  (c+2598,((((IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__val_D) 
				 & (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__ctrl__DOT__mngr2proc_rdy_D)) 
				& (~ (IData)(vlTOPp->mngr2proc_val)))));
	vcdp->chgBit  (c+2595,(vlTOPp->proc2mngr_val));
	vcdp->chgBit  (c+2594,(vlTOPp->proc2mngr_rdy));
	vcdp->chgBus  (c+2593,(vlTOPp->proc2mngr_msg),32);
	vcdp->chgBit  (c+2597,(vlTOPp->stats_en));
	vcdp->chgBus  (c+2590,(vlTOPp->mngr2proc_msg),32);
	vcdp->chgBus  (c+2599,(((0U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__csrr_sel_D))
				 ? vlTOPp->mngr2proc_msg
				 : ((1U == (IData)(vlTOPp->v__DOT__verilog_module__DOT__proc__DOT__csrr_sel_D))
				     ? 1U : 0U))),32);
	vcdp->chgBus  (c+2600,(((8U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
				 ? ((4U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
				     ? 0U : ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
					      ? ((1U 
						  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
						  ? 
						 ((IData)(vlTOPp->imemresp_val)
						   ? 6U
						   : 0xbU)
						  : 
						 ((IData)(vlTOPp->imemreq_rdy)
						   ? 0xbU
						   : 0xaU))
					      : ((1U 
						  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
						  ? 0xaU
						  : 
						 ((0U 
						   == (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out))
						   ? 4U
						   : 
						  ((1U 
						    == (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out))
						    ? 5U
						    : 8U)))))
				 : ((4U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
				     ? ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
					 ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
					     ? ((IData)(vlTOPp->imemresp_val)
						 ? 8U
						 : 7U)
					     : ((IData)(vlTOPp->imemreq_rdy)
						 ? 7U
						 : 6U))
					 : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
					     ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_rdy)
						 ? 
						((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_req_val)
						  ? 1U
						  : 0U)
						 : 5U)
					     : ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_rdy)
						 ? 
						((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_req_val)
						  ? 1U
						  : 0U)
						 : 4U)))
				     : ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
					 ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
					     ? 0U : 
					    ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_resp_rdy)
					      ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_req_val)
						  ? 1U
						  : 0U)
					      : 2U))
					 : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__state_reg))
					     ? ((2U 
						 == (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out))
						 ? 2U
						 : 
						((((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val0) 
						   | (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val1)) 
						  & (0U 
						     == (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out)))
						  ? 4U
						  : 
						 ((((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val0) 
						    | (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__hit_val1)) 
						   & (1U 
						      == (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_type_reg_out)))
						   ? 5U
						   : 
						  ((1U 
						    & (((~ 
							 ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty0) 
							  >> 
							  (7U 
							   & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
							      >> 4U)))) 
							& (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__victim_next))) 
						       | ((~ 
							   ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty1) 
							    >> 
							    (7U 
							     & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
								>> 4U)))) 
							  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__victim_next))))
						    ? 6U
						    : 
						   ((1U 
						     & ((((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty0) 
							  >> 
							  (7U 
							   & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
							      >> 4U))) 
							 & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__victim_next))) 
							| (((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__dirty1) 
							    >> 
							    (7U 
							     & (vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__dpath__DOT__cachereq_addr_reg_out 
								>> 4U))) 
							   & (IData)(vlTOPp->v__DOT__verilog_module__DOT__icache__DOT__ctrl__DOT__victim_next))))
						     ? 9U
						     : 1U)))))
					     : ((IData)(vlTOPp->v__DOT__verilog_module__DOT__icache_req_val)
						 ? 1U
						 : 0U)))))),4);
	__Vtemp666[0U] = vlTOPp->imemresp_msg[0U];
	__Vtemp666[1U] = vlTOPp->imemresp_msg[1U];
	__Vtemp666[2U] = vlTOPp->imemresp_msg[2U];
	__Vtemp666[3U] = vlTOPp->imemresp_msg[3U];
	vcdp->chgArray(c+2601,(__Vtemp666),128);
	vcdp->chgBit  (c+2582,(vlTOPp->imemreq_val));
	vcdp->chgBit  (c+2581,(vlTOPp->imemreq_rdy));
	vcdp->chgArray(c+2575,(vlTOPp->imemreq_msg),175);
	vcdp->chgBus  (c+2605,((7U & (vlTOPp->imemreq_msg[5U] 
				      >> 0xcU))),3);
	vcdp->chgBus  (c+2606,((0xffU & (vlTOPp->imemreq_msg[5U] 
					 >> 4U))),8);
	vcdp->chgBus  (c+2607,(((vlTOPp->imemreq_msg[5U] 
				 << 0x1cU) | (vlTOPp->imemreq_msg[4U] 
					      >> 4U))),32);
	vcdp->chgBus  (c+2608,((0xfU & vlTOPp->imemreq_msg[4U])),4);
	__Vtemp667[0U] = vlTOPp->imemreq_msg[0U];
	__Vtemp667[1U] = vlTOPp->imemreq_msg[1U];
	__Vtemp667[2U] = vlTOPp->imemreq_msg[2U];
	__Vtemp667[3U] = vlTOPp->imemreq_msg[3U];
	vcdp->chgArray(c+2609,(__Vtemp667),128);
	vcdp->chgBit  (c+2589,(vlTOPp->imemresp_val));
	vcdp->chgBit  (c+2588,(vlTOPp->imemresp_rdy));
	vcdp->chgArray(c+2583,(vlTOPp->imemresp_msg),145);
	vcdp->chgBus  (c+2613,((7U & (vlTOPp->imemresp_msg[4U] 
				      >> 0xeU))),3);
	vcdp->chgBus  (c+2614,((0xffU & (vlTOPp->imemresp_msg[4U] 
					 >> 6U))),8);
	vcdp->chgBus  (c+2615,((3U & (vlTOPp->imemresp_msg[4U] 
				      >> 4U))),2);
	vcdp->chgBus  (c+2616,((0xfU & vlTOPp->imemresp_msg[4U])),4);
	__Vtemp668[0U] = vlTOPp->imemresp_msg[0U];
	__Vtemp668[1U] = vlTOPp->imemresp_msg[1U];
	__Vtemp668[2U] = vlTOPp->imemresp_msg[2U];
	__Vtemp668[3U] = vlTOPp->imemresp_msg[3U];
	vcdp->chgArray(c+2617,(__Vtemp668),128);
	vcdp->chgBus  (c+2621,(((8U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
				 ? ((4U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
				     ? 0U : ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
					      ? ((1U 
						  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
						  ? 
						 ((IData)(vlTOPp->dmemresp_val)
						   ? 6U
						   : 0xbU)
						  : 
						 ((IData)(vlTOPp->dmemreq_rdy)
						   ? 0xbU
						   : 0xaU))
					      : ((1U 
						  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
						  ? 0xaU
						  : 
						 ((0U 
						   == (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out))
						   ? 4U
						   : 
						  ((1U 
						    == (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out))
						    ? 5U
						    : 8U)))))
				 : ((4U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
				     ? ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
					 ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
					     ? ((IData)(vlTOPp->dmemresp_val)
						 ? 8U
						 : 7U)
					     : ((IData)(vlTOPp->dmemreq_rdy)
						 ? 7U
						 : 6U))
					 : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
					     ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_rdy)
						 ? 
						((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_val)
						  ? 1U
						  : 0U)
						 : 5U)
					     : ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_rdy)
						 ? 
						((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_val)
						  ? 1U
						  : 0U)
						 : 4U)))
				     : ((2U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
					 ? ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
					     ? 0U : 
					    ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_resp_rdy)
					      ? ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_val)
						  ? 1U
						  : 0U)
					      : 2U))
					 : ((1U & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__state_reg))
					     ? ((2U 
						 == (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out))
						 ? 2U
						 : 
						((((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val0) 
						   | (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val1)) 
						  & (0U 
						     == (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out)))
						  ? 4U
						  : 
						 ((((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val0) 
						    | (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__hit_val1)) 
						   & (1U 
						      == (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_type_reg_out)))
						   ? 5U
						   : 
						  ((1U 
						    & (((~ 
							 ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty0) 
							  >> 
							  (7U 
							   & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
							      >> 4U)))) 
							& (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__victim_next))) 
						       | ((~ 
							   ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty1) 
							    >> 
							    (7U 
							     & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
								>> 4U)))) 
							  & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__victim_next))))
						    ? 6U
						    : 
						   ((1U 
						     & ((((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty0) 
							  >> 
							  (7U 
							   & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
							      >> 4U))) 
							 & (~ (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__victim_next))) 
							| (((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__dirty1) 
							    >> 
							    (7U 
							     & (vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__dpath__DOT__cachereq_addr_reg_out 
								>> 4U))) 
							   & (IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache__DOT__ctrl__DOT__victim_next))))
						     ? 9U
						     : 1U)))))
					     : ((IData)(vlTOPp->v__DOT__verilog_module__DOT__dcache_req_val)
						 ? 1U
						 : 0U)))))),4);
	__Vtemp669[0U] = vlTOPp->dmemresp_msg[0U];
	__Vtemp669[1U] = vlTOPp->dmemresp_msg[1U];
	__Vtemp669[2U] = vlTOPp->dmemresp_msg[2U];
	__Vtemp669[3U] = vlTOPp->dmemresp_msg[3U];
	vcdp->chgArray(c+2622,(__Vtemp669),128);
	vcdp->chgBit  (c+2565,(vlTOPp->dmemreq_val));
	vcdp->chgBit  (c+2564,(vlTOPp->dmemreq_rdy));
	vcdp->chgArray(c+2558,(vlTOPp->dmemreq_msg),175);
	vcdp->chgBus  (c+2626,((7U & (vlTOPp->dmemreq_msg[5U] 
				      >> 0xcU))),3);
	vcdp->chgBus  (c+2627,((0xffU & (vlTOPp->dmemreq_msg[5U] 
					 >> 4U))),8);
	vcdp->chgBus  (c+2628,(((vlTOPp->dmemreq_msg[5U] 
				 << 0x1cU) | (vlTOPp->dmemreq_msg[4U] 
					      >> 4U))),32);
	vcdp->chgBus  (c+2629,((0xfU & vlTOPp->dmemreq_msg[4U])),4);
	__Vtemp670[0U] = vlTOPp->dmemreq_msg[0U];
	__Vtemp670[1U] = vlTOPp->dmemreq_msg[1U];
	__Vtemp670[2U] = vlTOPp->dmemreq_msg[2U];
	__Vtemp670[3U] = vlTOPp->dmemreq_msg[3U];
	vcdp->chgArray(c+2630,(__Vtemp670),128);
	vcdp->chgBit  (c+2572,(vlTOPp->dmemresp_val));
	vcdp->chgBit  (c+2571,(vlTOPp->dmemresp_rdy));
	vcdp->chgArray(c+2566,(vlTOPp->dmemresp_msg),145);
	vcdp->chgBus  (c+2634,((7U & (vlTOPp->dmemresp_msg[4U] 
				      >> 0xeU))),3);
	vcdp->chgBus  (c+2635,((0xffU & (vlTOPp->dmemresp_msg[4U] 
					 >> 6U))),8);
	vcdp->chgBus  (c+2636,((3U & (vlTOPp->dmemresp_msg[4U] 
				      >> 4U))),2);
	vcdp->chgBus  (c+2637,((0xfU & vlTOPp->dmemresp_msg[4U])),4);
	__Vtemp671[0U] = vlTOPp->dmemresp_msg[0U];
	__Vtemp671[1U] = vlTOPp->dmemresp_msg[1U];
	__Vtemp671[2U] = vlTOPp->dmemresp_msg[2U];
	__Vtemp671[3U] = vlTOPp->dmemresp_msg[3U];
	vcdp->chgArray(c+2638,(__Vtemp671),128);
	vcdp->chgBit  (c+2554,(vlTOPp->clk));
	vcdp->chgBit  (c+2596,(vlTOPp->reset));
    }
}
