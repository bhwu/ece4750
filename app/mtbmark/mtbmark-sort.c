//========================================================================
// mtbmark-sort
//========================================================================

#include "common.h"
#include "mtbmark-sort.dat"

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Implement multicore sorting
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

#define SWAP(a,b) { \
		temp = a; \
		a = b; \
		b = temp; \
	}

// Threshold for parallel/serial
#define THRESHOLD 32

typedef struct {
  int* src;
  int low;
  int high;
} qsort_arg_t;	

typedef struct {
  int* dest;
  int* src0;
  int* src1;
  int size_src0;
  int size_src1;
} msort_arg_t;

void merge_sorted_arrays(void* arg_vptr);
void quicksort_helper(int* src, int low, int high);
void quicksort(void* arg_vptr);

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int dest[], int ref[], int size )
{
  int i;
  for ( i = 0; i < size; i++ ) {
    if ( !( dest[i] == ref[i] ) ) {
      test_fail( i, dest[i], ref[i] );
    }
  }
  test_pass();
}

//------------------------------------------------------------------------
// Test Harness
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{

  // Initialize the bthread (bare thread)
  bthread_init();

  // Initialize dest array, which stores the final result.

  int dest[size];

  //--------------------------------------------------------------------
  // Start counting stats
  //--------------------------------------------------------------------

  test_stats_on();

  int i = 0;

  // Because we need in-place sorting, we need to create a mutable temp
  // array.
  int temp0[size];

  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK:
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  
  if (size < THRESHOLD) { 
	    
    qsort_arg_t arg_scalar = { src, 0, size - 1 };
    quicksort( &arg_scalar );
    for( i = 0; i < size; i++ ) {
      dest[i] = src[i];
    }  
    
  } else {
	  
    int quarter_size = (size >> 2);
    int half_size    = (size >> 1);
    // args for 4 quarters of quicksort
    qsort_arg_t arg_q0  = { src, 0,                        quarter_size - 1             };
    qsort_arg_t arg_q1  = { src, quarter_size,             half_size - 1                };
    qsort_arg_t arg_q2  = { src, half_size,                half_size + quarter_size - 1 };
    qsort_arg_t arg_q3  = { src, half_size + quarter_size, size - 1                     };

    // Spawn work onto core 1,2,3 for three quarters
    bthread_spawn( 1, &quicksort, &arg_q1 );
    bthread_spawn( 2, &quicksort, &arg_q2 );
    bthread_spawn( 3, &quicksort, &arg_q3 );
    
    // Have 0 sort the first quarter
    quicksort( &arg_q0 );
    
    // wait for core 1,2,3
    bthread_join(1);
    bthread_join(2);
    bthread_join(3);
    
    // args for 2 merge sorts
    msort_arg_t arg_m0 = { temp0,             src,             src + quarter_size,              quarter_size, quarter_size                    };
    msort_arg_t arg_m1 = { temp0 + half_size, src + half_size, src + half_size + quarter_size,  quarter_size, size - half_size - quarter_size };
    
    // Spawn work onto core 1 to merge second half
    bthread_spawn( 1, &merge_sorted_arrays, &arg_m1 );
    
    // core 0 itself sorts first half
    merge_sorted_arrays( &arg_m0 );
    
    // wait for core 1
    bthread_join(1);

    msort_arg_t arg_m  = { dest, temp0, temp0 + half_size, half_size, size - half_size };
    // merge two halves
    merge_sorted_arrays( &arg_m );
    
  }

  //--------------------------------------------------------------------
  // Stop counting stats
  //--------------------------------------------------------------------

  test_stats_off();

  // verifies solution

  verify_results( dest, ref, size );

  return 0;
}

void merge_sorted_arrays( void* arg_vptr ) {
	// cast void pointers
	msort_arg_t* arg_ptr = (msort_arg_t*) arg_vptr;
	
	// create local parameters
	int* dest      = arg_ptr -> dest;
	int* src0      = arg_ptr -> src0;
	int* src1      = arg_ptr -> src1;
	int  size_src0 = arg_ptr -> size_src0;
	int  size_src1 = arg_ptr -> size_src1;

	// sanity check, assume the user knows dest_size == size_src0 + size_src1, because the simulator
	// does not support more than 5 arguments
	if (size_src0 < 1 || size_src1 < 1) {
		return;
	}
		
	int i = 0, j = 0, k = 0;
	while (i < size_src0 && j < size_src1) {
		if(src0[i] < src1[j])	{ dest[k++] = src0[i++]; }
		else 					{ dest[k++] = src1[j++]; }
	}
	while (i < size_src0) 		{ dest[k++] = src0[i++]; }
	while (j < size_src1) 		{ dest[k++] = src1[j++]; }
	
}

void quicksort_helper( int* src, int low, int high ) {
	if (low < high) {
		int pivotIndex, pivot, temp;
		pivotIndex = low + ((high - low) >> 1);
		// swap
		pivot = src[pivotIndex];
		src[pivotIndex] = src[high];
		src[high] = pivot;

		// start index
		int i = low - 1;
		int j = high;
		
		// partition: all left parts of a[i] <= pivot, right parts of a[j] >= pivot
		do {
			do { i++; } while (src[i] < pivot);
			do { j--; } while ((src[j] > pivot) && (j > i));
			if (i < j) SWAP(src[i], src[j]);
		} while (i < j);
		
		src[high] = src[i];
		src[i] = pivot;
		quicksort_helper(src, low, i - 1);
		quicksort_helper(src, i + 1, high);
	}			
}

void quicksort( void* arg_vptr )
{
	qsort_arg_t* arg_ptr = (qsort_arg_t*) arg_vptr;
	
	int* src = arg_ptr -> src;
	int low  = arg_ptr -> low;
	int high = arg_ptr -> high;
	 
    // sanity check
	if (high - low < 1) return;
	
	// Helper reference: https://www.tutorialspoint.com/data_structures_algorithms/quick_sort_algorithm.htm
	quicksort_helper(src, low, high);
    	
}
