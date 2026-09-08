#pragma once

#include <cstddef>
#include <vector>

// For n > 0, both pointers must refer to at least n readable floats.
// For n == 0, returns zero without dereferencing either pointer.
float dot_product_scalar(const float* a, const float* b, std::size_t n);

// Same pointer contract; ordinary optimized C++ with vectorization permitted.
float dot_product_compiler_optimized(const float* a, const float* b, std::size_t n);

// Same loop again, compiled with FP reassociation allowed (and contraction
// still off). Answers the question: what does the compiler do when it may
// reorder the reduction?
float dot_product_compiler_reassociated(const float* a, const float* b, std::size_t n);

using DotProductFunction = float (*)(const float*, const float*, std::size_t);
struct DotProductVariant {
    const char* name;
    DotProductFunction function;
};

// Checks both compiled kernel availability and runtime CPU/OS AVX state support.
bool dot_product_avx2_available();

// Only callable variants are returned. Disabling AVX2 never forces CPU support.
std::vector<DotProductVariant> available_dot_product_variants(bool disable_avx2 = false);
