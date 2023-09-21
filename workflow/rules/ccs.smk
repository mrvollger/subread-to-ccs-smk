# NO CCS FILE PROVIDED SO WE MUST GENERATE ONE
rule ccs_chunks:
    input:
        bam=get_input_bam,
        pbi=get_input_pbi,
    output:
        bam=temp("temp/{sm}/ccs.{scatteritem}.bam"),
        pbi=temp("temp/{sm}/ccs.{scatteritem}.bam.pbi"),
        json=temp("temp/{sm}/ccs.{scatteritem}.zmw_metrics.json.gz"),
        txt=temp("temp/{sm}/ccs.{scatteritem}.ccs_report.txt"),
    resources:
        mem_mb=16 * 1024,
        disk_mb=16 * 1024,
        time=200,
    threads: 8
    conda:
        "../envs/env.yml"
    params:
        chunk=get_chunk,
    priority: 0
    shell:
        """
        ccs {input.bam} {output.bam} \
            --metrics-json {output.json} \
            --report-file {output.txt} \
            --hifi-kinetics -j {threads} \
            --chunk {params.chunk}
        """


rule merge_ccs_chunks:
    input:
        expand(
            rules.ccs_chunks.output.bam,
            scatteritem=get_scatteritem_wc,
            allow_missing=True,
        ),
    output:
        bam="results/{sm}/{sm}.ccs.with.kinetics.bam",
    resources:
        mem_mb=32 * 1024,
        disk_mb=32 * 1024,
        time=200,
    threads: 24
    conda:
        "../envs/env.yml"
    shell:
        """
        pbmerge -j {threads} -o {output.bam} {input}
        """
