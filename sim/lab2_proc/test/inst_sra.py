#=========================================================================
# sra
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
    csrr x2, mngr2proc < 0x00000003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sra x3, x1, x2
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

def gen_dest_dep_test():
  return [
    gen_rr_dest_dep_test( 5, "sra",   0x00000001,  0, 0x00000001 ),
    gen_rr_dest_dep_test( 4, "sra",   0x00000002,  1, 0x00000001 ),
    gen_rr_dest_dep_test( 3, "sra",   0xfffffffd,  2, 0xffffffff ),
    gen_rr_dest_dep_test( 2, "sra",   0xfffffffc,  3, 0xffffffff ),
    gen_rr_dest_dep_test( 1, "sra",   0x00000005,  4, 0x00000000 ),
    gen_rr_dest_dep_test( 0, "sra",   0x00000006,  5, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "sra",   0x00000007,  0, 0x00000007 ),
    gen_rr_src0_dep_test( 4, "sra",   0x00000008,  1, 0x00000004 ),
    gen_rr_src0_dep_test( 3, "sra",   0xfffffff0,  2, 0xfffffffc ),
    gen_rr_src0_dep_test( 2, "sra",   0xfffffff0,  3, 0xfffffffe ),
    gen_rr_src0_dep_test( 1, "sra",   0x0000000a,  4, 0x00000000 ),
    gen_rr_src0_dep_test( 0, "sra",   0x0000000b,  5, 0x00000000 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "sra",   0x0000000c,  0, 0x0000000c ),
    gen_rr_src1_dep_test( 4, "sra",   0x0000000e,  1, 0x00000007 ),
    gen_rr_src1_dep_test( 3, "sra",   0xfffffff0,  2, 0xfffffffc ),
    gen_rr_src1_dep_test( 2, "sra",   0xffffffef,  3, 0xfffffffd ),
    gen_rr_src1_dep_test( 1, "sra",   0x0000000f,  4, 0x00000000 ),
    gen_rr_src1_dep_test( 0, "sra",   0x00000028,  5, 0x00000001 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "sra",   0x00000019,  0, 0x00000019 ),
    gen_rr_srcs_dep_test( 4, "sra",   0x00000020,  1, 0x00000010 ),
    gen_rr_srcs_dep_test( 3, "sra",   0xffff0000,  2, 0xffffc000 ),
    gen_rr_srcs_dep_test( 2, "sra",   0xffff0000,  3, 0xffffe000 ),
    gen_rr_srcs_dep_test( 1, "sra",   0x00000023,  4, 0x00000002 ),
    gen_rr_srcs_dep_test( 0, "sra",   0x00000024,  5, 0x00000001 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "sra", 0x00000025, 1, 0x00000012 ),
    gen_rr_src1_eq_dest_test( "sra", 0x00000026, 1, 0x00000013 ),
    gen_rr_src0_eq_src1_test( "sra", 0x00000027, 0 ),
    gen_rr_srcs_eq_dest_test( "sra", 0x00000028, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # Shift by 0, or 0 shift certain amount
    gen_rr_value_test( "sra", 0x00000000,  0, 0x00000000 ),
    gen_rr_value_test( "sra", 0x00000001,  0, 0x00000001 ),
    gen_rr_value_test( "sra", 0x00000000, 31, 0x00000000 ),
    gen_rr_value_test( "sra", 0x00000031,  0, 0x00000031 ),
    # Positive number shifting
    gen_rr_value_test( "sra", 0x00007ffe,  1, 0x00003fff ),
    gen_rr_value_test( "sra", 0x00007ffe,  4, 0x000007ff ),
    gen_rr_value_test( "sra", 0x00007ffe, 31, 0x00000000 ),
    # Negative number shifting
    gen_rr_value_test( "sra", 0x80007ffe,  1, 0xc0003fff ),
    gen_rr_value_test( "sra", 0x80007ffe,  4, 0xf80007ff ),
    gen_rr_value_test( "sra", 0x80007ffe, 31, 0xffffffff ),
    # Overflow handling
    gen_rr_value_test( "sra", 0xffff8000, -1, 0xffffffff ),
    gen_rr_value_test( "sra", 0x80000000, 63, 0xffffffff ),
    gen_rr_value_test( "sra", 0x80000000, 33, 0xc0000000 ),
    gen_rr_value_test( "sra", 0x80000002, 32, 0x80000002 ),

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
    temp_64  = Bits( 64, 0xffffffff00000000 if src0[31] else 0)
    temp_32  = Bits( 32, (temp_64 >> shamt), trunc = True)
    dest     = (src0 >> shamt) | temp_32
    asm_code.append( gen_rr_value_test( "sra", src0.int(), src1.int(), dest.int() ) )
  return asm_code
