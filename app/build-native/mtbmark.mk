#=========================================================================
# Modular C++ Build System Subproject Makefile Fragment
#=========================================================================
# Please read the documenation in 'mcppbs-uguide.txt' for more details
# on how the Modular C++ Build System works.

mtbmark_intdeps  = common 
mtbmark_cppflags = -I../mtbmark -I../common 
mtbmark_ldflags  = 
mtbmark_libs     = -lmtbmark -lcommon 

mtbmark_hdrs = \

mtbmark_srcs = \

mtbmark_install_prog_srcs = \
  mtbmark-vvadd.c \
  mtbmark-bsearch.c \
  mtbmark-mfilt.c \
  mtbmark-cmult.c \
  mtbmark-sort.c \

#''''''''''
