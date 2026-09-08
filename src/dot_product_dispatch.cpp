#include "dot_product.hpp"

#if DOT_PRODUCT_HAS_AVX2
// Internal entry point: callers use the checked registry, not this symbol.
float dot_product_avx2(const float*, const float*, std::size_t);
#endif

bool dot_product_avx2_available() {
#if DOT_PRODUCT_HAS_AVX2
    return __builtin_cpu_supports("avx2");
#else
    return false;
#endif
}

std::vector<DotProductVariant> available_dot_product_variants(bool disable_avx2) {
    std::vector<DotProductVariant> variants = {
        {"scalar", dot_product_scalar},
        {"compiler_optimized", dot_product_compiler_optimized},
        {"compiler_reassociated", dot_product_compiler_reassociated},
    };
#if DOT_PRODUCT_HAS_AVX2
    if (!disable_avx2 && dot_product_avx2_available()) {
        variants.push_back({"manual_avx2", dot_product_avx2});
    }
#else
    (void)disable_avx2;
#endif
    return variants;
}
