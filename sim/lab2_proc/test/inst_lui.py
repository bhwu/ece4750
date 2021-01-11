#=========================================================================
# lui
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    lui x1, 0x0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x1 > 0x00001000
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
    gen_imm_dest_dep_test( 5, "lui", 0x0ff, 0x000ff000 ),
    gen_imm_dest_dep_test( 4, "lui", 0xff0, 0x00ff0000 ),
    gen_imm_dest_dep_test( 3, "lui", 0xf00, 0x00f00000 ),
    gen_imm_dest_dep_test( 2, "lui", 0x00f, 0x0000f000 ),
    gen_imm_dest_dep_test( 1, "lui", 0xfff, 0x00fff000 ),
    gen_imm_dest_dep_test( 0, "lui", 0x0f0, 0x000f0000 ),
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [
    gen_imm_value_test( "lui", 0xf0f, 0x00f0f000 ),
    gen_imm_value_test( "lui", 0x0f0, 0x000f0000 ),
    gen_imm_value_test( "lui", 0x00f, 0x0000f000 ),
    gen_imm_value_test( "lui", 0xff0, 0x00ff0000 ),
  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():
  asm_code = []
  for i in xrange(100):
    imm  = Bits( 12, random.randint(0,0xfff) )
    dest = Bits( 32, imm )
    dest = dest << 12
    asm_code.append( gen_imm_value_test( "lui", imm.uint(), dest.uint() ) )
  return asm_code
