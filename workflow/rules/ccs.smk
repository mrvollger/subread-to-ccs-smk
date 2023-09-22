rule ccs_chunk:
    input:
        bam=get_input_bam,
        pbi=get_input_pbi,
    output:
        bam=temp("temp/{sm}.{scatteritem}.bam"),
        pbi=temp("temp/{sm}.{scatteritem}.bam.pbi"),
        json=temp("temp/{sm}.{scatteritem}.zmw_metrics.json.gz"),
        txt=temp("temp/{sm}.{scatteritem}.ccs_report.txt"),
    resources:
        mem_mb=8 * 1024,
        disk_mb=8 * 1024,
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


rule fofn:
    input:
        chunks=get_ccs_chunks,
    output:
        fofn=temp("temp/{sm}.ccs_chunks.fofn"),
    threads: 1
    run:
        with open(output.fofn, "w") as f:
            [f.write(f"{chunk}\n") for chunk in input.chunks]


rule merge_ccs_chunks:
    input:
        chunks=get_ccs_chunks,
        fofn=rules.fofn.output.fofn,
    output:
        bam="results/{sm}.ccs.with.kinetics.bam",
    resources:
        mem_mb=32 * 1024,
        disk_mb=32 * 1024,
        time=500,
    threads: 24
    log: "logs/{sm}.merge.log"
    conda:
        "../envs/env.yml"
    shell:
        """
        pbmerge -j {threads} -o {output.bam} {input.fofn} &> {log}
        """
