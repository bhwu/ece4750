#=========================================================================
# sll
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x80008000
    csrr x2, mngr2proc < 0x00000003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sll x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x00040000
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
    gen_rr_dest_dep_test( 5, "sll",   0x00000001,  0, 0x00000001 ),
    gen_rr_dest_dep_test( 4, "sll",   0x00000002,  1, 0x00000004 ),
    gen_rr_dest_dep_test( 3, "sll",   0xfffffffd,  2, 0xfffffff4 ),
    gen_rr_dest_dep_test( 2, "sll",   0xfffffffc,  3, 0xffffffe0 ),
    gen_rr_dest_dep_test( 1, "sll",   0x00000005,  4, 0x00000050 ),
    gen_rr_dest_dep_test( 0, "sll",   0x00000006,  5, 0x000000c0 ),
  ]
  
#-------------------------------------------------------------------------
# gen_src0_dep_test
#------------------------------------------------------------------------- 
 
def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "sll",   0x00000007,  0, 0x00000007 ),
    gen_rr_src0_dep_test( 4, "sll",   0x00000008,  1, 0x00000010 ),
    gen_rr_src0_dep_test( 3, "sll",   0xfffffff0,  2, 0xffffffc0 ),
    gen_rr_src0_dep_test( 2, "sll",   0xfffffff0,  3, 0xffffff80 ),
    gen_rr_src0_dep_test( 1, "sll",   0x0000000a,  4, 0x000000a0 ),
    gen_rr_src0_dep_test( 0, "sll",   0x0000000b,  5, 0x00000160 ),
  ]
  
#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "sll",   0x0000000c,  0, 0x0000000c ),
    gen_rr_src1_dep_test( 4, "sll",   0x0000000e,  1, 0x0000001c ),
    gen_rr_src1_dep_test( 3, "sll",   0xfffffff0,  2, 0xffffffc0 ),
    gen_rr_src1_dep_test( 2, "sll",   0xffffffef,  3, 0xffffff78 ),
    gen_rr_src1_dep_test( 1, "sll",   0x0000000f,  4, 0x000000f0 ),
    gen_rr_src1_dep_test( 0, "sll",   0x00000028,  5, 0x00000500 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "sll",   0x00000019,  0, 0x00000019 ),
    gen_rr_srcs_dep_test( 4, "sll",   0x00000020,  1, 0x00000040 ),
    gen_rr_srcs_dep_test( 3, "sll",   0x0000ffff,  2, 0x0003fffc ),
    gen_rr_srcs_dep_test( 2, "sll",   0x0000ffff,  3, 0x0007fff8 ),
    gen_rr_srcs_dep_test( 1, "sll",   0x00000023,  4, 0x00000230 ),
    gen_rr_srcs_dep_test( 0, "sll",   0x00000024,  5, 0x00000480 ),
  ]
  
#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "sll", 0x00000025, 1, 0x0000004a ),
    gen_rr_src1_eq_dest_test( "sll", 0x00000026, 1, 0x0000004c ),
    gen_rr_src0_eq_src1_test( "sll", 0x00000027, 0x00001380 ),
    gen_rr_srcs_eq_dest_test( "sll", 0x00000028, 0x00002800 ),
  ]
  
#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # Shift by 0, or 0 shift certain amount
    gen_rr_value_test( "sll", 0x00000000,  0, 0x00000000 ),
    gen_rr_value_test( "sll", 0x00000001,  0, 0x00000001 ),
    gen_rr_value_test( "sll", 0x00000000, 31, 0x00000000 ),
    gen_rr_value_test( "sll", 0x00000031,  0, 0x00000031 ),
    # High bits shifting
    gen_rr_value_test( "sll", 0x7ffe0000,  1, 0xfffc0000 ),
    gen_rr_value_test( "sll", 0x7ffe0000,  4, 0xffe00000 ),
    gen_rr_value_test( "sll", 0x7ffe0000, 31, 0x00000000 ),
    # Low bits shifting
    gen_rr_value_test( "sll", 0x80007ffe,  1, 0x0000fffc ),
    gen_rr_value_test( "sll", 0x80007ffe,  4, 0x0007ffe0 ),
    gen_rr_value_test( "sll", 0x80007ffe, 31, 0x00000000 ),
    # Overflow handling
    gen_rr_value_test( "sll", 0xffff8000, -1, 0x00000000 ),
    gen_rr_value_test( "sll", 0x00000001, 63, 0x80000000 ),
    gen_rr_value_test( "sll", 0x00000001, 33, 0x00000002 ),
    gen_rr_value_test( "sll", 0x00000002, 32, 0x00000002 ),

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0     = Bits( 32, random.randint(0,0xffffffff) )
    src1     = Bits( 32, random.randint(0,0xffffffff) )
    shamt    = (src1[0:5]).uint()
    dest     = (src0 << shamt)
    asm_code.append( gen_rr_value_test( "sll", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code
