# dot-product-simd-case-study

A benchmark that compares four implementations of a float dot product on
x86-64: scalar, compiler-optimized, compiler-reassociated, and a hand-written
AVX2 kernel. The data and the accompanying analysis appear in the AccML 2027
paper "When Does Manual SIMD Beat Compiler Auto-Vectorization?".

## Variants

| Variant | Flags |
|---|---|
| scalar | `-O3`; vectorization disabled; `-ffp-contract=off` |
| compiler-optimized | `-O3`; `-ffp-contract=off` |
| compiler-reassociated | `-O3`; GCC `-fassociative-math -fno-signed-zeros -fno-trapping-math`, Clang `-ffast-math`; `-ffp-contract=off` |
| manual_avx2 | `-O3 -mavx2 -mno-fma -ffp-contract=off` |

The compiler targets use `-march=native` by default. Build with
`-DDOT_PRODUCT_ISA_AVX2=ON` to use `-mavx2` instead (equal-ISA comparison
against the manual kernel).

## Build and test

Requires CMake 3.20+ and a C++17 compiler.

```sh
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
ctest --test-dir build --output-on-failure
```

## Run

```sh
./build/dot_product_benchmark > local-run.csv
```

Sizes 256..1048576; five warm-up calls; iteration count calibrated to at least
10 ms; seven samples per size.

## Data

Raw CSV files and provenance are under `results/`. See `results/README.md`
for the file layout and the measurement environment.

## Regenerate the chart and tables

```sh
python3 tools/plot_results.py --input results/results-2026-09-08-s2-native-gcc-pooled.csv --output results/charts/ns_per_call.png
python3 tools/table_numbers.py
```

## CI

A GitHub Actions workflow ([`.github/workflows/ci.yml`](.github/workflows/ci.yml))
builds and runs the tests on Ubuntu (GCC and Clang) and macOS (Clang) on every
push and pull request:

[![CI](https://github.com/omcal/dot-product-simd-case-study/actions/workflows/ci.yml/badge.svg)](https://github.com/omcal/dot-product-simd-case-study/actions/workflows/ci.yml)

### Adding a secret

This workflow uses no secrets. If you later add a step that needs an API token
or other credential, store it in GitHub under **Settings → Secrets and
variables → Actions → New repository secret**, then reference it in the
workflow as `${{ secrets.NAME }}`. Secrets are never committed to the
repository.

## License

MIT. See `LICENSE`.
