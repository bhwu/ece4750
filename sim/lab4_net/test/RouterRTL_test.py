#=========================================================================
# RouterRTL_test.py
#=========================================================================

from __future__    import print_function

import pytest
import random

random.seed(0xdeadbeef)

from pymtl         import *
from pclib.test    import TestSource, TestNetSink, mk_test_case_table
from pclib.ifcs    import NetMsg

from lab4_net.RouterRTL import RouterRTL
from NetFL_test import mk_msg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, RouterModel, router_id, src_msgs, sink_msgs, src_delay, sink_delay,
                num_ports, opaque_nbits, payload_nbits, 
                dump_vcd=False, test_verilog=False ):

    s.src_msgs   = src_msgs
    s.sink_msgs  = sink_msgs
    s.src_delay  = src_delay
    s.sink_delay = sink_delay

    msg_type = NetMsg( num_ports, 2**opaque_nbits, payload_nbits )

    s.src    = [ TestSource  ( msg_type, s.src_msgs[x],  s.src_delay  )
                 for x in xrange( 3 ) ]

    s.router = RouterModel

    s.sink   = [ TestNetSink ( msg_type, s.sink_msgs[x], s.sink_delay )
                 for x in xrange( 3 ) ]

    # Dump VCD

    if dump_vcd:
      s.router.vcd_file = dump_vcd
      if hasattr(s.router, 'inner'):
        s.router.inner.vcd_file = dump_vcd


    # Translation

    if test_verilog:
      s.router = TranslationTool( s.router )

    # Connect

    s.connect( s.router.in0 , s.src[0].out  )
    s.connect( s.router.out0, s.sink[0].in_ )

    s.connect( s.router.in1 , s.src[1].out  )
    s.connect( s.router.out1, s.sink[1].in_ )

    s.connect( s.router.in2 , s.src[2].out  )
    s.connect( s.router.out2, s.sink[2].in_ )

    s.connect( s.router.router_id, router_id )

  def done( s ):
    done_flag = 1
    for i in xrange( 3 ):
      done_flag &= s.src[i].done and s.sink[i].done
    return done_flag

  def line_trace( s ):
    in_ = '|'.join( [ x.out.to_str( "%02s:%1s>%1s" % ( x.out.msg[32:40],
                                                       x.out.msg[40:42],
                                                       x.out.msg[42:44] ) )
                                        for x in s.src  ] )
    out = '|'.join( [ x.in_.to_str( "%02s:%1s>%1s" % ( x.in_.msg[32:40],
                                                       x.in_.msg[40:42],
                                                       x.in_.msg[42:44] ) )
                                        for x in s.sink ] )
    return in_ + ' > ' + s.router.line_trace() + ' > '+ out

#-------------------------------------------------------------------------
# run_router_test
#-------------------------------------------------------------------------

def run_router_test( RouterModel, router_id, src_delay, sink_delay, test_msgs,
                     dump_vcd = False, test_verilog = False,
                     num_ports = 4, opaque_nbits = 8, payload_nbits = 32 ):

  # src/sink msgs

  src_msgs  = test_msgs[0]
  sink_msgs = test_msgs[1]

  # Instantiate and elaborate the model

  model = TestHarness( RouterModel, router_id,
                       src_msgs, sink_msgs, src_delay, sink_delay,
                       num_ports, opaque_nbits, payload_nbits,
                       dump_vcd, test_verilog )

  model.vcd_file     = dump_vcd
  model.test_verilog = test_verilog
  model.elaborate()

  # Create a simulator using the simulation tool

  sim = SimulationTool( model )

  # Run the simulation

  print()

  sim.reset()
  while not model.done() and sim.ncycles < 1000:
    sim.print_line_trace()
    sim.cycle()

  # Add a couple extra ticks so that the VCD dump is nicer

  sim.cycle()
  sim.cycle()
  sim.cycle()

  # Check for success

  if not model.done():
    raise AssertionError( "Simulation did not complete!" )

def mk_router_msgs( nrouters, msg_list ):
  """Utility function to create the msgs from a list of msg parameters."""

  src_msgs  = [ [] for x in xrange(nrouters) ]
  sink_msgs = [ [] for x in xrange(nrouters) ]

  for x in msg_list:
    tsrc, tsink, src, dest, opaque, payload = x[0], x[1], x[2], x[3], x[4], x[5]

    msg = mk_msg( src, dest, opaque, payload, num_ports=nrouters )
    src_msgs [tsrc].append( msg )
    sink_msgs[tsink].append( msg )

  return [ src_msgs, sink_msgs ]

