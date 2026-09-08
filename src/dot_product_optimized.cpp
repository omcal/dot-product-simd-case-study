#include "dot_product.hpp"

// Deliberately identical loop to the scalar baseline. The build settings differ.
float dot_product_compiler_optimized(const float* a, const float* b, std::size_t n) {
    float sum = 0.0f;
    for (std::size_t i = 0; i < n; ++i) {
        sum += a[i] * b[i];
    }
    return sum;
}
