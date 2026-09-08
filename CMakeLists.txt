cmake_minimum_required(VERSION 3.20)
project(cpu_simd_dot_product LANGUAGES CXX)

add_library(dot_product STATIC src/dot_product.cpp)
target_include_directories(dot_product PUBLIC include)
target_compile_features(dot_product PUBLIC cxx_std_17)

# Keep the scalar reference distinct from the compiler-optimized variant.
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(dot_product PRIVATE
        -Wall -Wextra -Wpedantic
        -fno-vectorize -fno-slp-vectorize -ffp-contract=off)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    target_compile_options(dot_product PRIVATE
        -Wall -Wextra -Wpedantic
        -fno-tree-vectorize -ffp-contract=off)
else()
    message(FATAL_ERROR "Use GCC or Clang to preserve the scalar build settings.")
endif()

add_library(dot_product_optimized STATIC src/dot_product_optimized.cpp)
target_include_directories(dot_product_optimized PUBLIC include)
target_compile_features(dot_product_optimized PUBLIC cxx_std_17)
target_compile_options(dot_product_optimized PRIVATE
    -Wall -Wextra -Wpedantic -ffp-contract=off)
# Enable diagnostics only for the compiler baseline. No reassociation/fast-math:
# whether this reduction vectorizes under normal -O3 rules is an experiment.
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(dot_product_optimized PRIVATE
        -Rpass=loop-vectorize -Rpass-missed=loop-vectorize
        -Rpass-analysis=loop-vectorize)
else()
    target_compile_options(dot_product_optimized PRIVATE -fopt-info-vec-all)
endif()

add_library(dot_product_reassociated STATIC src/dot_product_reassociated.cpp)
target_include_directories(dot_product_reassociated PUBLIC include)
target_compile_features(dot_product_reassociated PUBLIC cxx_std_17)
# FP reassociation allowed; contraction still off. GCC needs the explicit
# fno-signed-zeros/fno-trapping-math pair for the option to take effect.
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    target_compile_options(dot_product_reassociated PRIVATE
        -Wall -Wextra -Wpedantic -ffast-math -ffp-contract=off)
else()
    target_compile_options(dot_product_reassociated PRIVATE
        -Wall -Wextra -Wpedantic -fassociative-math -fno-signed-zeros
        -fno-trapping-math -ffp-contract=off)
endif()

option(DOT_PRODUCT_NATIVE "Use the build host's CPU features (not portable binaries)" ON)
option(DOT_PRODUCT_ISA_AVX2 "x86: compile compiler targets with -mavx2 instead of -march=native (equal-ISA comparison with the manual AVX2 kernel; implies DOT_PRODUCT_NATIVE=OFF)" OFF)
if(DOT_PRODUCT_ISA_AVX2 AND NOT CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|AMD64|amd64|i.86)$")
    message(FATAL_ERROR "DOT_PRODUCT_ISA_AVX2 requires an x86_64 target")
endif()
if(DOT_PRODUCT_ISA_AVX2)
    set(native_flag -mavx2)
elseif(DOT_PRODUCT_NATIVE)
    if(CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|AMD64|amd64|i.86)$")
        set(native_flag -march=native)
    elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^(arm64|aarch64)$")
        set(native_flag -mcpu=native)
    else()
        message(FATAL_ERROR "Unknown native CPU flag; configure with -DDOT_PRODUCT_NATIVE=OFF")
    endif()
endif()
if(DOT_PRODUCT_ISA_AVX2 OR DOT_PRODUCT_NATIVE)
    target_compile_options(dot_product PRIVATE ${native_flag})
    target_compile_options(dot_product_optimized PRIVATE ${native_flag})
    target_compile_options(dot_product_reassociated PRIVATE ${native_flag})
endif()

add_library(dot_product_dispatch STATIC src/dot_product_dispatch.cpp)
target_link_libraries(dot_product_dispatch PUBLIC
    dot_product dot_product_optimized dot_product_reassociated)
target_compile_options(dot_product_dispatch PRIVATE -Wall -Wextra -Wpedantic)
set_target_properties(dot_product_dispatch PROPERTIES INTERPROCEDURAL_OPTIMIZATION FALSE)
option(DOT_PRODUCT_ENABLE_AVX2 "Build the manual AVX2 kernel on x86" ON)
if(DOT_PRODUCT_ENABLE_AVX2 AND CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|AMD64|amd64|i.86)$")
    add_library(dot_product_avx2 STATIC src/dot_product_avx2.cpp)
    target_compile_features(dot_product_avx2 PRIVATE cxx_std_17)
    # No native flags here: this kernel must not acquire FMA/AVX-512 requirements.
    target_compile_options(dot_product_avx2 PRIVATE
        -Wall -Wextra -Wpedantic -mavx2 -mno-fma -ffp-contract=off)
    set_target_properties(dot_product_avx2 PROPERTIES INTERPROCEDURAL_OPTIMIZATION FALSE)
    target_link_libraries(dot_product_dispatch PUBLIC dot_product_avx2)
    target_compile_definitions(dot_product_dispatch PRIVATE DOT_PRODUCT_HAS_AVX2=1)
else()
    target_compile_definitions(dot_product_dispatch PRIVATE DOT_PRODUCT_HAS_AVX2=0)
endif()

add_executable(dot_product_benchmark src/benchmark.cpp)
target_link_libraries(dot_product_benchmark PRIVATE dot_product_dispatch)
target_compile_options(dot_product_benchmark PRIVATE -Wall -Wextra -Wpedantic)
target_compile_definitions(dot_product_benchmark PRIVATE
    BENCH_ARCH="${CMAKE_SYSTEM_PROCESSOR}"
    BENCH_BUILD_TYPE="$<CONFIG>")
# Keep kernel calls in a separate translation unit; no cross-unit hoisting.
set_target_properties(dot_product dot_product_optimized dot_product_benchmark PROPERTIES
    INTERPROCEDURAL_OPTIMIZATION FALSE)

include(CTest)
if(BUILD_TESTING)
    add_executable(dot_product_tests tests/dot_product_tests.cpp)
    target_link_libraries(dot_product_tests PRIVATE dot_product_dispatch)
    add_test(NAME dot_product_correctness COMMAND dot_product_tests)
    add_test(NAME correctness_without_avx2 COMMAND dot_product_tests --disable-avx2)
    add_test(NAME benchmark_smoke
        COMMAND ${CMAKE_COMMAND}
            -DBENCHMARK=$<TARGET_FILE:dot_product_benchmark>
            -P ${CMAKE_CURRENT_SOURCE_DIR}/tests/benchmark_smoke.cmake)
    add_test(NAME benchmark_without_avx2
        COMMAND ${CMAKE_COMMAND}
            -DBENCHMARK=$<TARGET_FILE:dot_product_benchmark>
            -DDISABLE_AVX2=ON
            -P ${CMAKE_CURRENT_SOURCE_DIR}/tests/benchmark_smoke.cmake)
endif()
