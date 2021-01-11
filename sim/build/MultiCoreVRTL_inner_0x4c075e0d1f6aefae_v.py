#=======================================================================
# VMultiCoreVRTL_inner_0x4c075e0d1f6aefae_v.py
#=======================================================================
# This wrapper makes a Verilator-generated C++ model appear as if it
# were a normal PyMTL model.

import os

from pymtl import *
from cffi  import FFI

#-----------------------------------------------------------------------
# MultiCoreVRTL_inner_0x4c075e0d1f6aefae
#-----------------------------------------------------------------------
class MultiCoreVRTL_inner_0x4c075e0d1f6aefae( Model ):
  id_ = 0

  def __init__( s ):

    # initialize FFI, define the exposed interface
    s.ffi = FFI()
    s.ffi.cdef('''
      typedef struct {

        // Exposed port interface
        unsigned int * dmemresp_msg;
      unsigned char * dmemresp_val;
      unsigned char * dmemreq_rdy;
      unsigned int * imemresp_msg;
      unsigned char * imemresp_val;
      unsigned char * imemreq_rdy;
      unsigned char * proc2mngr_rdy;
      unsigned int * mngr2proc_msg;
      unsigned char * mngr2proc_val;
      unsigned char * reset;
      unsigned char * clk;
      unsigned char * dcache_access;
      unsigned char * dcache_miss;
      unsigned char * icache_access;
      unsigned char * icache_miss;
      unsigned char * commit_inst;
      unsigned char * stats_en;
      unsigned char * dmemresp_rdy;
      unsigned int * dmemreq_msg;
      unsigned char * dmemreq_val;
      unsigned char * imemresp_rdy;
      unsigned int * imemreq_msg;
      unsigned char * imemreq_val;
      unsigned int * proc2mngr_msg;
      unsigned char * proc2mngr_val;
      unsigned char * mngr2proc_rdy;

        // Verilator model
        void * model;

        // VCD state
        int _vcd_en;

      } VMultiCoreVRTL_inner_0x4c075e0d1f6aefae_t;

      VMultiCoreVRTL_inner_0x4c075e0d1f6aefae_t * create_model( const char * );
      void destroy_model( VMultiCoreVRTL_inner_0x4c075e0d1f6aefae_t *);
      void eval( VMultiCoreVRTL_inner_0x4c075e0d1f6aefae_t * );
      void trace( VMultiCoreVRTL_inner_0x4c075e0d1f6aefae_t *, char * );

    ''')

    # Import the shared library containing the model. We defer
    # construction to the elaborate_logic function to allow the user to
    # set the vcd_file.

    s._ffi = s.ffi.dlopen('./libMultiCoreVRTL_inner_0x4c075e0d1f6aefae_v.so')

    # dummy class to emulate PortBundles
    class BundleProxy( PortBundle ):
      flip = False

    # define the port interface
    s.dcache_access = OutPort( 4 )
    s.dcache_miss = OutPort( 4 )
    s.icache_access = OutPort( 4 )
    s.icache_miss = OutPort( 4 )
    s.commit_inst = OutPort( 4 )
    s.stats_en = OutPort( 1 )
    s.dmemresp = BundleProxy()
    s.dmemresp._ports = []
    from pclib.ifcs.MemMsg import MemRespMsg
    s.dmemresp.msg = InPort( MemRespMsg(8, 128) )
    s.dmemresp._ports.append( s.dmemresp.msg )
    s.dmemresp.msg.name = 'msg'
    s.dmemresp.rdy = OutPort( 1 )
    s.dmemresp._ports.append( s.dmemresp.rdy )
    s.dmemresp.rdy.name = 'rdy'
    s.dmemresp.val = InPort( 1 )
    s.dmemresp._ports.append( s.dmemresp.val )
    s.dmemresp.val.name = 'val'
    s.dmemreq = BundleProxy()
    s.dmemreq._ports = []
    from pclib.ifcs.MemMsg import MemReqMsg
    s.dmemreq.msg = OutPort( MemReqMsg(8, 32, 128) )
    s.dmemreq._ports.append( s.dmemreq.msg )
    s.dmemreq.msg.name = 'msg'
    s.dmemreq.rdy = InPort( 1 )
    s.dmemreq._ports.append( s.dmemreq.rdy )
    s.dmemreq.rdy.name = 'rdy'
    s.dmemreq.val = OutPort( 1 )
    s.dmemreq._ports.append( s.dmemreq.val )
    s.dmemreq.val.name = 'val'
    s.imemresp = BundleProxy()
    s.imemresp._ports = []
    from pclib.ifcs.MemMsg import MemRespMsg
    s.imemresp.msg = InPort( MemRespMsg(8, 128) )
    s.imemresp._ports.append( s.imemresp.msg )
    s.imemresp.msg.name = 'msg'
    s.imemresp.rdy = OutPort( 1 )
    s.imemresp._ports.append( s.imemresp.rdy )
    s.imemresp.rdy.name = 'rdy'
    s.imemresp.val = InPort( 1 )
    s.imemresp._ports.append( s.imemresp.val )
    s.imemresp.val.name = 'val'
    s.imemreq = BundleProxy()
    s.imemreq._ports = []
    from pclib.ifcs.MemMsg import MemReqMsg
    s.imemreq.msg = OutPort( MemReqMsg(8, 32, 128) )
    s.imemreq._ports.append( s.imemreq.msg )
    s.imemreq.msg.name = 'msg'
    s.imemreq.rdy = InPort( 1 )
    s.imemreq._ports.append( s.imemreq.rdy )
    s.imemreq.rdy.name = 'rdy'
    s.imemreq.val = OutPort( 1 )
    s.imemreq._ports.append( s.imemreq.val )
    s.imemreq.val.name = 'val'
    s.proc2mngr_msg = OutPort( 128 )
    s.proc2mngr_rdy = InPort( 4 )
    s.proc2mngr_val = OutPort( 4 )
    s.mngr2proc_msg = InPort( 128 )
    s.mngr2proc_rdy = OutPort( 4 )
    s.mngr2proc_val = InPort( 4 )
    s.reset = InPort( 1 )
    s.clk = InPort( 1 )

    # increment instance count
    MultiCoreVRTL_inner_0x4c075e0d1f6aefae.id_ += 1

    # Defer vcd dumping until later
    s.vcd_file = None

    # Buffer for line tracing
    s._line_trace_str = s.ffi.new("char[512]")
    s._convert_string = s.ffi.string

  def __del__( s ):
    s._ffi.destroy_model( s._m )

  def elaborate_logic( s ):

    # Give verilator_vcd_file a slightly different name so PyMTL .vcd and
    # Verilator .vcd can coexist

    verilator_vcd_file = ""
    if s.vcd_file:
      filen, ext         = os.path.splitext( s.vcd_file )
      verilator_vcd_file = '{}.verilator{}{}'.format(filen, s.id_, ext)

    # Construct the model.

    s._m = s._ffi.create_model( s.ffi.new("char[]", verilator_vcd_file) )

    @s.combinational
    def logic():

      # set inputs
      s._m.dmemresp_msg[0] = s.dmemresp.msg[0:32]
      s._m.dmemresp_msg[1] = s.dmemresp.msg[32:64]
      s._m.dmemresp_msg[2] = s.dmemresp.msg[64:96]
      s._m.dmemresp_msg[3] = s.dmemresp.msg[96:128]
      s._m.dmemresp_msg[4] = s.dmemresp.msg[128:145]
      s._m.dmemresp_val[0] = s.dmemresp.val
      s._m.dmemreq_rdy[0] = s.dmemreq.rdy
      s._m.imemresp_msg[0] = s.imemresp.msg[0:32]
      s._m.imemresp_msg[1] = s.imemresp.msg[32:64]
      s._m.imemresp_msg[2] = s.imemresp.msg[64:96]
      s._m.imemresp_msg[3] = s.imemresp.msg[96:128]
      s._m.imemresp_msg[4] = s.imemresp.msg[128:145]
      s._m.imemresp_val[0] = s.imemresp.val
      s._m.imemreq_rdy[0] = s.imemreq.rdy
      s._m.proc2mngr_rdy[0] = s.proc2mngr_rdy
      s._m.mngr2proc_msg[0] = s.mngr2proc_msg[0:32]
      s._m.mngr2proc_msg[1] = s.mngr2proc_msg[32:64]
      s._m.mngr2proc_msg[2] = s.mngr2proc_msg[64:96]
      s._m.mngr2proc_msg[3] = s.mngr2proc_msg[96:128]
      s._m.mngr2proc_val[0] = s.mngr2proc_val
      s._m.reset[0] = s.reset

      # execute combinational logic
      s._ffi.eval( s._m )

      # set outputs
      # FIXME: currently write all outputs, not just combinational outs
      s.dcache_access.value = s._m.dcache_access[0]
      s.dcache_miss.value = s._m.dcache_miss[0]
      s.icache_access.value = s._m.icache_access[0]
      s.icache_miss.value = s._m.icache_miss[0]
      s.commit_inst.value = s._m.commit_inst[0]
      s.stats_en.value = s._m.stats_en[0]
      s.dmemresp.rdy.value = s._m.dmemresp_rdy[0]
      s.dmemreq.msg[0:32].value = s._m.dmemreq_msg[0]
      s.dmemreq.msg[32:64].value = s._m.dmemreq_msg[1]
      s.dmemreq.msg[64:96].value = s._m.dmemreq_msg[2]
      s.dmemreq.msg[96:128].value = s._m.dmemreq_msg[3]
      s.dmemreq.msg[128:160].value = s._m.dmemreq_msg[4]
      s.dmemreq.msg[160:175].value = s._m.dmemreq_msg[5]
      s.dmemreq.val.value = s._m.dmemreq_val[0]
      s.imemresp.rdy.value = s._m.imemresp_rdy[0]
      s.imemreq.msg[0:32].value = s._m.imemreq_msg[0]
      s.imemreq.msg[32:64].value = s._m.imemreq_msg[1]
      s.imemreq.msg[64:96].value = s._m.imemreq_msg[2]
      s.imemreq.msg[96:128].value = s._m.imemreq_msg[3]
      s.imemreq.msg[128:160].value = s._m.imemreq_msg[4]
      s.imemreq.msg[160:175].value = s._m.imemreq_msg[5]
      s.imemreq.val.value = s._m.imemreq_val[0]
      s.proc2mngr_msg[0:32].value = s._m.proc2mngr_msg[0]
      s.proc2mngr_msg[32:64].value = s._m.proc2mngr_msg[1]
      s.proc2mngr_msg[64:96].value = s._m.proc2mngr_msg[2]
      s.proc2mngr_msg[96:128].value = s._m.proc2mngr_msg[3]
      s.proc2mngr_val.value = s._m.proc2mngr_val[0]
      s.mngr2proc_rdy.value = s._m.mngr2proc_rdy[0]

    @s.posedge_clk
    def tick():

      s._m.clk[0] = 0
      s._ffi.eval( s._m )
      s._m.clk[0] = 1
      s._ffi.eval( s._m )

      # double buffer register outputs
      # FIXME: currently write all outputs, not just registered outs
      s.dcache_access.next = s._m.dcache_access[0]
      s.dcache_miss.next = s._m.dcache_miss[0]
      s.icache_access.next = s._m.icache_access[0]
      s.icache_miss.next = s._m.icache_miss[0]
      s.commit_inst.next = s._m.commit_inst[0]
      s.stats_en.next = s._m.stats_en[0]
      s.dmemresp.rdy.next = s._m.dmemresp_rdy[0]
      s.dmemreq.msg[0:32].next = s._m.dmemreq_msg[0]
      s.dmemreq.msg[32:64].next = s._m.dmemreq_msg[1]
      s.dmemreq.msg[64:96].next = s._m.dmemreq_msg[2]
      s.dmemreq.msg[96:128].next = s._m.dmemreq_msg[3]
      s.dmemreq.msg[128:160].next = s._m.dmemreq_msg[4]
      s.dmemreq.msg[160:175].next = s._m.dmemreq_msg[5]
      s.dmemreq.val.next = s._m.dmemreq_val[0]
      s.imemresp.rdy.next = s._m.imemresp_rdy[0]
      s.imemreq.msg[0:32].next = s._m.imemreq_msg[0]
      s.imemreq.msg[32:64].next = s._m.imemreq_msg[1]
      s.imemreq.msg[64:96].next = s._m.imemreq_msg[2]
      s.imemreq.msg[96:128].next = s._m.imemreq_msg[3]
      s.imemreq.msg[128:160].next = s._m.imemreq_msg[4]
      s.imemreq.msg[160:175].next = s._m.imemreq_msg[5]
      s.imemreq.val.next = s._m.imemreq_val[0]
      s.proc2mngr_msg[0:32].next = s._m.proc2mngr_msg[0]
      s.proc2mngr_msg[32:64].next = s._m.proc2mngr_msg[1]
      s.proc2mngr_msg[64:96].next = s._m.proc2mngr_msg[2]
      s.proc2mngr_msg[96:128].next = s._m.proc2mngr_msg[3]
      s.proc2mngr_val.next = s._m.proc2mngr_val[0]
      s.mngr2proc_rdy.next = s._m.mngr2proc_rdy[0]

  def line_trace( s ):
    if 1:
      s._ffi.trace( s._m, s._line_trace_str )
      return s._convert_string( s._line_trace_str )
    else:
      return ""
