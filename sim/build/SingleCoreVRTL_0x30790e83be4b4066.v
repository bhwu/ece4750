//-----------------------------------------------------------------------------
// SingleCoreVRTL_0x30790e83be4b4066
//-----------------------------------------------------------------------------
// dump-vcd: True
// verilator-xinit: zeros
`default_nettype none
module SingleCoreVRTL_0x30790e83be4b4066
(
  input  wire [   0:0] clk,
  output wire [   0:0] commit_inst,
  output wire [   0:0] dcache_access,
  output wire [   0:0] dcache_miss,
  output wire [ 174:0] dmemreq_msg,
  input  wire [   0:0] dmemreq_rdy,
  output wire [   0:0] dmemreq_val,
  input  wire [ 144:0] dmemresp_msg,
  output wire [   0:0] dmemresp_rdy,
  input  wire [   0:0] dmemresp_val,
  output wire [   0:0] icache_access,
  output wire [   0:0] icache_miss,
  output wire [ 174:0] imemreq_msg,
  input  wire [   0:0] imemreq_rdy,
  output wire [   0:0] imemreq_val,
  input  wire [ 144:0] imemresp_msg,
  output wire [   0:0] imemresp_rdy,
  input  wire [   0:0] imemresp_val,
  input  wire [  31:0] mngr2proc_msg,
  output wire [   0:0] mngr2proc_rdy,
  input  wire [   0:0] mngr2proc_val,
  output wire [  31:0] proc2mngr_msg,
  input  wire [   0:0] proc2mngr_rdy,
  output wire [   0:0] proc2mngr_val,
  input  wire [   0:0] reset,
  output wire [   0:0] stats_en
);

  // Imported Verilog source from:
  // /home/bhw49/ece4750/lab-group01/sim/lab5_mcore/SingleCoreVRTL.v

  lab5_mcore_SingleCoreVRTL#(
    .dummy ( 0 )
  )  verilog_module
  (
    .clk           ( clk ),
    .commit_inst   ( commit_inst ),
    .dcache_access ( dcache_access ),
    .dcache_miss   ( dcache_miss ),
    .dmemreq_msg   ( dmemreq_msg ),
    .dmemreq_rdy   ( dmemreq_rdy ),
    .dmemreq_val   ( dmemreq_val ),
    .dmemresp_msg  ( dmemresp_msg ),
    .dmemresp_rdy  ( dmemresp_rdy ),
    .dmemresp_val  ( dmemresp_val ),
    .icache_access ( icache_access ),
    .icache_miss   ( icache_miss ),
    .imemreq_msg   ( imemreq_msg ),
    .imemreq_rdy   ( imemreq_rdy ),
    .imemreq_val   ( imemreq_val ),
    .imemresp_msg  ( imemresp_msg ),
    .imemresp_rdy  ( imemresp_rdy ),
    .imemresp_val  ( imemresp_val ),
    .mngr2proc_msg ( mngr2proc_msg ),
    .mngr2proc_rdy ( mngr2proc_rdy ),
    .mngr2proc_val ( mngr2proc_val ),
    .proc2mngr_msg ( proc2mngr_msg ),
    .proc2mngr_rdy ( proc2mngr_rdy ),
    .proc2mngr_val ( proc2mngr_val ),
    .reset         ( reset ),
    .stats_en      ( stats_en )
  );

endmodule // SingleCoreVRTL_0x30790e83be4b4066
`default_nettype wire

`line 1 "lab5_mcore/SingleCoreVRTL.v" 0
//========================================================================
// 1-Core Processor-Cache-Network
//========================================================================

`ifndef LAB5_MCORE_SINGLE_CORE_V
`define LAB5_MCORE_SINGLE_CORE_V

`line 1 "vc/mem-msgs.v" 0
//========================================================================
// vc-mem-msgs : Memory Request/Response Messages
//========================================================================
// The memory request/response messages are used to interact with various
// memories. They are parameterized by the number of bits in the address,
// data, and opaque field.

`ifndef VC_MEM_MSGS_V
`define VC_MEM_MSGS_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 12 "vc/mem-msgs.v" 0

//========================================================================
// Memory Request Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// requests include an opaque field, the address, and the number of bytes
// to read, while write requests include an opaque field, the address,
// the number of bytes to write, and the actual data to write.
//
// Message Format:
//
//    3b    p_opaque_nbits  p_addr_nbits       calc   p_data_nbits
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field, address field, and data field. Note that the size of the length
// field is caclulated from the number of bits in the data field, and
// that the length field is expressed in _bytes_. If the value of the
// length field is zero, then the read or write should be for the full
// width of the data field.
//
// For example, if the opaque field is 8 bits, the address is 32 bits and
// the data is also 32 bits, then the message format is as follows:
//
//   76  74 73           66 65              34 33  32 31               0
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The length field is two bits. A length value of one means read or write
// a single byte, a length value of two means read or write two bytes, and
// so on. A length value of zero means read or write all four bytes. Note
// that not all memories will necessarily support any alignment and/or any
// value for the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [1:0]  len;
  logic [31:0] data;
} mem_req_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [3:0]  len;
  logic [127:0] data;
} mem_req_16B_t;

// memory request type values
`define VC_MEM_REQ_MSG_TYPE_READ     3'd0
`define VC_MEM_REQ_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_REQ_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_REQ_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_REQ_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_REQ_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_REQ_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Request Message: Trace message
//------------------------------------------------------------------------

module vc_MemReqMsg4BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_4B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_4B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemReqMsg16BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_16B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_16B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

//========================================================================
// Memory Response Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// responses include an opaque field, the actual data, and the number of
// bytes, while write responses currently include just the opaque field.
//
// Message Format:
//
//    3b    p_opaque_nbits   2b    calc   p_data_nbits
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field and data field. Note that the size of the length field is
// caclulated from the number of bits in the data field, and that the
// length field is expressed in _bytes_. If the value of the length field
// is zero, then the read or write should be for the full width of the
// data field.
//
// For example, if the opaque field is 8 bits and the data is 32 bits,
// then the message format is as follows:
//
//   46  44 43           36 35  34 33  32 31               0
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The length field is two bits. A length value of one means one byte was
// read, a length value of two means two bytes were read, and so on. A
// length value of zero means all four bytes were read. Note that not all
// memories will necessarily support any alignment and/or any value for
// the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [1:0]  len;
  logic [31:0] data;
} mem_resp_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [3:0]  len;
  logic [127:0] data;
} mem_resp_16B_t;

// Values for the type field

`define VC_MEM_RESP_MSG_TYPE_READ     3'd0
`define VC_MEM_RESP_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_RESP_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_RESP_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_RESP_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_RESP_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_RESP_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Response Message: Trace message
//------------------------------------------------------------------------

module vc_MemRespMsg4BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_4B_t  msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_4B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemRespMsg16BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_16B_t msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0] data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_16B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

`endif /* VC_MEM_MSGS_V */


`line 9 "lab5_mcore/SingleCoreVRTL.v" 0
`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 10 "lab5_mcore/SingleCoreVRTL.v" 0

`line 1 "lab2_proc/ProcAltVRTL.v" 0
//=========================================================================
// 5-Stage Simple Pipelined Processor
//=========================================================================

`ifndef LAB2_PROC_PIPELINED_PROC_ALT_V
`define LAB2_PROC_PIPELINED_PROC_ALT_V

`line 1 "vc/mem-msgs.v" 0
//========================================================================
// vc-mem-msgs : Memory Request/Response Messages
//========================================================================
// The memory request/response messages are used to interact with various
// memories. They are parameterized by the number of bits in the address,
// data, and opaque field.

`ifndef VC_MEM_MSGS_V
`define VC_MEM_MSGS_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 12 "vc/mem-msgs.v" 0

//========================================================================
// Memory Request Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// requests include an opaque field, the address, and the number of bytes
// to read, while write requests include an opaque field, the address,
// the number of bytes to write, and the actual data to write.
//
// Message Format:
//
//    3b    p_opaque_nbits  p_addr_nbits       calc   p_data_nbits
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field, address field, and data field. Note that the size of the length
// field is caclulated from the number of bits in the data field, and
// that the length field is expressed in _bytes_. If the value of the
// length field is zero, then the read or write should be for the full
// width of the data field.
//
// For example, if the opaque field is 8 bits, the address is 32 bits and
// the data is also 32 bits, then the message format is as follows:
//
//   76  74 73           66 65              34 33  32 31               0
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The length field is two bits. A length value of one means read or write
// a single byte, a length value of two means read or write two bytes, and
// so on. A length value of zero means read or write all four bytes. Note
// that not all memories will necessarily support any alignment and/or any
// value for the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [1:0]  len;
  logic [31:0] data;
} mem_req_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [3:0]  len;
  logic [127:0] data;
} mem_req_16B_t;

// memory request type values
`define VC_MEM_REQ_MSG_TYPE_READ     3'd0
`define VC_MEM_REQ_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_REQ_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_REQ_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_REQ_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_REQ_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_REQ_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Request Message: Trace message
//------------------------------------------------------------------------

module vc_MemReqMsg4BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_4B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_4B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemReqMsg16BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_16B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_16B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

//========================================================================
// Memory Response Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// responses include an opaque field, the actual data, and the number of
// bytes, while write responses currently include just the opaque field.
//
// Message Format:
//
//    3b    p_opaque_nbits   2b    calc   p_data_nbits
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field and data field. Note that the size of the length field is
// caclulated from the number of bits in the data field, and that the
// length field is expressed in _bytes_. If the value of the length field
// is zero, then the read or write should be for the full width of the
// data field.
//
// For example, if the opaque field is 8 bits and the data is 32 bits,
// then the message format is as follows:
//
//   46  44 43           36 35  34 33  32 31               0
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The length field is two bits. A length value of one means one byte was
// read, a length value of two means two bytes were read, and so on. A
// length value of zero means all four bytes were read. Note that not all
// memories will necessarily support any alignment and/or any value for
// the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [1:0]  len;
  logic [31:0] data;
} mem_resp_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [3:0]  len;
  logic [127:0] data;
} mem_resp_16B_t;

// Values for the type field

`define VC_MEM_RESP_MSG_TYPE_READ     3'd0
`define VC_MEM_RESP_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_RESP_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_RESP_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_RESP_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_RESP_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_RESP_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Response Message: Trace message
//------------------------------------------------------------------------

module vc_MemRespMsg4BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_4B_t  msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_4B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemRespMsg16BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_16B_t msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0] data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_16B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

`endif /* VC_MEM_MSGS_V */


`line 9 "lab2_proc/ProcAltVRTL.v" 0
`line 1 "vc/queues.v" 0
//========================================================================
// Verilog Components: Queues
//========================================================================

`ifndef VC_QUEUES_V
`define VC_QUEUES_V

`line 1 "vc/regs.v" 0
//========================================================================
// Verilog Components: Registers
//========================================================================

// Note that we place the register output earlier in the port list since
// this is one place we might actually want to use positional port
// binding like this:
//
//  logic [p_nbits-1:0] result_B;
//  vc_Reg#(p_nbits) result_AB( clk, result_B, result_A );

`ifndef VC_REGS_V
`define VC_REGS_V

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop
//------------------------------------------------------------------------

module vc_Reg
#(
  parameter p_nbits = 1
)(
  input  logic               clk, // Clock input
  output logic [p_nbits-1:0] q,   // Data output
  input  logic [p_nbits-1:0] d    // Data input
);

  always_ff @( posedge clk )
    q <= d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with reset
//------------------------------------------------------------------------

module vc_ResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d      // Data input
);

  always_ff @( posedge clk )
    q <= reset ? p_reset_value : d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable
//------------------------------------------------------------------------

module vc_EnReg
#(
  parameter p_nbits = 1
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( en )
      q <= d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable and reset
//------------------------------------------------------------------------

module vc_EnResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( reset || en )
      q <= reset ? p_reset_value : d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

`endif /* VC_REGS_V */


`line 9 "vc/queues.v" 0
`line 1 "vc/muxes.v" 0
//========================================================================
// Verilog Components: Muxes
//========================================================================

`ifndef VC_MUXES_V
`define VC_MUXES_V

//------------------------------------------------------------------------
// 2 Input Mux
//------------------------------------------------------------------------

module vc_Mux2
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1,
  input  logic               sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      1'd0 : out = in0;
      1'd1 : out = in1;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 3 Input Mux
//------------------------------------------------------------------------

module vc_Mux3
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 4 Input Mux
//------------------------------------------------------------------------

module vc_Mux4
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      2'd3 : out = in3;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 5 Input Mux
//------------------------------------------------------------------------

module vc_Mux5
#(
 parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 6 Input Mux
//------------------------------------------------------------------------

module vc_Mux6
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 7 Input Mux
//------------------------------------------------------------------------

module vc_Mux7
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 8 Input Mux
//------------------------------------------------------------------------

module vc_Mux8
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6, in7,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      3'd7 : out = in7;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

`endif /* VC_MUXES_V */


`line 10 "vc/queues.v" 0
`line 1 "vc/regfiles.v" 0
//========================================================================
// Verilog Components: Register Files
//========================================================================

`ifndef VC_REGFILES_V
`define VC_REGFILES_V

//------------------------------------------------------------------------
// 1r1w register file
//------------------------------------------------------------------------

module vc_Regfile_1r1w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                    clk,
  input  logic                    reset,

  // Read port (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr,
  output logic [p_data_nbits-1:0] read_data,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en,
  input  logic [c_addr_nbits-1:0] write_addr,
  input  logic [p_data_nbits-1:0] write_data
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data = rfile[read_addr];

  // Write on positive clock edge

  always_ff @( posedge clk )
    if ( write_en )
      rfile[write_addr] <= write_data;

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// 1r1w register file with reset
//------------------------------------------------------------------------

module vc_ResetRegfile_1r1w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,
  parameter p_reset_value = 0,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                    clk,
  input  logic                    reset,

  // Read port (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr,
  output logic [p_data_nbits-1:0] read_data,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en,
  input  logic [c_addr_nbits-1:0] write_addr,
  input  logic [p_data_nbits-1:0] write_data
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data = rfile[read_addr];

  // Write on positive clock edge. We have to use a generate statement to
  // allow us to include the reset logic for each individual register.

  genvar i;
  generate
    for ( i = 0; i < p_num_entries; i = i+1 )
    begin : wport
      always_ff @( posedge clk )
        if ( reset )
          rfile[i] <= p_reset_value;
        else if ( write_en && (i[c_addr_nbits-1:0] == write_addr) )
          rfile[i] <= write_data;
    end
  endgenerate

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// 2r1w register file
//------------------------------------------------------------------------

module vc_Regfile_2r1w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                   clk,
  input  logic                   reset,

  // Read port 0 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr0,
  output logic [p_data_nbits-1:0] read_data0,

  // Read port 1 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr1,
  output logic [p_data_nbits-1:0] read_data1,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en,
  input  logic [c_addr_nbits-1:0] write_addr,
  input  logic [p_data_nbits-1:0] write_data
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data0 = rfile[read_addr0];
  assign read_data1 = rfile[read_addr1];

  // Write on positive clock edge

  always_ff @( posedge clk )
    if ( write_en )
      rfile[write_addr] <= write_data;

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// 2r2w register file
//------------------------------------------------------------------------

module vc_Regfile_2r2w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                    clk,
  input  logic                    reset,

  // Read port 0 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr0,
  output logic [p_data_nbits-1:0] read_data0,

  // Read port 1 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr1,
  output logic [p_data_nbits-1:0] read_data1,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en0,
  input  logic [c_addr_nbits-1:0] write_addr0,
  input  logic [p_data_nbits-1:0] write_data0,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en1,
  input  logic [c_addr_nbits-1:0] write_addr1,
  input  logic [p_data_nbits-1:0] write_data1
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data0 = rfile[read_addr0];
  assign read_data1 = rfile[read_addr1];

  // Write on positive clock edge

  always_ff @( posedge clk ) begin

    if ( write_en0 )
      rfile[write_addr0] <= write_data0;

    if ( write_en1 )
      rfile[write_addr1] <= write_data1;

  end

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en0 );
      `VC_ASSERT_NOT_X( write_en1 );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en0 ) begin
        `VC_ASSERT_NOT_X( write_addr0 );
        `VC_ASSERT( write_addr0 < p_num_entries );
      end

      if ( write_en1 ) begin
        `VC_ASSERT_NOT_X( write_addr1 );
        `VC_ASSERT( write_addr1 < p_num_entries );
      end

      // It is invalid to use the same write address for both write ports

      if ( write_en0 && write_en1 ) begin
        `VC_ASSERT( write_addr0 != write_addr1 );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// Register file specialized for r0 == 0
//------------------------------------------------------------------------

module vc_Regfile_2r1w_zero
(
  input  logic        clk,
  input  logic        reset,

  input  logic  [4:0] rd_addr0,
  output logic [31:0] rd_data0,

  input  logic  [4:0] rd_addr1,
  output logic [31:0] rd_data1,

  input  logic        wr_en,
  input  logic  [4:0] wr_addr,
  input  logic [31:0] wr_data
);

  // these wires are to be hooked up to the actual register file read
  // ports

  logic [31:0] rf_read_data0;
  logic [31:0] rf_read_data1;

  vc_Regfile_2r1w
  #(
    .p_data_nbits  (32),
    .p_num_entries (32)
  )
  rfile
  (
    .clk         (clk),
    .reset       (reset),
    .read_addr0  (rd_addr0),
    .read_data0  (rf_read_data0),
    .read_addr1  (rd_addr1),
    .read_data1  (rf_read_data1),
    .write_en    (wr_en),
    .write_addr  (wr_addr),
    .write_data  (wr_data)
  );

  // we pick 0 value when either read address is 0
  assign rd_data0 = ( rd_addr0 == 5'd0 ) ? 32'd0 : rf_read_data0;
  assign rd_data1 = ( rd_addr1 == 5'd0 ) ? 32'd0 : rf_read_data1;

endmodule

`endif /* VC_REGFILES_V */


`line 11 "vc/queues.v" 0
`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 12 "vc/queues.v" 0

//------------------------------------------------------------------------
// Defines
//------------------------------------------------------------------------

`define VC_QUEUE_NORMAL   4'b0000
`define VC_QUEUE_PIPE     4'b0001
`define VC_QUEUE_BYPASS   4'b0010

//------------------------------------------------------------------------
// Single-Element Queue Control Logic
//------------------------------------------------------------------------
// This is the control logic for a single-elment queue. It is designed to
// be attached to a storage element with a write enable. Additionally, it
// includes the ability to statically enable pipeline and/or bypass
// behavior. Pipeline behavior is when the deq_rdy signal is
// combinationally wired to the enq_rdy signal allowing elements to be
// dequeued and enqueued in the same cycle when the queue is full. Bypass
// behavior is when the enq_val signal is combinationally wired to the
// deq_val signal allowing elements to bypass the storage element if the
// storage element is empty.

module vc_QueueCtrl1
#(
  parameter p_type = `VC_QUEUE_NORMAL
)(
  input  logic clk,
  input  logic reset,

  input  logic enq_val,        // Enqueue data is valid
  output logic enq_rdy,        // Ready for producer to do an enqueue

  output logic deq_val,        // Dequeue data is valid
  input  logic deq_rdy,        // Consumer is ready to do a dequeue

  output logic write_en,       // Write en signal to wire up to storage element
  output logic bypass_mux_sel, // Used to control bypass mux for bypass queues
  output logic num_free_entries // Either zero or one
);

  // Status register

  logic full;
  logic full_next;

  always_ff @(posedge clk) begin
    full <= reset ? 1'b0 : full_next;
  end

  assign num_free_entries = full ? 1'b0 : 1'b1;

  // Determine if pipeline or bypass behavior is enabled

  localparam c_pipe_en   = |( p_type & `VC_QUEUE_PIPE   );
  localparam c_bypass_en = |( p_type & `VC_QUEUE_BYPASS );

  // We enq/deq only when they are both ready and valid

  logic  do_enq;
  assign do_enq = enq_rdy && enq_val;

  logic  do_deq;
  assign do_deq = deq_rdy && deq_val;

  // Determine if we have pipeline or bypass behaviour and
  // set the write enable accordingly.

  logic  empty;
  assign empty = ~full;

  logic  do_pipe;
  assign do_pipe = c_pipe_en   && full  && do_enq && do_deq;

  logic  do_bypass;
  assign do_bypass = c_bypass_en && empty && do_enq && do_deq;

  assign write_en = do_enq && ~do_bypass;

  // Regardless of the type of queue or whether or not we are actually
  // doing a bypass, if the queue is empty then we select the enq bits,
  // otherwise we select the output of the queue state elements.

  assign bypass_mux_sel = empty;

  // Ready signals are calculated from full register. If pipeline
  // behavior is enabled, then the enq_rdy signal is also calculated
  // combinationally from the deq_rdy signal. If bypass behavior is
  // enabled then the deq_val signal is also calculated combinationally
  // from the enq_val signal.

  assign enq_rdy  = ~full  || ( c_pipe_en   && full  && deq_rdy );
  assign deq_val  = ~empty || ( c_bypass_en && empty && enq_val );

  // Control logic for the full register input

  assign full_next = ( do_deq && ~do_pipe )   ? 1'b0
                   : ( do_enq && ~do_bypass ) ? 1'b1
                   :                            full;

endmodule

//------------------------------------------------------------------------
// Single-Element Queue Datapath
//------------------------------------------------------------------------
// This is the datpath for single element queues. It includes a register
// and a bypass mux if needed.

module vc_QueueDpath1
#(
  parameter p_type      = `VC_QUEUE_NORMAL,
  parameter p_msg_nbits = 1
)(
  input  logic                   clk,
  input  logic                   reset,
  input  logic                   write_en,
  input  logic                   bypass_mux_sel,
  input  logic [p_msg_nbits-1:0] enq_msg,
  output logic [p_msg_nbits-1:0] deq_msg
);

  // Queue storage

  logic [p_msg_nbits-1:0] qstore;

  vc_EnReg#(p_msg_nbits) qstore_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (write_en),
    .d     (enq_msg),
    .q     (qstore)
  );

  // Bypass muxing

  generate
  if ( |(p_type & `VC_QUEUE_BYPASS ) )

    vc_Mux2#(p_msg_nbits) bypass_mux
    (
      .in0 (qstore),
      .in1 (enq_msg),
      .sel (bypass_mux_sel),
      .out (deq_msg)
    );

  else
    assign deq_msg = qstore;
  endgenerate

endmodule

//------------------------------------------------------------------------
// Multi-Element Queue Control Logic
//------------------------------------------------------------------------
// This is the control logic for a multi-elment queue. It is designed to
// be attached to a Regfile storage element. Additionally, it includes
// the ability to statically enable pipeline and/or bypass behavior.
// Pipeline behavior is when the deq_rdy signal is combinationally wired
// to the enq_rdy signal allowing elements to be dequeued and enqueued in
// the same cycle when the queue is full. Bypass behavior is when the
// enq_val signal is cominationally wired to the deq_val signal allowing
// elements to bypass the storage element if the storage element is
// empty.

module vc_QueueCtrl
#(
  parameter p_type     = `VC_QUEUE_NORMAL,
  parameter p_num_msgs = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits = $clog2(p_num_msgs)
)(
  input  logic                    clk, reset,

  input  logic                    enq_val,        // Enqueue data is valid
  output logic                    enq_rdy,        // Ready for producer to enqueue

  output logic                    deq_val,        // Dequeue data is valid
  input  logic                    deq_rdy,        // Consumer is ready to dequeue

  output logic                    write_en,       // Wen to wire to regfile
  output logic [c_addr_nbits-1:0] write_addr,     // Waddr to wire to regfile
  output logic [c_addr_nbits-1:0] read_addr,      // Raddr to wire to regfile
  output logic                    bypass_mux_sel, // Control mux for bypass queues
  output logic [c_addr_nbits:0]   num_free_entries // Num of free entries in queue
);

  // Enqueue and dequeue pointers

  logic [c_addr_nbits-1:0] enq_ptr;
  logic [c_addr_nbits-1:0] enq_ptr_next;

  vc_ResetReg#(c_addr_nbits) enq_ptr_reg
  (
    .clk     (clk),
    .reset   (reset),
    .d       (enq_ptr_next),
    .q       (enq_ptr)
  );

  logic [c_addr_nbits-1:0] deq_ptr;
  logic [c_addr_nbits-1:0] deq_ptr_next;

  vc_ResetReg#(c_addr_nbits) deq_ptr_reg
  (
    .clk   (clk),
    .reset (reset),
    .d     (deq_ptr_next),
    .q     (deq_ptr)
  );

  assign write_addr = enq_ptr;
  assign read_addr  = deq_ptr;

  // Extra state to tell difference between full and empty

  logic full;
  logic full_next;

  vc_ResetReg#(1) full_reg
  (
    .clk   (clk),
    .reset (reset),
    .d     (full_next),
    .q     (full)
  );

  // Determine if pipeline or bypass behavior is enabled

  localparam c_pipe_en   = |( p_type & `VC_QUEUE_PIPE   );
  localparam c_bypass_en = |( p_type & `VC_QUEUE_BYPASS );

  // We enq/deq only when they are both ready and valid

  logic  do_enq;
  assign do_enq = enq_rdy && enq_val;

  logic  do_deq;
  assign do_deq = deq_rdy && deq_val;

  // Determine if we have pipeline or bypass behaviour and
  // set the write enable accordingly.

  logic  empty;
  assign empty = ~full && (enq_ptr == deq_ptr);

  logic  do_pipe;
  assign do_pipe = c_pipe_en   && full  && do_enq && do_deq;

  logic  do_bypass;
  assign do_bypass = c_bypass_en && empty && do_enq && do_deq;

  assign write_en = do_enq && ~do_bypass;

  // Regardless of the type of queue or whether or not we are actually
  // doing a bypass, if the queue is empty then we select the enq bits,
  // otherwise we select the output of the queue state elements.

  assign bypass_mux_sel = empty;

  // Ready signals are calculated from full register. If pipeline
  // behavior is enabled, then the enq_rdy signal is also calculated
  // combinationally from the deq_rdy signal. If bypass behavior is
  // enabled then the deq_val signal is also calculated combinationally
  // from the enq_val signal.

  assign enq_rdy  = ~full  || ( c_pipe_en   && full  && deq_rdy );
  assign deq_val  = ~empty || ( c_bypass_en && empty && enq_val );

  // Control logic for the enq/deq pointers and full register

  logic [c_addr_nbits-1:0] deq_ptr_plus1;
  assign deq_ptr_plus1 = deq_ptr + 1'b1;

  /* verilator lint_off WIDTH */

  logic [c_addr_nbits-1:0] deq_ptr_inc;
  assign deq_ptr_inc = (deq_ptr_plus1 == p_num_msgs) ? {c_addr_nbits{1'b0}} : deq_ptr_plus1;

  logic [c_addr_nbits-1:0] enq_ptr_plus1;
  assign enq_ptr_plus1 = enq_ptr + 1'b1;

  logic [c_addr_nbits-1:0] enq_ptr_inc;
  assign enq_ptr_inc = (enq_ptr_plus1 == p_num_msgs) ? {c_addr_nbits{1'b0}} : enq_ptr_plus1;

  /* verilator lint_on WIDTH */

  assign deq_ptr_next
    = ( do_deq && ~do_bypass ) ? ( deq_ptr_inc ) : deq_ptr;

  assign enq_ptr_next
    = ( do_enq && ~do_bypass ) ? ( enq_ptr_inc ) : enq_ptr;

  assign full_next
    = ( do_enq && ~do_deq && ( enq_ptr_inc == deq_ptr ) ) ? 1'b1
    : ( do_deq && full && ~do_pipe )                      ? 1'b0
    :                                                       full;

  // Number of free entries

  assign num_free_entries
    = full                ? {(c_addr_nbits+1){1'b0}}
    : empty               ? p_num_msgs[c_addr_nbits:0]
    : (enq_ptr > deq_ptr) ? p_num_msgs[c_addr_nbits:0] - (enq_ptr - deq_ptr)
    : (deq_ptr > enq_ptr) ? deq_ptr - enq_ptr
    :                       {(c_addr_nbits+1){1'bx}};

endmodule

//------------------------------------------------------------------------
// Multi-Element Queue Datapath
//------------------------------------------------------------------------
// This is the datpath for multi-element queues. It includes a register
// and a bypass mux if needed.

module vc_QueueDpath
#(
  parameter p_type      = `VC_QUEUE_NORMAL,
  parameter p_msg_nbits = 4,
  parameter p_num_msgs  = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits = $clog2(p_num_msgs)
)(
  input  logic                    clk,
  input  logic                    reset,
  input  logic                    write_en,
  input  logic                    bypass_mux_sel,
  input  logic [c_addr_nbits-1:0] write_addr,
  input  logic [c_addr_nbits-1:0] read_addr,
  input  logic [p_msg_nbits-1:0]  enq_msg,
  output logic [p_msg_nbits-1:0]  deq_msg
);

  // Queue storage

  logic [p_msg_nbits-1:0] read_data;

  vc_Regfile_1r1w#(p_msg_nbits,p_num_msgs) qstore
  (
    .clk        (clk),
    .reset      (reset),
    .read_addr  (read_addr),
    .read_data  (read_data),
    .write_en   (write_en),
    .write_addr (write_addr),
    .write_data (enq_msg)
  );

  // Bypass muxing

  generate
  if ( |(p_type & `VC_QUEUE_BYPASS ) )

    vc_Mux2#(p_msg_nbits) bypass_mux
    (
      .in0 (read_data),
      .in1 (enq_msg),
      .sel (bypass_mux_sel),
      .out (deq_msg)
    );

  else
    assign deq_msg = read_data;
  endgenerate

endmodule

//------------------------------------------------------------------------
// Queue
//------------------------------------------------------------------------

module vc_Queue
#(
  parameter p_type      = `VC_QUEUE_NORMAL,
  parameter p_msg_nbits = 1,
  parameter p_num_msgs  = 2,

  // parameters not meant to be set outside this module
  parameter c_addr_nbits = $clog2(p_num_msgs)
)(
  input  logic                   clk,
  input  logic                   reset,

  input  logic                   enq_val,
  output logic                   enq_rdy,
  input  logic [p_msg_nbits-1:0] enq_msg,

  output logic                   deq_val,
  input  logic                   deq_rdy,
  output logic [p_msg_nbits-1:0] deq_msg,

  output logic [c_addr_nbits:0]  num_free_entries
);


  generate
  if ( p_num_msgs == 1 )
  begin

    logic write_en;
    logic bypass_mux_sel;

    vc_QueueCtrl1#(p_type) ctrl
    (
      .clk              (clk),
      .reset            (reset),
      .enq_val          (enq_val),
      .enq_rdy          (enq_rdy),
      .deq_val          (deq_val),
      .deq_rdy          (deq_rdy),
      .write_en         (write_en),
      .bypass_mux_sel   (bypass_mux_sel),
      .num_free_entries (num_free_entries)
    );

    vc_QueueDpath1#(p_type,p_msg_nbits) dpath
    (
      .clk            (clk),
      .reset          (reset),
      .write_en       (write_en),
      .bypass_mux_sel (bypass_mux_sel),
      .enq_msg        (enq_msg),
      .deq_msg        (deq_msg)
    );

  end
  else
  begin

    logic                    write_en;
    logic                    bypass_mux_sel;
    logic [c_addr_nbits-1:0] write_addr;
    logic [c_addr_nbits-1:0] read_addr;

    vc_QueueCtrl#(p_type,p_num_msgs) ctrl
    (
      .clk              (clk),
      .reset            (reset),
      .enq_val          (enq_val),
      .enq_rdy          (enq_rdy),
      .deq_val          (deq_val),
      .deq_rdy          (deq_rdy),
      .write_en         (write_en),
      .write_addr       (write_addr),
      .read_addr        (read_addr),
      .bypass_mux_sel   (bypass_mux_sel),
      .num_free_entries (num_free_entries)
    );

    vc_QueueDpath#(p_type,p_msg_nbits,p_num_msgs) dpath
    (
      .clk              (clk),
      .reset            (reset),
      .write_en         (write_en),
      .bypass_mux_sel   (bypass_mux_sel),
      .write_addr       (write_addr),
      .read_addr        (read_addr),
      .enq_msg          (enq_msg),
      .deq_msg          (deq_msg)
    );

  end
  endgenerate

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( enq_val );
      `VC_ASSERT_NOT_X( enq_rdy );
      `VC_ASSERT_NOT_X( deq_val );
      `VC_ASSERT_NOT_X( deq_rdy );
    end
  end
  */

  // Line Tracing

  //  logic [`VC_TRACE_NBITS_TO_NCHARS(p_msg_nbits)*8-1:0] str;
  //
  //  `VC_TRACE_BEGIN
  //  begin
  //
  //    $sformat( str, "%x", enq_msg );
  //    vc_trace.append_val_rdy_str( trace_str, enq_val, enq_rdy, str );
  //
  //    vc_trace.append_str( trace_str, "(" );
  //    $sformat( str, "%x", p_num_msgs-num_free_entries );
  //    vc_trace.append_str( trace_str, str );
  //    vc_trace.append_str( trace_str, ")" );
  //
  //    $sformat( str, "%x", deq_msg );
  //    vc_trace.append_val_rdy_str( trace_str, deq_val, deq_rdy, str );

  // end
  // endtask

endmodule

`endif /* VC_QUEUES_V */


`line 10 "lab2_proc/ProcAltVRTL.v" 0
`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 11 "lab2_proc/ProcAltVRTL.v" 0

`line 1 "lab2_proc/TinyRV2InstVRTL.v" 0
//========================================================================
// TinyRV2 Instruction Type
//========================================================================
// Instruction types are similar to message types but are strictly used
// for communication within a TinyRV2-based processor. Instruction
// "messages" can be unpacked into the various fields as defined by the
// TinyRV2 ISA, as well as be constructed from specifying each field
// explicitly. The 32-bit instruction has different fields depending on
// the format of the instruction used. The following are the various
// instruction encoding formats used in the TinyRV2 ISA.
//
//  31          25 24   20 19   15 14    12 11          7 6      0
// | funct7       | rs2   | rs1   | funct3 | rd          | opcode |  R-type
// | imm[11:0]            | rs1   | funct3 | rd          | opcode |  I-type, I-imm
// | imm[11:5]    | rs2   | rs1   | funct3 | imm[4:0]    | opcode |  S-type, S-imm
// | imm[12|10:5] | rs2   | rs1   | funct3 | imm[4:1|11] | opcode |  SB-type,B-imm
// | imm[31:12]                            | rd          | opcode |  U-type, U-imm
// | imm[20|10:1|11|19:12]                 | rd          | opcode |  UJ-type,J-imm

`ifndef TINY_RV2_INST_V
`define TINY_RV2_INST_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 24 "lab2_proc/TinyRV2InstVRTL.v" 0

//------------------------------------------------------------------------
// Instruction fields
//------------------------------------------------------------------------

