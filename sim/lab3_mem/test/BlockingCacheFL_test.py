#=========================================================================
# BlockingCacheFL_test.py
#=========================================================================

from __future__ import print_function

import pytest
import random
import struct
import numpy

random.seed(0xa4e28cc2)

from pymtl      import *
from pclib.test import mk_test_case_table, run_sim
from pclib.test import TestSource
from pclib.test import TestMemory

from pclib.ifcs import MemMsg,    MemReqMsg,    MemRespMsg
from pclib.ifcs import MemMsg4B,  MemReqMsg4B,  MemRespMsg4B
from pclib.ifcs import MemMsg16B, MemReqMsg16B, MemRespMsg16B

from TestCacheSink   import TestCacheSink
from lab3_mem.BlockingCacheFL import BlockingCacheFL

# We define all test cases here. They will be used to test _both_ FL and
# RTL models.
#
# Notice the difference between the TestHarness instances in FL and RTL.
#
# class TestHarness( Model ):
#   def __init__( s, src_msgs, sink_msgs, stall_prob, latency,
#                 src_delay, sink_delay, CacheModel, check_test, dump_vcd )
#
# The last parameter of TestHarness, check_test is whether or not we
# check the test field in the cacheresp. In FL model we don't care about
# test field and we set cehck_test to be False because FL model is just
# passing through cachereq to mem, so all cachereq sent to the FL model
# will be misses, whereas in RTL model we must set check_test to be True
# so that the test sink will know if we hit the cache properly.


#-------------------------------------------------------------------------
# Global variable
#-------------------------------------------------------------------------
# generic
randData = [Bits(32,0)]*64
randAddr  = [Bits(32,0)]*64
randReqType = numpy.zeros(64) # 0 = read, 1 = write
wData = [Bits(32,0)]*64
# dmap
randInd_dmap = [Bits(4,0)]*64
randTag_dmap = [Bits(28,0)]*64
dmap_cacheSim = [Bits(28,0)]*16
dmap_hit_miss = numpy.zeros(128)
#assoc
randInd_assoc = [Bits(3,0)]*64
randTag_assoc = [Bits(28,0)]*64
assoc_cacheSim = [[Bits(28,0)]*3]*8
assoc_hit_miss = numpy.zeros(128)

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness( Model ):

  def __init__( s, src_msgs, sink_msgs, stall_prob, latency,
                src_delay, sink_delay, 
                CacheModel, num_banks, check_test, dump_vcd ):

    # Messge type

    cache_msgs = MemMsg4B()
    mem_msgs   = MemMsg16B()

    # Instantiate models

    s.src   = TestSource   ( cache_msgs.req,  src_msgs,  src_delay  )
    s.cache = CacheModel   ( num_banks = num_banks )
    s.mem   = TestMemory   ( mem_msgs, 1, stall_prob, latency )
    s.sink  = TestCacheSink( cache_msgs.resp, sink_msgs, sink_delay, check_test )

    # Dump VCD

    if dump_vcd:
      s.cache.vcd_file = dump_vcd

    # Connect

    s.connect( s.src.out,       s.cache.cachereq  )
    s.connect( s.sink.in_,      s.cache.cacheresp )

    s.connect( s.cache.memreq,  s.mem.reqs[0]     )
    s.connect( s.cache.memresp, s.mem.resps[0]    )

  def load( s, addrs, data_ints ):
    for addr, data_int in zip( addrs, data_ints ):
      data_bytes_a = bytearray()
      data_bytes_a.extend( struct.pack("<I",data_int) )
      s.mem.write_mem( addr, data_bytes_a )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace() + " " + s.cache.line_trace() + " " \
         + s.mem.line_trace() + " " + s.sink.line_trace()

#-------------------------------------------------------------------------
# make messages
#-------------------------------------------------------------------------

def req( type_, opaque, addr, len, data ):
  msg = MemReqMsg4B()

  if   type_ == 'rd': msg.type_ = MemReqMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = MemReqMsg.TYPE_WRITE
  elif type_ == 'in': msg.type_ = MemReqMsg.TYPE_WRITE_INIT

  msg.addr   = addr
  msg.opaque = opaque
  msg.len    = len
  msg.data   = data
  return msg

def resp( type_, opaque, test, len, data ):
  msg = MemRespMsg4B()

  if   type_ == 'rd': msg.type_ = MemRespMsg.TYPE_READ
  elif type_ == 'wr': msg.type_ = MemRespMsg.TYPE_WRITE
  elif type_ == 'in': msg.type_ = MemRespMsg.TYPE_WRITE_INIT

  msg.opaque = opaque
  msg.len    = len
  msg.test   = test
  msg.data   = data
  return msg

#----------------------------------------------------------------------
# Test Case: read hit path
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT

def read_hit_1word_clean( base_addr ):
  return [
    #    type  opq  addr      len data                type  opq  test len data
    req( 'in', 0x0, base_addr, 0, 0xdeadbeef ), resp( 'in', 0x0, 0,   0,  0          ), # init base_addr
    req( 'rd', 0x1, base_addr, 0, 0          ), resp( 'rd', 0x1, 1,   0,  0xdeadbeef ), # read base_addr
  ]
def read_hit_1word_dirty( base_addr ):
  return [
    #    type  opq  addr      len data                type  opq  test len data
    req( 'wr', 0x0, base_addr, 0, 0xdeadbeef ), resp( 'wr', 0x0, 0,   0,  0          ), # init base_addr
    req( 'rd', 0x1, base_addr, 0, 0          ), resp( 'rd', 0x1, 1,   0,  0xdeadbeef ), # read base_addr
  ]

#----------------------------------------------------------------------
# Test Case: read hit path -- for set-associative cache
#----------------------------------------------------------------------
# This set of tests designed only for alternative design
# The test field in the response message: 0 == MISS, 1 == HIT

def read_hit_asso( base_addr ):
  return [
    #    type  opq  addr       len data                type  opq  test len data
    req( 'wr', 0x0, 0x00000000, 0, 0xdeadbeef ), resp( 'wr', 0x0, 0,   0,  0          ), # write 0x0000
    req( 'wr', 0x1, 0x00001000, 0, 0x00c0ffee ), resp( 'wr', 0x1, 0,   0,  0          ), # write 0x1000
    req( 'rd', 0x2, 0x00000000, 0, 0          ), resp( 'rd', 0x2, 1,   0,  0xdeadbeef ), # read  0x0000
    req( 'rd', 0x3, 0x00001000, 0, 0          ), resp( 'rd', 0x3, 1,   0,  0x00c0ffee ), # read  0x0000
  ]

#----------------------------------------------------------------------
# Test Case: read hit path -- for direct-mapped cache
#----------------------------------------------------------------------
# This set of tests designed only for baseline design

