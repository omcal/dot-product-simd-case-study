#!/usr/bin/env python3
"""Generate the paper's table numbers from the S2 record.

Source: results/results-2026-09-08-s2-{native,avx2}-{gcc,clang}-pooled.csv
(ARM column: results/results-2026-09-07-arm-two-variant.csv).
Rounding: half-up (ROUND_HALF_UP), applied to ratios of per-cell medians.
This file produces the numbers in the paper's Tables II/III/IV and the
Results narrative from a single place.
"""
import csv
import os
import statistics
from decimal import Decimal, ROUND_HALF_UP

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def half_up(x, nd):
    return float(Decimal(str(x)).quantize(Decimal(1).scaleb(-nd),
                                          rounding=ROUND_HALF_UP))


def pooled(path):
    d = {}
    for r in csv.DictReader(open(path)):
        d.setdefault((r["variant"], int(r["n"])), []).append(float(r["ns_per_call"]))
    return {k: statistics.median(v) for k, v in d.items()}


def vm(path):
    m = pooled(path)
    out = {}
    for (var, n), v in m.items():
        out.setdefault(n, {})[var] = v
    return out


def s2(cond, cc):
    return vm(f"{ROOT}/results/results-2026-09-08-s2-{cond}-{cc}-pooled.csv")


def main():
    print("Table II (compiler/scalar, 3dp): S2 native gcc / clang / arm")
    arm = vm(f"{ROOT}/results/results-2026-09-07-arm-two-variant.csv")
    gcc = s2("native", "gcc")
    clang = s2("native", "clang")
    for n in sorted(gcc):
        go = gcc[n]["compiler_optimized"] / gcc[n]["scalar"]
        co = clang[n]["compiler_optimized"] / clang[n]["scalar"]
        ao = arm[n]["compiler_optimized"] / arm[n]["scalar"]
        print(f"  {n} & ${half_up(go,3):.3f}\\times$ & ${half_up(co,3):.3f}\\times$ & ${half_up(ao,2):.2f}\\times$ \\\\")

    print("Table III (S2 native gcc; ns medians int + scalar/manual 1dp)")
    for n in sorted(gcc):
        v = gcc[n]
        print(f"  {n} & {half_up(v['scalar'],0):.0f} & {half_up(v['compiler_optimized'],0):.0f} "
              f"& {half_up(v['compiler_reassociated'],0):.0f} & {half_up(v['manual_avx2'],0):.0f} "
              f"& ${half_up(v['scalar']/v['manual_avx2'],1):.1f}\\times$ \\\\")

    print("Table IV (S2 avx2; R/M 2dp, S/M 1dp)")
    for cc in ("gcc", "clang"):
        v = s2("avx2", cc)
        rm = " ".join(f"${half_up(v[n]['compiler_reassociated']/v[n]['manual_avx2'],2):.2f}\\times$" for n in sorted(v))
        sm = " ".join(f"${half_up(v[n]['scalar']/v[n]['manual_avx2'],1):.1f}\\times$" for n in sorted(v))
        print(f"  {cc} R/M: {rm}")
        print(f"  {cc} S/M: {sm}")

    print("Narrative ranges")
    for cond in ("native", "avx2"):
        for cc in ("gcc", "clang"):
            v = s2(cond, cc)
            rm = [v[n]["compiler_reassociated"] / v[n]["manual_avx2"] for n in sorted(v)]
            sr = [v[n]["scalar"] / v[n]["compiler_reassociated"] for n in sorted(v)]
            sm = [v[n]["scalar"] / v[n]["manual_avx2"] for n in sorted(v)]
            print(f"  S2 {cond} {cc}: R/M {half_up(min(rm),2):.2f}-{half_up(max(rm),2):.2f} | "
                  f"S/R {half_up(min(sr),1):.1f}-{half_up(max(sr),1):.1f} | "
                  f"S/M {half_up(min(sm),1):.1f}-{half_up(max(sm),1):.1f}")


if __name__ == "__main__":
    main()
