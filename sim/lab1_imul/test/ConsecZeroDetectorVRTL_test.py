#=========================================================================
# Consecutive Zero Detector for 4 bits
#=========================================================================

from copy                                   import deepcopy
from random                                 import randint

from pymtl                                  import *
from pclib.test                             import run_test_vector_sim
from lab1_imul.ConsecZeroDetectorVRTL       import ConsecZeroDetectorVRTL

#-------------------------------------------------------------------------
# Syntax helpers
#-------------------------------------------------------------------------

# We define the header string here since it is so long. Then reference
# the header string and include a comment to label each of the columns.

header_str = \
  ( "number_4b" ,     
    "shift_bits*"  )

# We define a global variable 'x' so that we can simply use the x
# character instead of '?' to indicate don't care reference outputs

x = '?'

#-------------------------------------------------------------------------
# test_basic
#-------------------------------------------------------------------------

def test_basic( dump_vcd ):
  run_test_vector_sim( ConsecZeroDetectorVRTL(), [ header_str,
    # in          out          
    # number_4b   shift_bits   
    [ 0x0,        5 ],
    [ 0x1,        1 ],
    [ 0x2,        2 ],
    [ 0x3,        1 ],
    [ 0x4,        3 ],
    [ 0x5,        1 ],
    [ 0x6,        2 ],
    [ 0x7,        1 ],
    [ 0x8,        4 ],
    [ 0x9,        1 ],
    [ 0xa,        2 ],
    [ 0xb,        1 ],
    [ 0xc,        3 ],
    [ 0xd,        1 ],
    [ 0xe,        2 ],
    [ 0xf,        1 ],     
  ], dump_vcd )

