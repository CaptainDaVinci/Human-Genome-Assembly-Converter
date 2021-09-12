# Human Genome Assembly Converter

Converts chromosome coordinates from one human genome assembly to another
 
## Installation

### Pre-requisites

1. Clone this repository
2. Run from the root of the directory

```
$ perl ./human-genome-assembly-converter.pl -s GRCh38 -t GRCh37 --format BED 10 25000 30000
```

## Usage
    perl ./human-genome-assembly-converter [-s, -t, -f, -o, --format] CHROM_NAME CHROM_START CHROM_END

### Arguments
	CHROM_NAME			name of the human chromosome
	CHROM_START			starting coordinates	
	CHROM_END			ending coordinates

### Options
	-s,  --source    	source assembly. Default='GRCh37'
	-t,  --target      	target assembly. Default='GRCh38'
    -f,  --file         input file name which is in BED format
    -o,  --output       output file name
    -format             Either BED or JSON. Default JSON

