def get_chunk(wc):
    digits = str(wc.scatteritem).split("-of-")
    return f"{digits[0]}/{digits[1]}"


def get_input_bam(wc):
    bam = config[wc.sm]
    if not os.path.exists(bam):
        raise Exception(f"Missing input bam {bam}")
    return bam

def get_input_pbi(wc):
    index = f"{get_input_bam(wc)}.pbi"
    if not os.path.exists(index):
        raise Exception(f"Missing index {index}")
    return index


def get_number_of_chunks(wc):
    sample = wc.sm
    input_bam = config[sample]
    GB_size = os.path.getsize(input_bam) / 1024**3
    return int(GB_size) + 1


def get_scatteritem_wc(wc):
    chunks = get_number_of_chunks(wc)
    return [f"{i}-of-{chunks}" for i in range(1, chunks + 1)]


def get_ccs_splits(wc):
    rtn = expand(
        rules.ccs_chunks.output.bam,
        scatteritem=get_scatteritem_wc(wc),
        allow_missing=True,
    )
    return rtn