`define RV2ISA_INST_OPCODE  6:0
`define RV2ISA_INST_RD      11:7
`define RV2ISA_INST_RS1     19:15
`define RV2ISA_INST_RS2     24:20
`define RV2ISA_INST_FUNCT3  14:12
`define RV2ISA_INST_FUNCT7  31:25
`define RV2ISA_INST_CSR     31:20

//------------------------------------------------------------------------
// Field sizes
//------------------------------------------------------------------------

`define RV2ISA_INST_NBITS          32
`define RV2ISA_INST_OPCODE_NBITS   7
`define RV2ISA_INST_RD_NBITS       5
`define RV2ISA_INST_RS1_NBITS      5
`define RV2ISA_INST_RS2_NBITS      5
`define RV2ISA_INST_FUNCT3_NBITS   3
`define RV2ISA_INST_FUNCT7_NBITS   7
`define RV2ISA_INST_CSR_NBITS      12

//------------------------------------------------------------------------
// Instruction opcodes
//------------------------------------------------------------------------

// Basic instructions

`define RV2ISA_INST_CSRR  32'b???????_?????_?????_010_?????_1110011
`define RV2ISA_INST_CSRW  32'b???????_?????_?????_001_?????_1110011
`define RV2ISA_INST_NOP   32'b0000000_00000_00000_000_00000_0010011
`define RV2ISA_ZERO       32'b0000000_00000_00000_000_00000_0000000

// Register-register arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADD   32'b0000000_?????_?????_000_?????_0110011
`define RV2ISA_INST_SUB   32'b0100000_?????_?????_000_?????_0110011
`define RV2ISA_INST_AND   32'b0000000_?????_?????_111_?????_0110011
`define RV2ISA_INST_OR    32'b0000000_?????_?????_110_?????_0110011
`define RV2ISA_INST_XOR   32'b0000000_?????_?????_100_?????_0110011
`define RV2ISA_INST_SLT   32'b0000000_?????_?????_010_?????_0110011
`define RV2ISA_INST_SLTU  32'b0000000_?????_?????_011_?????_0110011
`define RV2ISA_INST_MUL   32'b0000001_?????_?????_000_?????_0110011

// Register-immediate arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADDI  32'b???????_?????_?????_000_?????_0010011
`define RV2ISA_INST_ANDI  32'b???????_?????_?????_111_?????_0010011
`define RV2ISA_INST_ORI   32'b???????_?????_?????_110_?????_0010011
`define RV2ISA_INST_XORI  32'b???????_?????_?????_100_?????_0010011
`define RV2ISA_INST_SLTI  32'b???????_?????_?????_010_?????_0010011
`define RV2ISA_INST_SLTIU 32'b???????_?????_?????_011_?????_0010011

// Shift instructions

`define RV2ISA_INST_SRA   32'b0100000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SRL   32'b0000000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SLL   32'b0000000_?????_?????_001_?????_0110011
`define RV2ISA_INST_SRAI  32'b0100000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SRLI  32'b0000000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SLLI  32'b0000000_?????_?????_001_?????_0010011

// Other instructions

`define RV2ISA_INST_LUI   32'b???????_?????_?????_???_?????_0110111
`define RV2ISA_INST_AUIPC 32'b???????_?????_?????_???_?????_0010111

// Memory instructions

`define RV2ISA_INST_LW    32'b???????_?????_?????_010_?????_0000011
`define RV2ISA_INST_SW    32'b???????_?????_?????_010_?????_0100011

// Unconditional jump instructions

`define RV2ISA_INST_JAL   32'b???????_?????_?????_???_?????_1101111
`define RV2ISA_INST_JALR  32'b???????_?????_?????_000_?????_1100111

// Conditional branch instructions

`define RV2ISA_INST_BEQ   32'b???????_?????_?????_000_?????_1100011
`define RV2ISA_INST_BNE   32'b???????_?????_?????_001_?????_1100011
`define RV2ISA_INST_BLT   32'b???????_?????_?????_100_?????_1100011
`define RV2ISA_INST_BGE   32'b???????_?????_?????_101_?????_1100011
`define RV2ISA_INST_BLTU  32'b???????_?????_?????_110_?????_1100011
`define RV2ISA_INST_BGEU  32'b???????_?????_?????_111_?????_1100011

//------------------------------------------------------------------------
// Coprocessor registers
//------------------------------------------------------------------------

`define RV2ISA_CPR_PROC2MNGR  12'h7C0
`define RV2ISA_CPR_MNGR2PROC  12'hFC0
`define RV2ISA_CPR_COREID     12'hF14
`define RV2ISA_CPR_NUMCORES   12'hFC1
`define RV2ISA_CPR_STATS_EN   12'h7C1

//------------------------------------------------------------------------
// Helper Tasks
//------------------------------------------------------------------------

