//========================================================================
// ubmark-quicksort
//========================================================================

#include "common.h"
#include "ubmark-quicksort.dat"

//------------------------------------------------------------------------
// quicksort-scalar
//------------------------------------------------------------------------

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Add functions you may need
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

// Use macro to reduce the overhead of function calls
#define SWAP(a,b) { \
		temp = a; \
		a = b; \
		b = temp; \
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

__attribute__ ((noinline))
void quicksort_scalar( int* dest, int* src, int size )
{
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: Implement main function of serial quicksort
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    // sanity check
	if (size < 2) return;
	int i;
	
	// Helper reference: https://www.tutorialspoint.com/data_structures_algorithms/quick_sort_algorithm.htm
	quicksort_helper(src, 0, size - 1);
    	
    // dummy copy src into dest
	for ( i = 0; i < size; i++ )
		dest[i] = src[i];
}

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
  int dest[size];

  int i;
  for ( i = 0; i < size; i++ )
    dest[i] = 0;

  test_stats_on();
  quicksort_scalar( dest, src, size );
  test_stats_off();

  verify_results( dest, ref, size );

  return 0;
}

