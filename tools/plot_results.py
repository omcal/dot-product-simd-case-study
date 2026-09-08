#!/usr/bin/env python3
"""Plot median ns/call per input size from a results CSV.

Usage:
  python3 tools/plot_results.py
  python3 tools/plot_results.py --input results/results-2026-09-08-s2-native-gcc-pooled.csv \
      --output results/charts/ns_per_call.png

Only "measurement" rows are used (smoke rows are skipped). The same script
runs locally and in CI; the chart itself does not produce measurements.
"""

import argparse
import csv
import os
import statistics
import sys

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt


def load_series(path):
    """Return {(variant, arch): {n: [ns_per_call, ...]}}."""
    series = {}
    with open(path, newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            if row.get("mode") != "measurement":
                continue
            key = (row["variant"], row["arch"])
            try:
                n = int(row["n"])
                value = float(row["ns_per_call"])
            except (TypeError, ValueError):
                continue
            series.setdefault(key, {}).setdefault(n, []).append(value)
    return series


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", default="results/results-2026-09-08-s2-native-gcc-pooled.csv")
    parser.add_argument("--output", default="results/charts/ns_per_call.png")
    args = parser.parse_args()

    if not os.path.exists(args.input):
        print(f"error: {args.input} not found", file=sys.stderr)
        return 2

    series = load_series(args.input)
    if not series:
        print(f"warning: no measurement rows in {args.input}; chart not generated")
        return 0

    fig, ax = plt.subplots(figsize=(7, 4.5))
    # Distinct line/marker styles so scalar and compiler_optimized remain
    # separable when they overlap.
    style = {
        "scalar": ("-", "o"),
        "compiler_optimized": ("--", "s"),
        "compiler_reassociated": (":", "d"),
        "manual_avx2": ("-.", "^"),
    }
    for (variant, arch), per_n in sorted(series.items()):
        ns = sorted(per_n)
        med = [statistics.median(per_n[n]) for n in ns]
        lo = [min(per_n[n]) for n in ns]
        hi = [max(per_n[n]) for n in ns]
        ls, mk = style.get(variant, ("-", "o"))
        (line,) = ax.plot(ns, med, linestyle=ls, marker=mk, markersize=4,
                          linewidth=1, label=f"{variant} · {arch}")
        # Min-max band shows the observed spread (asymmetric on a log axis).
        ax.errorbar(ns, med,
                    yerr=[[m - l for m, l in zip(med, lo)],
                          [h - m for m, h in zip(med, hi)]],
                    fmt="none", ecolor=line.get_color(), alpha=0.45,
                    capsize=2, linewidth=1)

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("Vector length (n)")
    ax.set_ylabel("median ns/call")
    ax.grid(True, which="both", alpha=0.3)
    ax.legend()

    os.makedirs(os.path.dirname(args.output), exist_ok=True)
    fig.savefig(args.output, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print(f"wrote: {args.output}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