def read_hit_dmap( base_addr ):
  return [
    #    type  opq  addr       len data                type  opq  test len data
    req( 'wr', 0x0, 0x00000000, 0, 0xdeadbeef ), resp( 'wr', 0x0, 0,   0,  0          ), # write 0x000
    req( 'wr', 0x1, 0x00000080, 0, 0x00c0ffee ), resp( 'wr', 0x1, 0,   0,  0          ), # write 0x080
    req( 'rd', 0x2, 0x00000000, 0, 0          ), resp( 'rd', 0x2, 1,   0,  0xdeadbeef ), # read  0x000
    req( 'rd', 0x3, 0x00000080, 0, 0          ), resp( 'rd', 0x3, 1,   0,  0x00c0ffee ), # read  0x080
  ]

#-------------------------------------------------------------------------
# Test Case: write hit path
#-------------------------------------------------------------------------

def write_hit_1word_clean( base_addr ):
  return [
    #    type  opq   addr      len data               type  opq   test len data
    req( 'in', 0x00, base_addr, 0, 0x0a0b0c0d ), resp('in', 0x00, 0,   0,  0          ), # write base_addr
    req( 'wr', 0x01, base_addr, 0, 0xbeefbeeb ), resp('wr', 0x01, 1,   0,  0          ), # write base_addr
    req( 'rd', 0x02, base_addr, 0, 0          ), resp('rd', 0x02, 1,   0,  0xbeefbeeb ), # read  base_addr
  ]
def write_hit_1word_dirty( base_addr ):
  return [
    #    type  opq   addr      len data               type  opq   test len data
    req( 'wr', 0x00, base_addr, 0, 0x0a0b0c0d ), resp('in', 0x00, 0,   0,  0          ), # write base_addr
    req( 'wr', 0x01, base_addr, 0, 0xbeefbeeb ), resp('wr', 0x01, 1,   0,  0          ), # write base_addr
    req( 'rd', 0x02, base_addr, 0, 0          ), resp('rd', 0x02, 1,   0,  0xbeefbeeb ), # read  base_addr
  ]

#-------------------------------------------------------------------------
# Test Case: read miss path
#-------------------------------------------------------------------------

def read_miss_1word_msg( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'rd', 0x00, 0x00000000, 0, 0          ), resp('rd', 0x00, 0, 0, 0xdeadbeef ), # read 0x000
    req( 'rd', 0x01, 0x00000004, 0, 0          ), resp('rd', 0x01, 1, 0, 0x00c0ffee ), # read 0x004
  ]
def read_miss_1word_noEvict( base_addr ):
  return [
    #    type  opq   addr      len  data               type  opq test len  data
    req( 'in', 0x00, 0x00000110, 0, 0x00c0ffee ), resp('in', 0x00, 0, 0, 0          ), # write 0x100
    req( 'rd', 0x01, 0x00000000, 0, 0          ), resp('rd', 0x01, 0, 0, 0xdeadbeef ), # read  0x000
    req( 'rd', 0x02, 0x00000110, 0, 0          ), resp('rd', 0x02, 1, 0, 0x00c0ffee ), # read  0x100
  ]
def read_miss_cacheline( base_addr ):
# checks that the entire cacheline is brought into the cache upon a read miss
  tVec      = []
  cacheline = 0x00000000
  base_val  = 0xf0000000
  opaque    = 0x00
  for i in xrange(16):
  # NOTE COMMENTS ARE FOR FIRST ITERATION ONLY
    #                type  opq     addr       len data
    tVec.append(req( 'rd', opaque, cacheline, 0,  0))
    #                type  opq     test len data
    tVec.append(resp('rd', opaque, 0,   0,  base_val + cacheline))              # read 0x000 (miss)
    #                type  opq           addr             len data
    tVec.append(req( 'rd', opaque + 0x1, cacheline + 0x4, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x1, 1,   0,  base_val + cacheline + 0x4))  # read 0x004 (hit)
    #                type  opq           addr             len data
    tVec.append(req( 'rd', opaque + 0x2, cacheline + 0x8, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x2, 1,   0,  base_val + cacheline + 0x8))  # read 0x008 (hit)
    #                type  opq           addr             len data
    tVec.append(req( 'rd', opaque + 0x3, cacheline + 0xc, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x3, 1,   0,  base_val + cacheline + 0xc))  # read 0x00c (hit)
    cacheline = cacheline + 0x10
    opaque = opaque + 0x4
  return tVec

def read_miss_evict_dmap( base_addr ):
  tVec = []
  cacheline = 0x00000000
  base_val  = 0xf0000000
  opaque    = 0x00
  for i in xrange(16):
  #NOTE COMMENTS ARE FOR FIRST ITERATION ONLY
    evictWord = random.randint(0,3) * 0x4
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque,       cacheline + evictWord, 0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque,       0,   0,  base_val + cacheline + evictWord))  # read  0x00? (miss)
    #                type  opq           addr                   len data
    tVec.append(req( 'wr', opaque + 0x1, cacheline + evictWord, 0,  0xaaaaaaaa ))
    #                type  opq           test len data
    tVec.append(resp('wr', opaque + 0x1, 1,   0,  0 ))                                # write 0x00? (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x2, cacheline + 0x100,     0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x2, 0,   0,  0xdeadbeef))                        # read  0x100 (miss + evict 0x00?)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x3, cacheline + evictWord, 0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x3, 0,   0,  0xaaaaaaaa))                        # read  0x00? (miss)
    cacheline = cacheline + 0x10
    opaque = opaque + 0x4
    return tVec

def read_miss_evict_assoc( base_addr ):
  tVec = []
  cacheline = 0x00000000
  base_val  = 0xf0000000
  opaque    = 0x00
  for i in xrange(16):
  #NOTE COMMENTS ARE FOR FIRST ITERATION ONLY
    evictWord = random.randint(0,3) * 0x4
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque,       cacheline + evictWord, 0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque,       0,   0,  base_val + cacheline + evictWord))  # read  0x00? (miss)
    #                type  opq           addr                   len data
    tVec.append(req( 'wr', opaque + 0x1, cacheline + evictWord, 0,  0xaaaaaaaa ))
    #                type  opq           test len data
    tVec.append(resp('wr', opaque + 0x1, 1,   0,  0 ))                                # write 0x00? (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x2, cacheline + 0x100,     0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x2, 0,   0,  0xdeadbeef))                        # read  0x100 (miss)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x3, cacheline + evictWord, 0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x3, 1,   0,  0xaaaaaaaa))                        # read  0x00? (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x4, cacheline + 0x100,     0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x4, 1,   0,  0xdeadbeef))                        # read  0x100 (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x5, cacheline + 0x200,     0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x5, 0,   0,  0x00c0ffee))                        # read  0x200 (miss + evict 0x00?)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x6, cacheline + evictWord, 0,  0 ))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x6, 0,   0,  0xaaaaaaaa))                        # read  0x00? (miss)
    cacheline = cacheline + 0x10
    opaque = opaque + 0x7
    return tVec

