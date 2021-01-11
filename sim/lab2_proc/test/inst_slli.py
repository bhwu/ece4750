#=========================================================================
# slli
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    slli x3, x1, 0x03
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

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [
    gen_rimm_dest_dep_test( 5, "slli",   0x00000001,  0, 0x00000001 ),
    gen_rimm_dest_dep_test( 4, "slli",   0x00000002,  1, 0x00000004 ),
    gen_rimm_dest_dep_test( 3, "slli",   0xfffffffd,  2, 0xfffffff4 ),
    gen_rimm_dest_dep_test( 2, "slli",   0xfffffffc,  3, 0xffffffe0 ),
    gen_rimm_dest_dep_test( 1, "slli",   0x00000005,  4, 0x00000050 ),
    gen_rimm_dest_dep_test( 0, "slli",   0x00000006,  5, 0x000000c0 ),
  ]

#-------------------------------------------------------------------------
# gen_src_dep_test
#------------------------------------------------------------------------- 
 
def gen_src_dep_test():
  return [
    gen_rimm_src_dep_test( 5, "slli",   0x00000007,  0, 0x00000007 ),
    gen_rimm_src_dep_test( 4, "slli",   0x00000008,  1, 0x00000010 ),
    gen_rimm_src_dep_test( 3, "slli",   0xfffffff0,  2, 0xffffffc0 ),
    gen_rimm_src_dep_test( 2, "slli",   0xfffffff0,  3, 0xffffff80 ),
    gen_rimm_src_dep_test( 1, "slli",   0x0000000a,  4, 0x000000a0 ),
    gen_rimm_src_dep_test( 0, "slli",   0x0000000b,  5, 0x00000160 ),
  ] 

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "slli", 0x00000025,  1, 0x0000004a ),
    gen_rimm_src_eq_dest_test( "slli", 0x00000026,  1, 0x0000004c ),
    gen_rimm_src_eq_dest_test( "slli", 0x00000027,  7, 0x00001380 ),
    gen_rimm_src_eq_dest_test( "slli", 0x00000028,  8, 0x00002800 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # Shift by 0, or 0 shift certain amount
    gen_rimm_value_test( "slli", 0x00000000,  0, 0x00000000 ),
    gen_rimm_value_test( "slli", 0x00000001,  0, 0x00000001 ),
    gen_rimm_value_test( "slli", 0x00000000, 31, 0x00000000 ),
    gen_rimm_value_test( "slli", 0x00000031,  0, 0x00000031 ),
    # High bits shifting
    gen_rimm_value_test( "slli", 0x7ffe0000,  1, 0xfffc0000 ),
    gen_rimm_value_test( "slli", 0x7ffe0000,  4, 0xffe00000 ),
    gen_rimm_value_test( "slli", 0x7ffe0000, 31, 0x00000000 ),
    # Low bits shifting
    gen_rimm_value_test( "slli", 0x80007ffe,  1, 0x0000fffc ),
    gen_rimm_value_test( "slli", 0x80007ffe,  4, 0x0007ffe0 ),
    gen_rimm_value_test( "slli", 0x80007ffe, 31, 0x00000000 ),
    # Overflow handling
    gen_rimm_value_test( "slli", 0xffff8000, 31, 0x00000000 ),
    gen_rimm_value_test( "slli", 0x00000001, 31, 0x80000000 ),
    gen_rimm_value_test( "slli", 0x00000001,  1, 0x00000002 ),
    gen_rimm_value_test( "slli", 0x00000002,  0, 0x00000002 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 5, random.randint(0,0x1f) )
    shamt    = (imm[0:5]).uint()
    dest     = (src << shamt)
    asm_code.append( gen_rimm_value_test( "slli", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code