module rv2isa_InstTasks();

  //----------------------------------------------------------------------
  // Immediate decoding -- only outputs signals at the width required for
  // line tracing
  //----------------------------------------------------------------------
  function [11:0] imm_i( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate
    imm_i = { inst[31], inst[30:25], inst[24:21], inst[20] };
  end
  endfunction

  function [4:0] imm_shamt( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate, specialized for shift amounts
    imm_shamt = { inst[24:21], inst[20] };
  end
  endfunction

  function [11:0] imm_s( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // S-type immediate
    imm_s = { inst[31], inst[30:25], inst[11:8], inst[7] };
  end
  endfunction

  function [12:0] imm_b( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // B-type immediate
    imm_b = { inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };
  end
  endfunction

  function [19:0] imm_u_sh12( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // U-type immediate, shifted right by 12
    imm_u_sh12 = { inst[31], inst[30:20], inst[19:12] };
  end
  endfunction

  function [20:0] imm_j( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // J-type immediate
    imm_j = { inst[31], inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm
  //----------------------------------------------------------------------

  reg [3*8-1:0]                     rs1_str;
  reg [3*8-1:0]                     rs2_str;
  reg [3*8-1:0]                     rd_str;
  reg [9*8-1:0]                     csr_str;

  logic [`RV2ISA_INST_RS1_NBITS-1:0] rs1;
  logic [`RV2ISA_INST_RS2_NBITS-1:0] rs2;
  logic [`RV2ISA_INST_RD_NBITS-1:0]  rd;
  logic [`RV2ISA_INST_CSR_NBITS-1:0] csr;

  function [25*8-1:0] disasm( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    // Unpack the fields

    rs1      = inst[`RV2ISA_INST_RS1];
    rs2      = inst[`RV2ISA_INST_RS2];
    rd       = inst[`RV2ISA_INST_RD];
    csr      = inst[`RV2ISA_INST_CSR];

    // Create fixed-width register specifiers

    if ( rs1 <= 9 )
      $sformat( rs1_str, "x0%0d", rs1 );
    else
      $sformat( rs1_str, "x%d",  rs1 );

    if ( rs2 <= 9 )
      $sformat( rs2_str, "x0%0d", rs2 );
    else
      $sformat( rs2_str, "x%d",  rs2 );

    if ( rd <= 9 )
      $sformat( rd_str, "x0%0d", rd );
    else
      $sformat( rd_str, "x%d",  rd );

    // if ( csr == `RV2ISA_CPR_PROC2MNGR )
      // $sformat( csr_str, "proc2mngr" );
    // else if ( csr == `RV2ISA_CPR_MNGR2PROC )
      // $sformat( csr_str, "mngr2proc" );
    // else if ( csr == `RV2ISA_CPR_COREID )
      // $sformat( csr_str, "coreid   " );
    // else if ( csr == `RV2ISA_CPR_NUMCORES )
      // $sformat( csr_str, "numcores " );
    // else if ( csr == `RV2ISA_CPR_STATS_EN )
      // $sformat( csr_str, "stats_en " );
    // else
    $sformat( csr_str, "    0x%x", csr );

    // Actual disassembly

    casez ( inst )
      `RV2ISA_INST_CSRR  : $sformat( disasm, "csrr   %s, %s  ",        rd_str,  csr_str );
      `RV2ISA_INST_CSRW  : $sformat( disasm, "csrw   %s, %s  ",        csr_str, rs1_str );
      `RV2ISA_INST_NOP   : $sformat( disasm, "nop                    " );
      `RV2ISA_ZERO       : $sformat( disasm, "                       " );

      `RV2ISA_INST_ADD   : $sformat( disasm, "add    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SUB   : $sformat( disasm, "sub    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_AND   : $sformat( disasm, "and    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_OR    : $sformat( disasm, "or     %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_XOR   : $sformat( disasm, "xor    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLT   : $sformat( disasm, "slt    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLTU  : $sformat( disasm, "sltu   %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_MUL   : $sformat( disasm, "mul    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );

      `RV2ISA_INST_ADDI  : $sformat( disasm, "addi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ANDI  : $sformat( disasm, "andi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ORI   : $sformat( disasm, "ori    %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_XORI  : $sformat( disasm, "xori   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTI  : $sformat( disasm, "slti   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTIU : $sformat( disasm, "sltiu  %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );

      `RV2ISA_INST_SRA   : $sformat( disasm, "sra    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRL   : $sformat( disasm, "srl    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLL   : $sformat( disasm, "sll    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRAI  : $sformat( disasm, "srai   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRLI  : $sformat( disasm, "srli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLLI  : $sformat( disasm, "slli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );

      `RV2ISA_INST_LUI   : $sformat( disasm, "lui    %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));
      `RV2ISA_INST_AUIPC : $sformat( disasm, "auipc  %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));

      `RV2ISA_INST_LW    : $sformat( disasm, "lw     %s, 0x%x(%s) ",   rd_str,  imm_i(inst), rs1_str );
      `RV2ISA_INST_SW    : $sformat( disasm, "sw     %s, 0x%x(%s) ",   rs2_str, imm_s(inst), rs1_str );

      `RV2ISA_INST_JAL   : $sformat( disasm, "jal    %s, 0x%x   ",     rd_str, imm_j(inst) );
      `RV2ISA_INST_JALR  : $sformat( disasm, "jalr   %s, %s, 0x%x ",   rd_str, rs1_str, imm_i(inst) );

      `RV2ISA_INST_BEQ   : $sformat( disasm, "beq    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BNE   : $sformat( disasm, "bne    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLT   : $sformat( disasm, "blt    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGE   : $sformat( disasm, "bge    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLTU  : $sformat( disasm, "bltu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGEU  : $sformat( disasm, "bgeu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );

      default            : $sformat( disasm, "illegal inst           " );
    endcase

  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm Tiny
  //----------------------------------------------------------------------

  function [4*8-1:0] disasm_tiny( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    casez ( inst )
      `RV2ISA_INST_CSRR  : disasm_tiny = "csrr";
      `RV2ISA_INST_CSRW  : disasm_tiny = "csrw";
      `RV2ISA_INST_NOP   : disasm_tiny = "nop ";

      `RV2ISA_INST_ADD   : disasm_tiny = "add ";
      `RV2ISA_INST_SUB   : disasm_tiny = "sub ";
      `RV2ISA_INST_AND   : disasm_tiny = "and ";
      `RV2ISA_INST_OR    : disasm_tiny = "or  ";
      `RV2ISA_INST_XOR   : disasm_tiny = "xor ";
      `RV2ISA_INST_SLT   : disasm_tiny = "slt ";
      `RV2ISA_INST_SLTU  : disasm_tiny = "sltu";
      `RV2ISA_INST_MUL   : disasm_tiny = "mul ";

      `RV2ISA_INST_ADDI  : disasm_tiny = "addi";
      `RV2ISA_INST_ANDI  : disasm_tiny = "andi";
      `RV2ISA_INST_ORI   : disasm_tiny = "ori ";
      `RV2ISA_INST_XORI  : disasm_tiny = "xori";
      `RV2ISA_INST_SLTI  : disasm_tiny = "slti";
      `RV2ISA_INST_SLTIU : disasm_tiny = "sltI";

      `RV2ISA_INST_SRA   : disasm_tiny = "sra ";
      `RV2ISA_INST_SRL   : disasm_tiny = "srl ";
      `RV2ISA_INST_SLL   : disasm_tiny = "sll ";
      `RV2ISA_INST_SRAI  : disasm_tiny = "srai";
      `RV2ISA_INST_SRLI  : disasm_tiny = "srli";
      `RV2ISA_INST_SLLI  : disasm_tiny = "slli";

      `RV2ISA_INST_LUI   : disasm_tiny = "lui ";
      `RV2ISA_INST_AUIPC : disasm_tiny = "auiP";

      `RV2ISA_INST_LW    : disasm_tiny = "lw  ";
      `RV2ISA_INST_SW    : disasm_tiny = "sw  ";

      `RV2ISA_INST_JAL   : disasm_tiny = "jal ";
      `RV2ISA_INST_JALR  : disasm_tiny = "jalr";

      `RV2ISA_INST_BEQ   : disasm_tiny = "beq ";
      `RV2ISA_INST_BNE   : disasm_tiny = "bne ";
      `RV2ISA_INST_BLT   : disasm_tiny = "blt ";
      `RV2ISA_INST_BGE   : disasm_tiny = "bge ";
      `RV2ISA_INST_BLTU  : disasm_tiny = "bltu";
      `RV2ISA_INST_BGEU  : disasm_tiny = "bgeu";

      default            : disasm_tiny = "????";
    endcase

  end
  endfunction

endmodule

//------------------------------------------------------------------------
// Unpack instruction
//------------------------------------------------------------------------

module rv2isa_InstUnpack
(
  // Packed message

  input  [`RV2ISA_INST_NBITS-1:0]        inst,

  // Packed fields

  output [`RV2ISA_INST_OPCODE_NBITS-1:0] opcode,
  output [`RV2ISA_INST_RD_NBITS-1:0]     rd,
  output [`RV2ISA_INST_RS1_NBITS-1:0]    rs1,
  output [`RV2ISA_INST_RS2_NBITS-1:0]    rs2,
  output [`RV2ISA_INST_FUNCT3_NBITS-1:0] funct3,
  output [`RV2ISA_INST_FUNCT7_NBITS-1:0] funct7,
  output [`RV2ISA_INST_CSR_NBITS-1:0]    csr
);

  assign opcode   = inst[`RV2ISA_INST_OPCODE];
  assign rd       = inst[`RV2ISA_INST_RD];
  assign rs1      = inst[`RV2ISA_INST_RS1];
  assign rs2      = inst[`RV2ISA_INST_RS2];
  assign funct3   = inst[`RV2ISA_INST_FUNCT3];
  assign csr      = inst[`RV2ISA_INST_CSR];

endmodule

//------------------------------------------------------------------------
// Convert message to string
//------------------------------------------------------------------------

module rv2isa_InstTrace
(
  input                          clk,
  input                          reset,
  input [`RV2ISA_INST_NBITS-1:0] inst
);

  rv2isa_InstTasks rv2isa();

  `VC_TRACE_BEGIN
  begin
    vc_trace.append_str( trace_str, rv2isa.disasm( inst ) );
    vc_trace.append_str( trace_str, " | " );
    vc_trace.append_str( trace_str, rv2isa.disasm_tiny( inst ) );
  end
  `VC_TRACE_END

endmodule

`endif /* TINY_RV2_INST_V */


`line 13 "lab2_proc/ProcAltVRTL.v" 0
`line 1 "lab2_proc/ProcAltCtrlVRTL.v" 0
//=========================================================================
// 5-Stage Stalling Pipelined Processor Control
//=========================================================================

`ifndef LAB2_PROC_PIPELINED_PROC_ALT_CTRL_V
`define LAB2_PROC_PIPELINED_PROC_ALT_CTRL_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 9 "lab2_proc/ProcAltCtrlVRTL.v" 0

`line 1 "lab2_proc/TinyRV2InstVRTL.v" 0
//========================================================================
// TinyRV2 Instruction Type
//========================================================================
// Instruction types are similar to message types but are strictly used
// for communication within a TinyRV2-based processor. Instruction
// "messages" can be unpacked into the various fields as defined by the
// TinyRV2 ISA, as well as be constructed from specifying each field
// explicitly. The 32-bit instruction has different fields depending on
// the format of the instruction used. The following are the various
// instruction encoding formats used in the TinyRV2 ISA.
//
//  31          25 24   20 19   15 14    12 11          7 6      0
// | funct7       | rs2   | rs1   | funct3 | rd          | opcode |  R-type
// | imm[11:0]            | rs1   | funct3 | rd          | opcode |  I-type, I-imm
// | imm[11:5]    | rs2   | rs1   | funct3 | imm[4:0]    | opcode |  S-type, S-imm
// | imm[12|10:5] | rs2   | rs1   | funct3 | imm[4:1|11] | opcode |  SB-type,B-imm
// | imm[31:12]                            | rd          | opcode |  U-type, U-imm
// | imm[20|10:1|11|19:12]                 | rd          | opcode |  UJ-type,J-imm

`ifndef TINY_RV2_INST_V
`define TINY_RV2_INST_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 24 "lab2_proc/TinyRV2InstVRTL.v" 0

//------------------------------------------------------------------------
// Instruction fields
//------------------------------------------------------------------------

`define RV2ISA_INST_OPCODE  6:0
`define RV2ISA_INST_RD      11:7
`define RV2ISA_INST_RS1     19:15
`define RV2ISA_INST_RS2     24:20
`define RV2ISA_INST_FUNCT3  14:12
`define RV2ISA_INST_FUNCT7  31:25
`define RV2ISA_INST_CSR     31:20

//------------------------------------------------------------------------
// Field sizes
//------------------------------------------------------------------------

`define RV2ISA_INST_NBITS          32
`define RV2ISA_INST_OPCODE_NBITS   7
`define RV2ISA_INST_RD_NBITS       5
`define RV2ISA_INST_RS1_NBITS      5
`define RV2ISA_INST_RS2_NBITS      5
`define RV2ISA_INST_FUNCT3_NBITS   3
`define RV2ISA_INST_FUNCT7_NBITS   7
`define RV2ISA_INST_CSR_NBITS      12

//------------------------------------------------------------------------
// Instruction opcodes
//------------------------------------------------------------------------

// Basic instructions

`define RV2ISA_INST_CSRR  32'b???????_?????_?????_010_?????_1110011
`define RV2ISA_INST_CSRW  32'b???????_?????_?????_001_?????_1110011
`define RV2ISA_INST_NOP   32'b0000000_00000_00000_000_00000_0010011
`define RV2ISA_ZERO       32'b0000000_00000_00000_000_00000_0000000

// Register-register arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADD   32'b0000000_?????_?????_000_?????_0110011
`define RV2ISA_INST_SUB   32'b0100000_?????_?????_000_?????_0110011
`define RV2ISA_INST_AND   32'b0000000_?????_?????_111_?????_0110011
`define RV2ISA_INST_OR    32'b0000000_?????_?????_110_?????_0110011
`define RV2ISA_INST_XOR   32'b0000000_?????_?????_100_?????_0110011
`define RV2ISA_INST_SLT   32'b0000000_?????_?????_010_?????_0110011
`define RV2ISA_INST_SLTU  32'b0000000_?????_?????_011_?????_0110011
`define RV2ISA_INST_MUL   32'b0000001_?????_?????_000_?????_0110011

// Register-immediate arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADDI  32'b???????_?????_?????_000_?????_0010011
`define RV2ISA_INST_ANDI  32'b???????_?????_?????_111_?????_0010011
`define RV2ISA_INST_ORI   32'b???????_?????_?????_110_?????_0010011
`define RV2ISA_INST_XORI  32'b???????_?????_?????_100_?????_0010011
`define RV2ISA_INST_SLTI  32'b???????_?????_?????_010_?????_0010011
`define RV2ISA_INST_SLTIU 32'b???????_?????_?????_011_?????_0010011

// Shift instructions

`define RV2ISA_INST_SRA   32'b0100000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SRL   32'b0000000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SLL   32'b0000000_?????_?????_001_?????_0110011
`define RV2ISA_INST_SRAI  32'b0100000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SRLI  32'b0000000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SLLI  32'b0000000_?????_?????_001_?????_0010011

// Other instructions

`define RV2ISA_INST_LUI   32'b???????_?????_?????_???_?????_0110111
`define RV2ISA_INST_AUIPC 32'b???????_?????_?????_???_?????_0010111

// Memory instructions

`define RV2ISA_INST_LW    32'b???????_?????_?????_010_?????_0000011
`define RV2ISA_INST_SW    32'b???????_?????_?????_010_?????_0100011

// Unconditional jump instructions

`define RV2ISA_INST_JAL   32'b???????_?????_?????_???_?????_1101111
`define RV2ISA_INST_JALR  32'b???????_?????_?????_000_?????_1100111

// Conditional branch instructions

`define RV2ISA_INST_BEQ   32'b???????_?????_?????_000_?????_1100011
`define RV2ISA_INST_BNE   32'b???????_?????_?????_001_?????_1100011
`define RV2ISA_INST_BLT   32'b???????_?????_?????_100_?????_1100011
`define RV2ISA_INST_BGE   32'b???????_?????_?????_101_?????_1100011
`define RV2ISA_INST_BLTU  32'b???????_?????_?????_110_?????_1100011
`define RV2ISA_INST_BGEU  32'b???????_?????_?????_111_?????_1100011

//------------------------------------------------------------------------
// Coprocessor registers
//------------------------------------------------------------------------

`define RV2ISA_CPR_PROC2MNGR  12'h7C0
`define RV2ISA_CPR_MNGR2PROC  12'hFC0
`define RV2ISA_CPR_COREID     12'hF14
`define RV2ISA_CPR_NUMCORES   12'hFC1
`define RV2ISA_CPR_STATS_EN   12'h7C1

//------------------------------------------------------------------------
// Helper Tasks
//------------------------------------------------------------------------

module rv2isa_InstTasks();

  //----------------------------------------------------------------------
  // Immediate decoding -- only outputs signals at the width required for
  // line tracing
  //----------------------------------------------------------------------
  function [11:0] imm_i( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate
    imm_i = { inst[31], inst[30:25], inst[24:21], inst[20] };
  end
  endfunction

  function [4:0] imm_shamt( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate, specialized for shift amounts
    imm_shamt = { inst[24:21], inst[20] };
  end
  endfunction

  function [11:0] imm_s( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // S-type immediate
    imm_s = { inst[31], inst[30:25], inst[11:8], inst[7] };
  end
  endfunction

  function [12:0] imm_b( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // B-type immediate
    imm_b = { inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };
  end
  endfunction

  function [19:0] imm_u_sh12( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // U-type immediate, shifted right by 12
    imm_u_sh12 = { inst[31], inst[30:20], inst[19:12] };
  end
  endfunction

  function [20:0] imm_j( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // J-type immediate
    imm_j = { inst[31], inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm
  //----------------------------------------------------------------------

  reg [3*8-1:0]                     rs1_str;
  reg [3*8-1:0]                     rs2_str;
  reg [3*8-1:0]                     rd_str;
  reg [9*8-1:0]                     csr_str;

  logic [`RV2ISA_INST_RS1_NBITS-1:0] rs1;
  logic [`RV2ISA_INST_RS2_NBITS-1:0] rs2;
  logic [`RV2ISA_INST_RD_NBITS-1:0]  rd;
  logic [`RV2ISA_INST_CSR_NBITS-1:0] csr;

  function [25*8-1:0] disasm( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    // Unpack the fields

    rs1      = inst[`RV2ISA_INST_RS1];
    rs2      = inst[`RV2ISA_INST_RS2];
    rd       = inst[`RV2ISA_INST_RD];
    csr      = inst[`RV2ISA_INST_CSR];

    // Create fixed-width register specifiers

    if ( rs1 <= 9 )
      $sformat( rs1_str, "x0%0d", rs1 );
    else
      $sformat( rs1_str, "x%d",  rs1 );

    if ( rs2 <= 9 )
      $sformat( rs2_str, "x0%0d", rs2 );
    else
      $sformat( rs2_str, "x%d",  rs2 );

    if ( rd <= 9 )
      $sformat( rd_str, "x0%0d", rd );
    else
      $sformat( rd_str, "x%d",  rd );

    // if ( csr == `RV2ISA_CPR_PROC2MNGR )
      // $sformat( csr_str, "proc2mngr" );
    // else if ( csr == `RV2ISA_CPR_MNGR2PROC )
      // $sformat( csr_str, "mngr2proc" );
    // else if ( csr == `RV2ISA_CPR_COREID )
      // $sformat( csr_str, "coreid   " );
    // else if ( csr == `RV2ISA_CPR_NUMCORES )
      // $sformat( csr_str, "numcores " );
    // else if ( csr == `RV2ISA_CPR_STATS_EN )
      // $sformat( csr_str, "stats_en " );
    // else
    $sformat( csr_str, "    0x%x", csr );

    // Actual disassembly

    casez ( inst )
      `RV2ISA_INST_CSRR  : $sformat( disasm, "csrr   %s, %s  ",        rd_str,  csr_str );
      `RV2ISA_INST_CSRW  : $sformat( disasm, "csrw   %s, %s  ",        csr_str, rs1_str );
      `RV2ISA_INST_NOP   : $sformat( disasm, "nop                    " );
      `RV2ISA_ZERO       : $sformat( disasm, "                       " );

      `RV2ISA_INST_ADD   : $sformat( disasm, "add    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SUB   : $sformat( disasm, "sub    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_AND   : $sformat( disasm, "and    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_OR    : $sformat( disasm, "or     %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_XOR   : $sformat( disasm, "xor    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLT   : $sformat( disasm, "slt    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLTU  : $sformat( disasm, "sltu   %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_MUL   : $sformat( disasm, "mul    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );

      `RV2ISA_INST_ADDI  : $sformat( disasm, "addi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ANDI  : $sformat( disasm, "andi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ORI   : $sformat( disasm, "ori    %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_XORI  : $sformat( disasm, "xori   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTI  : $sformat( disasm, "slti   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTIU : $sformat( disasm, "sltiu  %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );

      `RV2ISA_INST_SRA   : $sformat( disasm, "sra    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRL   : $sformat( disasm, "srl    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLL   : $sformat( disasm, "sll    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRAI  : $sformat( disasm, "srai   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRLI  : $sformat( disasm, "srli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLLI  : $sformat( disasm, "slli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );

      `RV2ISA_INST_LUI   : $sformat( disasm, "lui    %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));
      `RV2ISA_INST_AUIPC : $sformat( disasm, "auipc  %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));

      `RV2ISA_INST_LW    : $sformat( disasm, "lw     %s, 0x%x(%s) ",   rd_str,  imm_i(inst), rs1_str );
      `RV2ISA_INST_SW    : $sformat( disasm, "sw     %s, 0x%x(%s) ",   rs2_str, imm_s(inst), rs1_str );

      `RV2ISA_INST_JAL   : $sformat( disasm, "jal    %s, 0x%x   ",     rd_str, imm_j(inst) );
      `RV2ISA_INST_JALR  : $sformat( disasm, "jalr   %s, %s, 0x%x ",   rd_str, rs1_str, imm_i(inst) );

      `RV2ISA_INST_BEQ   : $sformat( disasm, "beq    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BNE   : $sformat( disasm, "bne    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLT   : $sformat( disasm, "blt    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGE   : $sformat( disasm, "bge    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLTU  : $sformat( disasm, "bltu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGEU  : $sformat( disasm, "bgeu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );

      default            : $sformat( disasm, "illegal inst           " );
    endcase

  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm Tiny
  //----------------------------------------------------------------------

  function [4*8-1:0] disasm_tiny( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    casez ( inst )
      `RV2ISA_INST_CSRR  : disasm_tiny = "csrr";
      `RV2ISA_INST_CSRW  : disasm_tiny = "csrw";
      `RV2ISA_INST_NOP   : disasm_tiny = "nop ";

      `RV2ISA_INST_ADD   : disasm_tiny = "add ";
      `RV2ISA_INST_SUB   : disasm_tiny = "sub ";
      `RV2ISA_INST_AND   : disasm_tiny = "and ";
      `RV2ISA_INST_OR    : disasm_tiny = "or  ";
      `RV2ISA_INST_XOR   : disasm_tiny = "xor ";
      `RV2ISA_INST_SLT   : disasm_tiny = "slt ";
      `RV2ISA_INST_SLTU  : disasm_tiny = "sltu";
      `RV2ISA_INST_MUL   : disasm_tiny = "mul ";

      `RV2ISA_INST_ADDI  : disasm_tiny = "addi";
      `RV2ISA_INST_ANDI  : disasm_tiny = "andi";
      `RV2ISA_INST_ORI   : disasm_tiny = "ori ";
      `RV2ISA_INST_XORI  : disasm_tiny = "xori";
      `RV2ISA_INST_SLTI  : disasm_tiny = "slti";
      `RV2ISA_INST_SLTIU : disasm_tiny = "sltI";

      `RV2ISA_INST_SRA   : disasm_tiny = "sra ";
      `RV2ISA_INST_SRL   : disasm_tiny = "srl ";
      `RV2ISA_INST_SLL   : disasm_tiny = "sll ";
      `RV2ISA_INST_SRAI  : disasm_tiny = "srai";
      `RV2ISA_INST_SRLI  : disasm_tiny = "srli";
      `RV2ISA_INST_SLLI  : disasm_tiny = "slli";

      `RV2ISA_INST_LUI   : disasm_tiny = "lui ";
      `RV2ISA_INST_AUIPC : disasm_tiny = "auiP";

      `RV2ISA_INST_LW    : disasm_tiny = "lw  ";
      `RV2ISA_INST_SW    : disasm_tiny = "sw  ";

      `RV2ISA_INST_JAL   : disasm_tiny = "jal ";
      `RV2ISA_INST_JALR  : disasm_tiny = "jalr";

      `RV2ISA_INST_BEQ   : disasm_tiny = "beq ";
      `RV2ISA_INST_BNE   : disasm_tiny = "bne ";
      `RV2ISA_INST_BLT   : disasm_tiny = "blt ";
      `RV2ISA_INST_BGE   : disasm_tiny = "bge ";
      `RV2ISA_INST_BLTU  : disasm_tiny = "bltu";
      `RV2ISA_INST_BGEU  : disasm_tiny = "bgeu";

      default            : disasm_tiny = "????";
    endcase

  end
  endfunction

endmodule

//------------------------------------------------------------------------
// Unpack instruction
//------------------------------------------------------------------------

module rv2isa_InstUnpack
(
  // Packed message

  input  [`RV2ISA_INST_NBITS-1:0]        inst,

  // Packed fields

  output [`RV2ISA_INST_OPCODE_NBITS-1:0] opcode,
  output [`RV2ISA_INST_RD_NBITS-1:0]     rd,
  output [`RV2ISA_INST_RS1_NBITS-1:0]    rs1,
  output [`RV2ISA_INST_RS2_NBITS-1:0]    rs2,
  output [`RV2ISA_INST_FUNCT3_NBITS-1:0] funct3,
  output [`RV2ISA_INST_FUNCT7_NBITS-1:0] funct7,
  output [`RV2ISA_INST_CSR_NBITS-1:0]    csr
);

  assign opcode   = inst[`RV2ISA_INST_OPCODE];
  assign rd       = inst[`RV2ISA_INST_RD];
  assign rs1      = inst[`RV2ISA_INST_RS1];
  assign rs2      = inst[`RV2ISA_INST_RS2];
  assign funct3   = inst[`RV2ISA_INST_FUNCT3];
  assign csr      = inst[`RV2ISA_INST_CSR];

endmodule

//------------------------------------------------------------------------
// Convert message to string
//------------------------------------------------------------------------

module rv2isa_InstTrace
(
  input                          clk,
  input                          reset,
  input [`RV2ISA_INST_NBITS-1:0] inst
);

  rv2isa_InstTasks rv2isa();

  `VC_TRACE_BEGIN
  begin
    vc_trace.append_str( trace_str, rv2isa.disasm( inst ) );
    vc_trace.append_str( trace_str, " | " );
    vc_trace.append_str( trace_str, rv2isa.disasm_tiny( inst ) );
  end
  `VC_TRACE_END

endmodule

`endif /* TINY_RV2_INST_V */


`line 11 "lab2_proc/ProcAltCtrlVRTL.v" 0

module lab2_proc_ProcAltCtrlVRTL
(
  input  logic        clk,
  input  logic        reset,

  // Instruction Memory Port

  output logic        imemreq_val,
  input  logic        imemreq_rdy,

  input  logic        imemresp_val,
  output logic        imemresp_rdy,

  output logic        imemresp_drop,

  // Data Memory Port

  output logic        dmemreq_val,
  input  logic        dmemreq_rdy,

  input  logic        dmemresp_val,
  output logic        dmemresp_rdy,

  // mngr communication port

  input  logic        mngr2proc_val,
  output logic        mngr2proc_rdy,

  output logic        proc2mngr_val,
  input  logic        proc2mngr_rdy,

  // control signals (ctrl->dpath)

  output logic        reg_en_F,
  output logic [1:0]  pc_sel_F,

  output logic        reg_en_D,
  output logic        op1_sel_D,
  output logic [1:0]  op2_sel_D,
  output logic [1:0]  csrr_sel_D,
  output logic [2:0]  imm_type_D,
  output logic        imul_req_val_D,
  // incremental design port for bypass
  output logic [1:0]  op1_byp_sel_D,
  output logic [1:0]  op2_byp_sel_D,

  output logic        reg_en_X,
  output logic [3:0]  alu_fn_X,
  output logic        imul_resp_rdy_X,
  output logic [1:0]  ex_result_sel_X,
  output logic [1:0]  dmemreq_type_X,

  output logic        reg_en_M,
  output logic        wb_result_sel_M,

  output logic        reg_en_W,
  output logic [4:0]  rf_waddr_W,
  output logic        rf_wen_W,

  // status signals (dpath->ctrl)

  input  logic [31:0] inst_D,
  input  logic        imul_req_rdy_D,
  input  logic        imul_resp_val_X,
  input  logic        br_cond_eq_X,
  input  logic        br_cond_ltu_X,
  input  logic        br_cond_lt_X,

  output logic        stats_en_wen_W,

  output logic        commit_inst

);

  //----------------------------------------------------------------------
  // Notes
  //----------------------------------------------------------------------
  // We follow this principle to organize code for each pipeline stage in
  // the control unit.  Register enable logics should always at the
  // beginning. It followed by pipeline registers. Then logic that is not
  // dependent on stall or squash signals. Then logic that is dependent
  // on stall or squash signals. At the end there should be signals meant
  // to be passed to the next stage in the pipeline.

  //----------------------------------------------------------------------
  // Valid, stall, and squash signals
  // ----------------------------------------------------------------------
  // We use valid signal to indicate if the instruction is valid.  An
  // instruction can become invalid because of being squashed or
  // stalled. Notice that invalid instructions are microarchitectural
  // events, they are different from archtectural no-ops. We must be
  // careful about control signals that might change the state of the
  // processor. We should always AND outgoing control signals with valid
  // signal.

  logic val_F;
  logic val_D;
  logic val_X;
  logic val_M;
  logic val_W;

  // Managing the stall and squash signals is one of the most important,
  // yet also one of the most complex, aspects of designing a pipelined
  // processor. We will carefully use four signals per stage to manage
  // stalling and squashing: ostall_A, osquash_A, stall_A, and squash_A.
  //
  // We denote the stall signals _originating_ from stage A as
  // ostall_A. For example, if stage A can stall due to a pipeline
  // harzard, then ostall_A would need to factor in the stalling
  // condition for this pipeline harzard.

  logic ostall_F;  // can ostall due to imemresp_val
  logic ostall_D;  // can ostall due to mngr2proc_val or other hazards
  logic ostall_X;  // can ostall due to dmemreq_rdy
  logic ostall_M;  // can ostall due to dmemresp_val
  logic ostall_W;  // can ostall due to proc2mngr_rdy

  // The stall_A signal should be used to indicate when stage A is indeed
  // stalling. stall_A will be a function of ostall_A and all the ostall
  // signals of stages in front of it in the pipeline.

  logic stall_F;
  logic stall_D;
  logic stall_X;
  logic stall_M;
  logic stall_W;

  // We denote the squash signals _originating_ from stage A as
  // osquash_A. For example, if stage A needs to squash the stages behind
  // A in the pipeline, then osquash_A would need to factor in this
  // squash condition.

  logic osquash_D; // can osquash due to unconditional jumps
  logic osquash_X; // can osquash due to taken branches

  // The squash_A signal should be used to indicate when stage A is being
  // squashed. squash_A will _not_ be a function of osquash_A, since
  // osquash_A means to squash the stages _behind_ A in the pipeline, but
  // not to squash A itself.

  logic squash_F;
  logic squash_D;

  //----------------------------------------------------------------------
  // F stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_F = !stall_F || squash_F;

  // Pipeline registers

  always_ff @( posedge clk ) begin
    if ( reset )
      val_F <= 1'b0;
    else if ( reg_en_F )
      val_F <= 1'b1;
  end

  // forward declaration for PC sel

  logic       pc_redirect_X;
  logic       pc_redirect_D;
  logic [1:0] pc_sel_X;

  // PC select logic

  always_comb begin
    if ( pc_redirect_X )       // If a branch is taken in X stage
      pc_sel_F = pc_sel_X;     // Use pc from X
    else if ( pc_redirect_D )
      pc_sel_F = 2'd2;         // Use jal target from D
    else
      pc_sel_F = 2'd3;         // Use pc+4
  end

  // ostall due to the imem response not valid.

  assign ostall_F = val_F && !imemresp_val;

  // stall and squash in F

  assign stall_F  = val_F && ( ostall_F  || ostall_D || ostall_X || ostall_M || ostall_W );
  assign squash_F = val_F && ( osquash_D || osquash_X );

  // We drop the mem response when we are getting squashed

  assign imemresp_drop = squash_F;

  // imem is very special. Actually imem requests are sent before the F
  // stage. Note that we need to factor in reset to the imemreq_val
  // signal because we don't want to send out imem request when we are
  // resetting.

  assign imemreq_val  = ( !stall_F || squash_F ) && !reset;
  assign imemresp_rdy = !stall_F || squash_F;

  // Valid signal for the next stage (stage D)

  logic  next_val_F;
  assign next_val_F = val_F && !stall_F && !squash_F;

  //----------------------------------------------------------------------
  // D stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_D = !stall_D || squash_D;

  // Pipline registers

  always_ff @( posedge clk ) begin
    if ( reset )
      val_D <= 1'b0;
    else if ( reg_en_D )
      val_D <= next_val_F;
  end
  
  // jal logic, redirect PC in F 

  always_comb begin
    pc_redirect_D = (val_D && (j_type_D == j_l));
  end

  // Parse instruction fields

  logic   [4:0]  inst_rd_D;
  logic   [4:0]  inst_rs1_D;
  logic   [4:0]  inst_rs2_D;
  logic   [11:0] inst_csr_D;

  rv2isa_InstUnpack inst_unpack
  (
    .inst     (inst_D),
    .opcode   (),
    .rd       (inst_rd_D),
    .rs1      (inst_rs1_D),
    .rs2      (inst_rs2_D),
    .funct3   (),
    .funct7   (),
    .csr      (inst_csr_D)
  );

  // Generic Parameters -- yes or no

  localparam n = 1'd0;
  localparam y = 1'd1;

  // Register specifiers

  localparam rx = 5'bx;   // don't care
  localparam r0 = 5'd0;   // zero
  localparam rL = 5'd31;  // for jal

  // Unconditional Jump type
  localparam j_x  = 2'dx;   // don't care
  localparam j_na = 2'd0;   // no jump
  localparam j_l  = 2'd1;   // jal
  localparam j_lr = 2'd2;   // jalr
  
  // Branch type

  localparam br_x     = 3'bx; // Don't care
  localparam br_na    = 3'd0; // No branch
  localparam br_bne   = 3'd1; // bne
  localparam br_beq   = 3'd2; // beq
  localparam br_blt   = 3'd3; // blt
  localparam br_bge   = 3'd4; // bge
  localparam br_bltu  = 3'd5; // bltu
  localparam br_bgeu  = 3'd6; // bgeu
  
  // Operand 1 Mux Select
  localparam am_x     = 1'bx; // Don't care
  localparam am_pc    = 1'd0; // from the pc
  localparam am_rf    = 1'd1; // from the register file

  // Operand 2 Mux Select

  localparam bm_x     = 2'bx; // Don't care
  localparam bm_imm   = 2'd0; // Use sign-extended immediate
  localparam bm_rf    = 2'd1; // Use data from register file
  localparam bm_csr   = 2'd2; // Use from mngr data

  // ALU Function

  localparam alu_x     = 4'bx;
  localparam alu_add   = 4'd0;
  localparam alu_sub   = 4'd1;
  localparam alu_and   = 4'd2;
  localparam alu_or    = 4'd3;
  localparam alu_xor   = 4'd4;
  localparam alu_slt   = 4'd5;
  localparam alu_sltu  = 4'd6;
  localparam alu_sra   = 4'd7;
  localparam alu_srl   = 4'd8;
  localparam alu_sll   = 4'd9;
  localparam alu_lui   = 4'd10;
  localparam alu_cp0   = 4'd11;
  localparam alu_cp1   = 4'd12;
  localparam alu_aupic = 4'd13;
  localparam alu_cmp   = 4'd14;
  localparam alu_jalr  = 4'd15;

  // Immediate Type
  localparam imm_x    = 3'bx;
  localparam imm_i    = 3'd0;
  localparam imm_s    = 3'd1;
  localparam imm_b    = 3'd2;
  localparam imm_u    = 3'd3;
  localparam imm_j    = 3'd4;

  // Memory Request Type

  localparam ld       = 2'd0; // Load
  localparam sw       = 2'd1; // Store
  localparam nr       = 2'd2; // No request
  
  // Execution Result Type
  localparam ex_p     = 2'd0; // pc+4
  localparam ex_a     = 2'd1; // alu
  localparam ex_m     = 2'd2; // multiplier
  localparam ex_x     = 2'dx; // don't care

  // Writeback Mux Select

  localparam wm_x     = 1'bx; // Don't care
  localparam wm_a     = 1'b0; // Use ALU output
  localparam wm_m     = 1'b1; // Use data memory response

  // Instruction Decode

  logic       inst_val_D;
  logic [2:0] br_type_D;
  logic [1:0] j_type_D;
  logic       rs1_en_D;
  logic       rs2_en_D;
  logic [3:0] alu_fn_D;
  logic [1:0] dmemreq_type_D;
  logic [1:0] ex_result_sel_D;
  logic       wb_result_sel_D;
  logic       rf_wen_pending_D;
  logic       csrr_D;
  logic       csrw_D;
  logic       proc2mngr_val_D;
  logic       mngr2proc_rdy_D;
  logic       stats_en_wen_D;
  logic       inst_mul_D;
  
  task cs
  (
    input logic       cs_inst_val,
    input logic [2:0] cs_br_type,
    input logic [1:0] cs_j_type,
    input logic [2:0] cs_imm_type,
    input logic       cs_op1_sel,
    input logic       cs_rs1_en,
    input logic [1:0] cs_op2_sel,
    input logic       cs_rs2_en,
    input logic [3:0] cs_alu_fn,
    input logic       cs_inst_mul_D,
    input logic       cs_imul_req_val,
    input logic [1:0] cs_dmemreq_type,
    input logic [1:0] cs_ex_result_sel,
    input logic       cs_wb_result_sel,
    input logic       cs_rf_wen_pending,
    input logic       cs_csrr,
    input logic       cs_csrw
  );
  begin
    inst_val_D            = cs_inst_val;
    br_type_D             = cs_br_type;
    j_type_D              = cs_j_type;
    imm_type_D            = cs_imm_type;
    op1_sel_D             = cs_op1_sel;
    rs1_en_D              = cs_rs1_en;
    op2_sel_D             = cs_op2_sel;
    rs2_en_D              = cs_rs2_en;
    alu_fn_D              = cs_alu_fn;
    inst_mul_D            = cs_inst_mul_D;
    imul_req_val_D        = cs_imul_req_val && val_D && (!stall_D);
    dmemreq_type_D        = cs_dmemreq_type;
    ex_result_sel_D       = cs_ex_result_sel;
    wb_result_sel_D       = cs_wb_result_sel;
    rf_wen_pending_D      = cs_rf_wen_pending;
    csrr_D                = cs_csrr;
    csrw_D                = cs_csrw;
  end
  endtask

  // Control signals table

  always_comb begin

    casez ( inst_D )

      //                           br       jmp   imm    op1     rs1  op2     rs2   alu       inst   imul     dmm ex res  wbmux rf
      //                       val type     typ   type   muxsel  en   muxsel  en    fn        mul    req val  typ sel     sel   wen csrr csrw
      `RV2ISA_INST_NOP     :cs( y, br_na,   j_na, imm_x, am_x,   n,   bm_x,   n,    alu_x,    n,     n,       nr, ex_x,   wm_a, n,  n,   n    );
      `RV2ISA_INST_ADD     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_add,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_ADDI    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_add,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SUB     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_sub,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_MUL     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_x,    y,     y,       nr, ex_m,   wm_a, y,  n,   n    );
      `RV2ISA_INST_AND     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_and,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_ANDI    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_and,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_OR      :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_or,   n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_ORI     :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_or,   n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_XOR     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_xor,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_XORI    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_xor,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SLT     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_slt,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SLTI    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_slt,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SLTU    :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_sltu, n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SLTIU   :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_sltu, n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SRA     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_sra,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SRAI    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_sra,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SRL     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_srl,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SRLI    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_srl,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SLL     :cs( y, br_na,   j_na, imm_x, am_rf,  y,   bm_rf,  y,    alu_sll,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_SLLI    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_sll,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_LUI     :cs( y, br_na,   j_na, imm_u, am_rf,  n,   bm_imm, n,    alu_cp1,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_AUIPC   :cs( y, br_na,   j_na, imm_u, am_pc,  n,   bm_imm, n,    alu_add,  n,     n,       nr, ex_a,   wm_a, y,  n,   n    );
      `RV2ISA_INST_LW      :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_imm, n,    alu_add,  n,     n,       ld, ex_x,   wm_m, y,  n,   n    );
      `RV2ISA_INST_SW      :cs( y, br_na,   j_na, imm_s, am_rf,  y,   bm_imm, y,    alu_add,  n,     n,       sw, ex_x,   wm_x, n,  n,   n    );
      `RV2ISA_INST_JAL     :cs( y, br_na,   j_l,  imm_j, am_x,   n,   bm_x,   n,    alu_x,    n,     n,       nr, ex_p,   wm_a, y,  n,   n    );
      `RV2ISA_INST_JALR    :cs( y, br_na,   j_lr, imm_i, am_rf,  y,   bm_imm, n,    alu_jalr, n,     n,       nr, ex_p,   wm_a, y,  n,   n    );
      `RV2ISA_INST_BEQ     :cs( y, br_beq,  j_na, imm_b, am_rf,  y,   bm_rf,  y,    alu_cmp,  n,     n,       nr, ex_x,   wm_a, n,  n,   n    );
      `RV2ISA_INST_BNE     :cs( y, br_bne,  j_na, imm_b, am_rf,  y,   bm_rf,  y,    alu_cmp,  n,     n,       nr, ex_x,   wm_a, n,  n,   n    );
      `RV2ISA_INST_BLT     :cs( y, br_blt,  j_na, imm_b, am_rf,  y,   bm_rf,  y,    alu_slt,  n,     n,       nr, ex_x,   wm_a, n,  n,   n    );
      `RV2ISA_INST_BGE     :cs( y, br_bge,  j_na, imm_b, am_rf,  y,   bm_rf,  y,    alu_slt,  n,     n,       nr, ex_x,   wm_a, n,  n,   n    );
      `RV2ISA_INST_BLTU    :cs( y, br_bltu, j_na, imm_b, am_rf,  y,   bm_rf,  y,    alu_sltu, n,     n,       nr, ex_x,   wm_a, n,  n,   n    );
      `RV2ISA_INST_BGEU    :cs( y, br_bgeu, j_na, imm_b, am_rf,  y,   bm_rf,  y,    alu_sltu, n,     n,       nr, ex_x,   wm_a, n,  n,   n    );
      `RV2ISA_INST_CSRR    :cs( y, br_na,   j_na, imm_i, am_x,   n,   bm_csr, n,    alu_cp1,  n,     n,       nr, ex_a,   wm_a, y,  y,   n    );
      `RV2ISA_INST_CSRW    :cs( y, br_na,   j_na, imm_i, am_rf,  y,   bm_x,   n,    alu_cp0,  n,     n,       nr, ex_a,   wm_a, n,  n,   y    );
      default              :cs( n, br_x,    j_na, imm_x, am_x,   n,   bm_x,   n,    alu_x,    n,     n,       nr, ex_a,   wm_x, n,  n,   n    );
    endcase
  end // always_comb

  logic [4:0] rf_waddr_D;
  assign rf_waddr_D = inst_rd_D;

  // csrr and csrw logic

  always_comb begin
    proc2mngr_val_D  = 1'b0;
    mngr2proc_rdy_D  = 1'b0;
    csrr_sel_D       = 2'h0;
    stats_en_wen_D   = 1'b0;

    if ( csrw_D && inst_csr_D == `RV2ISA_CPR_PROC2MNGR )
      proc2mngr_val_D    = 1'b1;
    if ( csrr_D && inst_csr_D == `RV2ISA_CPR_MNGR2PROC )
      mngr2proc_rdy_D  = 1'b1;
    if ( csrw_D && inst_csr_D == `RV2ISA_CPR_STATS_EN )
      stats_en_wen_D  = 1'b1;
    if ( csrr_D && inst_csr_D == `RV2ISA_CPR_NUMCORES )
      csrr_sel_D       = 2'h1;
    if ( csrr_D && inst_csr_D == `RV2ISA_CPR_COREID )
      csrr_sel_D       = 2'h2;
  end

  // mngr2proc_rdy signal for csrr instruction

  assign mngr2proc_rdy  = val_D && !stall_D && mngr2proc_rdy_D;

  logic  ostall_mngr2proc_D;
  assign ostall_mngr2proc_D = val_D && mngr2proc_rdy_D && !mngr2proc_val;

  // ostall if write address in X matches rs1 in D
  
  logic [1:0] op_X;
  assign      op_X = dmemreq_type_X;

  logic  ostall_waddr_X_rs1_D;
  assign ostall_waddr_X_rs1_D
    = rs1_en_D && val_X && rf_wen_pending_X
      && ( inst_rs1_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && ( op_X == ld );
  // bypass signal 
  
  logic  bypass_waddr_X_rs1_D;                                                       
  assign bypass_waddr_X_rs1_D
    = rs1_en_D && val_X && rf_wen_pending_X
      && ( inst_rs1_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && ( op_X != ld );
      

  // bypass if write address in M matches rs1 in D

  logic  bypass_waddr_M_rs1_D;            
  assign bypass_waddr_M_rs1_D
    = rs1_en_D && val_M && rf_wen_pending_M
      && ( inst_rs1_D == rf_waddr_M ) && ( rf_waddr_M != 5'd0 );

  // bypass if write address in W matches rs1 in D

  logic  bypass_waddr_W_rs1_D;                                                       
  assign bypass_waddr_W_rs1_D
    = rs1_en_D && val_W && rf_wen_pending_W
      && ( inst_rs1_D == rf_waddr_W ) && ( rf_waddr_W != 5'd0 );

  // ostall if write address in X matches rs2 in D

  logic  ostall_waddr_X_rs2_D;
  assign ostall_waddr_X_rs2_D
    = rs2_en_D && val_X && rf_wen_pending_X
      && ( inst_rs2_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && ( op_X == ld );
      
  logic  bypass_waddr_X_rs2_D;                                                      
  assign bypass_waddr_X_rs2_D
    = rs1_en_D && val_X && rf_wen_pending_X
      && ( inst_rs2_D == rf_waddr_X ) && ( rf_waddr_X != 5'd0 )
      && ( op_X != ld );

  // bypass if write address in M matches rs2 in D

  logic  bypass_waddr_M_rs2_D;                                                      
  assign bypass_waddr_M_rs2_D
    = rs2_en_D && val_M && rf_wen_pending_M
      && ( inst_rs2_D == rf_waddr_M ) && ( rf_waddr_M != 5'd0 );

  // bypass if write address in W matches rs2 in D

  logic bypass_waddr_W_rs2_D;                                                       
  assign bypass_waddr_W_rs2_D
    = rs2_en_D && val_W && rf_wen_pending_W
      && ( inst_rs2_D == rf_waddr_W ) && ( rf_waddr_W != 5'd0 );

  // Put together ostall signal due to hazards
  logic ostall_imul_req_rdy_D;
  assign ostall_imul_req_rdy_D = val_D && inst_mul_D && !imul_req_rdy_D;

  logic  ostall_hazard_D;
  assign ostall_hazard_D =
      ostall_waddr_X_rs1_D || 
      ostall_waddr_X_rs2_D || 
      ostall_imul_req_rdy_D;

  // Final ostall signal

  assign ostall_D = val_D && ( ostall_mngr2proc_D || ostall_hazard_D );

  // osquash due to jump instruction in D stage

  assign osquash_D = val_D && !stall_D && (j_type_D == j_l);
  
  // stall and squash in D

  assign stall_D  = val_D && ( ostall_D || ostall_X || ostall_M || ostall_W );
  assign squash_D = val_D && osquash_X;
  
  // bypass selects
  always_comb begin
    if(bypass_waddr_X_rs1_D)     
      op1_byp_sel_D = 2'd1;
    else if (bypass_waddr_M_rs1_D)
      op1_byp_sel_D = 2'd2;
    else if (bypass_waddr_W_rs1_D)
      op1_byp_sel_D = 2'd3;
    else
      op1_byp_sel_D = 2'd0;
    
    if(bypass_waddr_X_rs2_D)
      op2_byp_sel_D = 2'd1;
    else if (bypass_waddr_M_rs2_D)
      op2_byp_sel_D = 2'd2;
    else if (bypass_waddr_W_rs2_D)
      op2_byp_sel_D = 2'd3;
    else
      op2_byp_sel_D = 2'd0;
  end

  // Valid signal for the next stage

  logic  next_val_D;
  assign next_val_D = val_D && !stall_D && !squash_D;

  //----------------------------------------------------------------------
  // X stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_X = !stall_X;

  logic [31:0] inst_X;
  logic        wb_result_sel_X;
  logic        rf_wen_pending_X;
  logic [4:0]  rf_waddr_X;
  logic        proc2mngr_val_X;
  logic        stats_en_wen_X;
  logic [2:0]  br_type_X;
  logic [1:0]  j_type_X;
  logic        inst_mul_X;
  
  // Pipeline registers

  always_ff @( posedge clk ) begin
    if (reset) begin
      val_X           <= 1'b0;
      stats_en_wen_X  <= 1'b0;
    end 
    else if (reg_en_X) begin
      val_X           <= next_val_D;
      rf_wen_pending_X<= rf_wen_pending_D;
      inst_X          <= inst_D;
      alu_fn_X        <= alu_fn_D;
      rf_waddr_X      <= rf_waddr_D;
      proc2mngr_val_X <= proc2mngr_val_D;
      dmemreq_type_X  <= dmemreq_type_D;
      ex_result_sel_X <= ex_result_sel_D;
      wb_result_sel_X <= wb_result_sel_D;
      stats_en_wen_X  <= stats_en_wen_D;
      br_type_X       <= br_type_D;
      j_type_X        <= j_type_D;
      inst_mul_X      <= inst_mul_D;
    end
  end
  // branch logic, redirect PC in F if branch is taken

  always_comb begin
    if ( val_X && ( br_type_X == br_bne )) begin
      pc_redirect_X = !br_cond_eq_X;
      pc_sel_X      = 2'd1;          // use branch target
    end 
    else if ( val_X && br_type_X == br_beq ) begin
      pc_redirect_X = br_cond_eq_X;
      pc_sel_X      = 2'd1;
    end
    else if ( val_X && br_type_X == br_blt ) begin
      pc_redirect_X = br_cond_lt_X;
      pc_sel_X      = 2'd1;
    end
    else if ( val_X && br_type_X == br_bge ) begin
      pc_redirect_X = !br_cond_lt_X;
      pc_sel_X      = 2'd1;
    end
    else if ( val_X && br_type_X == br_bltu ) begin
      pc_redirect_X = br_cond_ltu_X;
      pc_sel_X      = 2'd1;
    end
    else if ( val_X && br_type_X == br_bgeu ) begin
      pc_redirect_X = !br_cond_ltu_X;
      pc_sel_X      = 2'd1;
    end
    else if ( val_X && j_type_X == j_lr ) begin
      pc_redirect_X = 1'd1;
      pc_sel_X      = 2'd0;
    end
    else begin
      pc_redirect_X = 1'd0;
      pc_sel_X      = 2'd3;          // use pc+4
    end
  end
  
  assign imul_resp_rdy_X = val_X && inst_mul_X && (!stall_X);
  
  // ostall due to dmemreq not ready.

  assign ostall_X = val_X && ((( dmemreq_type_X != nr ) && !dmemreq_rdy) || (inst_mul_X && !imul_resp_val_X));
  
  // osquash due to jump instruction in D stage

  // osquash due to taken branch, notice we can't osquash if current
  // stage stalls, otherwise we will send osquash twice.

  assign osquash_X = val_X && !stall_X && pc_redirect_X;

  // stall and squash used in X stage

  assign stall_X = val_X && ( ostall_X || ostall_M || ostall_W );

  // set dmemreq_val only if not stalling

  assign dmemreq_val = val_X && !stall_X && ( dmemreq_type_X != nr );

  // Valid signal for the next stage

  logic  next_val_X;
  assign next_val_X = val_X && !stall_X;

  //----------------------------------------------------------------------
  // M stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_M  = !stall_M;

  logic [31:0] inst_M;
  logic [1:0]  dmemreq_type_M;
  logic        rf_wen_pending_M;
  logic [4:0]  rf_waddr_M;
  logic        proc2mngr_val_M;
  logic        stats_en_wen_M;

  // Pipeline register

  always_ff @( posedge clk )
    if (reset) begin
      val_M            <= 1'b0;
      stats_en_wen_X   <= 1'b0;
    end else if (reg_en_M) begin
      val_M            <= next_val_X;
      rf_wen_pending_M <= rf_wen_pending_X;
      inst_M           <= inst_X;
      rf_waddr_M       <= rf_waddr_X;
      proc2mngr_val_M  <= proc2mngr_val_X;
      dmemreq_type_M   <= dmemreq_type_X;
      wb_result_sel_M  <= wb_result_sel_X;
      stats_en_wen_M   <= stats_en_wen_X;
    end

  // ostall due to dmemresp not valid

  assign ostall_M = val_M && ( dmemreq_type_M != nr ) && !dmemresp_val;

  // stall M

  assign stall_M = val_M && ( ostall_M || ostall_W );

  // Set dmemresp_rdy if valid and not stalling and this is a lw/sw

  assign dmemresp_rdy = val_M && !stall_M && ( dmemreq_type_M != nr );

  // Valid signal for the next stage

  logic  next_val_M;
  assign next_val_M = val_M && !stall_M;

  //----------------------------------------------------------------------
  // W stage
  //----------------------------------------------------------------------

  // Register enable logic

  assign reg_en_W = !stall_W;

  logic [31:0] inst_W;
  logic        proc2mngr_val_W;
  logic        rf_wen_pending_W;

  // Pipeline registers

  always_ff @( posedge clk ) begin
    if (reset) begin
      val_W            <= 1'b0;
      stats_en_wen_W   <= 1'b0;
    end else if (reg_en_W) begin
      val_W            <= next_val_M;
      rf_wen_pending_W <= rf_wen_pending_M;
      inst_W           <= inst_M;
      rf_waddr_W       <= rf_waddr_M;
      proc2mngr_val_W  <= proc2mngr_val_M;
      stats_en_wen_W   <= stats_en_wen_M;
    end
  end

  // write enable

  assign rf_wen_W = val_W && rf_wen_pending_W;

  // ostall due to proc2mngr

  assign ostall_W = val_W && proc2mngr_val_W && !proc2mngr_rdy;

  // stall and squash signal used in W stage

  assign stall_W = val_W && ostall_W;

  // proc2mngr port

  assign proc2mngr_val = val_W && !stall_W && proc2mngr_val_W;

  assign commit_inst = val_W && !stall_W;

endmodule

`endif


`line 14 "lab2_proc/ProcAltVRTL.v" 0
`line 1 "lab2_proc/ProcAltDpathVRTL.v" 0
//=========================================================================
// 5-Stage Stalling Pipelined Processor Datapath
//=========================================================================

`ifndef LAB2_PROC_PIPELINED_PROC_ALT_DPATH_V
`define LAB2_PROC_PIPELINED_PROC_ALT_DPATH_V

`line 1 "vc/arithmetic.v" 0
//========================================================================
// Verilog Components: Arithmetic Components
//========================================================================

`ifndef VC_ARITHMETIC_V
`define VC_ARITHMETIC_V

//------------------------------------------------------------------------
// Adders
//------------------------------------------------------------------------

module vc_Adder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  input  logic               cin,
  output logic [p_nbits-1:0] out,
  output logic               cout
);

  // We need to convert cin into a 32-bit value to
  // avoid verilator warnings

  assign {cout,out} = in0 + in1 + {{(p_nbits-1){1'b0}},cin};

endmodule

module vc_SimpleAdder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 + in1;

endmodule

//------------------------------------------------------------------------
// Subtractor
//------------------------------------------------------------------------

module vc_Subtractor
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 - in1;

endmodule

//------------------------------------------------------------------------
// Incrementer
//------------------------------------------------------------------------

module vc_Incrementer
#(
  parameter p_nbits     = 1,
  parameter p_inc_value = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic [p_nbits-1:0] out
);

  assign out = in + p_inc_value;

endmodule

//------------------------------------------------------------------------
// ZeroExtender
//------------------------------------------------------------------------

module vc_ZeroExtender
#(
  parameter p_in_nbits  = 1,
  parameter p_out_nbits = 8
)(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {( p_out_nbits - p_in_nbits ){1'b0}}, in };

endmodule

//------------------------------------------------------------------------
// SignExtender
//------------------------------------------------------------------------

module vc_SignExtender
#(
 parameter p_in_nbits = 1,
 parameter p_out_nbits = 8
)
(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {(p_out_nbits-p_in_nbits){in[p_in_nbits-1]}}, in };

endmodule

//------------------------------------------------------------------------
// ZeroComparator
//------------------------------------------------------------------------

module vc_ZeroComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic               out
);

  assign out = ( in == {p_nbits{1'b0}} );

endmodule

//------------------------------------------------------------------------
// EqComparator
//------------------------------------------------------------------------

module vc_EqComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 == in1 );

endmodule

//------------------------------------------------------------------------
// LtComparator
//------------------------------------------------------------------------

module vc_LtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 < in1 );

endmodule

//------------------------------------------------------------------------
// GtComparator
//------------------------------------------------------------------------

module vc_GtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 > in1 );

endmodule

//------------------------------------------------------------------------
// LeftLogicalShifter
//------------------------------------------------------------------------

module vc_LeftLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1 )
(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in << shamt );

endmodule

//------------------------------------------------------------------------
// RightLogicalShifter
//------------------------------------------------------------------------

module vc_RightLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1
)(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in >> shamt );

endmodule

`endif /* VC_ARITHMETIC_V */


`line 9 "lab2_proc/ProcAltDpathVRTL.v" 0
`line 1 "vc/mem-msgs.v" 0
//========================================================================
// vc-mem-msgs : Memory Request/Response Messages
//========================================================================
// The memory request/response messages are used to interact with various
// memories. They are parameterized by the number of bits in the address,
// data, and opaque field.

`ifndef VC_MEM_MSGS_V
`define VC_MEM_MSGS_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 12 "vc/mem-msgs.v" 0

//========================================================================
// Memory Request Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// requests include an opaque field, the address, and the number of bytes
// to read, while write requests include an opaque field, the address,
// the number of bytes to write, and the actual data to write.
//
// Message Format:
//
//    3b    p_opaque_nbits  p_addr_nbits       calc   p_data_nbits
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field, address field, and data field. Note that the size of the length
// field is caclulated from the number of bits in the data field, and
// that the length field is expressed in _bytes_. If the value of the
// length field is zero, then the read or write should be for the full
// width of the data field.
//
// For example, if the opaque field is 8 bits, the address is 32 bits and
// the data is also 32 bits, then the message format is as follows:
//
//   76  74 73           66 65              34 33  32 31               0
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The length field is two bits. A length value of one means read or write
// a single byte, a length value of two means read or write two bytes, and
// so on. A length value of zero means read or write all four bytes. Note
// that not all memories will necessarily support any alignment and/or any
// value for the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [1:0]  len;
  logic [31:0] data;
} mem_req_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [3:0]  len;
  logic [127:0] data;
} mem_req_16B_t;

// memory request type values
`define VC_MEM_REQ_MSG_TYPE_READ     3'd0
`define VC_MEM_REQ_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_REQ_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_REQ_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_REQ_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_REQ_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_REQ_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Request Message: Trace message
//------------------------------------------------------------------------

module vc_MemReqMsg4BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_4B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_4B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemReqMsg16BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_16B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_16B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

//========================================================================
// Memory Response Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// responses include an opaque field, the actual data, and the number of
// bytes, while write responses currently include just the opaque field.
//
// Message Format:
//
//    3b    p_opaque_nbits   2b    calc   p_data_nbits
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field and data field. Note that the size of the length field is
// caclulated from the number of bits in the data field, and that the
// length field is expressed in _bytes_. If the value of the length field
// is zero, then the read or write should be for the full width of the
// data field.
//
// For example, if the opaque field is 8 bits and the data is 32 bits,
// then the message format is as follows:
//
//   46  44 43           36 35  34 33  32 31               0
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The length field is two bits. A length value of one means one byte was
// read, a length value of two means two bytes were read, and so on. A
// length value of zero means all four bytes were read. Note that not all
// memories will necessarily support any alignment and/or any value for
// the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [1:0]  len;
  logic [31:0] data;
} mem_resp_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [3:0]  len;
  logic [127:0] data;
} mem_resp_16B_t;

// Values for the type field

`define VC_MEM_RESP_MSG_TYPE_READ     3'd0
`define VC_MEM_RESP_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_RESP_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_RESP_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_RESP_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_RESP_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_RESP_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Response Message: Trace message
//------------------------------------------------------------------------

module vc_MemRespMsg4BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_4B_t  msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_4B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemRespMsg16BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_16B_t msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0] data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_16B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

`endif /* VC_MEM_MSGS_V */


`line 10 "lab2_proc/ProcAltDpathVRTL.v" 0
`line 1 "vc/muxes.v" 0
//========================================================================
// Verilog Components: Muxes
//========================================================================

`ifndef VC_MUXES_V
`define VC_MUXES_V

//------------------------------------------------------------------------
// 2 Input Mux
//------------------------------------------------------------------------

module vc_Mux2
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1,
  input  logic               sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      1'd0 : out = in0;
      1'd1 : out = in1;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 3 Input Mux
//------------------------------------------------------------------------

module vc_Mux3
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 4 Input Mux
//------------------------------------------------------------------------

module vc_Mux4
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      2'd3 : out = in3;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 5 Input Mux
//------------------------------------------------------------------------

module vc_Mux5
#(
 parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 6 Input Mux
//------------------------------------------------------------------------

module vc_Mux6
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 7 Input Mux
//------------------------------------------------------------------------

module vc_Mux7
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 8 Input Mux
//------------------------------------------------------------------------

module vc_Mux8
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6, in7,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      3'd7 : out = in7;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

`endif /* VC_MUXES_V */


`line 11 "lab2_proc/ProcAltDpathVRTL.v" 0
`line 1 "vc/regs.v" 0
//========================================================================
// Verilog Components: Registers
//========================================================================

// Note that we place the register output earlier in the port list since
// this is one place we might actually want to use positional port
// binding like this:
//
//  logic [p_nbits-1:0] result_B;
//  vc_Reg#(p_nbits) result_AB( clk, result_B, result_A );

`ifndef VC_REGS_V
`define VC_REGS_V

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop
//------------------------------------------------------------------------

module vc_Reg
#(
  parameter p_nbits = 1
)(
  input  logic               clk, // Clock input
  output logic [p_nbits-1:0] q,   // Data output
  input  logic [p_nbits-1:0] d    // Data input
);

  always_ff @( posedge clk )
    q <= d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with reset
//------------------------------------------------------------------------

module vc_ResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d      // Data input
);

  always_ff @( posedge clk )
    q <= reset ? p_reset_value : d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable
//------------------------------------------------------------------------

module vc_EnReg
#(
  parameter p_nbits = 1
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( en )
      q <= d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable and reset
//------------------------------------------------------------------------

module vc_EnResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( reset || en )
      q <= reset ? p_reset_value : d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

`endif /* VC_REGS_V */


`line 12 "lab2_proc/ProcAltDpathVRTL.v" 0
`line 1 "vc/regfiles.v" 0
//========================================================================
// Verilog Components: Register Files
//========================================================================

`ifndef VC_REGFILES_V
`define VC_REGFILES_V

//------------------------------------------------------------------------
// 1r1w register file
//------------------------------------------------------------------------

module vc_Regfile_1r1w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                    clk,
  input  logic                    reset,

  // Read port (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr,
  output logic [p_data_nbits-1:0] read_data,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en,
  input  logic [c_addr_nbits-1:0] write_addr,
  input  logic [p_data_nbits-1:0] write_data
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data = rfile[read_addr];

  // Write on positive clock edge

  always_ff @( posedge clk )
    if ( write_en )
      rfile[write_addr] <= write_data;

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// 1r1w register file with reset
//------------------------------------------------------------------------

module vc_ResetRegfile_1r1w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,
  parameter p_reset_value = 0,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                    clk,
  input  logic                    reset,

  // Read port (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr,
  output logic [p_data_nbits-1:0] read_data,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en,
  input  logic [c_addr_nbits-1:0] write_addr,
  input  logic [p_data_nbits-1:0] write_data
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data = rfile[read_addr];

  // Write on positive clock edge. We have to use a generate statement to
  // allow us to include the reset logic for each individual register.

  genvar i;
  generate
    for ( i = 0; i < p_num_entries; i = i+1 )
    begin : wport
      always_ff @( posedge clk )
        if ( reset )
          rfile[i] <= p_reset_value;
        else if ( write_en && (i[c_addr_nbits-1:0] == write_addr) )
          rfile[i] <= write_data;
    end
  endgenerate

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// 2r1w register file
//------------------------------------------------------------------------

module vc_Regfile_2r1w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                   clk,
  input  logic                   reset,

  // Read port 0 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr0,
  output logic [p_data_nbits-1:0] read_data0,

  // Read port 1 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr1,
  output logic [p_data_nbits-1:0] read_data1,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en,
  input  logic [c_addr_nbits-1:0] write_addr,
  input  logic [p_data_nbits-1:0] write_data
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data0 = rfile[read_addr0];
  assign read_data1 = rfile[read_addr1];

  // Write on positive clock edge

  always_ff @( posedge clk )
    if ( write_en )
      rfile[write_addr] <= write_data;

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// 2r2w register file
//------------------------------------------------------------------------

module vc_Regfile_2r2w
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                    clk,
  input  logic                    reset,

  // Read port 0 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr0,
  output logic [p_data_nbits-1:0] read_data0,

  // Read port 1 (combinational read)

  input  logic [c_addr_nbits-1:0] read_addr1,
  output logic [p_data_nbits-1:0] read_data1,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en0,
  input  logic [c_addr_nbits-1:0] write_addr0,
  input  logic [p_data_nbits-1:0] write_data0,

  // Write port (sampled on the rising clock edge)

  input  logic                    write_en1,
  input  logic [c_addr_nbits-1:0] write_addr1,
  input  logic [p_data_nbits-1:0] write_data1
);

  logic [p_data_nbits-1:0] rfile[p_num_entries-1:0];

  // Combinational read

  assign read_data0 = rfile[read_addr0];
  assign read_data1 = rfile[read_addr1];

  // Write on positive clock edge

  always_ff @( posedge clk ) begin

    if ( write_en0 )
      rfile[write_addr0] <= write_data0;

    if ( write_en1 )
      rfile[write_addr1] <= write_data1;

  end

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( write_en0 );
      `VC_ASSERT_NOT_X( write_en1 );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's.

      if ( write_en0 ) begin
        `VC_ASSERT_NOT_X( write_addr0 );
        `VC_ASSERT( write_addr0 < p_num_entries );
      end

      if ( write_en1 ) begin
        `VC_ASSERT_NOT_X( write_addr1 );
        `VC_ASSERT( write_addr1 < p_num_entries );
      end

      // It is invalid to use the same write address for both write ports

      if ( write_en0 && write_en1 ) begin
        `VC_ASSERT( write_addr0 != write_addr1 );
      end

    end
  end
  */

endmodule

//------------------------------------------------------------------------
// Register file specialized for r0 == 0
//------------------------------------------------------------------------

module vc_Regfile_2r1w_zero
(
  input  logic        clk,
  input  logic        reset,

  input  logic  [4:0] rd_addr0,
  output logic [31:0] rd_data0,

  input  logic  [4:0] rd_addr1,
  output logic [31:0] rd_data1,

  input  logic        wr_en,
  input  logic  [4:0] wr_addr,
  input  logic [31:0] wr_data
);

  // these wires are to be hooked up to the actual register file read
  // ports

  logic [31:0] rf_read_data0;
  logic [31:0] rf_read_data1;

  vc_Regfile_2r1w
  #(
    .p_data_nbits  (32),
    .p_num_entries (32)
  )
  rfile
  (
    .clk         (clk),
    .reset       (reset),
    .read_addr0  (rd_addr0),
    .read_data0  (rf_read_data0),
    .read_addr1  (rd_addr1),
    .read_data1  (rf_read_data1),
    .write_en    (wr_en),
    .write_addr  (wr_addr),
    .write_data  (wr_data)
  );

  // we pick 0 value when either read address is 0
  assign rd_data0 = ( rd_addr0 == 5'd0 ) ? 32'd0 : rf_read_data0;
  assign rd_data1 = ( rd_addr1 == 5'd0 ) ? 32'd0 : rf_read_data1;

endmodule

`endif /* VC_REGFILES_V */


`line 13 "lab2_proc/ProcAltDpathVRTL.v" 0

`line 1 "lab2_proc/TinyRV2InstVRTL.v" 0
//========================================================================
// TinyRV2 Instruction Type
//========================================================================
// Instruction types are similar to message types but are strictly used
// for communication within a TinyRV2-based processor. Instruction
// "messages" can be unpacked into the various fields as defined by the
// TinyRV2 ISA, as well as be constructed from specifying each field
// explicitly. The 32-bit instruction has different fields depending on
// the format of the instruction used. The following are the various
// instruction encoding formats used in the TinyRV2 ISA.
//
//  31          25 24   20 19   15 14    12 11          7 6      0
// | funct7       | rs2   | rs1   | funct3 | rd          | opcode |  R-type
// | imm[11:0]            | rs1   | funct3 | rd          | opcode |  I-type, I-imm
// | imm[11:5]    | rs2   | rs1   | funct3 | imm[4:0]    | opcode |  S-type, S-imm
// | imm[12|10:5] | rs2   | rs1   | funct3 | imm[4:1|11] | opcode |  SB-type,B-imm
// | imm[31:12]                            | rd          | opcode |  U-type, U-imm
// | imm[20|10:1|11|19:12]                 | rd          | opcode |  UJ-type,J-imm

`ifndef TINY_RV2_INST_V
`define TINY_RV2_INST_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 24 "lab2_proc/TinyRV2InstVRTL.v" 0

//------------------------------------------------------------------------
// Instruction fields
//------------------------------------------------------------------------

`define RV2ISA_INST_OPCODE  6:0
`define RV2ISA_INST_RD      11:7
`define RV2ISA_INST_RS1     19:15
`define RV2ISA_INST_RS2     24:20
`define RV2ISA_INST_FUNCT3  14:12
`define RV2ISA_INST_FUNCT7  31:25
`define RV2ISA_INST_CSR     31:20

//------------------------------------------------------------------------
// Field sizes
//------------------------------------------------------------------------

`define RV2ISA_INST_NBITS          32
`define RV2ISA_INST_OPCODE_NBITS   7
`define RV2ISA_INST_RD_NBITS       5
`define RV2ISA_INST_RS1_NBITS      5
`define RV2ISA_INST_RS2_NBITS      5
`define RV2ISA_INST_FUNCT3_NBITS   3
`define RV2ISA_INST_FUNCT7_NBITS   7
`define RV2ISA_INST_CSR_NBITS      12

//------------------------------------------------------------------------
// Instruction opcodes
//------------------------------------------------------------------------

// Basic instructions

`define RV2ISA_INST_CSRR  32'b???????_?????_?????_010_?????_1110011
`define RV2ISA_INST_CSRW  32'b???????_?????_?????_001_?????_1110011
`define RV2ISA_INST_NOP   32'b0000000_00000_00000_000_00000_0010011
`define RV2ISA_ZERO       32'b0000000_00000_00000_000_00000_0000000

// Register-register arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADD   32'b0000000_?????_?????_000_?????_0110011
`define RV2ISA_INST_SUB   32'b0100000_?????_?????_000_?????_0110011
`define RV2ISA_INST_AND   32'b0000000_?????_?????_111_?????_0110011
`define RV2ISA_INST_OR    32'b0000000_?????_?????_110_?????_0110011
`define RV2ISA_INST_XOR   32'b0000000_?????_?????_100_?????_0110011
`define RV2ISA_INST_SLT   32'b0000000_?????_?????_010_?????_0110011
`define RV2ISA_INST_SLTU  32'b0000000_?????_?????_011_?????_0110011
`define RV2ISA_INST_MUL   32'b0000001_?????_?????_000_?????_0110011

// Register-immediate arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADDI  32'b???????_?????_?????_000_?????_0010011
`define RV2ISA_INST_ANDI  32'b???????_?????_?????_111_?????_0010011
`define RV2ISA_INST_ORI   32'b???????_?????_?????_110_?????_0010011
`define RV2ISA_INST_XORI  32'b???????_?????_?????_100_?????_0010011
`define RV2ISA_INST_SLTI  32'b???????_?????_?????_010_?????_0010011
`define RV2ISA_INST_SLTIU 32'b???????_?????_?????_011_?????_0010011

// Shift instructions

`define RV2ISA_INST_SRA   32'b0100000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SRL   32'b0000000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SLL   32'b0000000_?????_?????_001_?????_0110011
`define RV2ISA_INST_SRAI  32'b0100000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SRLI  32'b0000000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SLLI  32'b0000000_?????_?????_001_?????_0010011

// Other instructions

`define RV2ISA_INST_LUI   32'b???????_?????_?????_???_?????_0110111
`define RV2ISA_INST_AUIPC 32'b???????_?????_?????_???_?????_0010111

// Memory instructions

`define RV2ISA_INST_LW    32'b???????_?????_?????_010_?????_0000011
`define RV2ISA_INST_SW    32'b???????_?????_?????_010_?????_0100011

// Unconditional jump instructions

`define RV2ISA_INST_JAL   32'b???????_?????_?????_???_?????_1101111
`define RV2ISA_INST_JALR  32'b???????_?????_?????_000_?????_1100111

// Conditional branch instructions

`define RV2ISA_INST_BEQ   32'b???????_?????_?????_000_?????_1100011
`define RV2ISA_INST_BNE   32'b???????_?????_?????_001_?????_1100011
`define RV2ISA_INST_BLT   32'b???????_?????_?????_100_?????_1100011
`define RV2ISA_INST_BGE   32'b???????_?????_?????_101_?????_1100011
`define RV2ISA_INST_BLTU  32'b???????_?????_?????_110_?????_1100011
`define RV2ISA_INST_BGEU  32'b???????_?????_?????_111_?????_1100011

//------------------------------------------------------------------------
// Coprocessor registers
//------------------------------------------------------------------------

`define RV2ISA_CPR_PROC2MNGR  12'h7C0
`define RV2ISA_CPR_MNGR2PROC  12'hFC0
`define RV2ISA_CPR_COREID     12'hF14
`define RV2ISA_CPR_NUMCORES   12'hFC1
`define RV2ISA_CPR_STATS_EN   12'h7C1

//------------------------------------------------------------------------
// Helper Tasks
//------------------------------------------------------------------------

module rv2isa_InstTasks();

  //----------------------------------------------------------------------
  // Immediate decoding -- only outputs signals at the width required for
  // line tracing
  //----------------------------------------------------------------------
  function [11:0] imm_i( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate
    imm_i = { inst[31], inst[30:25], inst[24:21], inst[20] };
  end
  endfunction

  function [4:0] imm_shamt( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate, specialized for shift amounts
    imm_shamt = { inst[24:21], inst[20] };
  end
  endfunction

  function [11:0] imm_s( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // S-type immediate
    imm_s = { inst[31], inst[30:25], inst[11:8], inst[7] };
  end
  endfunction

  function [12:0] imm_b( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // B-type immediate
    imm_b = { inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };
  end
  endfunction

  function [19:0] imm_u_sh12( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // U-type immediate, shifted right by 12
    imm_u_sh12 = { inst[31], inst[30:20], inst[19:12] };
  end
  endfunction

  function [20:0] imm_j( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // J-type immediate
    imm_j = { inst[31], inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm
  //----------------------------------------------------------------------

  reg [3*8-1:0]                     rs1_str;
  reg [3*8-1:0]                     rs2_str;
  reg [3*8-1:0]                     rd_str;
  reg [9*8-1:0]                     csr_str;

  logic [`RV2ISA_INST_RS1_NBITS-1:0] rs1;
  logic [`RV2ISA_INST_RS2_NBITS-1:0] rs2;
  logic [`RV2ISA_INST_RD_NBITS-1:0]  rd;
  logic [`RV2ISA_INST_CSR_NBITS-1:0] csr;

  function [25*8-1:0] disasm( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    // Unpack the fields

    rs1      = inst[`RV2ISA_INST_RS1];
    rs2      = inst[`RV2ISA_INST_RS2];
    rd       = inst[`RV2ISA_INST_RD];
    csr      = inst[`RV2ISA_INST_CSR];

    // Create fixed-width register specifiers

    if ( rs1 <= 9 )
      $sformat( rs1_str, "x0%0d", rs1 );
    else
      $sformat( rs1_str, "x%d",  rs1 );

    if ( rs2 <= 9 )
      $sformat( rs2_str, "x0%0d", rs2 );
    else
      $sformat( rs2_str, "x%d",  rs2 );

    if ( rd <= 9 )
      $sformat( rd_str, "x0%0d", rd );
    else
      $sformat( rd_str, "x%d",  rd );

    // if ( csr == `RV2ISA_CPR_PROC2MNGR )
      // $sformat( csr_str, "proc2mngr" );
    // else if ( csr == `RV2ISA_CPR_MNGR2PROC )
      // $sformat( csr_str, "mngr2proc" );
    // else if ( csr == `RV2ISA_CPR_COREID )
      // $sformat( csr_str, "coreid   " );
    // else if ( csr == `RV2ISA_CPR_NUMCORES )
      // $sformat( csr_str, "numcores " );
    // else if ( csr == `RV2ISA_CPR_STATS_EN )
      // $sformat( csr_str, "stats_en " );
    // else
    $sformat( csr_str, "    0x%x", csr );

    // Actual disassembly

    casez ( inst )
      `RV2ISA_INST_CSRR  : $sformat( disasm, "csrr   %s, %s  ",        rd_str,  csr_str );
      `RV2ISA_INST_CSRW  : $sformat( disasm, "csrw   %s, %s  ",        csr_str, rs1_str );
      `RV2ISA_INST_NOP   : $sformat( disasm, "nop                    " );
      `RV2ISA_ZERO       : $sformat( disasm, "                       " );

      `RV2ISA_INST_ADD   : $sformat( disasm, "add    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SUB   : $sformat( disasm, "sub    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_AND   : $sformat( disasm, "and    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_OR    : $sformat( disasm, "or     %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_XOR   : $sformat( disasm, "xor    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLT   : $sformat( disasm, "slt    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLTU  : $sformat( disasm, "sltu   %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_MUL   : $sformat( disasm, "mul    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );

      `RV2ISA_INST_ADDI  : $sformat( disasm, "addi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ANDI  : $sformat( disasm, "andi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ORI   : $sformat( disasm, "ori    %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_XORI  : $sformat( disasm, "xori   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTI  : $sformat( disasm, "slti   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTIU : $sformat( disasm, "sltiu  %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );

      `RV2ISA_INST_SRA   : $sformat( disasm, "sra    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRL   : $sformat( disasm, "srl    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLL   : $sformat( disasm, "sll    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRAI  : $sformat( disasm, "srai   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRLI  : $sformat( disasm, "srli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLLI  : $sformat( disasm, "slli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );

      `RV2ISA_INST_LUI   : $sformat( disasm, "lui    %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));
      `RV2ISA_INST_AUIPC : $sformat( disasm, "auipc  %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));

      `RV2ISA_INST_LW    : $sformat( disasm, "lw     %s, 0x%x(%s) ",   rd_str,  imm_i(inst), rs1_str );
      `RV2ISA_INST_SW    : $sformat( disasm, "sw     %s, 0x%x(%s) ",   rs2_str, imm_s(inst), rs1_str );

      `RV2ISA_INST_JAL   : $sformat( disasm, "jal    %s, 0x%x   ",     rd_str, imm_j(inst) );
      `RV2ISA_INST_JALR  : $sformat( disasm, "jalr   %s, %s, 0x%x ",   rd_str, rs1_str, imm_i(inst) );

      `RV2ISA_INST_BEQ   : $sformat( disasm, "beq    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BNE   : $sformat( disasm, "bne    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLT   : $sformat( disasm, "blt    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGE   : $sformat( disasm, "bge    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLTU  : $sformat( disasm, "bltu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGEU  : $sformat( disasm, "bgeu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );

      default            : $sformat( disasm, "illegal inst           " );
    endcase

  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm Tiny
  //----------------------------------------------------------------------

  function [4*8-1:0] disasm_tiny( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    casez ( inst )
      `RV2ISA_INST_CSRR  : disasm_tiny = "csrr";
      `RV2ISA_INST_CSRW  : disasm_tiny = "csrw";
      `RV2ISA_INST_NOP   : disasm_tiny = "nop ";

      `RV2ISA_INST_ADD   : disasm_tiny = "add ";
      `RV2ISA_INST_SUB   : disasm_tiny = "sub ";
      `RV2ISA_INST_AND   : disasm_tiny = "and ";
      `RV2ISA_INST_OR    : disasm_tiny = "or  ";
      `RV2ISA_INST_XOR   : disasm_tiny = "xor ";
      `RV2ISA_INST_SLT   : disasm_tiny = "slt ";
      `RV2ISA_INST_SLTU  : disasm_tiny = "sltu";
      `RV2ISA_INST_MUL   : disasm_tiny = "mul ";

      `RV2ISA_INST_ADDI  : disasm_tiny = "addi";
      `RV2ISA_INST_ANDI  : disasm_tiny = "andi";
      `RV2ISA_INST_ORI   : disasm_tiny = "ori ";
      `RV2ISA_INST_XORI  : disasm_tiny = "xori";
      `RV2ISA_INST_SLTI  : disasm_tiny = "slti";
      `RV2ISA_INST_SLTIU : disasm_tiny = "sltI";

      `RV2ISA_INST_SRA   : disasm_tiny = "sra ";
      `RV2ISA_INST_SRL   : disasm_tiny = "srl ";
      `RV2ISA_INST_SLL   : disasm_tiny = "sll ";
      `RV2ISA_INST_SRAI  : disasm_tiny = "srai";
      `RV2ISA_INST_SRLI  : disasm_tiny = "srli";
      `RV2ISA_INST_SLLI  : disasm_tiny = "slli";

      `RV2ISA_INST_LUI   : disasm_tiny = "lui ";
      `RV2ISA_INST_AUIPC : disasm_tiny = "auiP";

      `RV2ISA_INST_LW    : disasm_tiny = "lw  ";
      `RV2ISA_INST_SW    : disasm_tiny = "sw  ";

      `RV2ISA_INST_JAL   : disasm_tiny = "jal ";
      `RV2ISA_INST_JALR  : disasm_tiny = "jalr";

      `RV2ISA_INST_BEQ   : disasm_tiny = "beq ";
      `RV2ISA_INST_BNE   : disasm_tiny = "bne ";
      `RV2ISA_INST_BLT   : disasm_tiny = "blt ";
      `RV2ISA_INST_BGE   : disasm_tiny = "bge ";
      `RV2ISA_INST_BLTU  : disasm_tiny = "bltu";
      `RV2ISA_INST_BGEU  : disasm_tiny = "bgeu";

      default            : disasm_tiny = "????";
    endcase

  end
  endfunction

endmodule

//------------------------------------------------------------------------
// Unpack instruction
//------------------------------------------------------------------------

module rv2isa_InstUnpack
(
  // Packed message

  input  [`RV2ISA_INST_NBITS-1:0]        inst,

  // Packed fields

  output [`RV2ISA_INST_OPCODE_NBITS-1:0] opcode,
  output [`RV2ISA_INST_RD_NBITS-1:0]     rd,
  output [`RV2ISA_INST_RS1_NBITS-1:0]    rs1,
  output [`RV2ISA_INST_RS2_NBITS-1:0]    rs2,
  output [`RV2ISA_INST_FUNCT3_NBITS-1:0] funct3,
  output [`RV2ISA_INST_FUNCT7_NBITS-1:0] funct7,
  output [`RV2ISA_INST_CSR_NBITS-1:0]    csr
);

  assign opcode   = inst[`RV2ISA_INST_OPCODE];
  assign rd       = inst[`RV2ISA_INST_RD];
  assign rs1      = inst[`RV2ISA_INST_RS1];
  assign rs2      = inst[`RV2ISA_INST_RS2];
  assign funct3   = inst[`RV2ISA_INST_FUNCT3];
  assign csr      = inst[`RV2ISA_INST_CSR];

endmodule

//------------------------------------------------------------------------
// Convert message to string
//------------------------------------------------------------------------

module rv2isa_InstTrace
(
  input                          clk,
  input                          reset,
  input [`RV2ISA_INST_NBITS-1:0] inst
);

  rv2isa_InstTasks rv2isa();

  `VC_TRACE_BEGIN
  begin
    vc_trace.append_str( trace_str, rv2isa.disasm( inst ) );
    vc_trace.append_str( trace_str, " | " );
    vc_trace.append_str( trace_str, rv2isa.disasm_tiny( inst ) );
  end
  `VC_TRACE_END

endmodule

`endif /* TINY_RV2_INST_V */


`line 15 "lab2_proc/ProcAltDpathVRTL.v" 0
`line 1 "lab2_proc/ProcDpathComponentsVRTL.v" 0
//========================================================================
// Datapath Components for 5-Stage Pipelined Processor
//========================================================================

`ifndef LAB2_PROC_DPATH_COMPONENTS_V
`define LAB2_PROC_DPATH_COMPONENTS_V

`line 1 "lab2_proc/TinyRV2InstVRTL.v" 0
//========================================================================
// TinyRV2 Instruction Type
//========================================================================
// Instruction types are similar to message types but are strictly used
// for communication within a TinyRV2-based processor. Instruction
// "messages" can be unpacked into the various fields as defined by the
// TinyRV2 ISA, as well as be constructed from specifying each field
// explicitly. The 32-bit instruction has different fields depending on
// the format of the instruction used. The following are the various
// instruction encoding formats used in the TinyRV2 ISA.
//
//  31          25 24   20 19   15 14    12 11          7 6      0
// | funct7       | rs2   | rs1   | funct3 | rd          | opcode |  R-type
// | imm[11:0]            | rs1   | funct3 | rd          | opcode |  I-type, I-imm
// | imm[11:5]    | rs2   | rs1   | funct3 | imm[4:0]    | opcode |  S-type, S-imm
// | imm[12|10:5] | rs2   | rs1   | funct3 | imm[4:1|11] | opcode |  SB-type,B-imm
// | imm[31:12]                            | rd          | opcode |  U-type, U-imm
// | imm[20|10:1|11|19:12]                 | rd          | opcode |  UJ-type,J-imm

`ifndef TINY_RV2_INST_V
`define TINY_RV2_INST_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 24 "lab2_proc/TinyRV2InstVRTL.v" 0

//------------------------------------------------------------------------
// Instruction fields
//------------------------------------------------------------------------

`define RV2ISA_INST_OPCODE  6:0
`define RV2ISA_INST_RD      11:7
`define RV2ISA_INST_RS1     19:15
`define RV2ISA_INST_RS2     24:20
`define RV2ISA_INST_FUNCT3  14:12
`define RV2ISA_INST_FUNCT7  31:25
`define RV2ISA_INST_CSR     31:20

//------------------------------------------------------------------------
// Field sizes
//------------------------------------------------------------------------

`define RV2ISA_INST_NBITS          32
`define RV2ISA_INST_OPCODE_NBITS   7
`define RV2ISA_INST_RD_NBITS       5
`define RV2ISA_INST_RS1_NBITS      5
`define RV2ISA_INST_RS2_NBITS      5
`define RV2ISA_INST_FUNCT3_NBITS   3
`define RV2ISA_INST_FUNCT7_NBITS   7
`define RV2ISA_INST_CSR_NBITS      12

//------------------------------------------------------------------------
// Instruction opcodes
//------------------------------------------------------------------------

// Basic instructions

`define RV2ISA_INST_CSRR  32'b???????_?????_?????_010_?????_1110011
`define RV2ISA_INST_CSRW  32'b???????_?????_?????_001_?????_1110011
`define RV2ISA_INST_NOP   32'b0000000_00000_00000_000_00000_0010011
`define RV2ISA_ZERO       32'b0000000_00000_00000_000_00000_0000000

// Register-register arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADD   32'b0000000_?????_?????_000_?????_0110011
`define RV2ISA_INST_SUB   32'b0100000_?????_?????_000_?????_0110011
`define RV2ISA_INST_AND   32'b0000000_?????_?????_111_?????_0110011
`define RV2ISA_INST_OR    32'b0000000_?????_?????_110_?????_0110011
`define RV2ISA_INST_XOR   32'b0000000_?????_?????_100_?????_0110011
`define RV2ISA_INST_SLT   32'b0000000_?????_?????_010_?????_0110011
`define RV2ISA_INST_SLTU  32'b0000000_?????_?????_011_?????_0110011
`define RV2ISA_INST_MUL   32'b0000001_?????_?????_000_?????_0110011

// Register-immediate arithmetic, logical, and comparison instructions

`define RV2ISA_INST_ADDI  32'b???????_?????_?????_000_?????_0010011
`define RV2ISA_INST_ANDI  32'b???????_?????_?????_111_?????_0010011
`define RV2ISA_INST_ORI   32'b???????_?????_?????_110_?????_0010011
`define RV2ISA_INST_XORI  32'b???????_?????_?????_100_?????_0010011
`define RV2ISA_INST_SLTI  32'b???????_?????_?????_010_?????_0010011
`define RV2ISA_INST_SLTIU 32'b???????_?????_?????_011_?????_0010011

// Shift instructions

`define RV2ISA_INST_SRA   32'b0100000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SRL   32'b0000000_?????_?????_101_?????_0110011
`define RV2ISA_INST_SLL   32'b0000000_?????_?????_001_?????_0110011
`define RV2ISA_INST_SRAI  32'b0100000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SRLI  32'b0000000_?????_?????_101_?????_0010011
`define RV2ISA_INST_SLLI  32'b0000000_?????_?????_001_?????_0010011

// Other instructions

`define RV2ISA_INST_LUI   32'b???????_?????_?????_???_?????_0110111
`define RV2ISA_INST_AUIPC 32'b???????_?????_?????_???_?????_0010111

// Memory instructions

`define RV2ISA_INST_LW    32'b???????_?????_?????_010_?????_0000011
`define RV2ISA_INST_SW    32'b???????_?????_?????_010_?????_0100011

// Unconditional jump instructions

`define RV2ISA_INST_JAL   32'b???????_?????_?????_???_?????_1101111
`define RV2ISA_INST_JALR  32'b???????_?????_?????_000_?????_1100111

// Conditional branch instructions

`define RV2ISA_INST_BEQ   32'b???????_?????_?????_000_?????_1100011
`define RV2ISA_INST_BNE   32'b???????_?????_?????_001_?????_1100011
`define RV2ISA_INST_BLT   32'b???????_?????_?????_100_?????_1100011
`define RV2ISA_INST_BGE   32'b???????_?????_?????_101_?????_1100011
`define RV2ISA_INST_BLTU  32'b???????_?????_?????_110_?????_1100011
`define RV2ISA_INST_BGEU  32'b???????_?????_?????_111_?????_1100011

//------------------------------------------------------------------------
// Coprocessor registers
//------------------------------------------------------------------------

`define RV2ISA_CPR_PROC2MNGR  12'h7C0
`define RV2ISA_CPR_MNGR2PROC  12'hFC0
`define RV2ISA_CPR_COREID     12'hF14
`define RV2ISA_CPR_NUMCORES   12'hFC1
`define RV2ISA_CPR_STATS_EN   12'h7C1

//------------------------------------------------------------------------
// Helper Tasks
//------------------------------------------------------------------------

module rv2isa_InstTasks();

  //----------------------------------------------------------------------
  // Immediate decoding -- only outputs signals at the width required for
  // line tracing
  //----------------------------------------------------------------------
  function [11:0] imm_i( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate
    imm_i = { inst[31], inst[30:25], inst[24:21], inst[20] };
  end
  endfunction

  function [4:0] imm_shamt( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // I-type immediate, specialized for shift amounts
    imm_shamt = { inst[24:21], inst[20] };
  end
  endfunction

  function [11:0] imm_s( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // S-type immediate
    imm_s = { inst[31], inst[30:25], inst[11:8], inst[7] };
  end
  endfunction

  function [12:0] imm_b( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // B-type immediate
    imm_b = { inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };
  end
  endfunction

  function [19:0] imm_u_sh12( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // U-type immediate, shifted right by 12
    imm_u_sh12 = { inst[31], inst[30:20], inst[19:12] };
  end
  endfunction

  function [20:0] imm_j( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin
    // J-type immediate
    imm_j = { inst[31], inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };
  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm
  //----------------------------------------------------------------------

  reg [3*8-1:0]                     rs1_str;
  reg [3*8-1:0]                     rs2_str;
  reg [3*8-1:0]                     rd_str;
  reg [9*8-1:0]                     csr_str;

  logic [`RV2ISA_INST_RS1_NBITS-1:0] rs1;
  logic [`RV2ISA_INST_RS2_NBITS-1:0] rs2;
  logic [`RV2ISA_INST_RD_NBITS-1:0]  rd;
  logic [`RV2ISA_INST_CSR_NBITS-1:0] csr;

  function [25*8-1:0] disasm( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    // Unpack the fields

    rs1      = inst[`RV2ISA_INST_RS1];
    rs2      = inst[`RV2ISA_INST_RS2];
    rd       = inst[`RV2ISA_INST_RD];
    csr      = inst[`RV2ISA_INST_CSR];

    // Create fixed-width register specifiers

    if ( rs1 <= 9 )
      $sformat( rs1_str, "x0%0d", rs1 );
    else
      $sformat( rs1_str, "x%d",  rs1 );

    if ( rs2 <= 9 )
      $sformat( rs2_str, "x0%0d", rs2 );
    else
      $sformat( rs2_str, "x%d",  rs2 );

    if ( rd <= 9 )
      $sformat( rd_str, "x0%0d", rd );
    else
      $sformat( rd_str, "x%d",  rd );

    // if ( csr == `RV2ISA_CPR_PROC2MNGR )
      // $sformat( csr_str, "proc2mngr" );
    // else if ( csr == `RV2ISA_CPR_MNGR2PROC )
      // $sformat( csr_str, "mngr2proc" );
    // else if ( csr == `RV2ISA_CPR_COREID )
      // $sformat( csr_str, "coreid   " );
    // else if ( csr == `RV2ISA_CPR_NUMCORES )
      // $sformat( csr_str, "numcores " );
    // else if ( csr == `RV2ISA_CPR_STATS_EN )
      // $sformat( csr_str, "stats_en " );
    // else
    $sformat( csr_str, "    0x%x", csr );

    // Actual disassembly

    casez ( inst )
      `RV2ISA_INST_CSRR  : $sformat( disasm, "csrr   %s, %s  ",        rd_str,  csr_str );
      `RV2ISA_INST_CSRW  : $sformat( disasm, "csrw   %s, %s  ",        csr_str, rs1_str );
      `RV2ISA_INST_NOP   : $sformat( disasm, "nop                    " );
      `RV2ISA_ZERO       : $sformat( disasm, "                       " );

      `RV2ISA_INST_ADD   : $sformat( disasm, "add    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SUB   : $sformat( disasm, "sub    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_AND   : $sformat( disasm, "and    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_OR    : $sformat( disasm, "or     %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_XOR   : $sformat( disasm, "xor    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLT   : $sformat( disasm, "slt    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_SLTU  : $sformat( disasm, "sltu   %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );
      `RV2ISA_INST_MUL   : $sformat( disasm, "mul    %s, %s, %s   ",   rd_str,  rs1_str, rs2_str );

      `RV2ISA_INST_ADDI  : $sformat( disasm, "addi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ANDI  : $sformat( disasm, "andi   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_ORI   : $sformat( disasm, "ori    %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_XORI  : $sformat( disasm, "xori   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTI  : $sformat( disasm, "slti   %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );
      `RV2ISA_INST_SLTIU : $sformat( disasm, "sltiu  %s, %s, 0x%x ",   rd_str,  rs1_str, imm_i(inst) );

      `RV2ISA_INST_SRA   : $sformat( disasm, "sra    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRL   : $sformat( disasm, "srl    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLL   : $sformat( disasm, "sll    %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRAI  : $sformat( disasm, "srai   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SRLI  : $sformat( disasm, "srli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );
      `RV2ISA_INST_SLLI  : $sformat( disasm, "slli   %s, %s, 0x%x  ",  rd_str,  rs1_str, imm_shamt(inst) );

      `RV2ISA_INST_LUI   : $sformat( disasm, "lui    %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));
      `RV2ISA_INST_AUIPC : $sformat( disasm, "auipc  %s, 0x%x    ",    rd_str,  imm_u_sh12(inst));

      `RV2ISA_INST_LW    : $sformat( disasm, "lw     %s, 0x%x(%s) ",   rd_str,  imm_i(inst), rs1_str );
      `RV2ISA_INST_SW    : $sformat( disasm, "sw     %s, 0x%x(%s) ",   rs2_str, imm_s(inst), rs1_str );

      `RV2ISA_INST_JAL   : $sformat( disasm, "jal    %s, 0x%x   ",     rd_str, imm_j(inst) );
      `RV2ISA_INST_JALR  : $sformat( disasm, "jalr   %s, %s, 0x%x ",   rd_str, rs1_str, imm_i(inst) );

      `RV2ISA_INST_BEQ   : $sformat( disasm, "beq    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BNE   : $sformat( disasm, "bne    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLT   : $sformat( disasm, "blt    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGE   : $sformat( disasm, "bge    %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BLTU  : $sformat( disasm, "bltu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );
      `RV2ISA_INST_BGEU  : $sformat( disasm, "bgeu   %s, %s, 0x%x",    rs1_str, rs2_str, imm_b(inst) );

      default            : $sformat( disasm, "illegal inst           " );
    endcase

  end
  endfunction

  //----------------------------------------------------------------------
  // Disasm Tiny
  //----------------------------------------------------------------------

  function [4*8-1:0] disasm_tiny( input [`RV2ISA_INST_NBITS-1:0] inst );
  begin

    casez ( inst )
      `RV2ISA_INST_CSRR  : disasm_tiny = "csrr";
      `RV2ISA_INST_CSRW  : disasm_tiny = "csrw";
      `RV2ISA_INST_NOP   : disasm_tiny = "nop ";

      `RV2ISA_INST_ADD   : disasm_tiny = "add ";
      `RV2ISA_INST_SUB   : disasm_tiny = "sub ";
      `RV2ISA_INST_AND   : disasm_tiny = "and ";
      `RV2ISA_INST_OR    : disasm_tiny = "or  ";
      `RV2ISA_INST_XOR   : disasm_tiny = "xor ";
      `RV2ISA_INST_SLT   : disasm_tiny = "slt ";
      `RV2ISA_INST_SLTU  : disasm_tiny = "sltu";
      `RV2ISA_INST_MUL   : disasm_tiny = "mul ";

      `RV2ISA_INST_ADDI  : disasm_tiny = "addi";
      `RV2ISA_INST_ANDI  : disasm_tiny = "andi";
      `RV2ISA_INST_ORI   : disasm_tiny = "ori ";
      `RV2ISA_INST_XORI  : disasm_tiny = "xori";
      `RV2ISA_INST_SLTI  : disasm_tiny = "slti";
      `RV2ISA_INST_SLTIU : disasm_tiny = "sltI";

      `RV2ISA_INST_SRA   : disasm_tiny = "sra ";
      `RV2ISA_INST_SRL   : disasm_tiny = "srl ";
      `RV2ISA_INST_SLL   : disasm_tiny = "sll ";
      `RV2ISA_INST_SRAI  : disasm_tiny = "srai";
      `RV2ISA_INST_SRLI  : disasm_tiny = "srli";
      `RV2ISA_INST_SLLI  : disasm_tiny = "slli";

      `RV2ISA_INST_LUI   : disasm_tiny = "lui ";
      `RV2ISA_INST_AUIPC : disasm_tiny = "auiP";

      `RV2ISA_INST_LW    : disasm_tiny = "lw  ";
      `RV2ISA_INST_SW    : disasm_tiny = "sw  ";

      `RV2ISA_INST_JAL   : disasm_tiny = "jal ";
      `RV2ISA_INST_JALR  : disasm_tiny = "jalr";

      `RV2ISA_INST_BEQ   : disasm_tiny = "beq ";
      `RV2ISA_INST_BNE   : disasm_tiny = "bne ";
      `RV2ISA_INST_BLT   : disasm_tiny = "blt ";
      `RV2ISA_INST_BGE   : disasm_tiny = "bge ";
      `RV2ISA_INST_BLTU  : disasm_tiny = "bltu";
      `RV2ISA_INST_BGEU  : disasm_tiny = "bgeu";

      default            : disasm_tiny = "????";
    endcase

  end
  endfunction

endmodule

//------------------------------------------------------------------------
// Unpack instruction
//------------------------------------------------------------------------

module rv2isa_InstUnpack
(
  // Packed message

  input  [`RV2ISA_INST_NBITS-1:0]        inst,

  // Packed fields

  output [`RV2ISA_INST_OPCODE_NBITS-1:0] opcode,
  output [`RV2ISA_INST_RD_NBITS-1:0]     rd,
  output [`RV2ISA_INST_RS1_NBITS-1:0]    rs1,
  output [`RV2ISA_INST_RS2_NBITS-1:0]    rs2,
  output [`RV2ISA_INST_FUNCT3_NBITS-1:0] funct3,
  output [`RV2ISA_INST_FUNCT7_NBITS-1:0] funct7,
  output [`RV2ISA_INST_CSR_NBITS-1:0]    csr
);

  assign opcode   = inst[`RV2ISA_INST_OPCODE];
  assign rd       = inst[`RV2ISA_INST_RD];
  assign rs1      = inst[`RV2ISA_INST_RS1];
  assign rs2      = inst[`RV2ISA_INST_RS2];
  assign funct3   = inst[`RV2ISA_INST_FUNCT3];
  assign csr      = inst[`RV2ISA_INST_CSR];

endmodule

//------------------------------------------------------------------------
// Convert message to string
//------------------------------------------------------------------------

module rv2isa_InstTrace
(
  input                          clk,
  input                          reset,
  input [`RV2ISA_INST_NBITS-1:0] inst
);

  rv2isa_InstTasks rv2isa();

  `VC_TRACE_BEGIN
  begin
    vc_trace.append_str( trace_str, rv2isa.disasm( inst ) );
    vc_trace.append_str( trace_str, " | " );
    vc_trace.append_str( trace_str, rv2isa.disasm_tiny( inst ) );
  end
  `VC_TRACE_END

endmodule

`endif /* TINY_RV2_INST_V */


`line 9 "lab2_proc/ProcDpathComponentsVRTL.v" 0

//------------------------------------------------------------------------
// Generate intermediate (imm) based on type
//------------------------------------------------------------------------

module lab2_proc_ImmGenVRTL
(
  input  logic [ 2:0] imm_type,
  input  logic [31:0] inst,
  output logic [31:0] imm
);

  always_comb begin
    case ( imm_type )
      3'd0: // I-type
        imm = { {21{inst[31]}}, inst[30:25], inst[24:21], inst[20] };
      
      3'd1: // S-type
        imm = { {21{inst[31]}}, inst[30:25], inst[11:8], inst[7]};

      3'd2: // B-type
        imm = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
        
      3'd3: // U-type
        imm = { inst[31], inst[30:20], inst[19:12], {12{1'b0}} };
        
      3'd4: // J-type
        imm = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:25], inst[24:21], 1'b0 };

      default:
        imm = 32'bx;

    endcase
  end

endmodule

//------------------------------------------------------------------------
// ALU
//------------------------------------------------------------------------

`line 1 "vc/arithmetic.v" 0
//========================================================================
// Verilog Components: Arithmetic Components
//========================================================================

`ifndef VC_ARITHMETIC_V
`define VC_ARITHMETIC_V

//------------------------------------------------------------------------
// Adders
//------------------------------------------------------------------------

module vc_Adder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  input  logic               cin,
  output logic [p_nbits-1:0] out,
  output logic               cout
);

  // We need to convert cin into a 32-bit value to
  // avoid verilator warnings

  assign {cout,out} = in0 + in1 + {{(p_nbits-1){1'b0}},cin};

endmodule

module vc_SimpleAdder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 + in1;

endmodule

//------------------------------------------------------------------------
// Subtractor
//------------------------------------------------------------------------

module vc_Subtractor
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 - in1;

endmodule

//------------------------------------------------------------------------
// Incrementer
//------------------------------------------------------------------------

module vc_Incrementer
#(
  parameter p_nbits     = 1,
  parameter p_inc_value = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic [p_nbits-1:0] out
);

  assign out = in + p_inc_value;

endmodule

//------------------------------------------------------------------------
// ZeroExtender
//------------------------------------------------------------------------

module vc_ZeroExtender
#(
  parameter p_in_nbits  = 1,
  parameter p_out_nbits = 8
)(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {( p_out_nbits - p_in_nbits ){1'b0}}, in };

endmodule

//------------------------------------------------------------------------
// SignExtender
//------------------------------------------------------------------------

module vc_SignExtender
#(
 parameter p_in_nbits = 1,
 parameter p_out_nbits = 8
)
(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {(p_out_nbits-p_in_nbits){in[p_in_nbits-1]}}, in };

endmodule

//------------------------------------------------------------------------
// ZeroComparator
//------------------------------------------------------------------------

module vc_ZeroComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic               out
);

  assign out = ( in == {p_nbits{1'b0}} );

endmodule

//------------------------------------------------------------------------
// EqComparator
//------------------------------------------------------------------------

module vc_EqComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 == in1 );

endmodule

//------------------------------------------------------------------------
// LtComparator
//------------------------------------------------------------------------

module vc_LtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 < in1 );

endmodule

//------------------------------------------------------------------------
// GtComparator
//------------------------------------------------------------------------

module vc_GtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 > in1 );

endmodule

//------------------------------------------------------------------------
// LeftLogicalShifter
//------------------------------------------------------------------------

module vc_LeftLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1 )
(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in << shamt );

endmodule

//------------------------------------------------------------------------
// RightLogicalShifter
//------------------------------------------------------------------------

module vc_RightLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1
)(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in >> shamt );

endmodule

`endif /* VC_ARITHMETIC_V */


`line 51 "lab2_proc/ProcDpathComponentsVRTL.v" 0

module lab2_proc_AluVRTL
(
  input  logic [31:0] in0,
  input  logic [31:0] in1,
  input  logic [ 3:0] fn,
  output logic [31:0] out,
  output logic        ops_eq,
  output logic        ops_lt,
  output logic        ops_ltu
);

  always_comb begin

    case ( fn )
      4'd0    : out = in0 + in1;                                // ADD
      4'd1    : out = in0 - in1;                                // SUB
      4'd2    : out = in0 & in1;                                // AND
      4'd3    : out = in0 | in1;                                // OR
      4'd4    : out = in0 ^ in1;                                // XOR
      4'd5    : out = {31'b0, ops_lt};                          // SLT
      4'd6    : out = {31'b0, ops_ltu};                         // SLTU
      4'd7    : out = $signed(in0) >>> in1[4:0];                // SRA
      4'd8    : out = in0 >> in1[4:0];                          // SRL
      4'd9    : out = in0 << in1[4:0];                          // SLL
      // LUI <- CP OP1
      4'd11   : out = in0;                                      // CP OP0
      4'd12   : out = in1;                                      // CP OP1
      // AUPIC <- ADD
      4'd14   : out = {31'b0, ops_eq};                          // CMP
      4'd15   : out = ( in0 + in1 ) & 32'hfffffffe;             // JALR
      default : out = 32'b0;
    endcase

  end

  // Calculate equality, zero, negative flags

  vc_EqComparator #(32) cond_eq_comp
  (
    .in0  (in0),
    .in1  (in1),
    .out  (ops_eq)
  );

  assign ops_lt = $signed(in0) < $signed(in1);
  assign ops_ltu = in0 < in1;

endmodule

`endif



`line 16 "lab2_proc/ProcAltDpathVRTL.v" 0
`line 1 "lab1_imul/IntMulAltVRTL.v" 0
//=========================================================================
// Integer Multiplier Variable-Latency Implementation
//=========================================================================

`ifndef LAB1_IMUL_INT_MUL_ALT_V
`define LAB1_IMUL_INT_MUL_ALT_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 9 "lab1_imul/IntMulAltVRTL.v" 0
`line 1 "lab1_imul/ConsecZeroDetectorVRTL.v" 0
module lab1_imul_ConsecZeroDetectorVRTL
(
  input  logic [3:0] number_4b,
  output logic [2:0] shift_bits
);

always @(*) begin
  casez(number_4b)
    4'b???1: shift_bits = 3'd1;
    4'b??10: shift_bits = 3'd2;
    4'b?100: shift_bits = 3'd3;
    4'b1000: shift_bits = 3'd4;
    4'b0000: shift_bits = 3'd5;
  endcase
end
endmodule

`line 10 "lab1_imul/IntMulAltVRTL.v" 0
`line 1 "vc/regs.v" 0
//========================================================================
// Verilog Components: Registers
//========================================================================

// Note that we place the register output earlier in the port list since
// this is one place we might actually want to use positional port
// binding like this:
//
//  logic [p_nbits-1:0] result_B;
//  vc_Reg#(p_nbits) result_AB( clk, result_B, result_A );

`ifndef VC_REGS_V
`define VC_REGS_V

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop
//------------------------------------------------------------------------

module vc_Reg
#(
  parameter p_nbits = 1
)(
  input  logic               clk, // Clock input
  output logic [p_nbits-1:0] q,   // Data output
  input  logic [p_nbits-1:0] d    // Data input
);

  always_ff @( posedge clk )
    q <= d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with reset
//------------------------------------------------------------------------

module vc_ResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d      // Data input
);

  always_ff @( posedge clk )
    q <= reset ? p_reset_value : d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable
//------------------------------------------------------------------------

module vc_EnReg
#(
  parameter p_nbits = 1
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( en )
      q <= d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable and reset
//------------------------------------------------------------------------

module vc_EnResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( reset || en )
      q <= reset ? p_reset_value : d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

`endif /* VC_REGS_V */


`line 11 "lab1_imul/IntMulAltVRTL.v" 0
`line 1 "vc/muxes.v" 0
//========================================================================
// Verilog Components: Muxes
//========================================================================

`ifndef VC_MUXES_V
`define VC_MUXES_V

//------------------------------------------------------------------------
// 2 Input Mux
//------------------------------------------------------------------------

module vc_Mux2
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1,
  input  logic               sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      1'd0 : out = in0;
      1'd1 : out = in1;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 3 Input Mux
//------------------------------------------------------------------------

module vc_Mux3
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 4 Input Mux
//------------------------------------------------------------------------

module vc_Mux4
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      2'd3 : out = in3;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 5 Input Mux
//------------------------------------------------------------------------

module vc_Mux5
#(
 parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 6 Input Mux
//------------------------------------------------------------------------

module vc_Mux6
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 7 Input Mux
//------------------------------------------------------------------------

module vc_Mux7
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 8 Input Mux
//------------------------------------------------------------------------

module vc_Mux8
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6, in7,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      3'd7 : out = in7;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

`endif /* VC_MUXES_V */


`line 12 "lab1_imul/IntMulAltVRTL.v" 0
`line 1 "vc/arithmetic.v" 0
//========================================================================
// Verilog Components: Arithmetic Components
//========================================================================

`ifndef VC_ARITHMETIC_V
`define VC_ARITHMETIC_V

//------------------------------------------------------------------------
// Adders
//------------------------------------------------------------------------

module vc_Adder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  input  logic               cin,
  output logic [p_nbits-1:0] out,
  output logic               cout
);

  // We need to convert cin into a 32-bit value to
  // avoid verilator warnings

  assign {cout,out} = in0 + in1 + {{(p_nbits-1){1'b0}},cin};

endmodule

module vc_SimpleAdder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 + in1;

endmodule

//------------------------------------------------------------------------
// Subtractor
//------------------------------------------------------------------------

module vc_Subtractor
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 - in1;

endmodule

//------------------------------------------------------------------------
// Incrementer
//------------------------------------------------------------------------

module vc_Incrementer
#(
  parameter p_nbits     = 1,
  parameter p_inc_value = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic [p_nbits-1:0] out
);

  assign out = in + p_inc_value;

endmodule

//------------------------------------------------------------------------
// ZeroExtender
//------------------------------------------------------------------------

module vc_ZeroExtender
#(
  parameter p_in_nbits  = 1,
  parameter p_out_nbits = 8
)(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {( p_out_nbits - p_in_nbits ){1'b0}}, in };

endmodule

//------------------------------------------------------------------------
// SignExtender
//------------------------------------------------------------------------

module vc_SignExtender
#(
 parameter p_in_nbits = 1,
 parameter p_out_nbits = 8
)
(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {(p_out_nbits-p_in_nbits){in[p_in_nbits-1]}}, in };

endmodule

//------------------------------------------------------------------------
// ZeroComparator
//------------------------------------------------------------------------

module vc_ZeroComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic               out
);

  assign out = ( in == {p_nbits{1'b0}} );

endmodule

//------------------------------------------------------------------------
// EqComparator
//------------------------------------------------------------------------

module vc_EqComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 == in1 );

endmodule

//------------------------------------------------------------------------
// LtComparator
//------------------------------------------------------------------------

module vc_LtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 < in1 );

endmodule

//------------------------------------------------------------------------
// GtComparator
//------------------------------------------------------------------------

module vc_GtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 > in1 );

endmodule

//------------------------------------------------------------------------
// LeftLogicalShifter
//------------------------------------------------------------------------

module vc_LeftLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1 )
(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in << shamt );

endmodule

//------------------------------------------------------------------------
// RightLogicalShifter
//------------------------------------------------------------------------

module vc_RightLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1
)(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in >> shamt );

endmodule

`endif /* VC_ARITHMETIC_V */


`line 13 "lab1_imul/IntMulAltVRTL.v" 0

// ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// Define datapath and control unit here.
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
module lab1_imul_IntMulAltCtrl
(
  input  logic clk,
  input  logic reset,
  
  //Dataflow signals  
  input  logic req_val,
  output logic req_rdy,
  output logic resp_val,
  input  logic resp_rdy,
  
  //Control signals  
  output logic b_mux_sel,      //sel signal for mux in front of b_reg
  output logic a_mux_sel,      //sel signal for mux in front of a_reg
  output logic result_mux_sel, //sel signal for mux in front of result_reg
  output logic result_en,      //enable for result_reg
  output logic add_mux_sel,    //sel signal for mux after Add

  
  //Data signals  
  input  logic         b_lsb,        //least significant bit of b
  input  logic [2:0]   shift_bits    //the amount of bits to be shifted this cycle
);
  
  //----------------------------------------------------------------------
  //State Definitions
  //----------------------------------------------------------------------
  localparam STATE_IDLE = 2'd0;
  localparam STATE_CALC = 2'd1;
  localparam STATE_DONE = 2'd2;
  
  //----------------------------------------------------------------------
  //Counter Handling
  //----------------------------------------------------------------------

  localparam p_count_nbits = 6;
  
  logic [p_count_nbits-1:0] count;
  logic [p_count_nbits-1:0] count_plus_shifted;
  logic [p_count_nbits-1:0] count_next; 

  vc_SimpleAdder#(p_count_nbits) adderCount
  (
    .in0  (count),
    .in1  ({3'b0, shift_bits}),
    .out  (count_plus_shifted)
  );
  
  vc_Reg#( p_count_nbits ) count_reg
  (
    .clk(clk),
    .q(count),                // Data output
    .d(count_next)            // Data input
  );

  
  //----------------------------------------------------------------------
  //State
  //----------------------------------------------------------------------
  logic [1:0] state_reg;
  logic [1:0] state_next;
  
  always_ff @(posedge clk) begin
    if(reset) begin
      state_reg <= STATE_IDLE;
    end
    else begin
      state_reg <= state_next;
    end
  end
  
  //----------------------------------------------------------------------
  //State Transitions
  //----------------------------------------------------------------------
  always_comb begin
    state_next = state_reg;
    case(state_reg)
	  STATE_IDLE: if(req_rdy && req_val)     state_next = STATE_CALC;
	  STATE_CALC: if(count >= 31)            state_next = STATE_DONE;
	  STATE_DONE: if(resp_rdy && resp_val)   state_next = STATE_IDLE;
	  default:                               state_next = 2'bxx;
    endcase
  end

  //----------------------------------------------------------------------
  //State Outputs
  //----------------------------------------------------------------------
  localparam b_x = 1'dx;
  localparam b_shift = 1'd0; //input from the shifter
  localparam b_req = 1'd1;   //input from the request
  
  localparam a_x = 1'dx;
  localparam a_shift = 1'd0; //input from the shifter
  localparam a_req = 1'd1;   //input from the request
  
  localparam res_x = 1'dx;
  localparam res_add = 1'd0; //input from the add_mux
  localparam res_0 = 1'd1;   //input 0
  
  localparam add_x = 1'dx;
  localparam add_add = 1'd0; //input from the adder
  localparam add_res = 1'd1; //input from the result_reg
  
  task cs
  (
    input logic                     cs_req_rdy,
    input logic                     cs_resp_val,
    input logic                     cs_b_mux_sel,
    input logic                     cs_a_mux_sel,
    input logic                     cs_result_mux_sel,
    input logic                     cs_add_mux_sel,
    input logic                     cs_result_en,
    input logic [p_count_nbits-1:0] cs_count_next,
  );
  begin
    req_rdy        = cs_req_rdy;
    resp_val       = cs_resp_val;
    b_mux_sel      = cs_b_mux_sel;
    a_mux_sel      = cs_a_mux_sel;
    result_mux_sel = cs_result_mux_sel;
    add_mux_sel    = cs_add_mux_sel;
    result_en      = cs_result_en;
    count_next     = cs_count_next;
  end
  endtask
  
  logic add_and_shift;
  logic shift_only;
  
  assign add_and_shift =  (b_lsb == 1);
  assign shift_only    =  (b_lsb == 0);
  
  always_comb begin
    case(state_reg)
      //             req  resp  b mux    a mux    res mux   add mux  result  count  
      //             rdy  val   sel      sel      sel       sel      en      next
      STATE_IDLE: cs(1,   0,    b_req,   a_req,   res_0,    add_res, 1,      0                  );
      STATE_CALC: if(add_and_shift)
                  cs(0,   0,    b_shift, a_shift, res_add,  add_add, 1,      count_plus_shifted );
                  else
                  cs(0,   0,    b_shift, a_shift, res_add,  add_res, 1,      count_plus_shifted );
      STATE_DONE: cs(0,   1,    b_x,     a_x,     res_x,    add_x,   0,      0                  );
      default:    cs('x, 'x,    b_x,     a_x,     res_x,    add_x,  'x,     'x                  );
    endcase
  end
  
endmodule

module lab1_imul_IntMulAltDpath
(
  input  logic        clk,
  input  logic        reset,

  // Data signals

  input  logic [63:0] req_msg,
  output logic [31:0] resp_msg,
  
  // Control signals
  
  input  logic        a_mux_sel,
  input  logic        b_mux_sel,
  input  logic        result_mux_sel,
  input  logic        result_en,
  input  logic        add_mux_sel,
  
  // Status signals
  
  output logic        b_lsb,
  output logic  [2:0] shift_bits
  
);
  
  localparam c_nbits = 32;
  
  // split out the input operand
  
  logic [c_nbits-1:0] req_msg_a = req_msg[63:32];
  logic [c_nbits-1:0] req_msg_b = req_msg[31:0];
  
  // B Mux 
  
  logic [c_nbits-1:0] b_shift_out;
  logic [c_nbits-1:0] b_mux_out;
  
  vc_Mux2#(c_nbits) b_mux
  (
    .sel  (b_mux_sel),
    .in1  (req_msg_b),
    .in0  (b_shift_out),
    .out  (b_mux_out)
  );
  
  // A Mux
  
  logic [c_nbits-1:0] a_shift_out;
  logic [c_nbits-1:0] a_mux_out;
  
  vc_Mux2#(c_nbits) a_mux
  (
    .sel  (a_mux_sel),
    .in1  (req_msg_a),
    .in0  (a_shift_out),
    .out  (a_mux_out)
  );
  
  // B Reg
  
  logic [c_nbits-1:0] b_reg_out;
  
  vc_Reg#(c_nbits) b_reg
  (
    .clk  (clk),
    .d    (b_mux_out),
    .q    (b_reg_out)
  ); 
  
  assign b_lsb = b_reg_out[0];
  
  // A Reg
  
  logic [c_nbits-1:0] a_reg_out;
  
  vc_Reg#(c_nbits) a_reg
  (
    .clk  (clk),
    .d    (a_mux_out),
    .q    (a_reg_out)
  ); 
  
  // 4-bit detector
  logic [3:0] number_4b;
  assign number_4b = b_reg_out[4:1];
  
  lab1_imul_ConsecZeroDetectorVRTL detector4b
  (
    .number_4b  (number_4b),
    .shift_bits (shift_bits)
  );
  
  // A left shift
  
  vc_LeftLogicalShifter#(c_nbits,3) a_shift
  (
    .in    (a_reg_out),
    .shamt (shift_bits),
    .out   (a_shift_out)
  );
  
  // B right shift
  
  vc_RightLogicalShifter#(c_nbits,3) b_shift
  (
    .in    (b_reg_out),
    .shamt (shift_bits),
    .out   (b_shift_out)
  );
  
  // Result mux 
  
  logic [c_nbits-1:0] add_mux_out;
  logic [c_nbits-1:0] result_mux_out;
  
  vc_Mux2#(c_nbits) result_mux
  (
    .sel  (result_mux_sel),
    .in0  (add_mux_out),
    .in1  (0),
    .out  (result_mux_out)
  );

  
  // Result reg
  
  logic [c_nbits-1:0] result_reg_out;
  
  vc_EnReg#(c_nbits) result_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (result_en),
    .d     (result_mux_out),
    .q     (result_reg_out)
  );
  
  // Adder
  
  logic [c_nbits-1:0] adder_out;
  
  vc_SimpleAdder#(c_nbits) adder0
  (
    .in0  (a_reg_out),
    .in1  (result_reg_out),
    .out  (adder_out)
  );
  
  // Adder_mux
  
  vc_Mux2#(c_nbits) add_mux
  (
    .sel   (add_mux_sel),
    .in0   (adder_out),
    .in1   (result_reg_out),
    .out   (add_mux_out)
  );
  
  // output
  
  assign resp_msg = result_reg_out;
  
endmodule


//=========================================================================
// Integer Multiplier Variable-Latency Implementation
//=========================================================================

module lab1_imul_IntMulAltVRTL
(
  input  logic        clk,
  input  logic        reset,

  input  logic        req_val,
  output logic        req_rdy,
  input  logic [63:0] req_msg,

  output logic        resp_val,
  input  logic        resp_rdy,
  output logic [31:0] resp_msg
);

  // ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // Instantiate datapath and control models here and then connect them
  // together.
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  //Control signals  
  logic b_mux_sel;
  logic a_mux_sel;
  logic result_mux_sel;
  logic add_mux_sel;
  logic result_en;
  
  //Data signals  
  logic       b_lsb;
  logic [2:0] shift_bits;
  
  lab1_imul_IntMulAltDpath dpath
  (
    .*
  );
  lab1_imul_IntMulAltCtrl ctrl
  (
    .*
  );
  
  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  logic [`VC_TRACE_NBITS-1:0] str;
  `VC_TRACE_BEGIN
  begin

    $sformat( str, "%x", req_msg );
    vc_trace.append_val_rdy_str( trace_str, req_val, req_rdy, str );

    vc_trace.append_str( trace_str, "(" );

    // ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // Add additional line tracing using the helper tasks for
    // internal state including the current FSM state.
    // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	vc_trace.append_str( trace_str, " shift_bits: " );
	$sformat( str, "%d", shift_bits );
	vc_trace.append_str( trace_str, str );
	vc_trace.append_str( trace_str, " count: " );
	$sformat( str, "%d", ctrl.count );
	vc_trace.append_str( trace_str, str );
	vc_trace.append_str( trace_str, " state_reg: " );
	$sformat( str, "%d", ctrl.state_reg );
	vc_trace.append_str( trace_str, str );
	vc_trace.append_str( trace_str, " result_reg_out: " );
	$sformat( str, "%d", dpath.result_reg_out );
	vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, ")" );

    $sformat( str, "%x", resp_msg );
    vc_trace.append_val_rdy_str( trace_str, resp_val, resp_rdy, str );

  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule

`endif /* LAB1_IMUL_INT_MUL_ALT_V */

`line 17 "lab2_proc/ProcAltDpathVRTL.v" 0

module lab2_proc_ProcAltDpathVRTL
#(
  parameter p_num_cores = 1
)
(
  input  logic        clk,
  input  logic        reset,

  input  logic [31:0] core_id,

  // Instruction Memory Port

  output logic [31:0]  imemreq_msg_addr,
  input  mem_resp_4B_t imemresp_msg,

  // Data Memory Port
  output logic        dmemreq_msg_type,
  output logic [31:0] dmemreq_msg_addr,
  output logic [31:0] dmemreq_msg_data,
  input  logic [31:0] dmemresp_msg_data,

  // mngr communication ports

  input  logic [31:0] mngr2proc_data,
  output logic [31:0] proc2mngr_data,

  // control signals (ctrl->dpath)

  output logic        imemresp_val_drop,
  input  logic        imemresp_rdy_drop,
  input  logic        imemresp_drop,

  input  logic        reg_en_F,
  input  logic [1:0]  pc_sel_F,

  input  logic        reg_en_D,
  input  logic        op1_sel_D,
  input  logic [1:0]  op2_sel_D,
  input  logic [1:0]  csrr_sel_D,
  input  logic [2:0]  imm_type_D,
  input  logic        imul_req_val_D,
  input  logic [1:0]  op1_byp_sel_D,
  input  logic [1:0]  op2_byp_sel_D, 

  input  logic        imul_resp_rdy_X, 
  input  logic        reg_en_X,
  input  logic [3:0]  alu_fn_X,
  input  logic [1:0]  ex_result_sel_X,
  input  logic [1:0]  dmemreq_type_X,

  input  logic        reg_en_M,
  input  logic        wb_result_sel_M,

  input  logic        reg_en_W,
  input  logic [4:0]  rf_waddr_W,
  input  logic        rf_wen_W,
  input  logic        stats_en_wen_W,

  // status signals (dpath->ctrl)

  output logic [31:0] inst_D,
  output logic        imul_req_rdy_D,
  
  output logic        imul_resp_val_X,  
  output logic        br_cond_eq_X,
  output logic        br_cond_lt_X, 
  output logic        br_cond_ltu_X,




  // stats output

  output logic        stats_en

);

  localparam c_reset_vector = 32'h200;
  localparam c_reset_inst   = 32'h00000000;

  // Fetch address

  assign imemreq_msg_addr = pc_next_F;

  //--------------------------------------------------------------------
  // F stage
  //--------------------------------------------------------------------

  logic [31:0] pc_F;
  logic [31:0] pc_next_F;
  logic [31:0] pc_plus4_F;
  logic [31:0] br_target_X;
  logic [31:0] jal_target_D;

  vc_EnResetReg #(32, c_reset_vector - 32'd4) pc_reg_F
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_F),
    .d      (pc_next_F),
    .q      (pc_F)
  );

  vc_Incrementer #(32, 4) pc_incr_F
  (
    .in   (pc_F),
    .out  (pc_plus4_F)
  );

  vc_Mux4 #(32) pc_sel_mux_F
  (
    .in0  (jalr_target_X),
    .in1  (br_target_X),
    .in2  (jal_target_D ),
    .in3  (pc_plus4_F),
    .sel  (pc_sel_F),
    .out  (pc_next_F)
  );

  //--------------------------------------------------------------------
  // D stage
  //--------------------------------------------------------------------

  logic  [31:0] pc_D;
  logic   [4:0] inst_rd_D;
  logic   [4:0] inst_rs1_D;
  logic   [4:0] inst_rs2_D;
  logic  [31:0] imm_D;

  vc_EnResetReg #(32) pc_reg_D
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_D),
    .d      (pc_F),
    .q      (pc_D)
  );

  vc_EnResetReg #(32, c_reset_inst) inst_D_reg
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_D),
    .d      (imemresp_msg.data),
    .q      (inst_D)
  );

  rv2isa_InstUnpack inst_unpack
  (
    .opcode   (),
    .inst     (inst_D),
    .rs1      (inst_rs1_D),
    .rs2      (inst_rs2_D),
    .rd       (inst_rd_D),
    .funct3   (),
    .funct7   (),
    .csr      ()
  );

  lab2_proc_ImmGenVRTL imm_gen_D
  (
    .imm_type (imm_type_D),
    .inst     (inst_D),
    .imm      (imm_D)
  );

  logic [31:0] rf_rdata0_D;
  logic [31:0] rf_rdata1_D;

  logic [31:0] rf_wdata_W;

  vc_Regfile_2r1w_zero rf
  (
    .clk      (clk),
    .reset    (reset),
    .rd_addr0 (inst_rs1_D),
    .rd_data0 (rf_rdata0_D),
    .rd_addr1 (inst_rs2_D),
    .rd_data1 (rf_rdata1_D),
    .wr_en    (rf_wen_W),
    .wr_addr  (rf_waddr_W),
    .wr_data  (rf_wdata_W)
  );

  // bypass sel mux
  logic [31:0] op1_byp_sel_out;
  logic [31:0] op2_byp_sel_out;
  logic [31:0] bypass_from_X;
  logic [31:0] bypass_from_M;
  logic [31:0] bypass_from_W;

  vc_Mux4 #(32) op1_byp_sel_mux_D
  (
    .in0  (rf_rdata0_D),
    .in1  (bypass_from_X), 
    .in2  (bypass_from_M),
    .in3  (bypass_from_W),
    .sel  (op1_byp_sel_D),
    .out  (op1_byp_sel_out)
  );

  vc_Mux4 #(32) op2_byp_sel_mux_D
  (
    .in0  (rf_rdata1_D),
    .in1  (bypass_from_X), 
    .in2  (bypass_from_M),
    .in3  (bypass_from_W),
    .sel  (op2_byp_sel_D),
    .out  (op2_byp_sel_out)
  );


  logic [31:0] op1_D;

  vc_Mux2 #(32) op1_sel_mux_D
  (
    .in0  (pc_D),
    .in1  (op1_byp_sel_out),
    .sel  (op1_sel_D),
    .out  (op1_D)
  );


  logic [31:0] op2_D;

  logic [31:0] csrr_data_D;

  logic [31:0] num_cores;
  assign num_cores = p_num_cores;

  // csrr data select mux
  vc_Mux3 #(32) csrr_sel_mux_D
  (
   .in0  (mngr2proc_data),
   .in1  (num_cores),
   .in2  (core_id),
   .sel  (csrr_sel_D),
   .out  (csrr_data_D)
  );

  // op2 select mux
  // This mux chooses among RS2, imm, and the output of the above csrr
  // csrr sel mux. Basically we are using two muxes here for pedagogy.
  vc_Mux3 #(32) op2_sel_mux_D
  (
    .in0  (imm_D),
    .in1  (op2_byp_sel_out),   //(rf_rdata1_D),  // need to change to the contest in the comment after the change is varified in simple design
    .in2  (csrr_data_D),
    .sel  (op2_sel_D),
    .out  (op2_D)
  );

  vc_Adder #(32) pc_plus_imm_D
  (
    .in0      (pc_D),
    .in1      (imm_D),
    .cin      (1'b0),
    .out      (jal_target_D),
    .cout     ()
  );

  //--------------------------------------------------------------------
  // X stage
  //--------------------------------------------------------------------

  logic [31:0] op1_X;
  logic [31:0] op2_X;
  logic [31:0] pc_X;
  
  vc_EnResetReg #(32, 0) op1_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (op1_D),
    .q      (op1_X)
  );

  vc_EnResetReg #(32, 0) op2_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (op2_D),
    .q      (op2_X)
  );

  vc_EnResetReg #(32, 0) br_target_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (jal_target_D),
    .q      (br_target_X)
  );

  vc_EnResetReg #(32, 0) pc_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (pc_D),
    .q      (pc_X)
  );

  vc_EnResetReg #(32, 0) dmem_write_data_reg_X
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_X),
    .d      (op2_byp_sel_out),
    .q      (dmemreq_msg_data)
  );

  logic [63:0] imul_req_msg_D;
  logic [31:0] imul_resp_msg_X;

  assign imul_req_msg_D = {op1_D,op2_D};

  lab1_imul_IntMulAltVRTL imul
  (
    .clk      (clk),
    .reset    (reset),
    
    //Control signals  
    .req_val  (imul_req_val_D),
    .req_rdy  (imul_req_rdy_D),
    .resp_val (imul_resp_val_X),
    .resp_rdy (imul_resp_rdy_X),
    
    //input and output 
    .req_msg  (imul_req_msg_D),
    .resp_msg (imul_resp_msg_X)
  );

  logic [31:0] pc_incr_out_X;

  vc_Incrementer #(32, 4) pc_incr_X 
  (
    .in(pc_X),
    .out(pc_incr_out_X)
  );

  logic [31:0] alu_result_X;
  logic [31:0] ex_result_X;
  logic [31:0] jalr_target_X;
  
  assign jalr_target_X = alu_result_X;
  
  lab2_proc_AluVRTL alu
  (
    .in0      (op1_X),
    .in1      (op2_X),
    .fn       (alu_fn_X),
    .out      (alu_result_X),
    .ops_eq   (br_cond_eq_X),
    .ops_lt   (br_cond_lt_X),
    .ops_ltu  (br_cond_ltu_X)
  );

  assign dmemreq_msg_addr = alu_result_X;

  vc_Mux3 #(32) ex_result_sel_mux_X
  (
    .in0  (pc_incr_out_X),
    .in1  (alu_result_X),
    .in2  (imul_resp_msg_X),
    .sel  (ex_result_sel_X),
    .out  (ex_result_X)
  );
  
  assign dmemreq_msg_type = dmemreq_type_X[0];
  
  assign bypass_from_X = ex_result_X;
  
  //--------------------------------------------------------------------
  // M stage
  //--------------------------------------------------------------------

  logic [31:0] ex_result_M;

  vc_EnResetReg #(32, 0) ex_result_reg_M
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_M),
    .d      (ex_result_X),
    .q      (ex_result_M)
  );

  logic [31:0] dmem_result_M;
  logic [31:0] wb_result_M;

  assign dmem_result_M = dmemresp_msg_data;

  vc_Mux2 #(32) wb_result_sel_mux_M
  (
    .in0    (ex_result_M),
    .in1    (dmem_result_M),
    .sel    (wb_result_sel_M),
    .out    (wb_result_M)
  );
  
  assign bypass_from_M = wb_result_M;

  //--------------------------------------------------------------------
  // W stage
  //--------------------------------------------------------------------

  logic [31:0] wb_result_W;

  vc_EnResetReg #(32, 0) wb_result_reg_W
  (
    .clk    (clk),
    .reset  (reset),
    .en     (reg_en_W),
    .d      (wb_result_M),
    .q      (wb_result_W)
  );

  assign proc2mngr_data = wb_result_W;

  assign rf_wdata_W = wb_result_W;
  
  assign bypass_from_W = wb_result_W;

  // stats output
  // note the stats en is full 32-bit here but the outside port is one
  // bit.

  logic [31:0] stats_en_W;

  assign stats_en = | stats_en_W;

  vc_EnResetReg #(32, 0) stats_en_reg_W
  (
   .clk    (clk),
   .reset  (reset),
   .en     (stats_en_wen_W),
   .d      (wb_result_W),
   .q      (stats_en_W)
  );


endmodule

`endif


`line 15 "lab2_proc/ProcAltVRTL.v" 0
`line 1 "lab2_proc/DropUnitVRTL.v" 0
//========================================================================
// Verilog Components: Drop Unit
//========================================================================
// Drop unit allows dropping a packet when the drop signal is high. This
// is useful especially in pipelined processor, when a squash should drop
// a late arriving memory response.

`ifndef VC_DROPUNIT_V
`define VC_DROPUNIT_V

module vc_DropUnit
#(
  parameter   p_msg_nbits = 1
)
(
  input  logic                   clk,
  input  logic                   reset,

  // the drop signal will drop the next arriving packet

  input  logic                   drop,

  input  logic [p_msg_nbits-1:0] in_msg,
  input  logic                   in_val,
  output logic                   in_rdy,

  output logic [p_msg_nbits-1:0] out_msg,
  output logic                   out_val,
  input  logic                   out_rdy
);

  localparam c_state_pass = 1'b0;
  localparam c_state_drop = 1'b1;

  logic state;
  logic next_state;
  logic in_go;

  assign in_go = in_rdy && in_val;

  // assign output message same as input message

  assign out_msg = in_msg;

  // next state

  always_comb begin
    if ( state == c_state_pass ) begin

      // we only go to drop state if there is a drop request and we cannot
      // drop it right away (!in_go)
      if ( drop && !in_go )
        next_state = c_state_drop;
      else
        next_state = c_state_pass;

    end else begin

      // if we are in the drop mode and a message arrives, we can go back
      // to pass state
      if ( in_go )
        next_state = c_state_pass;
      else
        next_state = c_state_drop;

    end
  end

  // state outputs

  always_comb begin
    if ( state == c_state_pass ) begin

      // we combinationally take care of dropping if the packet is already
      // available
      out_val = in_val && !drop;
      in_rdy  = out_rdy;

    end else begin

      // we just drop the packet
      out_val = 1'b0;
      in_rdy  = 1'b1;

    end
  end

  // state transitions

  always_ff @( posedge clk ) begin

    if ( reset )
      state <= c_state_pass;
    else
      state <= next_state;

  end

endmodule

`endif

`line 16 "lab2_proc/ProcAltVRTL.v" 0

module lab2_proc_ProcAltVRTL
#(
  parameter p_num_cores = 1
)
(
  input  logic         clk,
  input  logic         reset,

  // core_id is an input port rather than a parameter so that
  // the module only needs to be compiled once. If it were a parameter,
  // each core would be compiled separately.
  input  logic [31:0]  core_id,

  // From mngr streaming port

  input  logic [31:0]  mngr2proc_msg,
  input  logic         mngr2proc_val,
  output logic         mngr2proc_rdy,

  // To mngr streaming port

  output logic [31:0]  proc2mngr_msg,
  output logic         proc2mngr_val,
  input  logic         proc2mngr_rdy,

  // Instruction Memory Request Port

  output mem_req_4B_t  imemreq_msg,
  output logic         imemreq_val,
  input  logic         imemreq_rdy,

  // Instruction Memory Response Port

  input  mem_resp_4B_t imemresp_msg,
  input  logic         imemresp_val,
  output logic         imemresp_rdy,

  // Data Memory Request Port

  output mem_req_4B_t  dmemreq_msg,
  output logic         dmemreq_val,
  input  logic         dmemreq_rdy,

  // Data Memory Response Port

  input  mem_resp_4B_t dmemresp_msg,
  input  logic         dmemresp_val,
  output logic         dmemresp_rdy,

  // stats output

  output logic         commit_inst,

  output logic         stats_en

);

  //----------------------------------------------------------------------
  // data mem req/resp
  //----------------------------------------------------------------------

  // imemreq before pack

  logic [31:0] imemreq_msg_addr;

  // imemreq_enq signals after pack before bypass queue

  mem_req_4B_t imemreq_enq_msg;
  logic        imemreq_enq_val;
  logic        imemreq_enq_rdy;

  // dmem req before pack

  logic [31:0] dmemreq_msg_addr;
  logic        dmemreq_msg_type;
  logic [31:0] dmemreq_msg_data;

  // dmemreq after pack before bypass queue

  mem_req_4B_t dmemreq_enq_msg;
  logic        dmemreq_enq_val;
  logic        dmemreq_enq_rdy;

  // proc2mngr signals before bypass queue

  logic [31:0] proc2mngr_enq_msg;
  logic        proc2mngr_enq_val;
  logic        proc2mngr_enq_rdy;

  // imemresp signals after the drop unit

  logic        imemresp_val_drop;
  logic        imemresp_rdy_drop;

  // imemresp drop signal

  logic        imemresp_drop;

  // control signals (ctrl->dpath)

  logic        reg_en_F;
  logic [1:0]  pc_sel_F;

  logic        reg_en_D;
  logic        op1_sel_D;
  logic [1:0]  op2_sel_D;
  logic [1:0]  csrr_sel_D;
  logic [2:0]  imm_type_D;
  logic        imul_req_val_D;
  
  logic [1:0]  op1_byp_sel_D;
  logic [1:0]  op2_byp_sel_D;

  logic        reg_en_X;
  logic [3:0]  alu_fn_X;
  logic        imul_resp_rdy_X;
  logic [1:0]  ex_result_sel_X;
  logic [1:0]  dmemreq_type_X;

  logic        reg_en_M;
  logic        wb_result_sel_M;

  logic        reg_en_W;
  logic [4:0]  rf_waddr_W;
  logic        rf_wen_W;
  logic        stats_en_wen_W;

  // status signals (dpath->ctrl)

  logic [31:0] inst_D;
  logic        imul_req_rdy_D;
  logic        imul_resp_val_X;
  logic        br_cond_eq_X;
  logic        br_cond_ltu_X;
  logic        br_cond_lt_X;
  
  logic [7:0]  memreqCode;

  //----------------------------------------------------------------------
  // Pack Memory Request Messages
  //----------------------------------------------------------------------
  
  assign imemreq_enq_msg.type_  = `VC_MEM_REQ_MSG_TYPE_READ;
  assign imemreq_enq_msg.opaque = 8'b0;
  assign imemreq_enq_msg.addr   = imemreq_msg_addr;
  assign imemreq_enq_msg.len    = 2'd0;
  assign imemreq_enq_msg.data   = 32'bx;

  assign dmemreq_enq_msg.type_  = {2'b0 , dmemreq_msg_type};
  assign dmemreq_enq_msg.opaque = 8'b0;
  assign dmemreq_enq_msg.addr   = dmemreq_msg_addr;
  assign dmemreq_enq_msg.len    = 2'd0;
  assign dmemreq_enq_msg.data   = dmemreq_msg_data;

  //----------------------------------------------------------------------
  // Imem Drop Unit
  //----------------------------------------------------------------------

  mem_resp_4B_t imemresp_msg_drop;

  vc_DropUnit #($bits(mem_resp_4B_t)) imem_drop_unit
  (
    .clk      (clk),
    .reset    (reset),

    .drop     (imemresp_drop),

    .in_msg   (imemresp_msg),
    .in_val   (imemresp_val),
    .in_rdy   (imemresp_rdy),

    .out_msg  (imemresp_msg_drop),
    .out_val  (imemresp_val_drop),
    .out_rdy  (imemresp_rdy_drop)
  );

  //----------------------------------------------------------------------
  // Control Unit
  //----------------------------------------------------------------------

  lab2_proc_ProcAltCtrlVRTL ctrl
  (
    .clk                    (clk),
    .reset                  (reset),

    // Instruction Memory Port

    .imemreq_val            (imemreq_enq_val),
    .imemreq_rdy            (imemreq_enq_rdy),
    .imemresp_val           (imemresp_val_drop),
    .imemresp_rdy           (imemresp_rdy_drop),

    // Drop signal

    .imemresp_drop          (imemresp_drop),

    // Data Memory Port

    .dmemreq_val            (dmemreq_enq_val),
    .dmemreq_rdy            (dmemreq_enq_rdy),
    .dmemresp_val           (dmemresp_val),
    .dmemresp_rdy           (dmemresp_rdy),

    // mngr communication ports

    .mngr2proc_val          (mngr2proc_val),
    .mngr2proc_rdy          (mngr2proc_rdy),
    .proc2mngr_val          (proc2mngr_enq_val),
    .proc2mngr_rdy          (proc2mngr_enq_rdy),

    // control signals (ctrl->dpath)

    .reg_en_F               (reg_en_F),
    .pc_sel_F               (pc_sel_F),

    .reg_en_D               (reg_en_D),
    .op1_sel_D              (op1_sel_D),
    .op2_sel_D              (op2_sel_D),
    .csrr_sel_D             (csrr_sel_D),
    .imm_type_D             (imm_type_D),
    .imul_req_val_D         (imul_req_val_D),
    
    .op1_byp_sel_D          (op1_byp_sel_D),
    .op2_byp_sel_D          (op2_byp_sel_D),

    .reg_en_X               (reg_en_X),
    .alu_fn_X               (alu_fn_X),
    .imul_resp_rdy_X        (imul_resp_rdy_X),
    .ex_result_sel_X        (ex_result_sel_X),
    .dmemreq_type_X        (dmemreq_type_X),

    .reg_en_M               (reg_en_M),
    .wb_result_sel_M        (wb_result_sel_M),

    .reg_en_W               (reg_en_W),
    .rf_waddr_W             (rf_waddr_W),
    .rf_wen_W               (rf_wen_W),
    .stats_en_wen_W         (stats_en_wen_W),

    // status signals (dpath->ctrl)

    .inst_D                 (inst_D),
    .imul_req_rdy_D         (imul_req_rdy_D),
    .imul_resp_val_X        (imul_resp_val_X),
    .br_cond_eq_X           (br_cond_eq_X),
    .br_cond_lt_X           (br_cond_lt_X),
    .br_cond_ltu_X          (br_cond_ltu_X),

    .commit_inst            (commit_inst)
  );

  //----------------------------------------------------------------------
  // Bypass Queue
  //----------------------------------------------------------------------

  logic [1:0] imem_queue_num_free_entries;

  vc_Queue#(`VC_QUEUE_BYPASS,$bits(mem_req_4B_t),2) imem_queue
  (
    .clk     (clk),
    .reset   (reset),
    .num_free_entries(imem_queue_num_free_entries),
    .enq_val (imemreq_enq_val),
    .enq_rdy (imemreq_enq_rdy),
    .enq_msg (imemreq_enq_msg),
    .deq_val (imemreq_val),
    .deq_rdy (imemreq_rdy),
    .deq_msg (imemreq_msg)
  );

  logic dmem_queue_num_free_entries;

  vc_Queue#(`VC_QUEUE_BYPASS,$bits(mem_req_4B_t),1) dmem_queue
  (
    .clk     (clk),
    .reset   (reset),
    .num_free_entries(dmem_queue_num_free_entries),
    .enq_val (dmemreq_enq_val),
    .enq_rdy (dmemreq_enq_rdy),
    .enq_msg (dmemreq_enq_msg),
    .deq_val (dmemreq_val),
    .deq_rdy (dmemreq_rdy),
    .deq_msg (dmemreq_msg)
  );

  logic proc2mngr_queue_num_free_entries;

  vc_Queue#(`VC_QUEUE_BYPASS,32,1) proc2mngr_queue
  (
    .clk     (clk),
    .reset   (reset),
    .num_free_entries(proc2mngr_queue_num_free_entries),
    .enq_val (proc2mngr_enq_val),
    .enq_rdy (proc2mngr_enq_rdy),
    .enq_msg (proc2mngr_enq_msg),
    .deq_val (proc2mngr_val),
    .deq_rdy (proc2mngr_rdy),
    .deq_msg (proc2mngr_msg)
  );

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  lab2_proc_ProcAltDpathVRTL
  #(
    .p_num_cores             (p_num_cores)
  )
  dpath
  (
    .clk                     (clk),
    .reset                   (reset),

    // core id
    .core_id                 (core_id),

    // Instruction Memory Port

    .imemreq_msg_addr        (imemreq_msg_addr),
    .imemresp_msg            (imemresp_msg_drop),

    // Data Memory Port

    .dmemreq_msg_addr        (dmemreq_msg_addr),
    .dmemreq_msg_data        (dmemreq_msg_data),
    .dmemresp_msg_data       (dmemresp_msg.data),
    .dmemreq_msg_type        (dmemreq_msg_type),

    // mngr communication ports

    .mngr2proc_data          (mngr2proc_msg),
    .proc2mngr_data          (proc2mngr_enq_msg),

    // control signals (ctrl->dpath)

    .imemresp_val_drop       (imemresp_val_drop),
    .imemresp_rdy_drop       (imemresp_rdy_drop),
    .imemresp_drop           (imemresp_drop),

    .reg_en_F                (reg_en_F),
    .pc_sel_F                (pc_sel_F),

    .reg_en_D                (reg_en_D),
    .op1_sel_D               (op1_sel_D),
    .op2_sel_D               (op2_sel_D),
    .csrr_sel_D              (csrr_sel_D),
    .imm_type_D              (imm_type_D),
    .imul_req_val_D          (imul_req_val_D),
  
    .op1_byp_sel_D           (op1_byp_sel_D),
    .op2_byp_sel_D           (op2_byp_sel_D),

    .imul_resp_rdy_X         (imul_resp_rdy_X),
    .reg_en_X                (reg_en_X),
    .alu_fn_X                (alu_fn_X),
    .ex_result_sel_X         (ex_result_sel_X),
    .dmemreq_type_X          (dmemreq_type_X),
    

    .reg_en_M                (reg_en_M),
    .wb_result_sel_M         (wb_result_sel_M),

    .reg_en_W                (reg_en_W),
    .rf_waddr_W              (rf_waddr_W),
    .rf_wen_W                (rf_wen_W),
    .stats_en_wen_W          (stats_en_wen_W),

    // status signals (dpath->ctrl)

    .inst_D                  (inst_D),
    .imul_req_rdy_D          (imul_req_rdy_D),
    .imul_resp_val_X         (imul_resp_val_X),
    .br_cond_eq_X            (br_cond_eq_X),
    .br_cond_lt_X            (br_cond_lt_X),
    .br_cond_ltu_X           (br_cond_ltu_X),

    // stats_en

    .stats_en                (stats_en)
  );

  //----------------------------------------------------------------------
  // Line tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  rv2isa_InstTasks rv2isa();

  logic [`VC_TRACE_NBITS-1:0] str;
  `VC_TRACE_BEGIN
  begin

    if ( !ctrl.val_F )
      vc_trace.append_chars( trace_str, " ", 8 );
    else if ( ctrl.squash_F ) begin
      vc_trace.append_str( trace_str, "~" );
      vc_trace.append_chars( trace_str, " ", 8-1 );
    end else if ( ctrl.stall_F ) begin
      vc_trace.append_str( trace_str, "#" );
      vc_trace.append_chars( trace_str, " ", 8-1 );
    end else begin
      $sformat( str, "%x", dpath.pc_F );
      vc_trace.append_str( trace_str, str );
    end

    vc_trace.append_str( trace_str, "|" );

    if ( !ctrl.val_D )
      vc_trace.append_chars( trace_str, " ", 23 );
    else if ( ctrl.squash_D ) begin
      vc_trace.append_str( trace_str, "~" );
      vc_trace.append_chars( trace_str, " ", 23-1 );
    end else if ( ctrl.stall_D ) begin
      vc_trace.append_str( trace_str, "#" );
      vc_trace.append_chars( trace_str, " ", 23-1 );
    end else
      vc_trace.append_str( trace_str, { 3896'b0, rv2isa.disasm( ctrl.inst_D ) } );

    vc_trace.append_str( trace_str, "|" );

    if ( !ctrl.val_X )
      vc_trace.append_chars( trace_str, " ", 4 );
    else if ( ctrl.stall_X ) begin
      vc_trace.append_str( trace_str, "#" );
      vc_trace.append_chars( trace_str, " ", 4-1 );
    end else
      vc_trace.append_str( trace_str, { 4064'b0, rv2isa.disasm_tiny( ctrl.inst_X ) } );

    vc_trace.append_str( trace_str, "|" );

    if ( !ctrl.val_M )
      vc_trace.append_chars( trace_str, " ", 4 );
    else if ( ctrl.stall_M ) begin
      vc_trace.append_str( trace_str, "#" );
      vc_trace.append_chars( trace_str, " ", 4-1 );
    end else
      vc_trace.append_str( trace_str, { 4064'b0, rv2isa.disasm_tiny( ctrl.inst_M ) } );

    vc_trace.append_str( trace_str, "|" );

    if ( !ctrl.val_W )
      vc_trace.append_chars( trace_str, " ", 4 );
    else if ( ctrl.stall_W ) begin
      vc_trace.append_str( trace_str, "#" );
      vc_trace.append_chars( trace_str, " ", 4-1 );
    end else
      vc_trace.append_str( trace_str, { 4064'b0, rv2isa.disasm_tiny( ctrl.inst_W ) } );

  end
  `VC_TRACE_END

  vc_MemReqMsg4BTrace imemreq_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (imemreq_val),
    .rdy   (imemreq_rdy),
    .msg   (imemreq_msg)
  );

  vc_MemReqMsg4BTrace dmemreq_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (dmemreq_val),
    .rdy   (dmemreq_rdy),
    .msg   (dmemreq_msg)
  );

  vc_MemRespMsg4BTrace imemresp_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (imemresp_val),
    .rdy   (imemresp_rdy),
    .msg   (imemresp_msg)
  );

  vc_MemRespMsg4BTrace dmemresp_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (dmemresp_val),
    .rdy   (dmemresp_rdy),
    .msg   (dmemresp_msg)
  );

  `endif

endmodule

`endif


`line 12 "lab5_mcore/SingleCoreVRTL.v" 0
`line 1 "lab3_mem/BlockingCacheAltVRTL.v" 0
//=========================================================================
// Alternative Blocking Cache
//=========================================================================

`ifndef LAB3_MEM_BLOCKING_CACHE_ALT_V
`define LAB3_MEM_BLOCKING_CACHE_ALT_V

`line 1 "vc/mem-msgs.v" 0
//========================================================================
// vc-mem-msgs : Memory Request/Response Messages
//========================================================================
// The memory request/response messages are used to interact with various
// memories. They are parameterized by the number of bits in the address,
// data, and opaque field.

`ifndef VC_MEM_MSGS_V
`define VC_MEM_MSGS_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 12 "vc/mem-msgs.v" 0

//========================================================================
// Memory Request Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// requests include an opaque field, the address, and the number of bytes
// to read, while write requests include an opaque field, the address,
// the number of bytes to write, and the actual data to write.
//
// Message Format:
//
//    3b    p_opaque_nbits  p_addr_nbits       calc   p_data_nbits
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field, address field, and data field. Note that the size of the length
// field is caclulated from the number of bits in the data field, and
// that the length field is expressed in _bytes_. If the value of the
// length field is zero, then the read or write should be for the full
// width of the data field.
//
// For example, if the opaque field is 8 bits, the address is 32 bits and
// the data is also 32 bits, then the message format is as follows:
//
//   76  74 73           66 65              34 33  32 31               0
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The length field is two bits. A length value of one means read or write
// a single byte, a length value of two means read or write two bytes, and
// so on. A length value of zero means read or write all four bytes. Note
// that not all memories will necessarily support any alignment and/or any
// value for the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [1:0]  len;
  logic [31:0] data;
} mem_req_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [3:0]  len;
  logic [127:0] data;
} mem_req_16B_t;

// memory request type values
`define VC_MEM_REQ_MSG_TYPE_READ     3'd0
`define VC_MEM_REQ_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_REQ_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_REQ_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_REQ_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_REQ_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_REQ_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Request Message: Trace message
//------------------------------------------------------------------------

module vc_MemReqMsg4BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_4B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_4B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemReqMsg16BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_16B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_16B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

//========================================================================
// Memory Response Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// responses include an opaque field, the actual data, and the number of
// bytes, while write responses currently include just the opaque field.
//
// Message Format:
//
//    3b    p_opaque_nbits   2b    calc   p_data_nbits
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field and data field. Note that the size of the length field is
// caclulated from the number of bits in the data field, and that the
// length field is expressed in _bytes_. If the value of the length field
// is zero, then the read or write should be for the full width of the
// data field.
//
// For example, if the opaque field is 8 bits and the data is 32 bits,
// then the message format is as follows:
//
//   46  44 43           36 35  34 33  32 31               0
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The length field is two bits. A length value of one means one byte was
// read, a length value of two means two bytes were read, and so on. A
// length value of zero means all four bytes were read. Note that not all
// memories will necessarily support any alignment and/or any value for
// the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [1:0]  len;
  logic [31:0] data;
} mem_resp_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [3:0]  len;
  logic [127:0] data;
} mem_resp_16B_t;

// Values for the type field

`define VC_MEM_RESP_MSG_TYPE_READ     3'd0
`define VC_MEM_RESP_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_RESP_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_RESP_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_RESP_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_RESP_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_RESP_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Response Message: Trace message
//------------------------------------------------------------------------

module vc_MemRespMsg4BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_4B_t  msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_4B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemRespMsg16BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_16B_t msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0] data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_16B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

`endif /* VC_MEM_MSGS_V */


`line 9 "lab3_mem/BlockingCacheAltVRTL.v" 0
`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 10 "lab3_mem/BlockingCacheAltVRTL.v" 0

`line 1 "lab3_mem/BlockingCacheAltCtrlVRTL.v" 0
//=========================================================================
// Alternative Blocking Cache Control Unit
//=========================================================================

`ifndef LAB3_MEM_BLOCKING_CACHE_ALT_CTRL_V
`define LAB3_MEM_BLOCKING_CACHE_ALT_CTRL_V

`line 1 "vc/mem-msgs.v" 0
//========================================================================
// vc-mem-msgs : Memory Request/Response Messages
//========================================================================
// The memory request/response messages are used to interact with various
// memories. They are parameterized by the number of bits in the address,
// data, and opaque field.

`ifndef VC_MEM_MSGS_V
`define VC_MEM_MSGS_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 12 "vc/mem-msgs.v" 0

//========================================================================
// Memory Request Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// requests include an opaque field, the address, and the number of bytes
// to read, while write requests include an opaque field, the address,
// the number of bytes to write, and the actual data to write.
//
// Message Format:
//
//    3b    p_opaque_nbits  p_addr_nbits       calc   p_data_nbits
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field, address field, and data field. Note that the size of the length
// field is caclulated from the number of bits in the data field, and
// that the length field is expressed in _bytes_. If the value of the
// length field is zero, then the read or write should be for the full
// width of the data field.
//
// For example, if the opaque field is 8 bits, the address is 32 bits and
// the data is also 32 bits, then the message format is as follows:
//
//   76  74 73           66 65              34 33  32 31               0
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The length field is two bits. A length value of one means read or write
// a single byte, a length value of two means read or write two bytes, and
// so on. A length value of zero means read or write all four bytes. Note
// that not all memories will necessarily support any alignment and/or any
// value for the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [1:0]  len;
  logic [31:0] data;
} mem_req_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [3:0]  len;
  logic [127:0] data;
} mem_req_16B_t;

// memory request type values
`define VC_MEM_REQ_MSG_TYPE_READ     3'd0
`define VC_MEM_REQ_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_REQ_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_REQ_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_REQ_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_REQ_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_REQ_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Request Message: Trace message
//------------------------------------------------------------------------

module vc_MemReqMsg4BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_4B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_4B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemReqMsg16BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_16B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_16B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

//========================================================================
// Memory Response Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// responses include an opaque field, the actual data, and the number of
// bytes, while write responses currently include just the opaque field.
//
// Message Format:
//
//    3b    p_opaque_nbits   2b    calc   p_data_nbits
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field and data field. Note that the size of the length field is
// caclulated from the number of bits in the data field, and that the
// length field is expressed in _bytes_. If the value of the length field
// is zero, then the read or write should be for the full width of the
// data field.
//
// For example, if the opaque field is 8 bits and the data is 32 bits,
// then the message format is as follows:
//
//   46  44 43           36 35  34 33  32 31               0
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The length field is two bits. A length value of one means one byte was
// read, a length value of two means two bytes were read, and so on. A
// length value of zero means all four bytes were read. Note that not all
// memories will necessarily support any alignment and/or any value for
// the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [1:0]  len;
  logic [31:0] data;
} mem_resp_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [3:0]  len;
  logic [127:0] data;
} mem_resp_16B_t;

// Values for the type field

`define VC_MEM_RESP_MSG_TYPE_READ     3'd0
`define VC_MEM_RESP_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_RESP_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_RESP_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_RESP_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_RESP_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_RESP_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Response Message: Trace message
//------------------------------------------------------------------------

module vc_MemRespMsg4BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_4B_t  msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_4B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemRespMsg16BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_16B_t msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0] data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_16B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

`endif /* VC_MEM_MSGS_V */


`line 9 "lab3_mem/BlockingCacheAltCtrlVRTL.v" 0
`line 1 "vc/assert.v" 0
//========================================================================
// vc-Assert
//========================================================================

`ifndef VC_ASSERT_V
`define VC_ASSERT_V

//------------------------------------------------------------------------
// VC_PROPAGATE_X
//------------------------------------------------------------------------

`define VC_PROPAGATE_X( i_, o_ )                                        \
  if ((|(i_ ^ i_)) == 1'b0);                                            \
  else                                                                  \
    o_ = o_ + 1'bx

//------------------------------------------------------------------------
// VC_ASSERT
//------------------------------------------------------------------------

`define VC_ASSERT( expr_ )                                              \
  if ( expr_ );                                                         \
  else begin                                                            \
    $display( "\n VC_ASSERT FAILED\n  - assertion       :%s\n  - module instance : %m\n  - time            : %0d\n", \
              "expr_", $time );                                         \
    $finish;                                                            \
  end                                                                   \
  if (1)

//------------------------------------------------------------------------
// VC_ASSERT_FAIL
//------------------------------------------------------------------------

`define VC_ASSERT_FAIL( msg_ )                                         \
  $display( "\n VC_ASSERT FAILED\n  - assertion       :%s\n  - module instance : %m\n  - time            : %0d\n", \
            msg_, $time );                                             \
  $finish;                                                             \
  if (1)

//------------------------------------------------------------------------
// VC_ASSERT_NOT_X
//------------------------------------------------------------------------

`define VC_ASSERT_NOT_X( net_ )                                         \
  if ((|(net_ ^ net_)) == 1'b0);                                        \
  else begin                                                            \
    $display( "\n VC_ASSERT FAILED\n  - assertion that net not contain X's failed\n  - module instance : %m\n  - net             :%s\n  - time            : %0d\n", \
              "net_", $time );                                          \
    $finish;                                                            \
  end                                                                   \
  if (1)

`endif /* VC_ASSERT_V */


`line 10 "lab3_mem/BlockingCacheAltCtrlVRTL.v" 0

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

module lab3_mem_BlockingCacheAltCtrlVRTL
#(
  parameter p_idx_shamt    = 0
)
(
  input  logic                        clk,
  input  logic                        reset,

  // Cache Request

  input  logic                        cachereq_val,
  output logic                        cachereq_rdy,

  // Cache Response

  output logic                        cacheresp_val,
  input  logic                        cacheresp_rdy,

  // Memory Request

  output logic                        memreq_val,
  input  logic                        memreq_rdy,

  // Memory Response

  input  logic                        memresp_val,
  output logic                        memresp_rdy,

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Add control signals
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // ------------- Control signals CTRL -> Data Path ------------------ //
  
  // Cache request & memory response interface
  output logic                        cachereq_en,
  output logic                        memresp_en,
  // Mux signal
  output logic                        write_data_mux_sel,
  // Array enable signals
  output logic                        tag_array_ren,
  output logic                        tag_array_wen0,
  output logic                        tag_array_wen1,  
  output logic                        data_array_ren,
  output logic                        data_array_wen,
  output logic [15:0]                 data_array_wben,
  // reg enables and mux signals after arrays
  output logic                        read_data_mux_sel,
  output logic                        read_data_reg_en,
  output logic                        evict_addr_reg_en,
  output logic [1:0]                  read_word_mux_sel,
  output logic                        memreq_addr_mux_sel,
  // Cache response & memory request interface
  output logic [2:0]                  cacheresp_type,
  output logic                        hit,
  output logic [2:0]                  memreq_type,
  output logic                        cacheresp_data_mux_sel, 
  output logic                        mkaddr_mux_sel,   
  output logic                        victim,
  // ------------- Control signals Data Path -> CTRL ------------------ //
  // Cache request & memory response interface
  input logic [2:0]                   cachereq_type,
  // Addr signal
  input logic [31:0]                  cachereq_addr,
  // tag_match
  input  logic                        tag_match0,
  input  logic                        tag_match1,
  // Index
  input  logic [2:0]                  idx
 );

  // local parameters not meant to be set from outside
  localparam size = 256;             // Cache size in bytes
  localparam dbw  = 32;              // Short name for data bitwidth
  localparam abw  = 32;              // Short name for addr bitwidth
  localparam o    = 8;               // Short name for opaque bitwidth
  localparam clw  = 128;             // Short name for cacheline bitwidth
  localparam nbl  = size*8/clw;      // Number of blocks in the cache
  localparam nby  = nbl/2;           // Number of blocks per way
  localparam idw  = $clog2(nby);     // Short name for index bitwidth
  localparam ofw  = $clog2(clw/8);   // Short name for the offset bitwidth
  // In this lab, to simplify things, we always use all bits except for the
  // offset in the tag, rather than storing the "normal" 24 bits. This way,
  // when implementing a multi-banked cache, we don't need to worry about
  // re-inserting the bank id into the address of a cacheline.
  localparam tgw  = abw - ofw;       // Short name for the tag bitwidth

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Implement Control Unit
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  //----------------------------------------------------------------------
  //Valid & Dirty Handling, Hit reg, Victim, Used
  //----------------------------------------------------------------------
  
  // valid
  logic [7:0]  valid0;
  logic [7:0]  valid_next0;
  logic [7:0]  valid1;
  logic [7:0]  valid_next1;
  logic        valid_act;
  // dirty
  logic [7:0]  dirty0;
  logic [7:0]  dirty_next0;
  logic [7:0]  dirty1;
  logic [7:0]  dirty_next1;
  logic [1:0]  dirty_act;
  // hit
  logic        hit0;
  logic        hit_next0;
  logic        hit1;
  logic        hit_next1;
  logic        hit_act;
  // victim
  logic        victim;
  logic        victim_next;
  logic        victim_act;
  // used
  logic [7:0]  used;
  logic [7:0]  used_next;
  logic        used_act;
  
  

  always_comb begin
    // valid
    valid_next0 = (valid_act && vtm0) ? (valid0 | idx_line) : valid0;
    valid_next1 = (valid_act && vtm1) ? (valid1 | idx_line) : valid1;
    // hit
    hit_next0   = hit_act   ? hit_val0 : hit0;
    hit_next1   = hit_act   ? hit_val1 : hit1;
    // dirty way0
    if      (dirty_act == d_mark  && vtm0)  dirty_next0 = dirty0 | idx_line ;
    else if (dirty_act == d_keep  && vtm0)  dirty_next0 = dirty0;
    else if (dirty_act == d_clean && vtm0)  dirty_next0 = dirty0 & (idx_line ^ 8'hff);
    // dirty way1
    if      (dirty_act == d_mark  && vtm1)  dirty_next1 = dirty1 | idx_line ;
    else if (dirty_act == d_keep  && vtm1)  dirty_next1 = dirty1;
    else if (dirty_act == d_clean && vtm1)  dirty_next1 = dirty1 & (idx_line ^ 8'hff);
    // victim
    if(victim_act) begin
      if(hit_val0 && tag_match0)      victim_next    = 0;
      else if(hit_val1 && tag_match1) victim_next    = 1;
      else                            victim_next    = !used[idx];
     end
     else                             victim_next    = victim;
  end 
  
  assign hit = hit0 || hit1;
  assign used_next[idx] = used_act ? victim : used[idx]; 
    
  always_ff @(posedge clk) begin
    if(reset) begin
      valid0     <= 8'd0;
      valid1     <= 8'd0;
      dirty0     <= 8'd0;
      dirty1     <= 8'd0;
      hit0       <= 1'b0;
      hit1       <= 1'b0;
      victim     <= 1'b0;
      used       <= 8'd0;
    end
    else begin
      valid0     <= valid_next0;
      valid1     <= valid_next1;
      dirty0     <= dirty_next0;
      dirty1     <= dirty_next1;
      hit0       <= hit_next0;
      hit1       <= hit_next1;
      victim     <= victim_next;
      used       <= used_next;
    end
  end    
  
  // parameters for states
  localparam STATE_IDLE               = 4'd0;
  localparam STATE_TAG_CHECK          = 4'd1;
  localparam STATE_INIT_DATA_ACCESS   = 4'd2;
  localparam STATE_WAIT               = 4'd3;
  localparam STATE_READ_DATA_ACCESS   = 4'd4;
  localparam STATE_WRITE_DATA_ACCESS  = 4'd5;
  localparam STATE_REFILL_REQUEST     = 4'd6;
  localparam STATE_REFILL_WAIT        = 4'd7;
  localparam STATE_REFILL_UPDATE      = 4'd8;
  localparam STATE_EVICT_PREPARE      = 4'd9;
  localparam STATE_EVICT_REQUEST      = 4'd10;
  localparam STATE_EVICT_WAIT         = 4'd11;

  //----------------------------------------------------------------------
  //State
  //----------------------------------------------------------------------
  
  logic [3:0]  state_reg;
  logic [3:0]  state_next;

  always_ff @(posedge clk) begin
    if(reset) begin
      state_reg <= STATE_IDLE;
    end
    else begin
      state_reg <= state_next;
    end
  end
  
  //----------------------------------------------------------------------
  //State Transitions
  //----------------------------------------------------------------------
  
  always_comb begin
    state_next = state_reg;
    case(state_reg)
      STATE_IDLE:               if(cachereq_val)                            state_next = STATE_TAG_CHECK;
                                else                                        state_next = STATE_IDLE;
      STATE_TAG_CHECK:          if(cachereq_type == mem_init)               state_next = STATE_INIT_DATA_ACCESS;
                                else if((hit_val0 || hit_val1) && cachereq_type == mem_rd) 
                                                                            state_next = STATE_READ_DATA_ACCESS;
                                else if((hit_val0 || hit_val1) && cachereq_type == mem_wr) 
                                                                            state_next = STATE_WRITE_DATA_ACCESS;
                                else if((!dirty0[idx] && victim_next == 0) || (!dirty1[idx] && victim_next == 1))                        
                                                                            state_next = STATE_REFILL_REQUEST;
                                else if((dirty0[idx] && victim_next == 0)  || (dirty1[idx] && victim_next == 1))                         
                                                                            state_next = STATE_EVICT_PREPARE;
                                else                                        state_next = STATE_TAG_CHECK;     
      
      STATE_INIT_DATA_ACCESS:   if(cacheresp_rdy)                           
                                begin
                                  if(cachereq_val)                          state_next = STATE_TAG_CHECK;
                                  else                                      state_next = STATE_IDLE;
                                end
                                else                                        state_next = STATE_INIT_DATA_ACCESS;
                                
      STATE_READ_DATA_ACCESS:   if(cacheresp_rdy)                           
                                begin
                                  if(cachereq_val)                          state_next = STATE_TAG_CHECK;
                                  else                                      state_next = STATE_IDLE;
                                end
                                else                                        state_next = STATE_READ_DATA_ACCESS;                                            
      
      STATE_WRITE_DATA_ACCESS:  if(cacheresp_rdy)                           
                                begin
                                  if(cachereq_val)                          state_next = STATE_TAG_CHECK;
                                  else                                      state_next = STATE_IDLE;
                                end
                                else                                        state_next = STATE_WRITE_DATA_ACCESS;
      
      STATE_REFILL_REQUEST:     if(memreq_rdy)                              state_next = STATE_REFILL_WAIT;
                                else                                        state_next = STATE_REFILL_REQUEST;                          
      STATE_REFILL_WAIT:        if(memresp_val)                             state_next = STATE_REFILL_UPDATE;
                                else                                        state_next = STATE_REFILL_WAIT;
      STATE_REFILL_UPDATE:      if(cachereq_type      == mem_rd)            state_next = STATE_READ_DATA_ACCESS;
                                else if(cachereq_type == mem_wr)            state_next = STATE_WRITE_DATA_ACCESS;
                                else                                        state_next = STATE_REFILL_UPDATE; 
      STATE_EVICT_PREPARE:                                                  state_next = STATE_EVICT_REQUEST;
      STATE_EVICT_REQUEST:      if(memreq_rdy)                              state_next = STATE_EVICT_WAIT;
                                else                                        state_next = STATE_EVICT_REQUEST;
      STATE_EVICT_WAIT:         if(memresp_val)                             state_next = STATE_REFILL_REQUEST;
                                else                                        state_next = STATE_EVICT_WAIT;      
      default:                                                              state_next = 4'bxxxx;
    endcase
  end

  //----------------------------------------------------------------------
  //State Outputs
  //----------------------------------------------------------------------
  
  // ----------------------- Local Parameters ------------------------- //
  localparam wd_mux_rp   = 1'b0;
  localparam wd_mux_reg  = 1'b1;
  localparam wd_mux_x    = 1'bx;

  localparam rw_mux_w3   = 2'b11;
  localparam rw_mux_w2   = 2'b10;
  localparam rw_mux_w1   = 2'b01;
  localparam rw_mux_w0   = 2'b00;
  localparam rw_mux_x    = 2'bxx;

  localparam mm_mux_reg  = 1'b0;
  localparam mm_mux_mk   = 1'b1;
  localparam mm_mux_x    = 1'bx;

  localparam mem_init    = 3'd2;
  localparam mem_rd      = 3'd0;
  localparam mem_wr      = 3'd1;
  localparam mem_x       = 3'dx;

  localparam gnd         = 1'b0;
  localparam resp_data   = 1'b1;
  localparam dmux_x      = 1'bx;
  
  localparam rd_array    = 1'b0;
  localparam rd_reg      = 1'b1;

  localparam w_line      = 16'hffff;
  localparam w_word0     = 16'h000f;
  localparam w_word1     = 16'h00f0;
  localparam w_word2     = 16'h0f00;
  localparam w_word3     = 16'hf000;
  localparam w_none      = 16'h0000;
  localparam w_wordx     = 16'dx;  
  
  localparam keep        = 1'b0;
  localparam mark        = 1'b1;
  
  localparam d_clean     = 2'b00;
  localparam d_keep      = 2'b01;
  localparam d_mark      = 2'b10;
  
  task cs
  (
    // control signal table inputs
    input logic        cs_cachereq_en,
    input logic        cs_memresp_en,
    // Mux signal
    input logic        cs_write_data_mux_sel,
    // Array enable signals
    input logic        cs_tag_array_ren,
    input logic        cs_tag_array_wen0,
    input logic        cs_tag_array_wen1,
    input logic        cs_data_array_ren,
    input logic        cs_data_array_wen,
    input logic [15:0] cs_data_array_wben,
    // reg enables and mux signals after arrays
    input logic        cs_read_data_mux_sel,
    input logic        cs_read_data_reg_en,
    input logic        cs_evict_addr_reg_en,
    input logic [1:0]  cs_read_word_mux_sel,
    input logic        cs_memreq_addr_mux_sel,
    // Cache response & memory request interface
    input logic [2:0]  cs_cacheresp_type,
    input logic        cs_hit_act,
    input logic [2:0]  cs_memreq_type,
    input logic        cs_cachereq_rdy,
    input logic        cs_cacheresp_val,
    input logic        cs_memreq_val,
    input logic        cs_memresp_rdy,
    input logic        cs_cacheresp_data_mux_sel,
    // Valid & Dirty
    input logic        cs_valid_act,
    input logic [1:0]  cs_dirty_act,
    input logic        cs_victim_act,
    input logic        cs_used_act,
    input logic        cs_mkaddr_mux_sel
  );
  begin
    // blocking assignment
    // Cache request & memory response interface
    cachereq_en            = cs_cachereq_en;
    memresp_en             = cs_memresp_en;
    // Mux signal
    write_data_mux_sel     = cs_write_data_mux_sel;
    // Array enable signals
    tag_array_ren          = cs_tag_array_ren;
    tag_array_wen0         = cs_tag_array_wen0;
    tag_array_wen1         = cs_tag_array_wen1;
    data_array_ren         = cs_data_array_ren;
    data_array_wen         = cs_data_array_wen;
    data_array_wben        = cs_data_array_wben;
    // reg enables and mux signals after arrays
    read_data_mux_sel      = cs_read_data_mux_sel;
    read_data_reg_en       = cs_read_data_reg_en;
    evict_addr_reg_en      = cs_evict_addr_reg_en;
    read_word_mux_sel      = cs_read_word_mux_sel;
    memreq_addr_mux_sel    = cs_memreq_addr_mux_sel;
    // Cache response & memory request interface
    cacheresp_type         = cs_cacheresp_type;
    hit_act                = cs_hit_act;
    memreq_type            = cs_memreq_type;
    // val&rdy interface
    cachereq_rdy           = cs_cachereq_rdy;
    cacheresp_val          = cs_cacheresp_val;
    memreq_val             = cs_memreq_val;
    memresp_rdy            = cs_memresp_rdy;
    // Cache response data mux sel
    cacheresp_data_mux_sel = cs_cacheresp_data_mux_sel;
    // Valid & Dirty
    valid_act              = cs_valid_act;
    dirty_act              = cs_dirty_act;
    // Victim
    victim_act             = cs_victim_act; 
    // Use
    used_act               = cs_used_act;
    // makeaddr_mux_sel
    mkaddr_mux_sel         = cs_mkaddr_mux_sel;      
  end
  endtask
  
  // Helper Combinational logics
  logic [15:0] w_byte_en;
  logic [7:0]  idx_line;
  logic [2:0]  crq_t;
  logic        rsp_is_rd;
  logic        req_is_wr;
  logic        req_not_init;
  logic [1:0]  offset;
  logic        hit_val0;
  logic        hit_val1;
  logic        vtm0;
  logic        vtm1;
  logic        eot;

  always_comb begin
    if     (offset == 2'b00) w_byte_en = 16'h000f;
    else if(offset == 2'b01) w_byte_en = 16'h00f0;
    else if(offset == 2'b10) w_byte_en = 16'h0f00;
    else                     w_byte_en = 16'hf000;
  end

  assign  idx_line      = (8'd1    << idx);
  assign  crq_t         = cachereq_type;
  assign  offset        = cachereq_addr[3:2];
  assign  rsp_is_rd     = (cacheresp_type == mem_rd) ? resp_data : gnd;
  assign  req_is_wr     = (cachereq_type  == mem_wr);
  assign  req_not_init  = (cachereq_type  != mem_init);    
  assign  hit_val0      = tag_match0 && req_not_init && valid0[idx];
  assign  hit_val1      = tag_match1 && req_not_init && valid1[idx];
  assign  vtm0          = (victim == 0);
  assign  vtm1          = (victim == 1);
  // end of transcation
  assign  eot           = cacheresp_rdy && cacheresp_val;
  
  
  always_comb begin
    case(state_reg)
      //                       cache   memresp  wr_data     tag   tag   tag   data   data  data       rd_data   rd_data  evict  rd_word    memreq       cache      hit      memreq  cache    cache      mem       mem        resp_d      val    dirty     victim  used   makeaddr
      //                       req_en  en       mux_sel     ren   wen0  wen1  ren    wen   wben       mux_sel   reg_en   en     mux_sel    addr_sel     resp_type           type    req_rdy  resp_val   req_val   resp_rdy   mux_sel                                     mux_sel
      STATE_IDLE:              cs(1,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  1,       0,         0,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_TAG_CHECK:         cs(0,   0,       wd_mux_x,   1,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     mark,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep ,  mark,   keep,  1'bx );
      STATE_INIT_DATA_ACCESS:  cs(eot, 0,       wd_mux_rp,  0,    vtm0, vtm1, 0,     1,    w_byte_en, dmux_x,   0,       0,     offset,    mm_mux_x,    crq_t,     keep,    mem_x,  eot,     1,         0,        0,         dmux_x,     mark,  d_keep ,  keep,   mark,  1'bx );
      STATE_READ_DATA_ACCESS:  cs(eot, 0,       wd_mux_x,   0,    vtm0, vtm1, 1,     0,    w_none,    rd_array, 1,       0,     offset,    mm_mux_x,    crq_t,     keep,    mem_x,  eot,     1,         0,        0,         resp_data,  mark,  d_keep ,  keep,   mark,  1'bx );
      STATE_WRITE_DATA_ACCESS: cs(eot, 0,       wd_mux_rp,  0,    vtm0, vtm1, 0,     1,    w_byte_en, dmux_x,   0,       0,     offset,    mm_mux_x,    crq_t,     keep,    mem_x,  eot,     1,         0,        0,         dmux_x,     mark,  d_mark ,  keep,   mark,  1'bx );
      STATE_REFILL_REQUEST:    cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_mk,   mem_x,     keep,    mem_rd, 0,       0,         1,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_REFILL_WAIT:       cs(0,   1,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        1,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_REFILL_UPDATE:     cs(0,   0,       wd_mux_reg, 0,    0,    0,    0,     1,    w_line,    dmux_x,   0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_EVICT_PREPARE:     cs(0,   0,       wd_mux_x,   1,    0,    0,    1,     0,    w_none,    dmux_x,   1,       1,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_clean,  keep,   keep,  vtm1 );
      STATE_EVICT_REQUEST:     cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    1,        0,       0,     rw_mux_x,  mm_mux_reg,  mem_x,     keep,    mem_wr, 0,       0,         1,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      STATE_EVICT_WAIT:        cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    1,        0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     keep,    mem_x,  0,       0,         0,        1,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      default:                 cs(0,   0,       wd_mux_x,   0,    0,    0,    0,     0,    w_none,    1,        0,       0,     rw_mux_x,  mm_mux_x,    mem_x,     0,       mem_x,  0,       0,         0,        0,         dmux_x,     keep,  d_keep ,  keep,   keep,  1'bx );
      
    endcase
  end
  
endmodule

`endif

`line 12 "lab3_mem/BlockingCacheAltVRTL.v" 0
`line 1 "lab3_mem/BlockingCacheAltDpathVRTL.v" 0
//=========================================================================
// Alternative Blocking Cache Datapath
//=========================================================================

`ifndef LAB3_MEM_BLOCKING_CACHE_ALT_DPATH_V
`define LAB3_MEM_BLOCKING_CACHE_ALT_DPATH_V

`line 1 "vc/mem-msgs.v" 0
//========================================================================
// vc-mem-msgs : Memory Request/Response Messages
//========================================================================
// The memory request/response messages are used to interact with various
// memories. They are parameterized by the number of bits in the address,
// data, and opaque field.

`ifndef VC_MEM_MSGS_V
`define VC_MEM_MSGS_V

`line 1 "vc/trace.v" 0
//========================================================================
// Line Tracing
//========================================================================

`ifndef VC_TRACE_V
`define VC_TRACE_V

// NOTE: This macro is declared outside of the module to allow some vc
// modules to see it and use it in their own params. Verilog does not
// allow other modules to hierarchically reference the nbits localparam
// inside this module in constant expressions (e.g., localparams).

`define VC_TRACE_NCHARS 512
`define VC_TRACE_NBITS  512*8

module vc_Trace
(
  input logic clk,
  input logic reset
);

  integer len0;
  integer len1;
  integer idx0;
  integer idx1;

  // NOTE: If you change these, then you also need to change the
  // hard-coded constant in the declaration of the trace function at the
  // bottom of this file.
  // NOTE: You would also need to change the VC_TRACE_NBITS and
  // VC_TRACE_NCHARS macro at the top of this file.

  localparam nchars = 512;
  localparam nbits  = 512*8;

  // This is the actual trace storage used when displaying a trace

  logic [nbits-1:0] storage;

  // Meant to be accesible from outside module

  integer cycles_next = 0;
  integer cycles      = 0;

  // Get trace level from command line

  logic [3:0] level;

`ifndef VERILATOR
  initial begin
    if ( !$value$plusargs( "trace=%d", level ) ) begin
      level = 0;
    end
  end
`else
  initial begin
    level = 1;
  end
`endif // !`ifndef VERILATOR

  // Track cycle count

  always_ff @( posedge clk ) begin
    cycles <= ( reset ) ? 0 : cycles_next;
  end

  //----------------------------------------------------------------------
  // append_str
  //----------------------------------------------------------------------
  // Appends a string to the trace.

  task append_str
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    len0 = 1;
    while ( str[len0*8+:8] != 0 ) begin
      len0 = len0 + 1;
    end

    idx0 = trace[31:0];

    for ( idx1 = len0-1; idx1 >= 0; idx1 = idx1 - 1 )
    begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8 +: 8 ];
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_str_ljust
  //----------------------------------------------------------------------
  // Appends a left-justified string to the trace.

  task append_str_ljust
  (
    inout logic [nbits-1:0] trace,
    input logic [nbits-1:0] str
  );
  begin

    idx0 = trace[31:0];
    idx1 = nchars;

    while ( str[ idx1*8-1 -: 8 ] != 0 ) begin
      trace[ idx0*8 +: 8 ] = str[ idx1*8-1 -: 8 ];
      idx0 = idx0 - 1;
      idx1 = idx1 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_chars
  //----------------------------------------------------------------------
  // Appends the given number of characters to the trace.

  task append_chars
  (
    inout logic   [nbits-1:0] trace,
    input logic         [7:0] char,
    input integer             num
  );
  begin

    idx0 = trace[31:0];

    for ( idx1 = 0;
          idx1 < num;
          idx1 = idx1 + 1 )
    begin
      trace[idx0*8+:8] = char;
      idx0 = idx0 - 1;
    end

    trace[31:0] = idx0;

  end
  endtask

  //----------------------------------------------------------------------
  // append_val_str
  //----------------------------------------------------------------------
  // Append a string modified by val signal.

  task append_val_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( val )
      append_str( trace, str );
    else if ( !val )
      append_chars( trace, " ", len1 );
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

  //----------------------------------------------------------------------
  // val_rdy_str
  //----------------------------------------------------------------------
  // Append a string modified by val/rdy signals.

  task append_val_rdy_str
  (
    inout logic [nbits-1:0] trace,
    input logic             val,
    input logic             rdy,
    input logic [nbits-1:0] str
  );
  begin

    len1 = 0;
    while ( str[len1*8+:8] != 0 ) begin
      len1 = len1 + 1;
    end

    if ( rdy && val ) begin
      append_str( trace, str );
    end
    else if ( rdy && !val ) begin
      append_chars( trace, " ", len1 );
    end
    else if ( !rdy && val ) begin
      append_str( trace, "#" );
      append_chars( trace, " ", len1-1 );
    end
    else if ( !rdy && !val ) begin
      append_str( trace, "." );
      append_chars( trace, " ", len1-1 );
    end
    else begin
      append_str( trace, "x" );
      append_chars( trace, " ", len1-1 );
    end

  end
  endtask

endmodule

//------------------------------------------------------------------------
// VC_TRACE_NBITS_TO_NCHARS
//------------------------------------------------------------------------
// Macro to determine number of characters for a net

`define VC_TRACE_NBITS_TO_NCHARS( nbits_ ) ((nbits_+3)/4)

//------------------------------------------------------------------------
// VC_TRACE_BEGIN
//------------------------------------------------------------------------

//`define VC_TRACE_BEGIN                                                  \
//  export "DPI-C" task line_trace;                                       \
//  vc_Trace vc_trace(clk,reset);                                         \
//  task line_trace( inout bit [(512*8)-1:0] trace_str );

`ifndef VERILATOR
`define VC_TRACE_BEGIN                                                  \
  vc_Trace vc_trace(clk,reset);                                         \
                                                                        \
  task display_trace;                                                   \
  begin                                                                 \
                                                                        \
    if ( vc_trace.level > 0 ) begin                                     \
      vc_trace.storage[15:0] = vc_trace.nchars-1;                       \
                                                                        \
      line_trace( vc_trace.storage );                                   \
                                                                        \
      $write( "%4d: ", vc_trace.cycles );                               \
                                                                        \
      vc_trace.idx0 = vc_trace.storage[15:0];                           \
      for ( vc_trace.idx1 = vc_trace.nchars-1;                          \
            vc_trace.idx1 > vc_trace.idx0;                              \
            vc_trace.idx1 = vc_trace.idx1 - 1 )                         \
      begin                                                             \
        $write( "%s", vc_trace.storage[vc_trace.idx1*8+:8] );           \
      end                                                               \
      $write("\n");                                                     \
                                                                        \
    end                                                                 \
                                                                        \
    vc_trace.cycles_next = vc_trace.cycles + 1;                         \
                                                                        \
  end                                                                   \
  endtask                                                               \
                                                                        \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`else
`define VC_TRACE_BEGIN                                                  \
  export "DPI-C" task line_trace;                                       \
  vc_Trace vc_trace(clk,reset);                                         \
  task line_trace( inout bit [(512*8)-1:0] trace_str );
`endif

//------------------------------------------------------------------------
// VC_TRACE_END
//------------------------------------------------------------------------

`define VC_TRACE_END \
  endtask

`endif /* VC_TRACE_V */


`line 12 "vc/mem-msgs.v" 0

//========================================================================
// Memory Request Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// requests include an opaque field, the address, and the number of bytes
// to read, while write requests include an opaque field, the address,
// the number of bytes to write, and the actual data to write.
//
// Message Format:
//
//    3b    p_opaque_nbits  p_addr_nbits       calc   p_data_nbits
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field, address field, and data field. Note that the size of the length
// field is caclulated from the number of bits in the data field, and
// that the length field is expressed in _bytes_. If the value of the
// length field is zero, then the read or write should be for the full
// width of the data field.
//
// For example, if the opaque field is 8 bits, the address is 32 bits and
// the data is also 32 bits, then the message format is as follows:
//
//   76  74 73           66 65              34 33  32 31               0
//  +------+---------------+------------------+------+------------------+
//  | type | opaque        | addr             | len  | data             |
//  +------+---------------+------------------+------+------------------+
//
// The length field is two bits. A length value of one means read or write
// a single byte, a length value of two means read or write two bytes, and
// so on. A length value of zero means read or write all four bytes. Note
// that not all memories will necessarily support any alignment and/or any
// value for the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [1:0]  len;
  logic [31:0] data;
} mem_req_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [31:0] addr;
  logic [3:0]  len;
  logic [127:0] data;
} mem_req_16B_t;

// memory request type values
`define VC_MEM_REQ_MSG_TYPE_READ     3'd0
`define VC_MEM_REQ_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_REQ_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_REQ_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_REQ_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_REQ_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_REQ_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Request Message: Trace message
//------------------------------------------------------------------------

module vc_MemReqMsg4BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_4B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_4B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemReqMsg16BTrace
(
  input logic         clk,
  input logic         reset,
  input logic         val,
  input logic         rdy,
  input mem_req_16B_t  msg
);

  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [31:0]  addr;
  assign addr   = msg.addr;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits = $bits(mem_req_16B_t);
  localparam c_read      = `VC_MEM_REQ_MSG_TYPE_READ;
  localparam c_write     = `VC_MEM_REQ_MSG_TYPE_WRITE;
  localparam c_write_init  = `VC_MEM_REQ_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( msg.type_ === `VC_MEM_REQ_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( msg.type_ )
        c_read     : type_str = "rd";
        c_write    : type_str = "wr";
        c_write_init : type_str = "wn";
        default    : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( vc_trace.level == 1 ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 2 ) begin
      $sformat( str, "%s:%x", type_str, msg.addr );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_read ) begin
        $sformat( str, "%s:%x:%x %s", type_str, msg.opaque, msg.addr,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x:%x", type_str, msg.opaque, msg.addr, msg.data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

//========================================================================
// Memory Response Message
//========================================================================
// Memory request messages can either be for a read or write. Read
// responses include an opaque field, the actual data, and the number of
// bytes, while write responses currently include just the opaque field.
//
// Message Format:
//
//    3b    p_opaque_nbits   2b    calc   p_data_nbits
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The message type is parameterized by the number of bits in the opaque
// field and data field. Note that the size of the length field is
// caclulated from the number of bits in the data field, and that the
// length field is expressed in _bytes_. If the value of the length field
// is zero, then the read or write should be for the full width of the
// data field.
//
// For example, if the opaque field is 8 bits and the data is 32 bits,
// then the message format is as follows:
//
//   46  44 43           36 35  34 33  32 31               0
//  +------+---------------+------+------+------------------+
//  | type | opaque        | test | len  | data             |
//  +------+---------------+------+------+------------------+
//
// The length field is two bits. A length value of one means one byte was
// read, a length value of two means two bytes were read, and so on. A
// length value of zero means all four bytes were read. Note that not all
// memories will necessarily support any alignment and/or any value for
// the length field.
//
// The opaque field is reserved for use by a specific implementation. All
// memories should guarantee that every response includes the opaque
// field corresponding to the request that generated the response.

//------------------------------------------------------------------------
// Memory Request Struct: Using a packed struct to represent the message
//------------------------------------------------------------------------
typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [1:0]  len;
  logic [31:0] data;
} mem_resp_4B_t;

typedef struct packed {
  logic [2:0]  type_;
  logic [7:0]  opaque;
  logic [1:0]  test;
  logic [3:0]  len;
  logic [127:0] data;
} mem_resp_16B_t;

// Values for the type field

`define VC_MEM_RESP_MSG_TYPE_READ     3'd0
`define VC_MEM_RESP_MSG_TYPE_WRITE    3'd1

// write no-refill
`define VC_MEM_RESP_MSG_TYPE_WRITE_INIT 3'd2
`define VC_MEM_RESP_MSG_TYPE_AMO_ADD    3'd3
`define VC_MEM_RESP_MSG_TYPE_AMO_AND    3'd4
`define VC_MEM_RESP_MSG_TYPE_AMO_OR     3'd5
`define VC_MEM_RESP_MSG_TYPE_X          3'dx

//------------------------------------------------------------------------
// Memory Response Message: Trace message
//------------------------------------------------------------------------

module vc_MemRespMsg4BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_4B_t  msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [1:0]   len;
  assign len    = msg.len;
  logic [31:0]  data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_4B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {8{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

module vc_MemRespMsg16BTrace
(
  input logic          clk,
  input logic          reset,
  input logic          val,
  input logic          rdy,
  input mem_resp_16B_t msg
);

  // unpack message fields -- makes them visible in gtkwave
  logic [2:0]   type_;
  assign type_  = msg.type_;
  logic [7:0]   opaque;
  assign opaque = msg.opaque;
  logic [1:0]   test;
  assign test   = msg.test;
  logic [3:0]   len;
  assign len    = msg.len;
  logic [127:0] data;
  assign data   = msg.data;

  // Short names

  localparam c_msg_nbits  = $bits(mem_resp_16B_t);
  localparam c_read       = `VC_MEM_RESP_MSG_TYPE_READ;
  localparam c_write      = `VC_MEM_RESP_MSG_TYPE_WRITE;
  localparam c_write_init = `VC_MEM_RESP_MSG_TYPE_WRITE_INIT;

  // Line tracing

  logic [8*2-1:0] type_str;
  logic [`VC_TRACE_NBITS-1:0] str;

  `VC_TRACE_BEGIN
  begin

    // Convert type into a string

    if ( type_ === `VC_MEM_RESP_MSG_TYPE_X )
      type_str = "xx";
    else begin
      case ( type_ )
        c_read       : type_str = "rd";
        c_write      : type_str = "wr";
        c_write_init : type_str = "wn";
        default      : type_str = "??";
      endcase
    end

    // Put together the trace string

    if ( (vc_trace.level == 1) || (vc_trace.level == 2) ) begin
      $sformat( str, "%s", type_str );
    end
    else if ( vc_trace.level == 3 ) begin
      if ( type_ == c_write || type_ == c_write_init ) begin
        $sformat( str, "%s:%x %s", type_str, opaque,
                  {32{" "}} );
      end
      else
        $sformat( str, "%s:%x:%x", type_str, opaque, data );
    end

    // Trace with val/rdy signals

    vc_trace.append_val_rdy_str( trace_str, val, rdy, str );

  end
  `VC_TRACE_END

endmodule

`endif /* VC_MEM_MSGS_V */


`line 9 "lab3_mem/BlockingCacheAltDpathVRTL.v" 0

//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Include necessary files
//''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
`line 1 "vc/regs.v" 0
//========================================================================
// Verilog Components: Registers
//========================================================================

// Note that we place the register output earlier in the port list since
// this is one place we might actually want to use positional port
// binding like this:
//
//  logic [p_nbits-1:0] result_B;
//  vc_Reg#(p_nbits) result_AB( clk, result_B, result_A );

`ifndef VC_REGS_V
`define VC_REGS_V

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop
//------------------------------------------------------------------------

module vc_Reg
#(
  parameter p_nbits = 1
)(
  input  logic               clk, // Clock input
  output logic [p_nbits-1:0] q,   // Data output
  input  logic [p_nbits-1:0] d    // Data input
);

  always_ff @( posedge clk )
    q <= d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with reset
//------------------------------------------------------------------------

module vc_ResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d      // Data input
);

  always_ff @( posedge clk )
    q <= reset ? p_reset_value : d;

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable
//------------------------------------------------------------------------

module vc_EnReg
#(
  parameter p_nbits = 1
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( en )
      q <= d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

//------------------------------------------------------------------------
// Postive-edge triggered flip-flop with enable and reset
//------------------------------------------------------------------------

module vc_EnResetReg
#(
  parameter p_nbits       = 1,
  parameter p_reset_value = 0
)(
  input  logic               clk,   // Clock input
  input  logic               reset, // Sync reset input
  output logic [p_nbits-1:0] q,     // Data output
  input  logic [p_nbits-1:0] d,     // Data input
  input  logic               en     // Enable input
);

  always_ff @( posedge clk )
    if ( reset || en )
      q <= reset ? p_reset_value : d;

  // Assertions

  `ifndef SYNTHESIS

  /*
  always_ff @( posedge clk )
    if ( !reset )
      `VC_ASSERT_NOT_X( en );
  */

  `endif /* SYNTHESIS */

endmodule

`endif /* VC_REGS_V */


`line 14 "lab3_mem/BlockingCacheAltDpathVRTL.v" 0
`line 1 "vc/muxes.v" 0
//========================================================================
// Verilog Components: Muxes
//========================================================================

`ifndef VC_MUXES_V
`define VC_MUXES_V

//------------------------------------------------------------------------
// 2 Input Mux
//------------------------------------------------------------------------

module vc_Mux2
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1,
  input  logic               sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      1'd0 : out = in0;
      1'd1 : out = in1;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 3 Input Mux
//------------------------------------------------------------------------

module vc_Mux3
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 4 Input Mux
//------------------------------------------------------------------------

module vc_Mux4
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3,
  input  logic         [1:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      2'd0 : out = in0;
      2'd1 : out = in1;
      2'd2 : out = in2;
      2'd3 : out = in3;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 5 Input Mux
//------------------------------------------------------------------------

module vc_Mux5
#(
 parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 6 Input Mux
//------------------------------------------------------------------------

module vc_Mux6
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 7 Input Mux
//------------------------------------------------------------------------

module vc_Mux7
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

//------------------------------------------------------------------------
// 8 Input Mux
//------------------------------------------------------------------------

module vc_Mux8
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0, in1, in2, in3, in4, in5, in6, in7,
  input  logic         [2:0] sel,
  output logic [p_nbits-1:0] out
);

  always_comb
  begin
    case ( sel )
      3'd0 : out = in0;
      3'd1 : out = in1;
      3'd2 : out = in2;
      3'd3 : out = in3;
      3'd4 : out = in4;
      3'd5 : out = in5;
      3'd6 : out = in6;
      3'd7 : out = in7;
      default : out = {p_nbits{1'bx}};
    endcase
  end

endmodule

`endif /* VC_MUXES_V */


`line 15 "lab3_mem/BlockingCacheAltDpathVRTL.v" 0
`line 1 "vc/srams.v" 0
//========================================================================
// Verilog Components: SRAMs
//========================================================================

`ifndef VC_SRAMS_V
`define VC_SRAMS_V

//------------------------------------------------------------------------
// 1rw Combinational Bit-level SRAM
//------------------------------------------------------------------------

module vc_CombinationalBitSRAM_1rw
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries)
)(
  input  logic                     clk,
  input  logic                     reset,

  // Read port (combinational read)

  input  logic                     read_en,
  input  logic [c_addr_nbits-1:0]  read_addr,
  output logic [p_data_nbits-1:0]  read_data,

  // Write port (sampled on the rising clock edge)

  input  logic                     write_en,
  input  logic [c_addr_nbits-1:0]  write_addr,
  input  logic [p_data_nbits-1:0]  write_data
);

  logic [p_data_nbits-1:0] mem[p_num_entries-1:0];

  // Combinational read. We ensure the read data is all X's if we are
  // doing a write because we are modeling an SRAM with a single
  // read/write port (i.e., not a dual ported SRAM). We also ensure the
  // read data is all X's if the read is not enable at all to avoid
  // (potentially) incorrectly assuming the SRAM latches the read data.

  /* verilator lint_off WIDTH */

  always_comb begin
    if ( read_en )
      read_data = mem[read_addr];
    else
      read_data = 'hx;
  end

  /* verilator lint_on WIDTH */

  always_ff @(posedge clk) begin
    if (write_en)
      mem[write_addr] = write_data;
  end

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( read_en );
      `VC_ASSERT_NOT_X( write_en );

      // There is only one port. You can only do a read OR a write.

      `VC_ASSERT( !(read_en && write_en) );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's. Write byte
      // enables also cannot be X.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT_NOT_X( write_byte_en );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */
  
endmodule

//------------------------------------------------------------------------
// 1rw Combinational SRAM
//------------------------------------------------------------------------

module vc_CombinationalSRAM_1rw
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries),
  parameter c_data_nbytes = (p_data_nbits+7)/8 // $ceil(p_data_nbits/8)
)(
  input  logic                     clk,
  input  logic                     reset,

  // Read port (combinational read)

  input  logic                     read_en,
  input  logic [c_addr_nbits-1:0]  read_addr,
  output logic [p_data_nbits-1:0]  read_data,

  // Write port (sampled on the rising clock edge)

  input  logic                     write_en,
  input  logic [c_data_nbytes-1:0] write_byte_en,
  input  logic [c_addr_nbits-1:0]  write_addr,
  input  logic [p_data_nbits-1:0]  write_data
);

  logic [p_data_nbits-1:0] mem[p_num_entries-1:0];

  // Combinational read. We ensure the read data is all X's if we are
  // doing a write because we are modeling an SRAM with a single
  // read/write port (i.e., not a dual ported SRAM). We also ensure the
  // read data is all X's if the read is not enable at all to avoid
  // (potentially) incorrectly assuming the SRAM latches the read data.

  /* verilator lint_off WIDTH */

  always_comb begin
    if ( read_en )
      read_data = mem[read_addr];
    else
      read_data = 'hx;
  end

  /* verilator lint_on WIDTH */

  // Inspired by http://www.xilinx.com/support/documentation/sw_manuals/xilinx11/xst.pdf, page 159

  genvar i;
  generate
    for ( i = 0; i < c_data_nbytes; i = i + 1 )
    begin : test
      always_ff @( posedge clk ) begin
        if ( write_en && write_byte_en[i] )
          mem[write_addr][ (i+1)*8-1 : i*8 ] <= write_data[ (i+1)*8-1 : i*8 ];
      end
    end
  endgenerate

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( read_en );
      `VC_ASSERT_NOT_X( write_en );

      // There is only one port. You can only do a read OR a write.

      `VC_ASSERT( !(read_en && write_en) );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's. Write byte
      // enables also cannot be X.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT_NOT_X( write_byte_en );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */
  
endmodule

//------------------------------------------------------------------------
// 1rw Synchronous SRAM
//------------------------------------------------------------------------

module vc_SynchronousSRAM_1rw
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries),
  parameter c_data_nbytes = (p_data_nbits+7)/8 // $ceil(p_data_nbits/8)
)(
  input  logic                     clk,
  input  logic                     reset,

  // Read port (synchronous read)

  input  logic                     read_en,
  input  logic [c_addr_nbits-1:0]  read_addr,
  output logic [p_data_nbits-1:0]  read_data,

  // Write port (sampled on the rising clock edge)

  input  logic                     write_en,
  input  logic [c_data_nbytes-1:0] write_byte_en,
  input  logic [c_addr_nbits-1:0]  write_addr,
  input  logic [p_data_nbits-1:0]  write_data
);

  logic [p_data_nbits-1:0] mem[p_num_entries-1:0];

  // Combinational read. We ensure the read data is all X's if we are
  // doing a write because we are modeling an SRAM with a single
  // read/write port (i.e., not a dual ported SRAM). We also ensure the
  // read data is all X's if the read is not enable at all to avoid
  // (potentially) incorrectly assuming the SRAM latches the read data.

  always_ff @( posedge clk ) begin
    if ( read_en )
      read_data <= mem[read_addr];
    else
      read_data <= 'hx;
  end

  // Inspired by http://www.xilinx.com/support/documentation/sw_manuals/xilinx11/xst.pdf, page 159

  genvar i;
  generate
    for ( i = 0; i < c_data_nbytes; i = i + 1 )
    begin : test
      always_ff @( posedge clk ) begin
        if ( write_en && write_byte_en[i] )
          mem[write_addr][ (i+1)*8-1 : i*8 ] <= write_data[ (i+1)*8-1 : i*8 ];
      end
    end
  endgenerate

  // Assertions

  /*
  always_ff @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( read_en );
      `VC_ASSERT_NOT_X( write_en );

      // There is only one port. You can only do a read OR a write.

      `VC_ASSERT( !(read_en && write_en) );

      // If write_en is one, then write address better be less than the
      // number of entries and definitely cannot be X's. Write byte
      // enables also cannot be X.

      if ( write_en ) begin
        `VC_ASSERT_NOT_X( write_addr );
        `VC_ASSERT_NOT_X( write_byte_en );
        `VC_ASSERT( write_addr < p_num_entries );
      end

    end
  end
  */

endmodule

`endif /* VC_SRAMS_V */


`line 16 "lab3_mem/BlockingCacheAltDpathVRTL.v" 0
`line 1 "vc/arithmetic.v" 0
//========================================================================
// Verilog Components: Arithmetic Components
//========================================================================

`ifndef VC_ARITHMETIC_V
`define VC_ARITHMETIC_V

//------------------------------------------------------------------------
// Adders
//------------------------------------------------------------------------

module vc_Adder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  input  logic               cin,
  output logic [p_nbits-1:0] out,
  output logic               cout
);

  // We need to convert cin into a 32-bit value to
  // avoid verilator warnings

  assign {cout,out} = in0 + in1 + {{(p_nbits-1){1'b0}},cin};

endmodule

module vc_SimpleAdder
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 + in1;

endmodule

//------------------------------------------------------------------------
// Subtractor
//------------------------------------------------------------------------

module vc_Subtractor
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out
);

  assign out = in0 - in1;

endmodule

//------------------------------------------------------------------------
// Incrementer
//------------------------------------------------------------------------

module vc_Incrementer
#(
  parameter p_nbits     = 1,
  parameter p_inc_value = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic [p_nbits-1:0] out
);

  assign out = in + p_inc_value;

endmodule

//------------------------------------------------------------------------
// ZeroExtender
//------------------------------------------------------------------------

module vc_ZeroExtender
#(
  parameter p_in_nbits  = 1,
  parameter p_out_nbits = 8
)(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {( p_out_nbits - p_in_nbits ){1'b0}}, in };

endmodule

//------------------------------------------------------------------------
// SignExtender
//------------------------------------------------------------------------

module vc_SignExtender
#(
 parameter p_in_nbits = 1,
 parameter p_out_nbits = 8
)
(
  input  logic [p_in_nbits-1:0]  in,
  output logic [p_out_nbits-1:0] out
);

  assign out = { {(p_out_nbits-p_in_nbits){in[p_in_nbits-1]}}, in };

endmodule

//------------------------------------------------------------------------
// ZeroComparator
//------------------------------------------------------------------------

module vc_ZeroComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in,
  output logic               out
);

  assign out = ( in == {p_nbits{1'b0}} );

endmodule

//------------------------------------------------------------------------
// EqComparator
//------------------------------------------------------------------------

module vc_EqComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 == in1 );

endmodule

//------------------------------------------------------------------------
// LtComparator
//------------------------------------------------------------------------

module vc_LtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 < in1 );

endmodule

//------------------------------------------------------------------------
// GtComparator
//------------------------------------------------------------------------

module vc_GtComparator
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic               out
);

  assign out = ( in0 > in1 );

endmodule

//------------------------------------------------------------------------
// LeftLogicalShifter
//------------------------------------------------------------------------

module vc_LeftLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1 )
(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in << shamt );

endmodule

//------------------------------------------------------------------------
// RightLogicalShifter
//------------------------------------------------------------------------

module vc_RightLogicalShifter
#(
  parameter p_nbits       = 1,
  parameter p_shamt_nbits = 1
)(
  input  logic       [p_nbits-1:0] in,
  input  logic [p_shamt_nbits-1:0] shamt,
  output logic       [p_nbits-1:0] out
);

  assign out = ( in >> shamt );

endmodule

`endif /* VC_ARITHMETIC_V */


`line 17 "lab3_mem/BlockingCacheAltDpathVRTL.v" 0

module lab3_mem_BlockingCacheAltDpathVRTL
#(
  parameter p_idx_shamt    = 0
)
(
  input  logic                        clk,
  input  logic                        reset,

  // Cache Request

  input  mem_req_4B_t                 cachereq_msg,

  // Cache Response

  output mem_resp_4B_t                cacheresp_msg,

  // Memory Request

  output mem_req_16B_t                memreq_msg,

  // Memory Response

  input  mem_resp_16B_t               memresp_msg,

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Add dpath signals
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // ------------- Control signals CTRL -> Data Path ------------------ //
  
  // Cache request & memory response interface
  input logic                         cachereq_en,
  input logic                         memresp_en,
  // Mux signal
  input logic                         write_data_mux_sel,
  // Array enable signals
  input logic                         tag_array_ren,
  input logic                         tag_array_wen0,
  input logic                         tag_array_wen1,
  input logic                         data_array_ren,
  input logic                         data_array_wen,
  input logic [15:0]                  data_array_wben,
  // reg enables and mux signals after arrays
  input logic                         read_data_mux_sel,
  input logic                         read_data_reg_en,
  input logic                         evict_addr_reg_en,
  input logic [1:0]                   read_word_mux_sel,
  input logic                         memreq_addr_mux_sel,
  // Cache response & memory request interface
  input logic [2:0]                   cacheresp_type,
  input logic                         hit,
  input logic [2:0]                   memreq_type,
  input logic                         cacheresp_data_mux_sel,
  input logic                         mkaddr_mux_sel,
  input logic                         victim,
  // ------------- Control signals Data Path -> CTRL ------------------ //
  // Cache request & memory response interface
  output logic [2:0]                  cachereq_type,
  // Addr signal
  output logic [31:0]                 cachereq_addr,
  // tag_match
  output logic                        tag_match0,
  output logic                        tag_match1,
  // Index
  output logic [2:0]                  idx
);

  // local parameters not meant to be set from outside
  localparam size = 256;             // Cache size in bytes
  localparam dbw  = 32;              // Short name for data bitwidth
  localparam abw  = 32;              // Short name for addr bitwidth
  localparam o    = 8;               // Short name for opaque bitwidth
  localparam clw  = 128;             // Short name for cacheline bitwidth
  localparam nbl  = size*8/clw;      // Number of blocks in the cache
  localparam nby  = nbl/2;           // Number of blocks per way
  localparam idw  = $clog2(nby);     // Short name for index bitwidth
  localparam ofw  = $clog2(clw/8);   // Short name for the offset bitwidth
  // In this lab, to simplify things, we always use all bits except for the
  // offset in the tag, rather than storing the "normal" 24 bits. This way,
  // when implementing a multi-banked cache, we don't need to worry about
  // re-inserting the bank id into the address of a cacheline.
  localparam tgw  = abw - ofw;       // Short name for the tag bitwidth

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Implement Dpath
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

  // Cache Request
  localparam cachereq_type_bits    = 3;
  localparam cachereq_opaque_bits  = 8;
  localparam cachereq_addr_bits    = 32;
  localparam cachereq_len_bits     = 2;
  localparam cachereq_data_bits    = 32;

  // Cache Response
  localparam cacheresp_type_bits   = 3;
  localparam cacheresp_opaque_bits = 8;
  localparam cacheresp_test_bits   = 2;
  localparam cacheresp_len_bits    = 2;
  localparam cacheresp_data_bits   = 32;
  // Memory Request
  localparam memreq_type_bits      = 3;
  localparam memreq_opaque_bits    = 8;
  localparam memreq_addr_bits      = 32;
  localparam memreq_len_bits       = 4;
  localparam memreq_data_bits      = 128;
  // Memory Response
  localparam memresp_type_bits     = 3;
  localparam memresp_opaque_bits   = 8;
  localparam memresp_test_bits     = 2;
  localparam memresp_len_bits      = 4;
  localparam memresp_data_bits     = 128;

  //----------------------------------------------------------------------
  // Left Registers
  //----------------------------------------------------------------------
  logic [cachereq_opaque_bits - 1 : 0] cachereq_opaque_reg_out;
  vc_EnReg
  #(
    cachereq_opaque_bits
  )
  cachereq_opaque_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_opaque_reg_out),     // Data output
    .d(cachereq_msg.opaque),     // Data input
    .en(cachereq_en)     // Enable input
  );

  logic [cachereq_type_bits - 1 : 0] cachereq_type_reg_out;
  assign cachereq_type = cachereq_type_reg_out;
  vc_EnReg
  #(
    cachereq_type_bits
  )
  cachereq_type_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_type_reg_out),     // Data output
    .d(cachereq_msg.type_),     // Data input
    .en(cachereq_en)     // Enable input
  );

  logic [cachereq_addr_bits - 1 : 0] cachereq_addr_reg_out;
  assign cachereq_addr = cachereq_addr_reg_out;
  vc_EnReg
  #(
    cachereq_addr_bits
  )
  cachereq_addr_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_addr_reg_out),     // Data output
    .d(cachereq_msg.addr),     // Data input
    .en(cachereq_en)     // Enable input
  );

  logic [cachereq_data_bits - 1 : 0] cachereq_data_reg_out;
  vc_EnReg
  #(
    cachereq_data_bits
  )
  cachereq_data_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(cachereq_data_reg_out),     // Data output
    .d(cachereq_msg.data),     // Data input
    .en(cachereq_en)     // Enable input
  );

  // memery response interface registers
  logic [memresp_data_bits - 1 : 0] memresp_data_reg_out;
  vc_EnReg
  #(
    memresp_data_bits
  )
  memresp_data_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(memresp_data_reg_out),     // Data output
    .d(memresp_msg.data),     // Data input
    .en(memresp_en)     // Enable input
  );

  //----------------------------------------------------------------------
  // Replication unit, mux, tag array and data array & reg
  //----------------------------------------------------------------------  

  // Wires setup
  logic [27:0] addr_31_to_4;
  logic [31:0] cachereq_addr_shifted;
  assign cachereq_addr_shifted = cachereq_addr >> p_idx_shamt;
  assign idx                   = cachereq_addr_shifted[6:4];
  assign addr_31_to_4          = cachereq_addr[31:4];

  // Replication unit
  localparam repl_out_bits = 4 * cachereq_data_bits;
  logic [repl_out_bits - 1 : 0] repl_out;
  assign     repl_out     = {4{cachereq_data_reg_out}};
  
  // Mux
  logic [ repl_out_bits - 1 : 0] data_array_mux_out;
  vc_Mux2
  #(
    repl_out_bits
  )
  data_array_mux
  (
    .in0(repl_out), 
    .in1(memresp_data_reg_out),
    .sel(write_data_mux_sel),
    .out(data_array_mux_out)
  );

  // Tag array
  localparam tag_array_data_nbits  = 28;
  localparam tag_array_num_entries = 8;
  logic [tag_array_data_nbits - 1 : 0] tag_array0_read_data_out;
  
  vc_CombinationalBitSRAM_1rw
  #(
    tag_array_data_nbits,
    tag_array_num_entries
  )
  tag_array0
  (
    .clk(clk),
    .reset(reset),

    // Read port (combinational read)
    .read_en(tag_array_ren),
    .read_addr(idx),
    .read_data(tag_array0_read_data_out),

    // Write port (sampled on the rising clock edge)
    .write_en(tag_array_wen0),
    .write_addr(idx),
    .write_data(addr_31_to_4)
  );

  // Tag array
  logic [tag_array_data_nbits - 1 : 0] tag_array1_read_data_out;
  
  vc_CombinationalBitSRAM_1rw
  #(
    tag_array_data_nbits,
    tag_array_num_entries
  )
  tag_array1
  (
    .clk(clk),
    .reset(reset),

    // Read port (combinational read)
    .read_en(tag_array_ren),
    .read_addr(idx),
    .read_data(tag_array1_read_data_out),

    // Write port (sampled on the rising clock edge)
    .write_en(tag_array_wen1),
    .write_addr(idx),
    .write_data(addr_31_to_4)
  );
  
  // Data array
  localparam data_array_data_nbits  = 128;
  localparam data_array_num_entries = 16;
  logic [data_array_data_nbits - 1 : 0] data_array_read_data_out;

  vc_CombinationalSRAM_1rw
  #(
    data_array_data_nbits,
    data_array_num_entries
  )
  data_array
  (
    .clk(clk),
    .reset(reset),

    // Read port (combinational read)
    .read_en(data_array_ren),
    .read_addr({victim, idx}),
    .read_data(data_array_read_data_out),

    // Write port (sampled on the rising clock edge)
    .write_en(data_array_wen),
    .write_byte_en(data_array_wben),
    .write_addr({victim, idx}),
    .write_data(data_array_mux_out)
  );

  // data array out, read_data_reg
  logic [data_array_data_nbits - 1 : 0] read_data_reg_out;
  vc_EnReg
  #(
    data_array_data_nbits
  )
  read_data_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(read_data_reg_out),     // Data output
    .d(data_array_read_data_out),     // Data input
    .en(read_data_reg_en)     // Enable input
  );
  
  // Mux to select read_data_reg_out & data_array_read_data_out
  logic [data_array_data_nbits - 1 : 0] read_data_mux_out;
  vc_Mux2
  #(
    data_array_data_nbits
  )
  read_data_mux
  (
    .in0(data_array_read_data_out), 
    .in1(read_data_reg_out),
    .sel(read_data_mux_sel),
    .out(read_data_mux_out)
  );

  //----------------------------------------------------------------------
  // cmp, mkaddr, evict_addr_reg, muxes
  //----------------------------------------------------------------------  
  
  // Comparator
  vc_EqComparator
  #(
    tag_array_data_nbits
  )
  cmp0
  (
    .in0(addr_31_to_4),
    .in1(tag_array0_read_data_out),
    .out(tag_match0)
  );

  // Comparator
  vc_EqComparator
  #(
    tag_array_data_nbits
  )
  cmp1
  (
    .in0(addr_31_to_4),
    .in1(tag_array1_read_data_out),
    .out(tag_match1)
  );

  // Make address
  localparam mkaddr_nbits = 32;
  logic [mkaddr_nbits - 1 : 0] evict_addr_reg_in;
  logic [mkaddr_nbits - 1 : 0] memreq_addr_mux_in1;
  assign evict_addr_reg_in   = {mkaddr_mux_out, 4'h0};
  assign memreq_addr_mux_in1 = {addr_31_to_4, 4'h0};

  // Evict address register
  logic [mkaddr_nbits - 1 : 0] evict_addr_reg_out;
  vc_EnReg
  #(
    mkaddr_nbits
  )
  evict_addr_reg
  (
    .clk(clk),   // Clock input
    .reset(reset), // Sync reset input
    .q(evict_addr_reg_out),     // Data output
    .d(evict_addr_reg_in),     // Data input
    .en(evict_addr_reg_en)     // Enable input
  );

  // Muxes
  logic [27:0] mkaddr_mux_out;
  vc_Mux2
  #(
    28
  )
  mkaddr_mux
  (
    .in0(tag_array0_read_data_out), 
    .in1(tag_array1_read_data_out),
    .sel(mkaddr_mux_sel),
    .out(mkaddr_mux_out)
  );
  
  logic [mkaddr_nbits - 1 : 0] memreq_addr_mux_out;
  vc_Mux2
  #(
    mkaddr_nbits
  )
  memreq_addr_mux
  (
    .in0(evict_addr_reg_out), 
    .in1(memreq_addr_mux_in1),
    .sel(memreq_addr_mux_sel),
    .out(memreq_addr_mux_out)
  );

  localparam read_word_mux_nbits = data_array_data_nbits / 4;
  logic [read_word_mux_nbits - 1 : 0] read_word_mux_out;
  vc_Mux4
  #(
    read_word_mux_nbits
  )
  read_word_mux
  (
    .in0(read_data_mux_out[31:0]), 
    .in1(read_data_mux_out[63:32]), 
    .in2(read_data_mux_out[95:64]), 
    .in3(read_data_mux_out[127:96]),
    .sel(read_word_mux_sel),
    .out(read_word_mux_out)
  );

  logic [read_word_mux_nbits - 1 : 0] cacheresp_data_mux_out;
  vc_Mux2
  #(
    read_word_mux_nbits
  )
  cacheresp_data_mux
  (
    .in0(32'd0), 
    .in1(read_word_mux_out), 
    .sel(cacheresp_data_mux_sel),
    .out(cacheresp_data_mux_out)
  );

  //----------------------------------------------------------------------
  // cache response & memory request interface
  //----------------------------------------------------------------------
  
  // Cache response
  assign cacheresp_msg.opaque = cachereq_opaque_reg_out;
  assign cacheresp_msg.type_  = cacheresp_type;
  assign cacheresp_msg.len    = 2'h0;
  assign cacheresp_msg.test   = {1'b0,hit};
  assign cacheresp_msg.data   = cacheresp_data_mux_out;

  // Memory request
  assign memreq_msg.type_     = memreq_type; 
  assign memreq_msg.len       = 4'h0; 
  assign memreq_msg.addr      = memreq_addr_mux_out; 
  assign memreq_msg.data      = read_data_reg_out; 
  assign memreq_msg.opaque    = 8'd0; 
endmodule

`endif

`line 13 "lab3_mem/BlockingCacheAltVRTL.v" 0

// Note on p_num_banks:
// In a multi-banked cache design, cache lines are interleaved to
// different cache banks, so that consecutive cache lines correspond to a
// different bank. The following is the addressing structure in our
// four-banked data caches:
//
// +--------------------------+--------------+--------+--------+--------+
// |        22b               |     4b       |   2b   |   2b   |   2b   |
// |        tag               |   index      |bank idx| offset | subwd  |
// +--------------------------+--------------+--------+--------+--------+
//
// We will compose a four-banked cache in lab5, the multi-core lab

module lab3_mem_BlockingCacheAltVRTL
#(
  parameter p_num_banks  = 0              // Total number of cache banks
)
(
  input  logic           clk,
  input  logic           reset,

  // Cache Request

  input  mem_req_4B_t    cachereq_msg,
  input  logic           cachereq_val,
  output logic           cachereq_rdy,

  // Cache Response

  output mem_resp_4B_t   cacheresp_msg,
  output logic           cacheresp_val,
  input  logic           cacheresp_rdy,

  // Memory Request

  output mem_req_16B_t   memreq_msg,
  output logic           memreq_val,
  input  logic           memreq_rdy,

  // Memory Response

  input  mem_resp_16B_t  memresp_msg,
  input  logic           memresp_val,
  output logic           memresp_rdy
);

  localparam size = 256; // Number of bytes in the cache
  localparam dbw  = 32;  // Short name for data bitwidth
  localparam abw  = 32;  // Short name for addr bitwidth
  localparam clw  = 128; // Short name for cacheline bitwidth

  // calculate the index shift amount based on number of banks

  localparam c_idx_shamt = $clog2( p_num_banks );

  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Define temporary wires
  //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // ------------- Control signals CTRL -> Data Path ------------------ //
  // Cache request & memory response interface
  logic                        cachereq_en;
  logic                        memresp_en;
  // Mux signal
  logic                        write_data_mux_sel;
  // Array enable signals
  logic                        tag_array_ren;
  logic                        tag_array_wen0;
  logic                        tag_array_wen1;
  logic                        data_array_ren;
  logic                        data_array_wen;
  logic [15:0]                 data_array_wben;
  // reg enables and mux signals after arrays
  logic                        read_data_mux_sel;
  logic                        read_data_reg_en;
  logic                        evict_addr_reg_en;
  logic [1:0]                  read_word_mux_sel;
  logic                        memreq_addr_mux_sel;
  // Cache response & memory request interface
  logic [2:0]                  cacheresp_type;
  logic                        hit;
  logic [2:0]                  memreq_type;
  logic                        cacheresp_data_mux_sel;
  logic                        mkaddr_mux_sel;
  logic                        victim;
  // ------------- Control signals Data Path -> CTRL ------------------ //
  // Cache request & memory response interface
  logic [2:0]                  cachereq_type;
  // Addr signal
  logic [31:0]                 cachereq_addr;
  // tag_match
  logic                        tag_match0;
  logic                        tag_match1;
  // Index
  logic [2:0]                  idx;
  
  //----------------------------------------------------------------------
  // Control
  //----------------------------------------------------------------------

  lab3_mem_BlockingCacheAltCtrlVRTL
  #(
    .p_idx_shamt            (c_idx_shamt)
  )
  ctrl
  (
   .clk               (clk),
   .reset             (reset),

   // Cache Request

   .cachereq_val      (cachereq_val),
   .cachereq_rdy      (cachereq_rdy),

   // Cache Response

   .cacheresp_val     (cacheresp_val),
   .cacheresp_rdy     (cacheresp_rdy),

   // Memory Request

   .memreq_val        (memreq_val),
   .memreq_rdy        (memreq_rdy),

   // Memory Response

   .memresp_val       (memresp_val),
   .memresp_rdy       (memresp_rdy),

   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
   // LAB TASK: Connect control unit
   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

   // ------------- Control signals CTRL -> Data Path ------------------ //
   // Cache request & memory response interface
   .cachereq_en(cachereq_en),
   .memresp_en(memresp_en),
   // Mux signal
   .write_data_mux_sel(write_data_mux_sel),
   // Array enable signals
   .tag_array_ren(tag_array_ren),
   .tag_array_wen0(tag_array_wen0),
   .tag_array_wen1(tag_array_wen1),
   .data_array_ren(data_array_ren),
   .data_array_wen(data_array_wen),
   .data_array_wben(data_array_wben),
   // reg enables and mux signals after arrays
   .read_data_mux_sel(read_data_mux_sel),
   .read_data_reg_en(read_data_reg_en),
   .evict_addr_reg_en(evict_addr_reg_en),
   .read_word_mux_sel(read_word_mux_sel),
   .memreq_addr_mux_sel(memreq_addr_mux_sel),
   // Cache response & memory request interface
   .cacheresp_type(cacheresp_type),
   .hit(hit),
   .memreq_type(memreq_type),
   .cacheresp_data_mux_sel(cacheresp_data_mux_sel),
   .mkaddr_mux_sel(mkaddr_mux_sel),
   .victim(victim),
   // ------------- Control signals Data Path -> CTRL ------------------ //
   // Cache request & memory response interface
   .cachereq_type(cachereq_type),
   // Addr signal
   .cachereq_addr(cachereq_addr),
   // tag_match
   .tag_match0(tag_match0),
   .tag_match1(tag_match1),
   // Index
   .idx(idx)
  );

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  lab3_mem_BlockingCacheAltDpathVRTL
  #(
    .p_idx_shamt            (c_idx_shamt)
  )
  dpath
  (
   .clk               (clk),
   .reset             (reset),

   // Cache Request

   .cachereq_msg      (cachereq_msg),

   // Cache Response

   .cacheresp_msg     (cacheresp_msg),

   // Memory Request

   .memreq_msg        (memreq_msg),

   // Memory Response

   .memresp_msg       (memresp_msg),

   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
   // LAB TASK: Connect data path
   //'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

   // ------------- Control signals CTRL -> Data Path ------------------ //
   // Cache request & memory response interface
   .cachereq_en(cachereq_en),
   .memresp_en(memresp_en),
   // Mux signal
   .write_data_mux_sel(write_data_mux_sel),
   // Array enable signals
   .tag_array_ren(tag_array_ren),
   .tag_array_wen0(tag_array_wen0),
   .tag_array_wen1(tag_array_wen1),
   .data_array_ren(data_array_ren),
   .data_array_wen(data_array_wen),
   .data_array_wben(data_array_wben),
   // reg enables and mux signals after arrays
   .read_data_mux_sel(read_data_mux_sel),
   .read_data_reg_en(read_data_reg_en),
   .evict_addr_reg_en(evict_addr_reg_en),
   .read_word_mux_sel(read_word_mux_sel),
   .memreq_addr_mux_sel(memreq_addr_mux_sel),
   // Cache response & memory request interface
   .cacheresp_type(cacheresp_type),
   .hit(hit),
   .memreq_type(memreq_type),
   .cacheresp_data_mux_sel(cacheresp_data_mux_sel),
   .mkaddr_mux_sel(mkaddr_mux_sel),
   .victim(victim),
   // ------------- Control signals Data Path -> CTRL ------------------ //
   // Cache request & memory response interface
   .cachereq_type(cachereq_type),
   // Addr signal
   .cachereq_addr(cachereq_addr),
   // tag_match
   .tag_match0(tag_match0),
   .tag_match1(tag_match1),
   // Index
   .idx(idx)
  );

  //----------------------------------------------------------------------
  // Line tracing
  //----------------------------------------------------------------------
  vc_MemReqMsg4BTrace cachereq_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (cachereq_val),
    .rdy   (cachereq_rdy),
    .msg   (cachereq_msg)
  );

  vc_MemRespMsg4BTrace cacheresp_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (cacheresp_val),
    .rdy   (cacheresp_rdy),
    .msg   (cacheresp_msg)
  );

  vc_MemReqMsg16BTrace memreq_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (memreq_val),
    .rdy   (memreq_rdy),
    .msg   (memreq_msg)
  );

  vc_MemRespMsg16BTrace memresp_msg_trace
  (
    .clk   (clk),
    .reset (reset),
    .val   (memresp_val),
    .rdy   (memresp_rdy),
    .msg   (memresp_msg)
  );

  `ifndef SYNTHESIS
  logic [`VC_TRACE_NBITS-1:0] str;
 
  `VC_TRACE_BEGIN
  begin

     case ( ctrl.state_reg )

       ctrl.STATE_IDLE:                   vc_trace.append_str( trace_str, "(I )" );
       ctrl.STATE_TAG_CHECK:              vc_trace.append_str( trace_str, "(TC)" );
       ctrl.STATE_INIT_DATA_ACCESS:       vc_trace.append_str( trace_str, "(IN)" );
       ctrl.STATE_WAIT:                   vc_trace.append_str( trace_str, "(W )" );
       ctrl.STATE_READ_DATA_ACCESS:       vc_trace.append_str( trace_str, "(RD)" );
       ctrl.STATE_WRITE_DATA_ACCESS:      vc_trace.append_str( trace_str, "(WD)" );
       ctrl.STATE_REFILL_REQUEST:         vc_trace.append_str( trace_str, "(RR)" );
       ctrl.STATE_REFILL_WAIT:            vc_trace.append_str( trace_str, "(RW)" );
       ctrl.STATE_REFILL_UPDATE:          vc_trace.append_str( trace_str, "(RU)" );
       ctrl.STATE_EVICT_PREPARE:          vc_trace.append_str( trace_str, "(EP)" );
       ctrl.STATE_EVICT_REQUEST:          vc_trace.append_str( trace_str, "(ER)" );
       ctrl.STATE_EVICT_WAIT:             vc_trace.append_str( trace_str, "(EW)" );

       default:                           vc_trace.append_str( trace_str, "(? )" );

     endcase

    //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // LAB TASK: Add line tracing
    //''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // vc_trace.append_str( trace_str, "cache response valid " );
    // $sformat( str, "%x ", ctrl.cacheresp_val );
    // vc_trace.append_str( trace_str, str ); 
    
    /*   
    vc_trace.append_str( trace_str, "dirty0 " );
    $sformat( str, "%x ", ctrl.dirty0[ctrl.idx] );
    vc_trace.append_str( trace_str, str );

    vc_trace.append_str( trace_str, "dirty1 " );
    $sformat( str, "%x ", ctrl.dirty1[ctrl.idx] );
    vc_trace.append_str( trace_str, str );
        
    vc_trace.append_str( trace_str, " valid0 " );
    $sformat( str, "%x ", ctrl.valid0[ctrl.idx] );
    vc_trace.append_str( trace_str, str ); 
    
    vc_trace.append_str( trace_str, " valid1 " );
    $sformat( str, "%x ", ctrl.valid1[ctrl.idx] );
    vc_trace.append_str( trace_str, str );  

    vc_trace.append_str( trace_str, " hit " );
    $sformat( str, "%x ", ctrl.hit );
    vc_trace.append_str( trace_str, str );  
    
    vc_trace.append_str( trace_str, " victim " );
    $sformat( str, "%x ", ctrl.victim );
    vc_trace.append_str( trace_str, str );  
    */
  end
  `VC_TRACE_END
  
  `endif /* SYNTHESIS */

endmodule

`endif

`line 13 "lab5_mcore/SingleCoreVRTL.v" 0

module lab5_mcore_SingleCoreVRTL
#(
  parameter dummy = 0 // need this to keep pymtl from automatically adding parameters
)
(
  input  logic                       clk,
  input  logic                       reset,

  // proc manager ports

  input  logic [31:0]                mngr2proc_msg,
  input  logic                       mngr2proc_val,
  output logic                       mngr2proc_rdy,

  output logic [31:0]                proc2mngr_msg,
  output logic                       proc2mngr_val,
  input  logic                       proc2mngr_rdy,

  output mem_req_16B_t               imemreq_msg,
  output logic                       imemreq_val,
  input  logic                       imemreq_rdy,

  input  mem_resp_16B_t              imemresp_msg,
  input  logic                       imemresp_val,
  output logic                       imemresp_rdy,

  output mem_req_16B_t               dmemreq_msg,
  output logic                       dmemreq_val,
  input  logic                       dmemreq_rdy,

  input  mem_resp_16B_t              dmemresp_msg,
  input  logic                       dmemresp_val,
  output logic                       dmemresp_rdy,

  output logic                       stats_en,
  output logic                       commit_inst,
  output logic                       icache_miss,
  output logic                       icache_access,
  output logic                       dcache_miss,
  output logic                       dcache_access
);

  mem_req_4B_t                  icache_req_msg;
  logic                         icache_req_val;
  logic                         icache_req_rdy;

  mem_resp_4B_t                 icache_resp_msg;
  logic                         icache_resp_val;
  logic                         icache_resp_rdy;

  mem_req_4B_t                  dcache_req_msg;
  logic                         dcache_req_val;
  logic                         dcache_req_rdy;

  mem_resp_4B_t                 dcache_resp_msg;
  logic                         dcache_resp_val;
  logic                         dcache_resp_rdy;

  logic                         proc_commit_inst;

  // processor

  lab2_proc_ProcAltVRTL proc
  (
    .clk           (clk),
    .reset         (reset),

    .core_id       (32'd0),

    .imemreq_msg   (icache_req_msg),
    .imemreq_val   (icache_req_val),
    .imemreq_rdy   (icache_req_rdy),

    .imemresp_msg  (icache_resp_msg),
    .imemresp_val  (icache_resp_val),
    .imemresp_rdy  (icache_resp_rdy),

    .dmemreq_msg   (dcache_req_msg),
    .dmemreq_val   (dcache_req_val),
    .dmemreq_rdy   (dcache_req_rdy),

    .dmemresp_msg  (dcache_resp_msg),
    .dmemresp_val  (dcache_resp_val),
    .dmemresp_rdy  (dcache_resp_rdy),

    .mngr2proc_msg (mngr2proc_msg),
    .mngr2proc_val (mngr2proc_val),
    .mngr2proc_rdy (mngr2proc_rdy),

    .proc2mngr_msg (proc2mngr_msg),
    .proc2mngr_val (proc2mngr_val),
    .proc2mngr_rdy (proc2mngr_rdy),

    .stats_en      (stats_en),
    .commit_inst   (proc_commit_inst)
  );

  // instruction cache

  lab3_mem_BlockingCacheAltVRTL
  #(
    .p_num_banks   (1)
  )
  icache
  (
    .clk           (clk),
    .reset         (reset),

    .cachereq_msg  (icache_req_msg),
    .cachereq_val  (icache_req_val),
    .cachereq_rdy  (icache_req_rdy),

    .cacheresp_msg (icache_resp_msg),
    .cacheresp_val (icache_resp_val),
    .cacheresp_rdy (icache_resp_rdy),

    .memreq_msg    (imemreq_msg),
    .memreq_val    (imemreq_val),
    .memreq_rdy    (imemreq_rdy),

    .memresp_msg   (imemresp_msg),
    .memresp_val   (imemresp_val),
    .memresp_rdy   (imemresp_rdy)

  );

  // data cache

  lab3_mem_BlockingCacheAltVRTL
  #(
    .p_num_banks   (1)
  )
  dcache
  (
    .clk           (clk),
    .reset         (reset),

    .cachereq_msg  (dcache_req_msg),
    .cachereq_val  (dcache_req_val),
    .cachereq_rdy  (dcache_req_rdy),

    .cacheresp_msg (dcache_resp_msg),
    .cacheresp_val (dcache_resp_val),
    .cacheresp_rdy (dcache_resp_rdy),

    .memreq_msg    (dmemreq_msg),
    .memreq_val    (dmemreq_val),
    .memreq_rdy    (dmemreq_rdy),

    .memresp_msg   (dmemresp_msg),
    .memresp_val   (dmemresp_val),
    .memresp_rdy   (dmemresp_rdy)

  );

  // This piece of code is used to help simulator calculate the cache
  // miss/access, miss rate, and committed instruction count

  assign commit_inst   = proc_commit_inst;
  assign icache_miss   = icache_resp_val & icache_resp_rdy & ~icache_resp_msg.test[0];
  assign icache_access = icache_req_val  & icache_req_rdy;
  assign dcache_miss   = dcache_resp_val & dcache_resp_rdy & ~dcache_resp_msg.test[0];
  assign dcache_access = dcache_req_val  & dcache_req_rdy;

  `VC_TRACE_BEGIN
  begin
    proc.line_trace( trace_str );
    vc_trace.append_str( trace_str, "|" );
    icache.line_trace( trace_str );
    dcache.line_trace( trace_str );
  end
  `VC_TRACE_END

endmodule

`endif /* LAB5_MCORE_SINGLE_CORE_V */