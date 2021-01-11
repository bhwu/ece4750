#=========================================================================
# Consecutive Zero Detector for 4 bits
#=========================================================================

from pymtl import *
import os

class ConsecZeroDetectorVRTL( VerilogModel ):

  # Verilog module setup

  vprefix = "lab1_imul"

  # Constructor

  def __init__( s ):

    s.number_4b  = InPort  ( 4 )
    s.shift_bits = OutPort ( 3 )


    # Verilog ports

    s.set_ports({
      'number_4b'     : s.number_4b,
      'shift_bits'    : s.shift_bits,
    })

  # Line tracing

  def line_trace( s ):
    return "{}||{}".format( s.number_4b, s.shift_bits )