#-------------------------------------------------------------------------
# Test Case: write miss path
#-------------------------------------------------------------------------

def write_miss_1word_clean( base_addr ):
  return [
    #    type  opq   addr      len data               type  opq   test len data
    req( 'wr', 0x00, base_addr, 0, 0xbeefbeeb ), resp('wr', 0x00, 0,   0,  0          ), # write 0x000
    req( 'rd', 0x01, base_addr, 0, 0          ), resp('rd', 0x01, 1,   0,  0xbeefbeeb ), # read  0x000
  ]
def write_miss_cacheline( base_addr ):
  # checks that the entire cacheline is brought into the cache upon a read miss
  tVec      = []
  cacheline = 0x00000000
  base_val  = 0xf0000000
  opaque    = 0x00
  for i in xrange(16):
  #NOTE COMMENTS ARE FOR FIRST ITERATION ONLY
    #                type  opq           addr                   len data
    tVec.append(req( 'wr', opaque,       cacheline,             0,  0xaaaaaaaa))
    #                type  opq           test len data
    tVec.append(resp('wr', opaque,       0,   0,  0))                           # write 0x000 (miss)
    #                type  opq           addr             len data
    tVec.append(req( 'rd', opaque + 0x1, cacheline + 0x4, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x1, 1,   0,  base_val + cacheline + 0x4))  # read  0x004 (hit)
    #                type  opq           addr             len data
    tVec.append(req( 'rd', opaque + 0x2, cacheline + 0x8, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x2, 1,   0,  base_val + cacheline + 0x8))  # read  0x008 (hit)
    #                type  opq           addr             len data
    tVec.append(req( 'rd', opaque + 0x3, cacheline + 0xc, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x3, 1,   0,  base_val + cacheline + 0xc))  # read  0x00c (hit)
    cacheline = cacheline + 0x10
    opaque = opaque + 0x4
  return tVec

def write_miss_evict_dmap( base_addr ):
  tVec = []
  cacheline = 0x00000000
  base_val  = 0xf0000000
  opaque    = 0x00
  for i in xrange(16):
  #NOTE COMMENTS ARE FOR FIRST ITERATION ONLY
    evictWord = random.randint(0,3) * 0x4
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque,       cacheline + evictWord, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque,       0,   0,  base_val + cacheline + evictWord))   # read  0x00? (miss)
    #                type  opq           addr                   len data
    tVec.append(req( 'wr', opaque + 0x1, cacheline + evictWord, 0,  0xaaaaaaaa))
    #                type  opq           test len data
    tVec.append(resp('wr', opaque + 0x1, 1,   0,  0))                                  # write 0x00? (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x2, cacheline + evictWord, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x2, 1,   0,  0xaaaaaaaa))                         # read  0x00? (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'wr', opaque + 0x3, cacheline + 0x100,     0,  0xbbbbbbbb))
    #                type  opq           test len data
    tVec.append(resp('wr', opaque + 0x3, 0,   0,  0))                                  # write 0x100 (miss + evict 0x00?)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x4, cacheline + 0x100,     0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x4, 1,   0,  0xbbbbbbbb))                         # read  0x100 (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x5, cacheline + evictWord, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x5, 0,   0,  0xaaaaaaaa))                         # read  0x00? (miss)
    cacheline = cacheline + 0x10
    opaque = opaque + 0x6
  return tVec

def write_miss_evict_assoc( base_addr ):
  tVec = []
  cacheline = 0x00000000
  base_val  = 0xf0000000
  opaque    = 0x00
  for i in xrange(16):
  #NOTE COMMENTS ARE FOR FIRST ITERATION ONLY
    evictWord = random.randint(0,3) * 0x4
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque,       cacheline + evictWord, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque,       0,   0,  base_val + cacheline + evictWord))   # read  0x00? (miss)
    #                type  opq           addr                   len data
    tVec.append(req( 'wr', opaque + 0x1, cacheline + evictWord, 0,  0xaaaaaaaa))
    #                type  opq           test len data
    tVec.append(resp('wr', opaque + 0x1, 1,   0,  0))                                  # write 0x00? (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x2, cacheline + evictWord, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x2, 1,   0,  0xaaaaaaaa))                         # read  0x00? (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x3, cacheline + 0x100,     0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x3, 0,   0,  0xdeadbeef))                         # read  0x100 (miss)
    #                type  opq           addr                   len data
    tVec.append(req( 'wr', opaque + 0x4, cacheline + 0x200,     0,  0xbbbbbbbb))
    #                type  opq           test len data
    tVec.append(resp('wr', opaque + 0x4, 0,   0,  0))                                  # write 0x200 (miss + evict 0x00?)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x5, cacheline + 0x100,     0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x5, 1,   0,  0xdeadbeef))                         # read  0x100 (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x6, cacheline + 0x200,     0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x6, 1,   0,  0xbbbbbbbb))                         # read  0x200 (hit)
    #                type  opq           addr                   len data
    tVec.append(req( 'rd', opaque + 0x7, cacheline + evictWord, 0,  0))
    #                type  opq           test len data
    tVec.append(resp('rd', opaque + 0x7, 0,   0,  0xaaaaaaaa))                         # read  0x00? (miss)
    cacheline = cacheline + 0x10
    opaque = opaque + 0x8
  return tVec
  
