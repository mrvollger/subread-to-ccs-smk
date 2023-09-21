def get_chunk(wc):
    digits = str(wc.scatteritem).split("-of-")
    return f"{digits[0]}/{digits[1]}"


def get_input_bam(wc):
    return config[wc.sm]


def get_input_pbi(wc):
    return f"{get_input_bam(wc)}.pbi"


def get_number_of_chunks(wc):
    sample = wc.sm
    input_bam = config[sample]
    GB_size = os.path.getsize(input_bam) / 1024**3
    return int(GB_size) + 1


def get_scatteritem_wc(wc):
    chunks = get_number_of_chunks(wc)
    return [f"{i}-of-{chunks}" for i in range(1, chunks + 1)]
