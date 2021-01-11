# Verilated -*- Makefile -*-
# DESCRIPTION: Verilator output: Make include file with class lists
#
# This file lists generated Verilated files, for including in higher level makefiles.
# See VMultiCoreVRTL_inner_0x4c075e0d1f6aefae.mk for the caller.

### Switches...
# Coverage output mode?  0/1 (from --coverage)
VM_COVERAGE = 0
# Tracing output mode?  0/1 (from --trace)
VM_TRACE = 1

### Object file lists...
# Generated module classes, fast-path, compile with highest optimization
VM_CLASSES_FAST += \
	VMultiCoreVRTL_inner_0x4c075e0d1f6aefae \
	VMultiCoreVRTL_inner_0x4c075e0d1f6aefae___024unit \

# Generated module classes, non-fast-path, compile with low/medium optimization
VM_CLASSES_SLOW += \

# Generated support classes, fast-path, compile with highest optimization
VM_SUPPORT_FAST += \
	VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Dpi \
	VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Trace \

# Generated support classes, non-fast-path, compile with low/medium optimization
VM_SUPPORT_SLOW += \
	VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Syms \
	VMultiCoreVRTL_inner_0x4c075e0d1f6aefae__Trace__Slow \

# Global classes, need linked once per executable, fast-path, compile with highest optimization
VM_GLOBAL_FAST += \
	verilated \
	verilated_dpi \
	verilated_vcd_c \

# Global classes, need linked once per executable, non-fast-path, compile with low/medium optimization
VM_GLOBAL_SLOW += \


# Verilated -*- Makefile -*-