#-------------------------------------------------------------------------
# Test Case: 4B tests
#-------------------------------------------------------------------------
def cases_4B_dmap ( base_addr ):
	# Tests 4B cases, covering 1) write miss, no evict 2) write miss, evict
	# 3) write hit 4) read miss, evict 5) read miss, no evict 6) read miss
	return [
	  # Test cases independent of banking structure
	  req( 'rd', 0x01, 0x00000fc0, 0, 0          ), resp('rd', 0x01, 0,   0,  0xadd10000 ), # read  0x000ffff0 (read miss no evict)
	  req( 'wr', 0x02, 0x00000fc0, 0, 0xaaaaaaaa ), resp('wr', 0x02, 1,   0,  0          ), # write 0x000ffff0 (write hit)
	  req( 'rd', 0x03, 0x00000fc0, 0, 0          ), resp('rd', 0x03, 1,   0,  0xaaaaaaaa ), # read  0x000ffff0 (read hit)
	  
	  # Test same bank, same index
	  #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x04, 0x00000000, 0, 0xaaaaaaaa ), resp('wr', 0x04, 0,   0,  0          ), # write 0x00000000 (write miss no evict)
      req( 'wr', 0x05, 0x00001000, 0, 0xbbbbbbbb ), resp('wr', 0x05, 0,   0,  0          ), # write 0x00001000 (write miss evict)
      req( 'rd', 0x06, 0x00000000, 0, 0          ), resp('rd', 0x06, 0,   0,  0xaaaaaaaa ), # read  0x00000000 (read miss evict)
      req( 'rd', 0x07, 0x00001000, 0, 0          ), resp('rd', 0x07, 0,   0,  0xbbbbbbbb ), # read  0x00001000 (read miss evict)
      
      # Test same bank, different index 
      #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x08, 0x00000040, 0, 0xaaaaaaaa ), resp('wr', 0x08, 0,   0,  0          ), # write 0x00000040 (write miss no evict)
      req( 'wr', 0x09, 0x00001080, 0, 0xbbbbbbbb ), resp('wr', 0x09, 0,   0,  0          ), # write 0x00001080 (write miss no evict)
      req( 'rd', 0x0a, 0x00000040, 0, 0          ), resp('rd', 0x0a, 1,   0,  0xaaaaaaaa ), # read  0x00000040 (read hit)      
      req( 'rd', 0x0b, 0x00001080, 0, 0          ), resp('rd', 0x0b, 1,   0,  0xbbbbbbbb ), # read  0x00001080 (read hit)
      
      # Test different bank, same index
	  #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x0c, 0x000000d0, 0, 0xaaaaaaaa ), resp('wr', 0x0c, 0,   0,  0          ), # write 0x000000d0 (write miss no evict)
      req( 'wr', 0x0d, 0x000010e0, 0, 0xbbbbbbbb ), resp('wr', 0x0d, 0,   0,  0          ), # write 0x000010e0 (write miss evict)
      req( 'rd', 0x0e, 0x000000d0, 0, 0          ), resp('rd', 0x0e, 0,   0,  0xaaaaaaaa ), # read  0x000000d0 (read miss evict)
      req( 'rd', 0x0f, 0x000010e0, 0, 0          ), resp('rd', 0x0f, 0,   0,  0xbbbbbbbb ), # read  0x000010e0 (read miss evict)
      
      # Test different bank, different index 
      #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x10, 0x00000120, 0, 0xaaaaaaaa ), resp('wr', 0x10, 0,   0,  0          ), # write 0x00000120 (write miss no evict)
      req( 'wr', 0x11, 0x00001170, 0, 0xbbbbbbbb ), resp('wr', 0x11, 0,   0,  0          ), # write 0x00001170 (write miss no evict)
      req( 'rd', 0x12, 0x00000120, 0, 0          ), resp('rd', 0x12, 1,   0,  0xaaaaaaaa ), # read  0x00000120 (read hit)      
      req( 'rd', 0x13, 0x00001170, 0, 0          ), resp('rd', 0x13, 1,   0,  0xbbbbbbbb ) # read  0x00001170 (read hit)
	]
	
def cases_4B_assoc ( base_addr ):
	# Tests 4B cases, covering 1) write miss, no evict 2) write miss, evict
	# 3) write hit 4) read miss, evict 5) read miss, no evict 6) read miss
	return [
	  # Test cases independent of banking structure
	  req( 'rd', 0x01, 0x00000fc0, 0, 0          ), resp('rd', 0x01, 0,   0,  0xadd10000 ), # read  0x000ffff0 (read miss no evict)
	  req( 'wr', 0x02, 0x00000fc0, 0, 0xaaaaaaaa ), resp('wr', 0x02, 1,   0,  0          ), # write 0x000ffff0 (write hit)
	  req( 'rd', 0x03, 0x00000fc0, 0, 0          ), resp('rd', 0x03, 1,   0,  0xaaaaaaaa ), # read  0x000ffff0 (read hit)
	  
	  # Test same bank, same index
	  #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x04, 0x00000000, 0, 0xaaaaaaaa ), resp('wr', 0x04, 0,   0,  0          ), # write 0x00000000 (write miss no evict)
      req( 'wr', 0x05, 0x00001000, 0, 0xbbbbbbbb ), resp('wr', 0x05, 0,   0,  0          ), # write 0x00001000 (write miss no evict)
      req( 'wr', 0x06, 0x00002000, 0, 0xcccccccc ), resp('wr', 0x06, 0,   0,  0          ), # write 0x00002000 (write miss evict)
      req( 'rd', 0x07, 0x00000000, 0, 0          ), resp('rd', 0x07, 0,   0,  0xaaaaaaaa ), # read  0x00000000 (read miss evict)
      req( 'rd', 0x08, 0x00001000, 0, 0          ), resp('rd', 0x08, 0,   0,  0xbbbbbbbb ), # read  0x00001000 (read miss evict)
      
      # Test same bank, different index 
      #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x09, 0x00000040, 0, 0xaaaaaaaa ), resp('wr', 0x09, 0,   0,  0          ), # write 0x00000040 (write miss no evict)
      req( 'wr', 0x0a, 0x00001080, 0, 0xbbbbbbbb ), resp('wr', 0x0a, 0,   0,  0          ), # write 0x00001080 (write miss no evict)
      req( 'wr', 0x0b, 0x000020c0, 0, 0xcccccccc ), resp('wr', 0x0b, 0,   0,  0          ), # write 0x000020c0 (write miss no evict)
      req( 'rd', 0x0c, 0x00000040, 0, 0          ), resp('rd', 0x0c, 1,   0,  0xaaaaaaaa ), # read  0x00000040 (read hit)      
      req( 'rd', 0x0d, 0x00001080, 0, 0          ), resp('rd', 0x0d, 1,   0,  0xbbbbbbbb ), # read  0x00001080 (read hit)
      
      # Test different bank, same index
	  #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x0c, 0x000000d0, 0, 0xaaaaaaaa ), resp('wr', 0x0c, 0,   0,  0          ), # write 0x000000d0 (write miss no evict)
      req( 'wr', 0x0d, 0x000010e0, 0, 0xbbbbbbbb ), resp('wr', 0x0d, 0,   0,  0          ), # write 0x000010e0 (write miss evict)
      req( 'wr', 0x0d, 0x000020f0, 0, 0xcccccccc ), resp('wr', 0x0d, 0,   0,  0          ), # write 0x000020f0 (write miss evict)
      req( 'rd', 0x0e, 0x000000d0, 0, 0          ), resp('rd', 0x0e, 0,   0,  0xaaaaaaaa ), # read  0x000000d0 (read miss evict)
      req( 'rd', 0x0f, 0x000010e0, 0, 0          ), resp('rd', 0x0f, 0,   0,  0xbbbbbbbb ), # read  0x000010e0 (read miss evict)
      
      # Test different bank, different index 
      #    type  opq   addr      len data                type  opq   test len data
      req( 'wr', 0x10, 0x00000120, 0, 0xaaaaaaaa ), resp('wr', 0x10, 0,   0,  0          ), # write 0x00000120 (write miss no evict)
      req( 'wr', 0x11, 0x00001170, 0, 0xbbbbbbbb ), resp('wr', 0x11, 0,   0,  0          ), # write 0x00001170 (write miss evict)
      req( 'wr', 0x11, 0x00002180, 0, 0xcccccccc ), resp('wr', 0x11, 0,   0,  0          ), # write 0x00002180 (write miss evict)
      req( 'rd', 0x12, 0x00000120, 0, 0          ), resp('rd', 0x12, 1,   0,  0xaaaaaaaa ), # read  0x00000120 (read hit)      
      req( 'rd', 0x13, 0x00001170, 0, 0          ), resp('rd', 0x13, 1,   0,  0xbbbbbbbb )  # read  0x00001170 (read hit)
	]

