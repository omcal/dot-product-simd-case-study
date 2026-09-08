#include <cstddef>
#include <immintrin.h>

// Called only after runtime AVX2 detection. Unaligned inputs are supported.
float dot_product_avx2(const float* a, const float* b, std::size_t n) {
    __m256 sum0 = _mm256_setzero_ps();
    __m256 sum1 = _mm256_setzero_ps();
    __m256 sum2 = _mm256_setzero_ps();
    __m256 sum3 = _mm256_setzero_ps();
    std::size_t i = 0;
    // Four independent accumulators shorten the dependency chain.
    for (; n - i >= 32; i += 32) {
        sum0 = _mm256_add_ps(sum0, _mm256_mul_ps(_mm256_loadu_ps(a + i), _mm256_loadu_ps(b + i)));
        sum1 = _mm256_add_ps(sum1, _mm256_mul_ps(_mm256_loadu_ps(a + i + 8), _mm256_loadu_ps(b + i + 8)));
        sum2 = _mm256_add_ps(sum2, _mm256_mul_ps(_mm256_loadu_ps(a + i + 16), _mm256_loadu_ps(b + i + 16)));
        sum3 = _mm256_add_ps(sum3, _mm256_mul_ps(_mm256_loadu_ps(a + i + 24), _mm256_loadu_ps(b + i + 24)));
    }
    for (; n - i >= 8; i += 8) {
        sum0 = _mm256_add_ps(sum0, _mm256_mul_ps(_mm256_loadu_ps(a + i), _mm256_loadu_ps(b + i)));
    }
    const __m256 sum = _mm256_add_ps(_mm256_add_ps(sum0, sum1), _mm256_add_ps(sum2, sum3));
    alignas(32) float lanes[8];
    _mm256_store_ps(lanes, sum);
    float result = 0.0f;
    for (float lane : lanes) {
        result += lane;
    }
    // At most seven elements remain; no vector load may cross the input end.
    for (; i < n; ++i) {
        result += a[i] * b[i];
    }
    return result;
}
