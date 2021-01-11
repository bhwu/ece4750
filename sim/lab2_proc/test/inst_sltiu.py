#=========================================================================
# sltiu
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 5
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sltiu x3, x1, 6
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

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [
    gen_rimm_dest_dep_test( 5, "sltiu",   0x00000001,  0x00000001,  0 ),
    gen_rimm_dest_dep_test( 4, "sltiu",   0x00000002,  0x00000fff,  1 ),
    gen_rimm_dest_dep_test( 3, "sltiu",   0xfffffffd,  0x00000001,  0 ),
    gen_rimm_dest_dep_test( 2, "sltiu",   0xfffffffc,  0x00000fff,  1 ),
    gen_rimm_dest_dep_test( 1, "sltiu",   0x00000005,  0x00000001,  0 ),
    gen_rimm_dest_dep_test( 0, "sltiu",   0x00000006,  0x00000001,  0 ),
  ]

#-------------------------------------------------------------------------
# gen_src_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [
    gen_rimm_src_dep_test( 5, "sltiu",    0x00000007,  0x00000001,   0 ),
    gen_rimm_src_dep_test( 4, "sltiu",    0x00000008,  0x00000fff,   1 ),
    gen_rimm_src_dep_test( 3, "sltiu",    0xfffffff0,  0x00000001,   0 ),
    gen_rimm_src_dep_test( 2, "sltiu",    0xfffffff0,  0x00000fff,   1 ),
    gen_rimm_src_dep_test( 1, "sltiu",    0x0000000a,  0x00000001,   0 ),
    gen_rimm_src_dep_test( 0, "sltiu",    0x0000000b,  0x00000001,   0 ),
  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rimm_src_eq_dest_test( "sltiu", 25, 1,  0 ),
    gen_rimm_src_eq_dest_test( "sltiu", 26, 1,  0 ),
    gen_rimm_src_eq_dest_test( "sltiu", 27, 27, 0 ),
    gen_rimm_src_eq_dest_test( "sltiu", 28, 28, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    # Compare with 0
    gen_rimm_value_test( "sltiu", 0x00000000, 0x00000000, 0 ),
    gen_rimm_value_test( "sltiu", 0x00000001, 0x00000000, 0 ),
    gen_rimm_value_test( "sltiu", 0x00000000, 0x00000007, 1 ),
    gen_rimm_value_test( "sltiu", 0x00000000, 0x00000800, 1 ),
    gen_rimm_value_test( "sltiu", 0x80000000, 0x00000000, 0 ),
    # Small & Small
    gen_rimm_value_test( "sltiu", 0x000007fe, 0x000007ff, 1 ),
    gen_rimm_value_test( "sltiu", 0x000007ff, 0x000007fe, 0 ),
    gen_rimm_value_test( "sltiu", 0x000007ff, 0x000007ff, 0 ),
    # Small & Large
    gen_rimm_value_test( "sltiu", 0x00007fff, 0x00000800, 1 ),
    gen_rimm_value_test( "sltiu", 0x80000000, 0x000007ff, 0 ),
    # Large & Large
    gen_rimm_value_test( "sltiu", 0xffff8000, 0x00000fff, 1 ),
    gen_rimm_value_test( "sltiu", 0x80000000, 0x00000fff, 1 ),
    gen_rimm_value_test( "sltiu", 0xffffffff, 0x00000800, 0 ),
    gen_rimm_value_test( "sltiu", 0xffffffff, 0x00000fff, 0 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src  = Bits( 32, random.randint(0,0xffffffff) )
    imm  = Bits( 12, random.randint(0,0xfff) )
    dest = src & sext(imm,32)
    dest = Bits( 32, 1 if (src.uint() < sext(imm,32).uint()) else 0)
    asm_code.append( gen_rimm_value_test( "sltiu", src.uint(), imm.uint(), dest.uint() ) )
  return asm_code