#-------------------------------------------------------------------------
# Random tests
#-------------------------------------------------------------------------

def rand_writeData( base_addr ):
    datas = []
    tVec  = []
    opaque    = 0x00
    cacheline = 0x00000000
    for i in xrange(16):
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr       len data
      tVec.append(req( 'wr', opaque,       cacheline, 0,  datas[4*i] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque,       0,   0,  0))
      
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'wr', opaque+0x1,   cacheline + 0x4, 0,  datas[4*i+1] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque+0x1,   1,   0,  0))
      
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'wr', opaque+0x2,   cacheline + 0x8, 0,  datas[4*i+2] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque+0x2,   1,   0,  0))
      
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'wr', opaque+0x3,   cacheline + 0xc, 0,  datas[4*i+3] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque+0x3,   1,   0,  0))
      
      cacheline = cacheline + 0x10
      opaque = opaque + 0x4
    
    cacheline = 0x00000000
    for i in xrange (16):
      #                type  opq           addr       len data
      tVec.append(req( 'rd', opaque,       cacheline, 0,  0 ))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque,       1,   0,  datas[4*i]))
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'rd', opaque+0x1,   cacheline + 0x4, 0,  0 ))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque+0x1,   1,   0,  datas[4*i+1]))
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'rd', opaque+0x2,   cacheline + 0x8, 0,  0 ))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque+0x2,   1,   0,  datas[4*i+2]))
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'rd', opaque+0x3,   cacheline + 0xc, 0,  0))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque+0x3,   1,   0,  datas[4*i+3] ))
      cacheline = cacheline + 0x10
      opaque = opaque + 0x4   
    return tVec
    
def rand_writeStrideData( base_addr ):
    datas = []
    tVec  = []
    opaque    = 0x00
    cacheline = 0x00000000
    for i in xrange(16):
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr       len data
      tVec.append(req( 'wr', opaque,       cacheline, 0,  datas[i] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque,       0,   0,  0))
      
      cacheline = cacheline + 0x10
      opaque = opaque + 0x4
    
    cacheline = 0x00000000
    for i in xrange (16):
      #                type  opq           addr       len data
      tVec.append(req( 'rd', opaque,       cacheline, 0,  0 ))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque,       1,   0,  datas[i]))

      cacheline = cacheline + 0x10
      opaque = opaque + 0x4   
    return tVec
    
def rand_UnitStrideShared( base_addr ):
    datas = []
    tVec  = []
    opaque    = 0x00
    cacheline = random.randint(0,0x000ffff)<<4
    for i in xrange(16):
      datas.append(random.randint(0, 0xffffffff))
      if(i == 0):
        tVal = 0
      else:
        tVal = 1
      #                type  opq           addr       len data
      tVec.append(req( 'wr', opaque,       cacheline, 0,  datas[4*i] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque,       tVal,0,  0))
      
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'wr', opaque+0x1,   cacheline + 0x4, 0,  datas[4*i+1] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque+0x1,   1,   0,  0))
      
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'wr', opaque+0x2,   cacheline + 0x8, 0,  datas[4*i+2] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque+0x2,   1,   0,  0))
      
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'wr', opaque+0x3,   cacheline + 0xc, 0,  datas[4*i+3] ))
      #                type  opq           test len data
      tVec.append(resp('wr', opaque+0x3,   1,   0,  0))
      
      
      #                type  opq           addr       len data
      tVec.append(req( 'rd', opaque,       cacheline, 0,  0 ))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque,       1,   0,  datas[4*i]))
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'rd', opaque+0x1,   cacheline + 0x4, 0,  0 ))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque+0x1,   1,   0,  datas[4*i+1]))
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'rd', opaque+0x2,   cacheline + 0x8, 0,  0 ))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque+0x2,   1,   0,  datas[4*i+2]))
      datas.append(random.randint(0, 0xffffffff))
      #                type  opq           addr             len data
      tVec.append(req( 'rd', opaque+0x3,   cacheline + 0xc, 0,  0))
      #                type  opq           test len data
      tVec.append(resp('rd', opaque+0x3,   1,   0,  datas[4*i+3] ))
      
      opaque = opaque + 0x8  
    return tVec
    
def rand_reqTypes( base_addr ):
    isWriteArr = []
    tVec  = []
    opaque    = 0x00
    cacheline = 0x00000000
    base_val  = 0xf0000000
    for i in xrange(16):
      isWriteArr.append(random.randint(0,1))
      if (isWriteArr[4*i] == 1):
        #                type  opq           addr       len data
        tVec.append(req( 'wr', opaque,       cacheline, 0,  0xaaaaaaaa ))
        #                type  opq           test len data
        tVec.append(resp('wr', opaque,       0,   0,  0))
      else:
        #                type  opq           addr       len data
        tVec.append(req( 'rd', opaque,       cacheline, 0,  0          ))
        #                type  opq           test len data
        tVec.append(resp('rd', opaque,       0,   0,  cacheline + base_val))
        
      isWriteArr.append(random.randint(0,1))
      if (isWriteArr[4*i+1] == 1):
        #                type  opq           addr           len data
        tVec.append(req( 'wr', opaque+0x1,   cacheline+0x4, 0,  0xaaaaaaaa ))
        #                type  opq           test len data
        tVec.append(resp('wr', opaque+0x1,   1,   0,  0))
      else:
        #                type  opq           addr           len data
        tVec.append(req( 'rd', opaque+0x1,   cacheline+0x4, 0,  0          ))
        #                type  opq           test len data
        tVec.append(resp('rd', opaque+0x1,   1,   0,  cacheline + base_val + 0x4))
        
      isWriteArr.append(random.randint(0,1))
      if (isWriteArr[4*i+2] == 1):
        #                type  opq           addr           len data
        tVec.append(req( 'wr', opaque+0x2,   cacheline+0x8, 0,  0xaaaaaaaa ))
        #                type  opq           test len data
        tVec.append(resp('wr', opaque+0x2,   1,   0,  0))
      else:
        #                type  opq           addr           len data
        tVec.append(req( 'rd', opaque+0x2,   cacheline+0x8, 0,  0          ))
        #                type  opq           test len data
        tVec.append(resp('rd', opaque+0x2,   1,   0,  cacheline + base_val + 0x8))
        
      isWriteArr.append(random.randint(0,1))
      if (isWriteArr[4*i+3] == 1):
        #                type  opq           addr           len data
        tVec.append(req( 'wr', opaque+0x3,   cacheline+0xc, 0,  0xaaaaaaaa ))
        #                type  opq           test len data
        tVec.append(resp('wr', opaque+0x3,   1,   0,  0))
      else:
        #                type  opq           addr           len data
        tVec.append(req( 'rd', opaque+0x3,   cacheline+0xc, 0,  0          ))
        #                type  opq           test len data
        tVec.append(resp('rd', opaque+0x3,   1,   0,  cacheline + base_val + 0xc))
      
      cacheline = cacheline +0x10
      opaque = opaque + 0x4
      
    address = 0x00000000
    for i in xrange(64):
      if (isWriteArr[i] == 1):
        #                type  opq       addr       len data
        tVec.append(req( 'rd', opaque,   address,   0,  0          ))
        #                type  opq       test len data
        tVec.append(resp('rd', opaque,   1,   0,  0xaaaaaaaa))
      address = address + 0x4
      opaque = opaque + 0x1
    return tVec




