#=========================================================================
# mul
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
    csrr x2, mngr2proc < 4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    mul x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 20
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
    gen_rr_dest_dep_test( 5, "mul",   1,  1,  1 ),
    gen_rr_dest_dep_test( 4, "mul",   2, -1, -2 ),
    gen_rr_dest_dep_test( 3, "mul",  -3,  1, -3 ),
    gen_rr_dest_dep_test( 2, "mul",  -4, -1,  4 ),
    gen_rr_dest_dep_test( 1, "mul",   5,  1,  5 ),
    gen_rr_dest_dep_test( 0, "mul",   6,  1,  6 ),
  ]
  
#-------------------------------------------------------------------------
# gen_src0_dep_test
#-------------------------------------------------------------------------

def gen_src0_dep_test():
  return [
    gen_rr_src0_dep_test( 5, "mul",   7,  1,   7 ),
    gen_rr_src0_dep_test( 4, "mul",   8, -1,  -8 ),
    gen_rr_src0_dep_test( 3, "mul",  -9,  1,  -9 ),
    gen_rr_src0_dep_test( 2, "mul", -10, -1,  10 ),
    gen_rr_src0_dep_test( 1, "mul",  11,  1,  11 ),
    gen_rr_src0_dep_test( 0, "mul",  12,  1,  12 ),
  ]

#-------------------------------------------------------------------------
# gen_src1_dep_test
#-------------------------------------------------------------------------

def gen_src1_dep_test():
  return [
    gen_rr_src1_dep_test( 5, "mul",  13,  1,  13 ),
    gen_rr_src1_dep_test( 4, "mul",  14, -1, -14 ),
    gen_rr_src1_dep_test( 3, "mul", -15,  1, -15 ),
    gen_rr_src1_dep_test( 2, "mul", -16, -1,  16 ),
    gen_rr_src1_dep_test( 1, "mul",  17,  1,  17 ),
    gen_rr_src1_dep_test( 0, "mul",  18,  1,  18 ),
  ]
  
#-------------------------------------------------------------------------
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [
    gen_rr_srcs_dep_test( 5, "mul",  19,  1,  19 ),
    gen_rr_srcs_dep_test( 4, "mul",  20, -1, -20 ),
    gen_rr_srcs_dep_test( 3, "mul", -21,  1, -21 ),
    gen_rr_srcs_dep_test( 2, "mul", -22, -1,  22 ),
    gen_rr_srcs_dep_test( 1, "mul",  23,  1,  23 ),
    gen_rr_srcs_dep_test( 0, "mul",  24,  1,  24 ),
  ]
  
#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_rr_src0_eq_dest_test( "mul", 25, 1, 25 ),
    gen_rr_src1_eq_dest_test( "mul", 26, 1, 26 ),
    gen_rr_src0_eq_src1_test( "mul", 26, 26*26 ),
    gen_rr_srcs_eq_dest_test( "mul", 28, 28*28 ),
  ]

#-------------------------------------------------------------------------
# gen_value_direct_test
#-------------------------------------------------------------------------

def gen_value_dir_test():
  return [
    # small positive * positive
    gen_rr_value_test( "mul",  2,  3 ,  6   ),
    gen_rr_value_test( "mul",  4,  5 , 20   ),
    gen_rr_value_test( "mul",  3,  4 , 12   ),
    gen_rr_value_test( "mul", 10,  13, 130  ),
    gen_rr_value_test( "mul",  7,  8 , 56   ),
    # small negative * negative
    gen_rr_value_test( "mul",  -6,  -3,  18 ),
    gen_rr_value_test( "mul",  -2,  -5,  10 ),
    gen_rr_value_test( "mul",  -3,  -4,  12 ),
    gen_rr_value_test( "mul", -11, -13, 143 ),
    gen_rr_value_test( "mul",  -5,  -7,  35 ),
    # small negative * positve
    gen_rr_value_test( "mul",  -3,   3, -9  ),
    gen_rr_value_test( "mul",  -7,   5, -35 ),
    gen_rr_value_test( "mul",  -3,   8, -24 ),
    gen_rr_value_test( "mul", -10,  13, -130),
    gen_rr_value_test( "mul",  -8,   1, -8  ),
    # small positve * negative
    gen_rr_value_test( "mul",   2,  -3, -6  ),
    gen_rr_value_test( "mul",   4,  -5, -20 ),
    gen_rr_value_test( "mul",   3,  -4, -12 ),
    gen_rr_value_test( "mul",  10, -13, -130),
    gen_rr_value_test( "mul",   8,  -7, -56 ),
    # zeros: directly multiply with 0
    gen_rr_value_test( "mul",   -2    ,  0     , 0 ),
    gen_rr_value_test( "mul",   4864  ,  0     , 0 ),
    gen_rr_value_test( "mul",   0     ,  13**8 , 0 ),
    gen_rr_value_test( "mul",   0     ,  -8**7 , 0 ),
    gen_rr_value_test( "mul",   0     ,  0     , 0 ),
    # large mul, overflow, including pos_pos, pos_neg, neg_pos, neg_neg
    gen_rr_value_test( "mul",  -2**19 ,  3**16   , 0x00000000ffffffff & (- (2**19) * (3**16)) ),
    gen_rr_value_test( "mul",  -4**9  ,  5**8    , 0x00000000ffffffff & (- (4**9)  * (5**8) ) ),
    gen_rr_value_test( "mul",  10**9  , -(13**8) , 0x00000000ffffffff & (- (10**9) * (13**8)) ),
    gen_rr_value_test( "mul",   8**7  , -7**9    , 0x00000000ffffffff & (- (8**7)  * (7**9) ) ),
    gen_rr_value_test( "mul",   8**7  ,  7**9    , 0x00000000ffffffff & (  (8**7)  * (7**9) ) ),
    gen_rr_value_test( "mul",   4**9  ,  5**8    , 0x00000000ffffffff & (  (4**9)  * (5**8) ) ),
    gen_rr_value_test( "mul",  -2**19 , -3**15   , 0x00000000ffffffff & (  (2**19) * (3**15)) ),
    gen_rr_value_test( "mul",  -10**9 , -13**7   , 0x00000000ffffffff & (  (10**9) * (13**7)) ),
  ]
  
