//========================================================================
// 1-Core Processor-Cache-Network
//========================================================================

`ifndef LAB5_MCORE_MULTI_CORE_V
`define LAB5_MCORE_MULTI_CORE_V

`include "vc/mem-msgs.v"
`include "vc/trace.v"

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include components
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

`include "lab2_proc/ProcAltVRTL.v"
`include "lab3_mem/BlockingCacheAltVRTL.v"
`include "lab5_mcore/McoreDataCacheVRTL.v"
`include "lab5_mcore/MemNetVRTL.v"


module lab5_mcore_MultiCoreVRTL
(
  input  logic                       clk,
  input  logic                       reset,

  input  logic [c_num_cores-1:0][31:0] mngr2proc_msg,
  input  logic [c_num_cores-1:0]       mngr2proc_val,
  output logic [c_num_cores-1:0]       mngr2proc_rdy,

  output logic [c_num_cores-1:0][31:0] proc2mngr_msg,
  output logic [c_num_cores-1:0]       proc2mngr_val,
  input  logic [c_num_cores-1:0]       proc2mngr_rdy,

  output mem_req_16B_t                 imemreq_msg,
  output logic                         imemreq_val,
  input  logic                         imemreq_rdy,

  input  mem_resp_16B_t                imemresp_msg,
  input  logic                         imemresp_val,
  output logic                         imemresp_rdy,

  output mem_req_16B_t                 dmemreq_msg,
  output logic                         dmemreq_val,
  input  logic                         dmemreq_rdy,

  input  mem_resp_16B_t                dmemresp_msg,
  input  logic                         dmemresp_val,
  output logic                         dmemresp_rdy,

  //  Only takes Core 0's stats_en to the interface
  output logic                         stats_en,
  output logic [c_num_cores-1:0]       commit_inst,
  output logic [c_num_cores-1:0]       icache_miss,
  output logic [c_num_cores-1:0]       icache_access,
  output logic [c_num_cores-1:0]       dcache_miss,
  output logic [c_num_cores-1:0]       dcache_access
);

  localparam c_num_cores = 4;
  mem_req_16B_t [c_num_cores-1:0]   memreq_msg;
  logic         [c_num_cores-1:0]   memreq_val;
  logic         [c_num_cores-1:0]   memreq_rdy;

  mem_resp_16B_t[c_num_cores-1:0]   memresp_msg;
  logic         [c_num_cores-1:0]   memresp_val;
  logic         [c_num_cores-1:0]   memresp_rdy;

  mem_req_16B_t  [c_num_cores-1:0] mainmemreq_refill_msg;
  logic          [c_num_cores-1:0] mainmemreq_refill_val;
  logic          [c_num_cores-1:0] mainmemreq_refill_rdy;

  mem_resp_16B_t [c_num_cores-1:0] mainmemresp_refill_msg;
  logic          [c_num_cores-1:0] mainmemresp_refill_val;
  logic          [c_num_cores-1:0] mainmemresp_refill_rdy;

  lab5_mcore_MemNetVRTL icache_refill_net
  (  
    .clk           (clk),
    .reset         (reset),

    .memreq_msg  (memreq_msg),
    .memreq_val  (memreq_val),
    .memreq_rdy  (memreq_rdy),

    .memresp_msg (memresp_msg),
    .memresp_val (memresp_val),
    .memresp_rdy (memresp_rdy),

    .mainmemreq_msg  (mainmemreq_refill_msg),
    .mainmemreq_val  (mainmemreq_refill_val),
    .mainmemreq_rdy  (mainmemreq_refill_rdy),

    .mainmemresp_msg (mainmemresp_refill_msg),
    .mainmemresp_val (mainmemresp_refill_val),
    .mainmemresp_rdy (mainmemresp_refill_rdy)
  );

  assign imemreq_msg = mainmemreq_refill_msg[0];
  assign imemreq_val = mainmemreq_refill_val[0];
  assign mainmemreq_refill_rdy = { {c_num_cores-1{1'b0}}, imemreq_rdy };

  assign mainmemresp_refill_msg[0] = imemresp_msg;
  assign mainmemresp_refill_val = { {c_num_cores-1{1'b0}}, imemresp_val };
  assign imemresp_rdy = mainmemresp_refill_rdy[0];

  mem_req_4B_t   [c_num_cores-1:0] icachereq_msg;
  logic          [c_num_cores-1:0] icachereq_val;
  logic          [c_num_cores-1:0] icachereq_rdy;

  mem_resp_4B_t  [c_num_cores-1:0] icacheresp_msg;
  logic          [c_num_cores-1:0] icacheresp_val;
  logic          [c_num_cores-1:0] icacheresp_rdy;

  mem_req_4B_t   [c_num_cores-1:0] dcachereq_msg;
  logic          [c_num_cores-1:0] dcachereq_val;
  logic          [c_num_cores-1:0] dcachereq_rdy;

  mem_resp_4B_t  [c_num_cores-1:0] dcacheresp_msg;
  logic          [c_num_cores-1:0] dcacheresp_val;
  logic          [c_num_cores-1:0] dcacheresp_rdy;

  logic          [c_num_cores-1:0] full_stats_en;
  logic          [c_num_cores-1:0] proc_commit_inst;

  genvar i;
  generate
  for ( i = 0; i < c_num_cores; i = i + 1 ) begin: CORES_CACHES

    // instruction cache

    lab3_mem_BlockingCacheAltVRTL
    #(
      .p_num_banks          (0)
    )
    icache
    (
      .clk           (clk),
      .reset         (reset),

      .cachereq_msg  (icachereq_msg[i]),
      .cachereq_val  (icachereq_val[i]),
      .cachereq_rdy  (icachereq_rdy[i]),

      .cacheresp_msg (icacheresp_msg[i]),
      .cacheresp_val (icacheresp_val[i]),
      .cacheresp_rdy (icacheresp_rdy[i]),

      .memreq_msg    (memreq_msg[i]),
      .memreq_val    (memreq_val[i]),
      .memreq_rdy    (memreq_rdy[i]),

      .memresp_msg   (memresp_msg[i]),
      .memresp_val   (memresp_val[i]),
      .memresp_rdy   (memresp_rdy[i])

    );

    lab2_proc_ProcAltVRTL
    #(
      .p_num_cores(4)
    ) proc
    (
      .clk           (clk),
      .reset         (reset),

      .core_id       (i),

      .imemreq_msg   (icachereq_msg[i]),
      .imemreq_val   (icachereq_val[i]),
      .imemreq_rdy   (icachereq_rdy[i]),

      .imemresp_msg  (icacheresp_msg[i]),
      .imemresp_val  (icacheresp_val[i]),
      .imemresp_rdy  (icacheresp_rdy[i]),

      .dmemreq_msg   (dcachereq_msg[i]),
      .dmemreq_val   (dcachereq_val[i]),
      .dmemreq_rdy   (dcachereq_rdy[i]),

      .dmemresp_msg  (dcacheresp_msg[i]),
      .dmemresp_val  (dcacheresp_val[i]),
      .dmemresp_rdy  (dcacheresp_rdy[i]),

      .mngr2proc_msg (mngr2proc_msg[i]),
      .mngr2proc_val (mngr2proc_val[i]),
      .mngr2proc_rdy (mngr2proc_rdy[i]),

      .proc2mngr_msg (proc2mngr_msg[i]),
      .proc2mngr_val (proc2mngr_val[i]),
      .proc2mngr_rdy (proc2mngr_rdy[i]),

      .stats_en      (full_stats_en[i]),
      .commit_inst   (proc_commit_inst[i])
    );


    // Collect statistics for this cache
    assign icache_miss[i] = icacheresp_rdy[i] & icacheresp_val[i] & (! icacheresp_msg[i].test[0] );
    assign icache_access[i] = icachereq_rdy[i] & icachereq_val[i];
  end
  endgenerate

  assign stats_en = full_stats_en[0];
  assign commit_inst   = proc_commit_inst;

  lab5_mcore_McoreDataCacheVRTL dcache
  (
      .clk                  (clk),
      .reset                (reset),

      .procreq_msg          (dcachereq_msg),
      .procreq_val          (dcachereq_val),
      .procreq_rdy          (dcachereq_rdy),

      .procresp_msg         (dcacheresp_msg),
      .procresp_val         (dcacheresp_val),
      .procresp_rdy         (dcacheresp_rdy),

      .mainmemreq_msg       (dmemreq_msg),
      .mainmemreq_val       (dmemreq_val),
      .mainmemreq_rdy       (dmemreq_rdy),

      .mainmemresp_msg      (dmemresp_msg),
      .mainmemresp_val      (dmemresp_val),
      .mainmemresp_rdy      (dmemresp_rdy),

    // Ports used for statistics gathering
      .dcache_miss          (dcache_miss),
      .dcache_access        (dcache_access)
  );

    `VC_TRACE_BEGIN
  begin

    // This is staffs' line trace, which assume the processors and icaches
    // are instantiated in using generate statement, and the data cache
    // system is instantiated with the name dcache. You can add net to the
    // line trace.
    // Feel free to revamp it or redo it based on your need.

    // CORES_CACHES[0].icache.line_trace( trace_str );
    CORES_CACHES[0].proc.line_trace( trace_str );
    // CORES_CACHES[1].icache.line_trace( trace_str );
    CORES_CACHES[1].proc.line_trace( trace_str );
    // CORES_CACHES[2].icache.line_trace( trace_str );
    CORES_CACHES[2].proc.line_trace( trace_str );
    // CORES_CACHES[3].icache.line_trace( trace_str );
    CORES_CACHES[3].proc.line_trace( trace_str );

    // dcache.line_trace( trace_str );
  end
  `VC_TRACE_END

endmodule

`endif /* LAB5_MCORE_MULTI_CORE_V */

