# Splice-site PSSM scoring

- `5primeSS.GT.PSSM` contains nucleotide counts for the 9-position donor window.
- `3primeSS.AG.PSSM` contains nucleotide counts for the 15-position acceptor window.

Rows follow the order of positions in each window. Columns are A, C, G and T.
`scan_motif_PSSM.awk` (Kudla Lab) sums the counts for the bases in each
window and normalises the score using the minimum and maximum possible sums.

Run this example from this directory with GNU awk. The input table contains
the sequence identifier in column 1 and the nucleotide sequence in column 2.

```bash
gawk -f scan_motif_PSSM.awk POS=1 CUTOFF=0 'FILTER=.........' \
  5primeSS.GT.PSSM input_sequences.tsv
```

`POS` is the 1-based start of the scoring window. The output columns are
sequence identifier, window start, motif sequence and normalised score.
Canonical GT/AG site eligibility is applied downstream in the benchmark.
The scanner's original loop omits the last possible window in each sequence.
