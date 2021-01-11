#=========================================================================
# srli
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x00008000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    srli x3, x1, 0x03
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x00001000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [
    gen_rimm_dest_dep_test( 5, "srli",    0x00000001,  0, 0x00000001 ),
    gen_rimm_dest_dep_test( 4, "srli",    0x00000002,  1, 0x00000001 ),
    gen_rimm_dest_dep_test( 3, "srli",    0xfffffffd,  2, 0x3fffffff ),
    gen_rimm_dest_dep_test( 2, "srli",    0xfffffffc,  3, 0x1fffffff ),
    gen_rimm_dest_dep_test( 1, "srli",    0x00000005,  4, 0x00000000 ),
    gen_rimm_dest_dep_test( 0, "srli",    0x00000006,  5, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_rimm_src_dep_test( 5, "srli",   0x00000007,  0, 0x00000007 ),
    gen_rimm_src_dep_test( 4, "srli",   0x00000008,  1, 0x00000004 ),
    gen_rimm_src_dep_test( 3, "srli",   0xfffffff0,  2, 0x3ffffffc ),
    gen_rimm_src_dep_test( 2, "srli",   0xfffffff0,  3, 0x1ffffffe ),
    gen_rimm_src_dep_test( 1, "srli",   0x0000000a,  4, 0x00000000 ),
    gen_rimm_src_dep_test( 0, "srli",   0x0000000b,  5, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "srli", 0x00000025, 1 , 0x00000012 ),
    gen_rimm_src_eq_dest_test( "srli", 0x00000026, 1 , 0x00000013 ),
    gen_rimm_src_eq_dest_test( "srli", 0x00000027, 27, 0x00000000 ),
    gen_rimm_src_eq_dest_test( "srli", 0x00000028, 27, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # Shift by 0, or 0 shift certain amount
    gen_rimm_value_test( "srli", 0x00000000,  0, 0x00000000 ),
    gen_rimm_value_test( "srli", 0x00000001,  0, 0x00000001 ),
    gen_rimm_value_test( "srli", 0x00000000, 31, 0x00000000 ),
    gen_rimm_value_test( "srli", 0x00000031,  0, 0x00000031 ),
    # Positive number shifting
    gen_rimm_value_test( "srli", 0x00007ffe,  1, 0x00003fff ),
    gen_rimm_value_test( "srli", 0x00007ffe,  4, 0x000007ff ),
    gen_rimm_value_test( "srli", 0x00007ffe, 31, 0x00000000 ),
    # Negative number shifting
    gen_rimm_value_test( "srli", 0x80007ffe,  1, 0x40003fff ),
    gen_rimm_value_test( "srli", 0x80007ffe,  4, 0x080007ff ),
    gen_rimm_value_test( "srli", 0x80007ffe, 31, 0x00000001 ),
    # Overflow handling
    gen_rimm_value_test( "srli", 0xffff8000, 31, 0x00000001 ),
    gen_rimm_value_test( "srli", 0x80000000, 31, 0x00000001 ),
    gen_rimm_value_test( "srli", 0x80000000, 1 , 0x40000000 ),
    gen_rimm_value_test( "srli", 0x80000002, 0 , 0x80000002 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 5, random.randint(0,0x1f) )
    shamt    = imm.uint()
    dest     = (src >> shamt)
    asm_code.append( gen_rimm_value_test( "srli", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code
