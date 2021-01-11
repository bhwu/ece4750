#=========================================================================
# Modular C++ Build System Subproject Makefile Fragment
#=========================================================================
# Please read the documenation in 'mcppbs-uguide.txt' for more details
# on how the Modular C++ Build System works.

ubmark_intdeps  = common 
ubmark_cppflags = -I../ubmark -I../common 
ubmark_ldflags  = 
ubmark_libs     = -lubmark -lcommon 

ubmark_hdrs = \

ubmark_srcs = \

ubmark_install_prog_srcs = \
  ubmark-vvadd.c \
  ubmark-bsearch.c \
  ubmark-cmult.c \
  ubmark-mfilt.c \
  ubmark-quicksort.c \

#''''''''''