# Helper functions for random address testing    
def rand_addr_setup():
  # generates random addresses and data
  global randAddr
  global randData
  global randReqType
  for i in xrange(64):
    randAddr[i]=Bits(32, random.randint(0,0x000ffff)<<4)
    randData[i]=Bits(32,random.randint(0,0xffffffff))
    randReqType[i]=random.randint(0,1)

def rand_addr_setup_dmap():
  # extracts set index and tag from each address (for direct-mapped cache)
  global randAddr
  global randInd_dmap
  global randTag_dmap
  for i in xrange(64):
    temp = randAddr[i]
    randInd_dmap[i]=temp[4:8]
    randTag_dmap[i]=temp[4:32]
def rand_addr_clear():
  global randAddr
  global randData
  global randReqType
  global wData
  global randInd_dmap
  global randTag_dmap
  global dmap_cacheSim
  global dmap_hit_miss
  # generic
  randData = [Bits(32,0)]*64
  randAddr  = [Bits(32,0)]*64
  randReqType = numpy.zeros(64) # 0 = read, 1 = write
  wData = [Bits(32,0)]*64
  # dmap
  randInd_dmap = [Bits(4,0)]*64
  randTag_dmap = [Bits(28,0)]*64
  dmap_cacheSim = [Bits(28,0)]*16
  dmap_hit_miss = numpy.zeros(128)
  #assoc
  randInd_assoc = [Bits(3,0)]*64
  randTag_assoc = [Bits(28,0)]*64
  assoc_cacheSim = [[Bits(28,0)]*3]*8
  assoc_hit_miss = numpy.zeros(128)
  

def dmap_isHit( i ):
  # checks if a given element in randAddr is a cache hit or not (for DM cache)
  global dmap_cacheSim
  global randInd_dmap
  global randTag_dmap
  return dmap_cacheSim[randInd_dmap[i].uint()].uint() == randTag_dmap[i].uint()
  
def rand_addr_dmap( base_addr ):
  global randAddr
  global randData
  global randReqType
  global wData
  global randInd_dmap
  global randTag_dmap
  global dmap_cacheSim
  global dmap_hit_miss
  rand_addr_clear()
  rand_addr_setup()
  rand_addr_setup_dmap()
  tVec = []
  opaque = 0x00
  for i in xrange(64):
    if(dmap_isHit(i)):
      dmap_hit_miss[i]=1
    else:
      dmap_hit_miss[i]=0
      dmap_cacheSim[randInd_dmap[i].uint()] = randTag_dmap[i]
    
    if(randReqType[i] == 0): # reads
      wData[i]=Bits(32,0)
      #                type  opq           addr         len data
      tVec.append(req( 'rd', opaque,       randAddr[i].uint(), 0,  0 ))
      #                type  opq           test              len data
      tVec.append(resp('rd', opaque,       dmap_hit_miss[i], 0,  randData[i].uint()))
    else: # writes
      wData[i]=Bits(32,random.randint(0,0xffffffff))
      randData[i] = wData[i]
      #                type  opq     addr         len data
      tVec.append(req( 'wr', opaque, randAddr[i].uint(), 0,  wData[i].uint() ))
      #                type  opq     test              len data
      tVec.append(resp('wr', opaque, dmap_hit_miss[i], 0,  0))
    opaque = opaque + 0x1
    
  for i in xrange(64):
    if(randReqType[i] == 1):
      if(dmap_isHit(i)):
        dmap_hit_miss[i+64]=1
      else:
	    dmap_hit_miss[i+64]=0
	    dmap_cacheSim[randInd_dmap[i].uint()] = randTag_dmap[i]
	    
      #                type  opq           addr         len data
      tVec.append(req( 'rd', opaque,       randAddr[i].uint(), 0,  0 ))
      #                type  opq           test                 len data
      tVec.append(resp('rd', opaque,       dmap_hit_miss[i+64], 0,  randData[i].uint()))   
    opaque = opaque + 0x1   
  return tVec
  
def rand_addr_setup_assoc():
  # extracts set index and tag from each address (for direct-mapped cache)
  global randAddr
  global randInd_assoc
  global randTag_assoc
  for i in xrange(64):
    temp = randAddr[i]
    randInd_assoc[i]=temp[4:7]
    randTag_assoc[i]=temp[4:32]

def assoc_isHitWay0( i ):
  # checks if a given element in randAddr is a cache hit or not (for DM cache)
  global assoc_cacheSim
  global randInd_assoc
  global randTag_assoc
  return assoc_cacheSim[randInd_assoc[i].uint()][0] == randTag_assoc[i]
  
def assoc_isHitWay1( i ):
  # checks if a given element in randAddr is a cache hit or not (for DM cache)
  global assoc_cacheSim
  global randInd_assoc
  global randTag_assoc
  return assoc_cacheSim[randInd_assoc[i].uint()][1] == randTag_assoc[i]
  
