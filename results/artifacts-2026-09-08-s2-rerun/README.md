# S2 verification rerun — 2026-09-08

`em-amazing-liskov` (AMD EPYC 8024P, virt=none, boost=0, governor=performance,
taskset -c 0). Toolchains: g++ 15.2.0, clang++ 21.1.8, cmake 4.2.3.

## Purpose (R1 provenance)

The original S2 build directories were overwritten during earlier re-run
attempts, so the four `compile_commands.json`/`CMakeCache.txt` sets and object
disassembly of the measured binaries were no longer recoverable from the
original session. This is a **dated, separately labeled rebuild + rerun** of
S2 from the archived sources (main @ `04f058f`; source files unchanged by the
data/paper commits that follow). It archives the missing provenance rather
than retrofitting it onto the original record.

- Sources: `git archive HEAD` at commit `04f058f`.
- Source checksum (CMakeLists + `src/*.cpp`): `427a6dad028296bbe899b8decff7ef622721a98d91d9173ffaed6c2fd715f4f5` (also in `environment.txt`).
- Builds: `build-{native,avx2}-{gcc,clang}` in `~/gpu-works-s2r`, each
  configured `-DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
  (plus `-DDOT_PRODUCT_ISA_AVX2=ON` for the avx2 configs).

## Contents (`measure/`)

- `environment.txt` — host/CPU/governor/boost/toolchains + source checksum.
- `session.log` — full run log (versions, config order, 72 correctness checks
  per config, CTest 4/4 per config, benchmark output suppressed).
- `asm-{native,avx2}-{gcc,clang}/` — flag-identical `-S` listings
  (`scalar.s`, `compiler_optimized.s`, `compiler_reassociated.s`,
  `manual_avx2.s`) + `compiler.txt` (exact compiler identity).
- `bench-{cfg}-{cc}-run{1,2}.csv` — raw timing CSV (2 runs × 7 samples × 6 sizes).
- `provenance-{cfg}-{cc}/` — `compile_commands.json`, `CMakeCache.txt`,
  `objdump/` (disassembly of `libdot_product{,_optimized,_reassociated,_avx2}.a`),
  `sha256sums.txt` (kernel libraries + benchmark/test binaries).

## Reproducibility vs the committed S2 pooled records

Per-cell pooled medians agree tightly; the worst single cell is the
memory-sensitive `manual_avx2 @ n=65536`.

| config | max per-cell diff | median per-cell diff |
|--------|-------------------|----------------------|
| native gcc   | 3.14% | 0.073% |
| native clang | 2.32% | 0.054% |
| avx2 gcc     | 8.38% | 0.050% |
| avx2 clang   | 2.11% | 0.053% |

Assembly spot checks reproduce the S2 listings: avx2-gcc `compiler_reassociated`
keeps a single `ymm` accumulator (`vaddps` dst `%ymm1`), avx2-clang uses four
accumulators (`%ymm0..3`), native-clang lists 17 `zmm` lines (as in
`artifacts-2026-09-08-s2`).

## Note on the run script

Earlier re-run attempts reused the compiler glob `[[ "$cc" == *g++* ]]`, which
also matches `clang++-21` (contains `g++`), causing the clang build to overwrite
the gcc build directory. The final script (`tools/s2-rerun-session.sh`) anchors
the match (`g++*`) and removes each build dir before configuring; every config
in this record was verified via `compiler.txt` and the per-config cache.
