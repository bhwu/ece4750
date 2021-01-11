#=========================================================================
# sltu
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 4
    csrr x2, mngr2proc < 5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sltu x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 1
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

def gen_dest_dep_test():
  return [
    gen_rr_dest_dep_test( 5, "sltu",   0x00000001,  0x00000001,  0 ),
    gen_rr_dest_dep_test( 4, "sltu",   0x00000002,  0xffffffff,  1 ),
    gen_rr_dest_dep_test( 3, "sltu",   0xfffffffd,  0x00000001,  0 ),
    gen_rr_dest_dep_test( 2, "sltu",   0xfffffffc,  0xffffffff,  1 ),
    gen_rr_dest_dep_test( 1, "sltu",   0x00000005,  0x00000001,  0 ),
    gen_rr_dest_dep_test( 0, "sltu",   0x00000006,  0x00000001,  0 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "sltu",   0x00000007,  0x00000001,   0 ),
    gen_rr_src0_dep_test( 4, "sltu",   0x00000008,  0xffffffff,   1 ),
    gen_rr_src0_dep_test( 3, "sltu",   0xfffffff0,  0x00000001,   0 ),
    gen_rr_src0_dep_test( 2, "sltu",   0xfffffff0,  0xffffffff,   1 ),
    gen_rr_src0_dep_test( 1, "sltu",   0x0000000a,  0x00000001,   0 ),
    gen_rr_src0_dep_test( 0, "sltu",   0x0000000b,  0x00000001,   0 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "sltu",  0x0000000c,  0x00000001,  0 ),
    gen_rr_src1_dep_test( 4, "sltu",  0x0000000e,  0xffffffff,  1 ),
    gen_rr_src1_dep_test( 3, "sltu",  0xfffffff0,  0x00000001,  0 ),
    gen_rr_src1_dep_test( 2, "sltu",  0xffffffef,  0xffffffff,  1 ),
    gen_rr_src1_dep_test( 1, "sltu",  0x0000000f,  0x00000001,  0 ),
    gen_rr_src1_dep_test( 0, "sltu",  0x00000018,  0x00000001,  0 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "sltu",  0x00000019,  0x00000001,  0 ),
    gen_rr_srcs_dep_test( 4, "sltu",  0x00000020,  0xffffffff,  1 ),
    gen_rr_srcs_dep_test( 3, "sltu",  0xffff0000,  0x00000001,  0 ),
    gen_rr_srcs_dep_test( 2, "sltu",  0xffff0000,  0xffffffff,  1 ),
    gen_rr_srcs_dep_test( 1, "sltu",  0x00000023,  0x00000001,  0 ),
    gen_rr_srcs_dep_test( 0, "sltu",  0x00000024,  0x00000001,  0 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "sltu", 25, 1, 0 ),
    gen_rr_src1_eq_dest_test( "sltu", 26, 1, 0 ),
    gen_rr_src0_eq_src1_test( "sltu", 27, 0 ),
    gen_rr_srcs_eq_dest_test( "sltu", 28, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # Compare with 0
    gen_rr_value_test( "sltu", 0x00000000, 0x00000000, 0 ),
    gen_rr_value_test( "sltu", 0x00000001, 0x00000000, 0 ),
    gen_rr_value_test( "sltu", 0x00000000, 0x00000007, 1 ),
    gen_rr_value_test( "sltu", 0x00000000, 0xffff8000, 1 ),
    gen_rr_value_test( "sltu", 0x80000000, 0x00000000, 0 ),
    # Small & Small
    gen_rr_value_test( "sltu", 0x00007ffe, 0x00007fff, 1 ),
    gen_rr_value_test( "sltu", 0x00007fff, 0x00007ffe, 0 ),
    gen_rr_value_test( "sltu", 0x00007fff, 0x00007fff, 0 ),
    # Small & Large
    gen_rr_value_test( "sltu", 0x00007fff, 0x80000000, 1 ),
    gen_rr_value_test( "sltu", 0x80000000, 0x00007fff, 0 ),
    # Large & Large
    gen_rr_value_test( "sltu", 0xffff8000, 0x0fffffff, 0 ),
    gen_rr_value_test( "sltu", 0x80000000, 0xffffffff, 1 ),
    gen_rr_value_test( "sltu", 0xffffffff, 0x80000000, 0 ),
    gen_rr_value_test( "sltu", 0xffffffff, 0xffffffff, 0 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0 = Bits( 32, random.randint(0,0xffffffff) )
    src1 = Bits( 32, random.randint(0,0xffffffff) )
    dest = Bits( 32, (1 if src0.uint() < src1.uint() else 0))
    asm_code.append( gen_rr_value_test( "sltu", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code
