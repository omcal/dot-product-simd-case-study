#include "dot_product.hpp"

// Reassociated compiler variant: byte-identical loop to the
// compiler_optimized translation unit, but the target is compiled with FP
// reassociation allowed (GCC: -fassociative-math -fno-signed-zeros
// -fno-trapping-math; Clang: -ffast-math; contraction stays off via
// -ffp-contract=off). This answers the "strawman" objection: what does the
// compiler do when it is permitted to reorder the reduction?
float dot_product_compiler_reassociated(const float* a, const float* b, std::size_t n) {
    float sum = 0.0f;
    for (std::size_t i = 0; i < n; ++i) {
        sum += a[i] * b[i];
    }
    return sum;
}
