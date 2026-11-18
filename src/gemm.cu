#include <cuda_runtime.h>
#include <cudacheck.h>
#include <blasphemy.h>
#include <algorithm>
#include <iostream>

constexpr int THREADS = 256;

using namespace std;


//
// Kernels
//

// column major by default

template <typename T>
__global__ void gemm_naive_kernel(
        T* mat_A, T* mat_B, T* mat_C, 
        int m, int k, int n,
        T alpha, T beta,
        int lda, int ldb, int ldc) {

    size_t i = static_cast<size_t>(blockIdx.x) * blockDim.x +  threadIdx.x;
    if (i <= static_cast<size_t>(m) * n) {
        const int A_row = i % m;
        const int B_col = i / m;

        T sum = static_cast<T>(0.0);
        for (int idx = 0; idx < k; idx++) {
            sum += mat_A[A_row + idx * lda] * mat_B[idx + B_col * ldb];
        }   

        int C_idx = B_col * ldc + A_row;
        mat_C[C_idx] = alpha * sum + beta * mat_C[C_idx];
    }
    
}


//
// Helpers
//


template <typename T>
cudaError_t launch_naive(
        T* mat_A, T* mat_B, T* mat_C, 
        int m, int k, int n, 
        T alpha, T beta, 
        int lda, int ldb, int ldc, 
        cudaStream_t stream) {

    int blocksPerGrid = (m * n + THREADS - 1) / THREADS;
    gemm_naive_kernel<<<blocksPerGrid, THREADS, 0, stream>>>(mat_A, mat_B, mat_C, m, k, n, alpha, beta, lda, ldb, ldc);
    return cudaGetLastError();

}


//
// Entry points
//

template <typename T>
cudaError_t gemm_naive(
        T* mat_A, T* mat_B, T* mat_C, 
        int m, int k, int n, 
        T alpha, T beta,
        int lda, int ldb, int ldc, 
        cudaStream_t stream) {
    cudaError_t return_status;

    if (m < 0 || k < 0 || n < 0) return_status = cudaErrorInvalidValue;
    else if (m == 0 || k == 0 || n == 0) return_status = cudaSuccess;
    else if (lda < max(1, m) || ldb < max(1, k) || ldc < max(1, m)) return_status = cudaErrorInvalidValue;
    else {
        return launch_naive(mat_A, mat_B, mat_C, m, k, n, alpha, beta, lda, ldb, ldc, stream);
    }
}