#-------------------------------------------------------------------------
# gen_value_low_mask_test
#-------------------------------------------------------------------------

def gen_value_lom_test():
  lomask_code = []
  for i in xrange(20):
    a = Bits(32, random.randint( 0, 0xffffffff ))
    b = Bits(32, random.randint( 0, 0xffffffff ))
    lomask_a  = Bits(32, a & 0xffffff00)
    lomask_b  = Bits(32, b & 0xffffff00)
    product   = Bits(32, (lomask_a * lomask_b), trunc = True)
    lomask_code.append(gen_rr_value_test( "mul", lomask_a.uint(), lomask_b.uint(), product.uint()))
  return lomask_code
  
#-------------------------------------------------------------------------
# gen_value_mid_mask_test
#-------------------------------------------------------------------------

def gen_value_midm_test():
  midmask_code = []
  for i in xrange(20):
    a = Bits(32, random.randint( 0, 0xffffffff ))
    b = Bits(32, random.randint( 0, 0xffffffff ))
    midmask_a  = Bits(32, a & 0xfff000ff)
    midmask_b  = Bits(32, b & 0xfff000ff)
    product   = Bits(32, (midmask_a * midmask_b), trunc = True)
    midmask_code.append(gen_rr_value_test( "mul", midmask_a.uint(), midmask_b.uint(), product.uint()))
  return midmask_code

#-------------------------------------------------------------------------
# gen_value_sparse_test
#-------------------------------------------------------------------------

def gen_value_sprs_test():
  sparse_code = []
  for i in xrange(20):
    a = Bits(32, random.randint( 0, 0xffffffff ))
    b = Bits(32, random.randint( 0, 0xffffffff ))
    sparse_a  = Bits(32, a & (0x000000ff << random.randint(0,24)))
    sparse_b  = Bits(32, b & (0x000000ff << random.randint(0,24)))
    product   = Bits(32, (sparse_a * sparse_b), trunc = True)
    sparse_code.append(gen_rr_value_test( "mul", sparse_a.uint(), sparse_b.uint(), product.uint()))
  return sparse_code

#-------------------------------------------------------------------------
# gen_value_dense_test
#-------------------------------------------------------------------------

def gen_value_dens_test():
  dense_code = []
  for i in xrange(20):
    a = Bits(32, random.randint( 0, 0xffffffff ))
    b = Bits(32, random.randint( 0, 0xffffffff ))
    dense_a  = Bits(32, a | (0xffffff00 >> random.randint(0,8) ))
    dense_b  = Bits(32, b | (0xffffff00 >> random.randint(0,8) ))
    product   = Bits(32, (dense_a * dense_b), trunc = True)
    dense_code.append(gen_rr_value_test( "mul", dense_a.uint(), dense_b.uint(), product.uint()))
  return dense_code

#-------------------------------------------------------------------------
# gen_consec_mul_test
#-------------------------------------------------------------------------

def gen_consec_mul_test():
  return """
    csrr x1, mngr2proc < 5
    csrr x2, mngr2proc < 4
    mul x3, x1, x2     # 5 * 4 = 20
    mul x3, x1, x3     # 5 * 20 = 100
    mul x3, x1, x3     # 5 * 100 = 500
    csrw proc2mngr, x3 > 500
  """
  
#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    src0     = Bits( 32, random.randint(0,0xffffffff) )
    src1     = Bits( 32, random.randint(0,0xffffffff) )
    dest     = Bits( 32, src0 * src1, trunc = True    )
    asm_code.append( gen_rr_value_test( "mul", src0.uint(), src1.uint(), dest.uint() ) )
  return asm_code
