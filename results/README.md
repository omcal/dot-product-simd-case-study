# Results

Raw benchmark CSV files and provenance for the dot-product SIMD study.

## Sessions

- `results-2026-09-08-s2-{native,avx2}-{gcc,clang}-{run1,run2,pooled}.csv`
  Second dedicated-server session (2026-09-08). Four variants, two ISA
  conditions (native and equal-ISA AVX2), GCC and Clang, two runs each.
  Pooled files contain 14 samples per cell and feed the paper's main tables.
- `results-2026-09-07-bm-{gcc,clang}-*.csv`
  First dedicated-server session (2026-09-07), native condition only. Kept as
  an independent replication.
- `results-2026-09-08-s2-rerun-*.csv`
  Verification rebuild of the S2 sources on the same machine.
- `results-2026-09-07-vps-*.csv`
  Earlier VM record (preliminary).
- `results-2026-09-07-arm-two-variant.csv`
  Two-variant ARM record (Apple Clang, M4 MacBook Air).

## Artifacts

Each `artifacts-*` directory holds assembly listings, `compile_commands.json`,
`CMakeCache.txt`, object disassembly, and an `environment.txt` for that
session.

## Environment

- Dedicated servers (S1 and S2): AMD EPYC 8024P, boost disabled, performance
  governor, `taskset -c 0`. GCC 15.2.0, Clang 21.1.8, Ubuntu 24.04.
- ARM: Apple M4 MacBook Air, Apple Clang 21.0.0.
- VM: rented VM with a QEMU "Haswell" guest; preliminary only.
