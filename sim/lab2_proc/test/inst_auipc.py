#=========================================================================
# auipc
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    auipc x1, 0x00010                       # PC=0x200
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw  proc2mngr, x1 > 0x00010200
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
    gen_imm_dest_dep_test( 5, "auipc", 0x0ff, 0x000ff000 + 0x00000200 + 0*4  ),
    gen_imm_dest_dep_test( 4, "auipc", 0xff0, 0x00ff0000 + 0x00000200 + 7*4  ),
    gen_imm_dest_dep_test( 3, "auipc", 0xf00, 0x00f00000 + 0x00000200 + 13*4 ),
    gen_imm_dest_dep_test( 2, "auipc", 0x00f, 0x0000f000 + 0x00000200 + 18*4 ),
    gen_imm_dest_dep_test( 1, "auipc", 0xfff, 0x00fff000 + 0x00000200 + 22*4 ),
    gen_imm_dest_dep_test( 0, "auipc", 0x0f0, 0x000f0000 + 0x00000200 + 25*4 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_imm_value_test( "auipc", 0xf0f, 0x00f0f000 + 0x00000200 + 0*4),
    gen_imm_value_test( "auipc", 0x0f0, 0x000f0000 + 0x00000200 + 2*4),
    gen_imm_value_test( "auipc", 0x00f, 0x0000f000 + 0x00000200 + 4*4),
    gen_imm_value_test( "auipc", 0xff0, 0x00ff0000 + 0x00000200 + 6*4),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    imm  = Bits( 12, random.randint(0,0xfff) )
    dest = Bits( 32, imm )
    dest = (dest << 12) + 0x00000200 + 2*i*4
    asm_code.append( gen_imm_value_test( "auipc", imm.uint(), dest.uint() ) )
  return asm_code