def rand_addr_assoc( base_addr ):
  global randAddr
  global randData
  global randReqType
  global wData
  global randInd_assoc
  global randTag_assoc
  global assoc_cacheSim
  global assoc_hit_miss
  rand_addr_clear()
  rand_addr_setup()
  rand_addr_setup_assoc()
  tVec = []
  opaque = 0x00
  for i in xrange(64):
    index = randInd_assoc[i].uint()
    if(assoc_isHitWay0(i)):
      assoc_hit_miss[i]=1
      assoc_cacheSim[index][2]=Bits(28,0)
    elif(assoc_isHitWay1(i)):
      assoc_hit_miss[i]=1
      assoc_cacheSim[index][2]=Bits(28,1)
    else:
      assoc_hit_miss[i]=0
      evictTarget = not assoc_cacheSim[index][2]
      assoc_cacheSim[index][evictTarget] = randTag_assoc[i]
    
    if(randReqType[i] == 0): # reads
      wData[i]=Bits(32,0)
      #                type  opq           addr         len data
      tVec.append(req( 'rd', opaque,       randAddr[i].uint(), 0,  0 ))
      #                type  opq           test              len data
      tVec.append(resp('rd', opaque,       assoc_hit_miss[i], 0,  randData[i].uint()))
    else: # writes
      wData[i]=Bits(32,random.randint(0,0xffffffff))
      randData[i] = wData[i]
      #                type  opq     addr         len data
      tVec.append(req( 'wr', opaque, randAddr[i].uint(), 0,  wData[i].uint() ))
      #                type  opq     test              len data
      tVec.append(resp('wr', opaque, assoc_hit_miss[i], 0,  0))
    opaque = opaque + 0x1
    
  for i in xrange(64):
    if(randReqType[i] == 1):
      index = randInd_assoc[i].uint()
      if(assoc_isHitWay0(i)):
        assoc_hit_miss[i+64]=1
        assoc_cacheSim[index][2]=Bits(28,0)
      elif(assoc_isHitWay1(i)):
        assoc_hit_miss[i+64]=0
        assoc_cacheSim[index][2]=Bits(28,1)
      else:
	    assoc_hit_miss[i+64]=0
	    evictTarget = not assoc_cacheSim[index][2]
	    assoc_cacheSim[index][evictTarget] = randTag_assoc[i]
	    
      #                type  opq           addr         len data
      tVec.append(req( 'rd', opaque,       randAddr[i].uint(), 0,  0 ))
      #                type  opq           test                 len data
      tVec.append(resp('rd', opaque,       assoc_hit_miss[i+64], 0,  randData[i].uint()))   
    opaque = opaque + 0x1   
  return tVec
  
#-------------------------------------------------------------------------
# Test memories
#-------------------------------------------------------------------------
def read_miss_1word_mem( base_addr ):
  return [
    # addr      data (in int)
    0x00000000, 0xdeadbeef,
    0x00000004, 0x00c0ffee
  ]

def cases_4B_mem ( base_addr ):
	return[
	  # addr      data (in int)
    0x00000fc0, 0xadd10000
	]

def rand_mem( base_addr ):
  global randAddr
  global randData
  mem = []
  for i in xrange(64):
    mem.append(randAddr[i].uint())
    mem.append(randData[i].uint())
  return mem

def init_mem( base_addr ):
  # generates a unique word-value for each of 16 different cache lines
  mem = []
  addr = 0x00000000
  base_val = 0xf0000000
  for i in xrange(16):
    for j in xrange(4):
      mem.append(addr)
      mem.append(addr+base_val)
      addr = addr + 0x4
  return mem

def init_mem_dirty( base_addr ):
  # generates a unique word-value for each of 16 different cache lines and 16 corresponding cache lines
  mem = []
  addr = 0x00000000
  base_val = 0xf0000000
  diff_tag = 0x00000100
  for i in xrange(16):
    for j in xrange(4):
      mem.append(addr)
      mem.append(addr+base_val)
      mem.append(addr+diff_tag)
      mem.append(0xdeadbeef)
      mem.append(addr+diff_tag+diff_tag)
      mem.append(0x00c0ffee)
      addr = addr + 0x4
  return mem
  
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# LAB TASK: Add more test cases
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#----------------------------------------------------------------------
# Banked cache test
#----------------------------------------------------------------------
# The test field in the response message: 0 == MISS, 1 == HIT

# This test case is to test if the bank offset is implemented correctly.
#
# The idea behind this test case is to differentiate between a cache
# with no bank bits and a design has one/two bank bits by looking at cache
# request hit/miss status.

#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# LAB TASK:
#'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#-------------------------------------------------------------------------
# Test table for generic test
#-------------------------------------------------------------------------

test_case_table_generic = mk_test_case_table([
  (                          "msg_func                mem_data_func         nbank stall lat src sink"),
  [ "read_hit_1word_clean",   read_hit_1word_clean,   None,                 0,    0.0,  0,  0,  0    ],
  [ "read_hit_1word_dirty",   read_hit_1word_dirty,   None,                 0,    0.0,  0,  0,  0    ],
  [ "read_miss_1word",        read_miss_1word_msg,    read_miss_1word_mem,  0,    0.0,  0,  0,  0    ],
  [ "read_miss_1word_noEvict",read_miss_1word_noEvict,read_miss_1word_mem,  0,    0.0,  0,  0,  0    ],
  [ "read_miss_cacheline",    read_miss_cacheline,    init_mem,             0,    0.0,  0,  0,  0    ],
  [ "write_hit_1word_clean",  write_hit_1word_clean,  None,                 0,    0.0,  0,  0,  0    ],
  [ "write_hit_1word_dirty",  write_hit_1word_dirty,  None,                 0,    0.0,  0,  0,  0    ],
  [ "write_miss_1word_clean", write_miss_1word_clean, None,                 0,    0.0,  0,  0,  0    ],
  [ "write_miss_cacheline",   write_miss_cacheline,   init_mem,             0,    0.0,  0,  0,  0    ],
  [ "read_hit_1word_4bank",   read_hit_1word_clean,   None,                 4,    0.0,  0,  0,  0    ],
  [ "rand_writeData",         rand_writeData,         None,                 0,    0.0,  0,  0,  0    ],
  [ "rand_writeStrideData",   rand_writeStrideData,   None,                 0,    0.0,  0,  0,  0    ],
  [ "rand_UnitStrideShared",  rand_UnitStrideShared,  None,                 0,    0.0,  0,  0,  0    ],
  [ "rand_reqTypes",          rand_reqTypes,          init_mem,             0,    0.0,  0,  0,  0    ],
  
  [ "read_hit_1word_clean_d",   read_hit_1word_clean,   None,                 0,    0.1,  2,  1,  3    ],
  [ "read_hit_1word_dirty_d",   read_hit_1word_dirty,   None,                 0,    0.2,  1,  5,  2    ],
  [ "read_miss_1word_d",        read_miss_1word_msg,    read_miss_1word_mem,  0,    0.3,  0,  4,  0    ],
  [ "read_miss_1word_noEvict_d",read_miss_1word_noEvict,read_miss_1word_mem,  0,    0.4,  1,  3,  2    ],
  [ "read_miss_cacheline_d",    read_miss_cacheline,    init_mem,             0,    0.5,  2,  2,  2    ],
  [ "write_hit_1word_clean_d",  write_hit_1word_clean,  None,                 0,    0.4,  0,  1,  3    ],
  [ "write_hit_1word_dirty_d",  write_hit_1word_dirty,  None,                 0,    0.3,  1,  1,  1    ],
  [ "write_miss_1word_clean_d", write_miss_1word_clean, None,                 0,    0.2,  0,  0,  6    ],
  [ "write_miss_cacheline_d",   write_miss_cacheline,   init_mem,             0,    0.1,  6,  0,  0    ],
  [ "read_hit_1word_4bank_d",   read_hit_1word_clean,   None,                 4,    0.0,  0,  6,  0    ],
  [ "rand_writeData_d",         rand_writeData,         None,                 0,    0.1,  1,  5,  5    ],
  [ "rand_writeStrideData_d",   rand_writeStrideData,   None,                 0,    0.2,  6,  6,  6    ],
  [ "rand_UnitStrideShared_d",  rand_UnitStrideShared,  None,                 0,    0.3,  5,  5,  0    ],
  [ "rand_reqTypes_d",          rand_reqTypes,          init_mem,             0,    0.4,  4,  0,  4    ],

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # LAB TASK: Add test cases to this table
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

])

