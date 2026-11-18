#ifndef CUDACHECK_H_
#define CUDACHECK_H_

#define cudaCheckError(call) { \
    cudaError_t e = call; \
    if (e != cudaSuccess) { \
        fprintf(stderr, "CUDA failure %s:%d: '%s'\n", __FILE__, __LINE__, cudaGetErrorString(e)); \
    } \
}

#define cudaCheckKernel() cudaCheckError(cudaGetLastError())

#endif