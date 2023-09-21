# subread-to-ccs-smk

# Example

```bash
snakemake --profile profiles/checkpoint --config m64076_221108_005936=/mmfs1/gscratch/stergachislab/data-store/PacBio-archive/m64076_221108_005936/m64076_221108_005936.subreads.bam --dry-run
```

After `--config` you can list one or more subread bam file(s) each as a key value pair, where the key is the movie name and the value is the full path. Right now this example shows a `--dry-run`, remove that to run the pipeline.

### Dependencies

Dependencies are managed with conda. Be sure to include the following in your `.bashrc` if you want to use the pre-computed conda env.

```
export SNAKEMAKE_CONDA_PREFIX=/mmfs1/gscratch/stergachislab/snakemake-conda-envs
```