@pytest.mark.parametrize( **test_case_table_generic )
def test_generic( test_params, dump_vcd ):
  msgs = test_params.msg_func( 0 )
  if test_params.mem_data_func != None:
    mem = test_params.mem_data_func( 0 )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.stall, test_params.lat,
                         test_params.src, test_params.sink,
                         BlockingCacheFL, test_params.nbank,
                         False, dump_vcd )
  # Load memory before the test
  if test_params.mem_data_func != None:
    harness.load( mem[::2], mem[1::2] )
  # Run the test
  run_sim( harness, dump_vcd )

#-------------------------------------------------------------------------
# Test table for set-associative cache (alternative design)
#-------------------------------------------------------------------------

test_case_table_set_assoc = mk_test_case_table([
  (                             "msg_func                mem_data_func    nbank stall lat src sink"),
  [ "read_hit_asso",             read_hit_asso,          None,            0,    0.0,  0,  0,  0    ],
  [ "read_miss_evict_assoc",     read_miss_evict_assoc,  init_mem_dirty,  0,    0.0,  0,  0,  0    ],
  [ "write_miss_evict_assoc",    write_miss_evict_assoc, init_mem_dirty,  0,    0.0,  0,  0,  0    ],
  [ "rand_addr_assoc",           rand_addr_assoc,        rand_mem,        0,    0.0,  0,  0,  0    ],
  [ "4B_assoc",                  cases_4B_assoc,         cases_4B_mem,    4,    0.0,  0,  0,  0    ],
  
  [ "read_hit_asso_d",             read_hit_asso,          None,            0,    0.3,  1,  2,  3    ],
  [ "read_miss_evict_assoc_d",     read_miss_evict_assoc,  init_mem_dirty,  0,    0.2,  6,  6,  6    ],
  [ "write_miss_evict_assoc_d",    write_miss_evict_assoc, init_mem_dirty,  0,    0.5,  2,  3,  4    ],
  [ "rand_addr_assoc_d",           rand_addr_assoc,        rand_mem,        0,    0.2,  1,  2,  3    ],
  [ "4B_assoc_d",                  cases_4B_assoc,         cases_4B_mem,    4,    0.7,  2,  3,  4    ],

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # LAB TASK: Add test cases to this table
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

])

@pytest.mark.parametrize( **test_case_table_set_assoc )
def test_set_assoc( test_params, dump_vcd ):
  msgs = test_params.msg_func( 0 )
  if test_params.mem_data_func != None:
    mem  = test_params.mem_data_func( 0 )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.stall, test_params.lat,
                         test_params.src, test_params.sink,
                         BlockingCacheFL, test_params.nbank,
                         False, dump_vcd )
  # Load memory before the test
  if test_params.mem_data_func != None:
    harness.load( mem[::2], mem[1::2] )
  # Run the test
  run_sim( harness, dump_vcd )


#-------------------------------------------------------------------------
# Test table for direct-mapped cache (baseline design)
#-------------------------------------------------------------------------

test_case_table_dir_mapped = mk_test_case_table([
  (                                  "msg_func              mem_data_func          nbank stall lat src sink"),
  [ "read_hit_dmap",                  read_hit_dmap,        None,                  0,    0.0,  0,  0,  0    ],
  [ "read_miss_evict_dmap",           read_miss_evict_dmap, init_mem_dirty,        0,    0.0,  0,  0,  0    ],
  [ "write_miss_evict_dmap",          write_miss_evict_dmap,init_mem_dirty,        0,    0.0,  0,  0,  0    ],
  [ "rand_addr_dmap",                 rand_addr_dmap,       rand_mem,              0,    0.0,  0,  0,  0    ],
  [ "4B_dmap",                        cases_4B_dmap        ,cases_4B_mem,          4,    0.0,  0,  0,  0    ],
  
  [ "read_hit_dmap_d",                  read_hit_dmap,        None,                  0,    0.3,  1,  2,  7    ],
  [ "read_miss_evict_dmap_d",           read_miss_evict_dmap, init_mem_dirty,        0,    0.3,  3,  3,  3    ],
  [ "write_miss_evict_dmap_d",          write_miss_evict_dmap,init_mem_dirty,        0,    0.5,  1,  0,  8    ],
  [ "rand_addr_dmap_d",                 rand_addr_dmap,       rand_mem,              0,    0.2,  5,  1,  1    ],
  [ "4B_dmap_d",                        cases_4B_dmap        ,cases_4B_mem,          4,    0.5,  0,  3,  2    ],

  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  # LAB TASK: Add test cases to this table
  #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

])

@pytest.mark.parametrize( **test_case_table_dir_mapped )
def test_dir_mapped( test_params, dump_vcd ):
  msgs = test_params.msg_func( 0 )
  if test_params.mem_data_func != None:
    mem  = test_params.mem_data_func( 0 )
  # Instantiate testharness
  harness = TestHarness( msgs[::2], msgs[1::2],
                         test_params.stall, test_params.lat,
                         test_params.src, test_params.sink,
                         BlockingCacheFL, test_params.nbank,
                         False, dump_vcd )
  # Load memory before the test
  if test_params.mem_data_func != None:
    harness.load( mem[::2], mem[1::2] )
  # Run the test
  run_sim( harness, dump_vcd )
