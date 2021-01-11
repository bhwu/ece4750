#=========================================================================
# IntMulFL_test
#=========================================================================

import pytest
import random

random.seed(0xdeadbeef)

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource, TestSink

from lab1_imul.IntMulFL   import IntMulFL

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, imul, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src  = TestSource ( Bits(64), src_msgs,  src_delay  )
    s.imul = imul
    s.sink = TestSink   ( Bits(32), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.imul.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.imul = TranslationTool( s.imul )

    # Connect

    s.connect( s.src.out,  s.imul.req  )
    s.connect( s.imul.resp, s.sink.in_ )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace()  + " > " + \
           s.imul.line_trace()  + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# mk_req_msg
#-------------------------------------------------------------------------

def req( a, b ):
  msg = Bits( 64 )
  msg[32:64] = Bits( 32, a, trunc=True )
  msg[ 0:32] = Bits( 32, b, trunc=True )
  return msg

def resp( a ):
  return Bits( 32, a, trunc=True )

#----------------------------------------------------------------------
# Test Case: small positive * positive
#----------------------------------------------------------------------

small_pos_pos_msgs = [
  req(  2,  3 ), resp(   6 ),
  req(  4,  5 ), resp(  20 ),
  req(  3,  4 ), resp(  12 ),
  req( 10, 13 ), resp( 130 ),
  req(  8,  7 ), resp(  56 ),
]

# ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional lists of request/response messages to create
# additional directed and random test cases.
# ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#----------------------------------------------------------------------
# Test Case: small negative * negative
#----------------------------------------------------------------------
small_neg_neg_msgs = [
  req(  -6,  -3 ), resp(  18 ),
  req(  -2,  -5 ), resp(  10 ),
  req(  -3,  -4 ), resp(  12 ),
  req( -11, -13 ), resp( 143 ),
  req(  -5,  -7 ), resp(  35 ),
]

#----------------------------------------------------------------------
# Test Case: small negative * positve
#----------------------------------------------------------------------
small_neg_pos_msgs = [
  req(  -3,  3 ), resp(  -9   ),
  req(  -7,  5 ), resp(  -35  ),
  req(  -3,  8 ), resp(  -24  ),
  req( -10, 13 ), resp(  -130 ),
  req(  -8,  1 ), resp(  -8  ),
]

#----------------------------------------------------------------------
# Test Case: small positve * negative
#----------------------------------------------------------------------
small_pos_neg_msgs = [
  req(  2,  -3 ), resp(  -6   ),
  req(  4,  -5 ), resp(  -20  ),
  req(  3,  -4 ), resp(  -12  ),
  req( 10, -13 ), resp(  -130 ),
  req(  8,  -7 ), resp(  -56  ),
]

#----------------------------------------------------------------------
# Test Case: large mul, overflow, including pos_pos, pos_neg, neg_pos, neg_neg
#----------------------------------------------------------------------
large_msgs = [
  req(  -2**19 ,  3**16   ), resp(  - (2**19) * (3**16)  ),
  req(  -4**9  ,  5**8    ), resp(  - (4**9)  * (5**8)   ),
  req(  10**9  , -(13**8) ), resp(  - (10**9) * (13**8)  ),
  req(   8**7  , -7**9    ), resp(  - (8**7)  * (7**9)   ),
  req(   8**7  ,  7**9    ), resp(    (8**7)  * (7**9)   ),
  req(   4**9  ,  5**8    ), resp(    (4**9)  * (5**8)   ),
  req(  -2**19 , -3**15   ), resp(    (2**19) * (3**15)  ),
  req(  -10**9 , -13**7   ), resp(    (10**9) * (13**7)  ),
]

#----------------------------------------------------------------------
# Test Case: zeros: directly multiply with 0
#----------------------------------------------------------------------
zeros_msgs = [
  req(  -2    ,  0     ), resp(  0  ),
  req(  4864  ,  0     ), resp(  0  ),
  req(  0     ,  13**8 ), resp(  0  ),
  req(  0     ,  -8**7 ), resp(  0  ),
  req(  0     ,  0     ), resp(  0  ),
]

#----------------------------------------------------------------------
# Test Case: lomask, testing initial calculation cycle
#----------------------------------------------------------------------
lomask_msgs = []

for i in xrange(20):
  a = random.randint( 0, 0xffffffff )
  b = random.randint( 0, 0xffffffff )
  lomask_a  = a & 0xffffff00
  lomask_b  = b & 0xffffff00
  lomask_msgs.extend([ req(lomask_a ,lomask_b) , resp(lomask_a  * lomask_b )])


#----------------------------------------------------------------------
# Test Case: middlemask, testing calculation jump in the middle
#----------------------------------------------------------------------
midmask_msgs = []

for i in xrange(20):
  a = random.randint( 0, 0xffffffff )
  b = random.randint( 0, 0xffffffff )
  midmask_a = a & 0xfff000ff
  midmask_b = b & 0xfff000ff
  midmask_msgs.extend([ req(midmask_a,midmask_b), resp(midmask_a * midmask_b)]) 

#----------------------------------------------------------------------
# Test Case: sparse, testing case with lots of zeros
#----------------------------------------------------------------------
sparse_msgs = []

for i in xrange(20):
  a = random.randint( 0, 0xffffffff )
  b = random.randint( 0, 0xffffffff )
  sparse_a  = a & (0x000000ff << random.randint(0,24))
  sparse_b  = b & (0x000000ff << random.randint(0,24))
  sparse_msgs.extend([ req(sparse_a ,sparse_b) , resp(sparse_a  * sparse_b )]) 

#----------------------------------------------------------------------
# Test Case: dense, testing case with lots of ones
#----------------------------------------------------------------------
dense_msgs = []

for i in xrange(20):
  a = random.randint( 0, 0xffffffff )
  b = random.randint( 0, 0xffffffff )
  dense_a   = a | (0xffffff00 >> random.randint(0,8) )
  dense_b   = b | (0xffffff00 >> random.randint(0,8) )
  dense_msgs.extend([ req(dense_a  ,dense_b)  , resp(dense_a   * dense_b)  ]) 
  
#-------------------------------------------------------------------------
# Test Case: random, completely random cases
#-------------------------------------------------------------------------

random_msgs = []
for i in xrange(20):
  a = random.randint( 0, 0xffffffff )
  b = random.randint( 0, 0xffffffff )
  c = Bits( 32, (a * b), trunc = True )
  random_msgs.extend([ req(a,b), resp(c) ])
  
#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                          "msgs                 src_delay sink_delay"),
  [ "small_pos_pos_basic",   small_pos_pos_msgs,   0,        0          ],

  # ''' LAB TASK '''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # Add more rows to the test case table to leverage the additional lists
  # of request/response messages defined above, but also to test
  # different source/sink random delays.
  # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  [ "small_pos_pos"    ,     small_pos_pos_msgs,   0,        0          ],
  [ "small_neg_neg"    ,     small_neg_neg_msgs,   0,        0          ],
  [ "small_pos_neg"    ,     small_pos_neg_msgs,   0,        0          ],
  [ "small_neg_pos"    ,     small_neg_pos_msgs,   0,        0          ],
  [ "large"            ,     large_msgs        ,   0,        0          ],
  [ "zeros"            ,     zeros_msgs        ,   0,        0          ],
  [ "lomask"           ,     lomask_msgs       ,   0,        0          ],
  [ "midmask"          ,     midmask_msgs      ,   0,        0          ],
  [ "sparse"           ,     sparse_msgs       ,   0,        0          ],
  [ "dense"            ,     dense_msgs        ,   0,        0          ],
  [ "random"           ,     random_msgs       ,   0,        0          ],
  [ "small_pos_pos_0x5",     small_pos_pos_msgs,   0,        5          ],
  [ "small_pos_pos_5x0",     small_pos_pos_msgs,   5,        0          ],
  [ "small_pos_pos_3x9",     small_pos_pos_msgs,   3,        9          ],
  [ "small_neg_neg_3x5",     small_neg_neg_msgs,   3,        5          ],
  [ "small_pos_neg_5x2",     small_pos_neg_msgs,   5,        2          ],
  [ "small_neg_pos_5x2",     small_neg_pos_msgs,   2,        5          ],
  [ "large_3x7"        ,     large_msgs        ,   3,        7          ],
  [ "zeros_6x2"        ,     zeros_msgs        ,   6,        2          ],
  [ "lomask_4x5"       ,     lomask_msgs       ,   4,        5          ],
  [ "midmask_2x3"      ,     midmask_msgs      ,   2,        3          ],
  [ "sparse_6x7"       ,     sparse_msgs       ,   6,        7          ],
  [ "dense_7x1"        ,     dense_msgs        ,   7,        1          ],
  [ "random_7x3"       ,     random_msgs       ,   2,        3          ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd ):
  run_sim( TestHarness( IntMulFL(),
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay ),
           dump_vcd )