#-------------------------------------------------------------------------
# Test case: very basic messages
#-------------------------------------------------------------------------
# The testing approach for the router is basically the following.
# - tsrc: which _input port_ the router is getting a message from.
# - tsink: the _expected port_ the router should forward to.
# - src and dest are the _router ids_ for the _actual network_
#
# For example, say the router is number 2 (the parameter is at the bottom
# of this file), and we want to test if the router directly forward a
# message from inport #1 (input terminal) with src=dest=2 to output port
# #1 (output terminal).
# If your router fail to forward this message to the correct output port,
# the simulation will hang or fail, since the test sink connected
# to outport#1 expects to get a message but there is really no message
# for it, or some other test sink receives an unexpected message.

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Calculate next/previous router
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def pre(x, nrouters = 4):
  previous = x-1 if x>0        else nrouters-1
  return previous

def nxt(x, nrouters = 4):
  nxt = x+1 if x<nrouters-1   else 0
  return nxt

def very_basic_msgs( i ):

  nrouters = 4

  pre = i-1 if i>0        else nrouters-1
  nxt = i+1 if i<nrouters-1 else 0

  return mk_router_msgs( nrouters,
#       tsrc tsink src  dest opaque payload
    [ ( 0x1, 0x1,  i,   i,   0x00,  0xfe ), # deliver directly to #2
      ( 0x0, 0x2,  pre, nxt, 0x01,  0xde ), # pass it through
    ]
  )

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# LAB TASK: Add new test cases
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def all_path( i, k ):
  if (k == 1 or k == 7 or k == 8) and (i % 2 != 1):
      k += 2
  elif (k == 2 or k == 4 or k == 10) and (i % 2 != 0):
      k -= 1
  #         tsrc tsink src          dest        opaque payload 
  msg = [(  0,   1,    pre(i),      i,          0x00,  0x13  ), # cw                                          0 
         (  0,   1,    pre(pre(i)), i,          0x01,  0x24  ), # cw only work for odd ID 1, 3                1 
         (  0,   2,    pre(i),      nxt(i),     0x02,  0x84  ), # cw only work for this router ID is even     2 
         (  1,   0,    i,           pre(i),     0x03,  0x15  ), # ccw                                         3 
         (  1,   0,    i,           pre(pre(i)),0x04,  0x12  ), # ccw only work for even ID, 2, 4             4 
         (  1,   1,    i,           i,          0x05,  0x84  ), # in -> out                                   5 
         (  1,   2,    i,           nxt(i),     0x06,  0xa7  ), # cw                                          6 
         (  1,   2,    i,           nxt(nxt(i)),0x07,  0x65  ), # cw only work for odd ID                     7     
         (  2,   0,    nxt(i),      pre(i),     0x08,  0x8a  ), # ccw only work for this router ID is odd     8 
         (  2,   1,    nxt(i),      i,          0x09,  0x76  ), # ccw                                         9  
         (  2,   1,    nxt(nxt(i)), i,          0x0a,  0x98  ), # ccw only work for even ID                   10
        ]

  return msg[k]
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# from it self sending to all fout routers
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def same_src_diff_dest_msgs( i ):

  nrouters = 4
  # a = 4 if i % 2 == 0 else 7
  # msg = [all_path(i, 5), all_path(i, 6),all_path(i, a),all_path(i, 3)]
  a = 0 if i % 2 == 0 else 2
  msg = []
             # tsrc tsink src  dest        opaque           payload
  msg.append(( 1,   1,    i,   i,          0x00,     0xae))    # in -> out
  msg.append(( 1,   2,    i,   nxt(i),     0x01,     0xa0))    # router cw
  msg.append(( 1,   a,    i,   nxt(nxt(i)),0x02,     0xa1))    # router cw (when greddy cinsider take the cw one)
  msg.append(( 1,   0,    i,   pre(i),     0x03,     0xa2))    # router ccw

  return mk_router_msgs( nrouters, msg )

