#ifndef BLASPHEMY_H_
#define BLASPHEMY_H_

#include <cuda_runtime.h>


//
// Kernel entry points
//


template <typename T>
cudaError_t gemm_naive(
        T* mat_A, T* mat_B, T* mat_C, 
        int m, int k, int n, 
        T alpha, T beta,
        int lda, int ldb, int ldc, 
        cudaStream_t stream = 0);


//
// Compiled templates
//


extern template cudaError_t gemm_naive<double>(
        double*, double*, double*, 
        int, int, int, 
        double, double, 
        int, int, int, 
        cudaStream_t);

extern template cudaError_t gemm_naive<float>(
        float*, float*, float*, 
        int, int, int, 
        float, float, 
        int, int, int, 
        cudaStream_t);


#endif