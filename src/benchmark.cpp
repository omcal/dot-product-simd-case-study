#include "dot_product.hpp"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <iomanip>
#include <iostream>
#include <string_view>
#include <vector>

namespace {
using Clock = std::chrono::steady_clock;

// The compiler must materialize every result. The memory clobber also prevents
// reusing input loads across calls. This is a compiler barrier, not a CPU fence.
void consume(float result) {
    asm volatile("" : : "m"(result) : "memory");
}

double measure(DotProductFunction dot, const std::vector<float>& a, const std::vector<float>& b,
               std::size_t iterations) {
    const auto start = Clock::now();
    for (std::size_t i = 0; i < iterations; ++i) {
        consume(dot(a.data(), b.data(), a.size()));
    }
    const auto end = Clock::now();
    return std::chrono::duration<double, std::nano>(end - start).count();
}

bool correct(const std::vector<float>& a, const std::vector<float>& b, float actual) {
    double reference = 0.0;
    double absolute_products = 0.0;
    for (std::size_t i = 0; i < a.size(); ++i) {
        const double product = static_cast<double>(a[i]) * b[i];
        reference += product;
        absolute_products += std::abs(product);
    }
    // Same dataset-specific tolerance as the scalar tests; not an accuracy proof.
    return std::isfinite(actual) &&
           std::abs(actual - reference) <= 1e-5 * std::max(1.0, absolute_products);
}
} // namespace

int main(int argc, char** argv) {
    bool smoke = false;
    bool disable_avx2 = false;
    bool list_variants = false;
    for (int i = 1; i < argc; ++i) {
        const std::string_view arg(argv[i]);
        if (arg == "--smoke") smoke = true;
        else if (arg == "--disable-avx2") disable_avx2 = true;
        else if (arg == "--list-variants") list_variants = true;
        else {
            std::cerr << "Usage: dot_product_benchmark [--smoke] [--disable-avx2] [--list-variants]\n";
            return 2;
        }
    }
    const auto variants = available_dot_product_variants(disable_avx2);
    if (list_variants) {
        for (const auto& variant : variants) std::cout << variant.name << '\n';
        return 0;
    }
    if (std::string_view(BENCH_BUILD_TYPE) != "Release") {
        std::cerr << "Benchmark requires a Release build.\n";
        return 2;
    }

    const int samples = smoke ? 2 : 7;
    const double target_ns = smoke ? 1e6 : 1e7;
    constexpr std::size_t max_iterations = 1u << 24;
    std::cout << "variant,arch,build_type,mode,n,sample,iterations,elapsed_ns,ns_per_call,result\n"
              << std::setprecision(17);

    for (const std::size_t n : {256, 1024, 4096, 16384, 65536, 1048576}) {
        std::vector<float> a(n), b(n);
        for (std::size_t i = 0; i < n; ++i) {
            a[i] = static_cast<float>(static_cast<int>(i % 29) - 14) / 13.0f;
            b[i] = static_cast<float>(static_cast<int>(i % 17) - 8) / 11.0f;
        }
        for (const auto& variant : variants) {
            const float result = variant.function(a.data(), b.data(), n);
            if (!correct(a, b, result)) {
                std::cerr << "Correctness failed before timing " << variant.name << " n=" << n << '\n';
                return 1;
            }

            // Warm-up and calibration are deliberately excluded from recorded rows.
            for (int i = 0; i < 5; ++i) {
                consume(variant.function(a.data(), b.data(), n));
            }
            std::size_t iterations = 1;
            while (measure(variant.function, a, b, iterations) < target_ns && iterations < max_iterations) {
                iterations *= 2;
            }
            for (int sample = 0; sample < samples; ++sample) {
                const double elapsed_ns = measure(variant.function, a, b, iterations);
                if (!std::isfinite(elapsed_ns) || elapsed_ns <= 0.0) {
                    std::cerr << "Invalid timer measurement for n=" << n << '\n';
                    return 1;
                }
                std::cout << variant.name << ',' << BENCH_ARCH << ',' << BENCH_BUILD_TYPE << ','
                          << (smoke ? "smoke" : "measurement") << ',' << n << ','
                          << sample << ',' << iterations << ',' << elapsed_ns << ','
                          << elapsed_ns / static_cast<double>(iterations) << ',' << result << '\n';
            }
        }
    }
    std::cout.flush();
    if (!std::cout) {
        std::cerr << "Could not write benchmark CSV.\n";
        return 1;
    }
    return 0;
}
