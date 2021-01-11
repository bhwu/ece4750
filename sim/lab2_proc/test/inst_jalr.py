#=========================================================================
# jalr
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    # Use r3 to track the control flow pattern
    addi  x3, x0, 0           # 0x0200
                              #
    lui x1,      %hi[label_a] # 0x0204
    addi x1, x1, %lo[label_a] # 0x0208
                              #
    nop                       # 0x020c
    nop                       # 0x0210
    nop                       # 0x0214
    nop                       # 0x0218
    nop                       # 0x021c
    nop                       # 0x0220
    nop                       # 0x0224
    nop                       # 0x0228
                              #
    jalr  x31, x1, 0          # 0x022c
    addi  x3, x3, 0b01        # 0x0230

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

  label_a:
    addi  x3, x3, 0b10

    # Check the link address
    csrw  proc2mngr, x31 > 0x0230

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3  > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_jalr_value_test( "jalr", 8,  0, "x1", "x31"  , 0x0200),
    gen_jalr_value_test( "jalr", 7,  1, "x1", "x31"  , 0x0268),
    gen_jalr_value_test( "jalr", 6,  2, "x1", "x31"  , 0x02d0),

    gen_jalr_value_test( "jalr", 5,  3, "x1", "x31"  , 0x0338),
    gen_jalr_value_test( "jalr", 4,  4, "x1", "x31"  , 0x03a0),
    gen_jalr_value_test( "jalr", 3,  5, "x1", "x31"  , 0x0408),

    gen_jalr_value_test( "jalr", 2,  6, "x1", "x31"  , 0x0470),
    gen_jalr_value_test( "jalr", 1,  7, "x1", "x31"  , 0x04d8),
    gen_jalr_value_test( "jalr", 0,  8, "x1", "x31"  , 0x0540),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  result_pc_start = 0x0200
  for i in xrange(5):	
    src0  = Bits( 5, random.randint(0,31) )
    src1  = Bits( 5, random.randint(0,31) )
    src_reg_index = random.randint(1,15)
    src_reg   = "x" + str(src_reg_index if src_reg_index != 3 else 1)    
    dest_reg_index = random.randint(16,31)
    dest_reg  = "x" + str(dest_reg_index)
    asm_code.append( gen_jalr_value_test( "jalr", src0.uint(), src1.uint(), src_reg, dest_reg , result_pc_start) )
    result_pc_start += 4 * (src0.uint() + src1.uint()) + 0x0048
  return asm_code