def same_src_pass_cw_msgs( i ):
  # only work for routers with even ID
  if i % 2 != 0:
    print('wrong input router ID !\n')
    exit()

  nrouters = 4

  msg = []
             # tsrc tsink src     dest        opaque           payload
  msg.append(( 0,   1,    pre(i), i,          0x00,     0xae))    # in -> out
  msg.append(( 0,   2,    pre(i), nxt(i),     0x01,     0xa0))    # router cw

  return mk_router_msgs( nrouters, msg )

def same_src_pass_ccw_msgs( i ):
  # only work for routers with odd ID
  if i % 2 == 0:
    print('wrong input router ID !\n')
    exit()
  nrouters = 4

  msg = []
             # tsrc tsink src       dest        opaque           payload
  msg.append(( 2,   1,    nxt(i),   i,          0x00,     0xae))    # in -> out
  msg.append(( 2,   0,    nxt(i),   pre(i),     0x01,     0xa0))    # router cw

  return mk_router_msgs( nrouters, msg )

def input_0_to_others_msgs( i ):

    nrouters = 4
    a = 1 if i % 2 == 1  else 2
    msg = [all_path( i , 0), all_path( i, a)]

    return mk_router_msgs( nrouters, msg )

def input_2_to_others_msgs( i ):

  nrouters = 4
  a = 8 if i % 2 == 1  else 10
  msg = [all_path( i , 9), all_path( i, a )]

  return mk_router_msgs( nrouters, msg )


#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# All three others sending msgs
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
def diff_src_same_dest_msgs( i ) : 

  nrouters = 4

  a = 2 if nxt(nxt(i)) % 2 == 0 else 0

  msg = []
             # tsrc tsink src         dest   opaque           payload
  msg.append(( 1,   1,    i,          i,     0x00,     0xae))    # in -> out
  msg.append(( 2,   1,    nxt(i),     i,     0x01,     0xa0))    # router cw
  msg.append(( a,   1,    nxt(nxt(i)),i,     0x02,     0xa1))    # router cw (when greddy cinsider take the cw one)
  msg.append(( 0,   1,    pre(i),     i,     0x03,     0xa2))    # router ccw

  return mk_router_msgs ( nrouters, msg )

def others_to_output_0_msgs( i ):

  nrouters = 4

  a = 8 if i % 2 == 1  else 4
  msg = [all_path( i , 3 ), all_path( i, a )]

  return mk_router_msgs( nrouters, msg )

def others_to_output_2_msgs( i ):

  nrouters = 4
  a = 7 if i % 2 == 1  else 2
  msg = [all_path( i , 6 ), all_path( i, a )]

  return mk_router_msgs( nrouters, msg )

def two_way_use_msgs( i ):

  nrouters = 4
  a = 8 if i % 2 == 1  else 2
  msg = [all_path( i , 5 ), all_path( i, a )]

  return mk_router_msgs( nrouters, msg )

def three_way_use_msgs( i ):
  nrouters = 4
  a = [8, 1, 7] if i % 2 == 1 else [2, 4, 10]
  msg = [all_path(i, a[1] ), all_path(i,a[2] ), all_path(i, a[0])]  

  return mk_router_msgs( nrouters, msg )

def random_test_msgs( i ):

  nrouters = 4
  msg = []
  for x in range(100):
    a = random.randint(0,10)
    msg.append(all_path( i , a ))

  return mk_router_msgs( nrouters, msg )


  
