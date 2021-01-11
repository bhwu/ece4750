#=========================================================================
# jal
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
    addi  x3, x0, 0     # 0x0200
                        #
    nop                 # 0x0204
    nop                 # 0x0208
    nop                 # 0x020c
    nop                 # 0x0210
    nop                 # 0x0214
    nop                 # 0x0218
    nop                 # 0x021c
    nop                 # 0x0220
                        #
    jal   x1, label_a   # 0x0224
    addi  x3, x3, 0b01  # 0x0228

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
    csrw  proc2mngr, x1 > 0x0228 

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3 > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_jal_value_test( "jal", 8,  0, "x31"  , 0x0200),
    gen_jal_value_test( "jal", 7,  1, "x31"  , 0x0250),
    gen_jal_value_test( "jal", 6,  2, "x31"  , 0x02a0),

    gen_jal_value_test( "jal", 5,  3, "x31"  , 0x02f0),
    gen_jal_value_test( "jal", 4,  4, "x31"  , 0x0340),
    gen_jal_value_test( "jal", 3,  5, "x31"  , 0x0390),

    gen_jal_value_test( "jal", 2,  6, "x31"  , 0x03e0),
    gen_jal_value_test( "jal", 1,  7, "x31"  , 0x0430),
    gen_jal_value_test( "jal", 0,  8, "x31"  , 0x0480),
  ]
#-------------------------------------------------------------------------
# gen_consec_jal_test
#-------------------------------------------------------------------------

def gen_consec_jal_test():
  return """

    # Use r3 to track the control flow pattern
    addi  x3, x0, 0     # 0x0200
                        #
    nop                 # 0x0204
    nop                 # 0x0208
    nop                 # 0x020c
    nop                 # 0x0210
    nop                 # 0x0214
    nop                 # 0x0218
    nop                 # 0x021c
    nop                 # 0x0220
                        #
    jal   x1, label_a   # 0x0224
    jal   x1, label_b   # 0x0228

  label_a:
    jal   x1, label_c   # 0x022c

  label_c:
    addi  x3, x3, 0b10  # 0x0230

    # Check the link address
    csrw  proc2mngr, x1 > 0x0230 

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3 > 0b10

  label_b:
    addi  x3, x3, 0b100
    
    csrw  proc2mngr, x1 > 0x0230
  """

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  result_pc_start = 0x0200
  for i in xrange(20):
	
    src0  = Bits( 5, random.randint(0,31) )
    src1  = Bits( 5, random.randint(0,31) )
    reg_index = random.randint(1,31)
    register  = "x" + str(reg_index if reg_index != 3 else 31)
    asm_code.append( gen_jal_value_test( "jal", src0.uint(), src1.uint(), register , result_pc_start) )
    result_pc_start += 4 * (src0.uint() + src1.uint()) + 0x0030
  return asm_code
