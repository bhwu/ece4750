#=========================================================================
# srai
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
    srai x3, x1, 0x03
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
    gen_rimm_dest_dep_test( 5, "srai",   0x00000001,  0, 0x00000001 ),
    gen_rimm_dest_dep_test( 4, "srai",   0x00000002,  1, 0x00000001 ),
    gen_rimm_dest_dep_test( 3, "srai",   0xfffffffd,  2, 0xffffffff ),
    gen_rimm_dest_dep_test( 2, "srai",   0xfffffffc,  3, 0xffffffff ),
    gen_rimm_dest_dep_test( 1, "srai",   0x00000005,  4, 0x00000000 ),
    gen_rimm_dest_dep_test( 0, "srai",   0x00000006,  5, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_rimm_src_dep_test( 5, "srai",   0x00000007,  0, 0x00000007 ),
    gen_rimm_src_dep_test( 4, "srai",   0x00000008,  1, 0x00000004 ),
    gen_rimm_src_dep_test( 3, "srai",   0xfffffff0,  2, 0xfffffffc ),
    gen_rimm_src_dep_test( 2, "srai",   0xfffffff0,  3, 0xfffffffe ),
    gen_rimm_src_dep_test( 1, "srai",   0x0000000a,  4, 0x00000000 ),
    gen_rimm_src_dep_test( 0, "srai",   0x0000000b,  5, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "srai", 0x00000025, 1 , 0x00000012 ),
    gen_rimm_src_eq_dest_test( "srai", 0x00000026, 1 , 0x00000013 ),
    gen_rimm_src_eq_dest_test( "srai", 0x00000027, 27, 0x00000000 ),
    gen_rimm_src_eq_dest_test( "srai", 0x00000028, 28, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # Shift by 0, or 0 shift certain amount
    gen_rimm_value_test( "srai", 0x00000000,  0, 0x00000000 ),
    gen_rimm_value_test( "srai", 0x00000001,  0, 0x00000001 ),
    gen_rimm_value_test( "srai", 0x00000000, 31, 0x00000000 ),
    gen_rimm_value_test( "srai", 0x00000031,  0, 0x00000031 ),
    # Positive number shifting
    gen_rimm_value_test( "srai", 0x00007ffe,  1, 0x00003fff ),
    gen_rimm_value_test( "srai", 0x00007ffe,  4, 0x000007ff ),
    gen_rimm_value_test( "srai", 0x00007ffe, 31, 0x00000000 ),
    # Negative number shifting
    gen_rimm_value_test( "srai", 0x80007ffe,  1, 0xc0003fff ),
    gen_rimm_value_test( "srai", 0x80007ffe,  4, 0xf80007ff ),
    gen_rimm_value_test( "srai", 0x80007ffe, 31, 0xffffffff ),
    # Overflow handling
    gen_rimm_value_test( "srai", 0xffff8000, 31, 0xffffffff ),
    gen_rimm_value_test( "srai", 0x80000000, 31, 0xffffffff ),
    gen_rimm_value_test( "srai", 0x80000000, 1, 0xc0000000 ),
    gen_rimm_value_test( "srai", 0x80000002, 0, 0x80000002 ),
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
    temp_64  = Bits( 64, 0xffffffff00000000 if src[31] else 0)
    temp_32  = Bits( 32, (temp_64 >> shamt), trunc = True)
    dest     = (src >> shamt) | temp_32
    asm_code.append( gen_rimm_value_test( "srai", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code