#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                       "msgs                        routerid  src_delay sink_delay"),
  [ "vbasic_0",            very_basic_msgs(0),          0,        0,        0          ],
  [ "vbasic_1",            very_basic_msgs(1),          1,        0,        0          ],
  [ "vbasic_2",            very_basic_msgs(2),          2,        0,        0          ],
  [ "vbasic_3",            very_basic_msgs(3),          3,        0,        0          ],

  [ "src_0_to_diff_dest",  same_src_diff_dest_msgs(0),  0,        0,        0          ],
  [ "src_1_to_diff_dest",  same_src_diff_dest_msgs(1),  1,        0,        0          ],
  [ "src_2_to_diff_dest",  same_src_diff_dest_msgs(2),  2,        0,        0          ],
  [ "src_3_to_diff_dest",  same_src_diff_dest_msgs(3),  3,        0,        0          ],

  [ "diff_src_to_dest_0",  diff_src_same_dest_msgs(0),  0,        0,        0          ],
  [ "diff_src_to_dest_1",  diff_src_same_dest_msgs(1),  1,        0,        0          ],
  [ "diff_src_to_dest_2",  diff_src_same_dest_msgs(2),  2,        0,        0          ],
  [ "diff_src_to_dest_3",  diff_src_same_dest_msgs(3),  3,        0,        0          ],

  [ "src_0_pass_cw",       same_src_pass_cw_msgs(0),    0,        0,        0          ],
  [ "src_1_pass_ccw",      same_src_pass_ccw_msgs(1),   1,        0,        0          ],
  [ "src_2_pass_cw",       same_src_pass_cw_msgs(2),    2,        0,        0          ],
  [ "src_3_pass_ccw",      same_src_pass_ccw_msgs(3),   3,        0,        0          ],
  
  [ "input_0_to_others_0", input_0_to_others_msgs(0),    0,        0,        0          ],
  [ "input_0_to_others_1", input_0_to_others_msgs(1),    1,        0,        0          ],
  [ "input_0_to_others_2", input_0_to_others_msgs(2),    2,        0,        0          ],
  [ "input_0_to_others_3", input_0_to_others_msgs(3),    3,        0,        0          ],
  
  [ "input_2_to_others_0", input_2_to_others_msgs(0),    0,        0,        0          ],
  [ "input_2_to_others_1", input_2_to_others_msgs(1),    1,        0,        0          ],
  [ "input_2_to_others_2", input_2_to_others_msgs(2),    2,        0,        0          ],
  [ "input_2_to_others_3", input_2_to_others_msgs(3),    3,        0,        0          ],

  [ "others_to_output_0_0", others_to_output_0_msgs(0),  0,        0,        0          ],
  [ "others_to_output_0_1", others_to_output_0_msgs(1),  1,        0,        0          ],
  [ "others_to_output_0_2", others_to_output_0_msgs(2),  2,        0,        0          ],
  [ "others_to_output_0_3", others_to_output_0_msgs(3),  3,        0,        0          ],
  
  [ "others_to_output_2_0", others_to_output_2_msgs(0),  0,        0,        0          ],
  [ "others_to_output_2_1", others_to_output_2_msgs(1),  1,        0,        0          ],
  [ "others_to_output_2_2", others_to_output_2_msgs(2),  2,        0,        0          ],
  [ "others_to_output_2_3", others_to_output_2_msgs(3),  3,        0,        0          ],

  [ "two_way_use_0",       two_way_use_msgs(0),          0,        0,        0          ],
  [ "two_way_use_1",       two_way_use_msgs(1),          1,        0,        0          ],
  [ "two_way_use_2",       two_way_use_msgs(2),          2,        0,        0          ],
  [ "two_way_use_3",       two_way_use_msgs(3),          3,        0,        0          ],

  [ "three_way_use_0",     three_way_use_msgs(0),        0,        0,        0          ],
  [ "three_way_use_1",     three_way_use_msgs(1),        1,        0,        0          ],
  [ "three_way_use_2",     three_way_use_msgs(2),        2,        0,        0          ],
  [ "three_way_use_3",     three_way_use_msgs(3),        3,        0,        0          ],

  [ "random_test_0",       random_test_msgs(0),          0,        0,        0          ],
  [ "random_test_1",       random_test_msgs(1),          1,        0,        0          ],
  [ "random_test_2",       random_test_msgs(2),          2,        0,        0          ],
  [ "random_test_3",       random_test_msgs(3),          3,        0,        0          ],

  [ "random_test_0_rd",    random_test_msgs(0),          0,        2,        4          ],
  [ "random_test_1_rd",    random_test_msgs(1),          1,        1,        5          ],
  [ "random_test_2_rd",    random_test_msgs(2),          2,        0,        3          ],
  [ "random_test_3_rd",    random_test_msgs(3),          3,        5,        1          ],


  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to leverage the additional lists
  # of request/response messages defined above, but also to test
  # different source/sink random delays. same_src_pass_cw_msgs same_src_pass_ccw_msgs
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
])

#-------------------------------------------------------------------------
# Run tests
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  run_router_test( RouterRTL(), test_params.routerid,
                   test_params.src_delay, test_params.sink_delay,
                   test_params.msgs, dump_vcd, test_verilog )
