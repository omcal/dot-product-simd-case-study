#include "dot_product.hpp"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <iostream>
#include <string_view>
#include <vector>

int main(int argc, char** argv) {
    bool disable_avx2 = false;
    bool require_avx2 = false;
    for (int i = 1; i < argc; ++i) {
        const std::string_view arg(argv[i]);
        if (arg == "--disable-avx2") disable_avx2 = true;
        else if (arg == "--require-avx2") require_avx2 = true;
        else return 2;
    }
    if (require_avx2 && (disable_avx2 || !dot_product_avx2_available())) {
        std::cerr << "FAIL: AVX2 required but unavailable or disabled\n";
        return 1;
    }
    const auto variants = available_dot_product_variants(disable_avx2);
    // Base set: scalar, compiler_optimized, compiler_reassociated.
    // manual_avx2 is appended when available and not disabled.
    const std::size_t expected = 3u + (dot_product_avx2_available() && !disable_avx2 ? 1u : 0u);
    if (variants.size() != expected) {
        std::cerr << "FAIL: unexpected runtime variant selection\n";
        return 1;
    }
    if (!dot_product_avx2_available() || disable_avx2) {
        std::cout << "skip: manual_avx2 (unavailable or disabled)\n";
    }
    int failures = 0;
    int total = 0;
    for (const auto& variant : variants) {
        const auto check = [&](bool ok, const char* name) {
            ++total;
            if (!ok) {
                std::cerr << "FAIL: " << variant.name << ": " << name << '\n';
                ++failures;
            } else {
                std::cout << "ok: " << variant.name << ": " << name << '\n';
            }
        };

        check(variant.function(nullptr, nullptr, 0) == 0.0f, "empty input");

        const float a[] = {1.0f, -2.0f, 3.0f, 4.0f};
        const float b[] = {5.0f, 6.0f, -7.0f, 8.0f};
        check(variant.function(a, b, 1) == 5.0f, "single element");
        check(variant.function(a, b, 4) == 4.0f, "mixed signs");
        check(variant.function(a, a, 4) == 30.0f, "same input buffer");
        check(variant.function(a + 1, b + 1, 2) == -33.0f, "offset and prefix");

        const float cancel_a[] = {1.0f, 1.0f, 1.0f};
        const float cancel_b[] = {2.0f, -3.0f, 1.0f};
        check(variant.function(cancel_a, cancel_b, 3) == 0.0f, "cancellation");

        alignas(32) float unaligned_a[17], unaligned_b[17];
        for (int i = 0; i < 17; ++i) {
            unaligned_a[i] = static_cast<float>(i);
            unaligned_b[i] = 1.0f;
        }
        check(variant.function(unaligned_a + 1, unaligned_b + 1, 16) == 136.0f,
              "guaranteed unaligned vector loads");

        // Odd sizes and lengths around eight lanes will also be useful for AVX2 tails.
        for (const std::size_t n : {1, 7, 8, 9, 31, 256, 1024, 4097}) {
            ++total;
            std::vector<float> x(n), y(n);
            double reference = 0.0;
            double absolute_products = 0.0;
            for (std::size_t i = 0; i < n; ++i) {
                x[i] = static_cast<float>(static_cast<int>(i % 29) - 14) / 13.0f;
                y[i] = static_cast<float>(static_cast<int>(i % 17) - 8) / 11.0f;
                const double product = static_cast<double>(x[i]) * y[i];
                reference += product;
                absolute_products += std::abs(product);
            }
            const double actual = variant.function(x.data(), y.data(), n);
            // A dataset-specific tolerance, scaled by magnitudes to handle cancellation.
            // It is not a general accuracy guarantee or an AVX2/FMA tolerance policy.
            const double tolerance = 1e-5 * std::max(1.0, absolute_products);
            if (!std::isfinite(actual) || std::abs(actual - reference) > tolerance) {
                std::cerr << "FAIL: " << variant.name << " n=" << n << " actual=" << actual
                          << " reference=" << reference << '\n';
                ++failures;
            } else {
                std::cout << "ok: " << variant.name << " n=" << n << '\n';
            }
        }
        // Every tail around both eight lanes and the 32-element unroll, with
        // exact-size allocations for sanitizer over-read detection. Offset=1
        // exercises loadu; compare with both double and scalar references.
        for (const std::size_t offset : {0, 1}) {
            bool passed = true;
            for (std::size_t n = 0; n <= 65; ++n) {
                std::vector<float> x(n + offset), y(n + offset);
                float* a_tail = n + offset ? x.data() + offset : nullptr;
                float* b_tail = n + offset ? y.data() + offset : nullptr;
                double reference = 0.0, absolute_products = 0.0;
                for (std::size_t i = 0; i < n; ++i) {
                    a_tail[i] = static_cast<float>(static_cast<int>(i % 13) - 6) / 7.0f;
                    b_tail[i] = static_cast<float>(static_cast<int>(i % 11) - 5) / 3.0f;
                    const double product = static_cast<double>(a_tail[i]) * b_tail[i];
                    reference += product;
                    absolute_products += std::abs(product);
                }
                const double actual = variant.function(a_tail, b_tail, n);
                const double scalar = dot_product_scalar(a_tail, b_tail, n);
                const double tolerance = 1e-5 * std::max(1.0, absolute_products);
                if (!std::isfinite(actual) || std::abs(actual - reference) > tolerance ||
                    std::abs(actual - scalar) > 2 * tolerance) {
                    std::cerr << "FAIL: " << variant.name << " tail n=" << n << " offset=" << offset << '\n';
                    passed = false;
                }
            }
            check(passed, offset == 0 ? "all tails n=0..65" : "offset tails n=0..65");
        }

        // Well-conditioned large-n fixture. The usual dataset cancels almost
        // completely, so its magnitude-scaled threshold (~2.25 at n=2^20) is
        // not informative about actual accuracy. Here all products are
        // positive, magnitude equals |reference|, and the bound is a tight
        // relative one: 1e-4 * sum|products| (0.01%). Simulated worst-case
        // summation orders stay below ~1.4e-5 relative at n=2^20, so this
        // catches orderings that break under cancellation.
        {
            bool passed = true;
            for (const std::size_t n : {65536u, 1048576u}) {
                std::vector<float> x(n), y(n);
                std::uint32_t state = 1u;
                auto next = [&state]() {
                    state = state * 1664525u + 1013904223u;
                    return 0.5f + static_cast<float>((state >> 8) & 0xffffu) / 65535.0f;
                };
                double reference = 0.0;
                double magnitude = 0.0;
                for (std::size_t i = 0; i < n; ++i) {
                    const float xi = next();
                    const float yi = next();
                    x[i] = xi;
                    y[i] = yi;
                    const double product = static_cast<double>(xi) * yi;
                    reference += product;
                    magnitude += std::abs(product);
                }
                const double actual = variant.function(x.data(), y.data(), n);
                const double tolerance = 1e-4 * std::max(1.0, magnitude);
                if (!std::isfinite(actual) || std::abs(actual - reference) > tolerance) {
                    std::cerr << "FAIL: " << variant.name << " well-conditioned n=" << n
                              << " actual=" << actual << " reference=" << reference << '\n';
                    passed = false;
                }
            }
            check(passed, "well-conditioned large n (no cancellation)");
        }
    }

    if (failures != 0) {
        return 1;
    }
    std::cout << total << " checks passed.\n";
    return 0;
}
