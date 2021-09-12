# Human Genome Assembly Converter

Converts chromosome coordinates from one human genome assembly to another
 
## Usage
    perl ./human-genome-assembly-converter [-s, -t, -f, -o, --format] CHROM_NAME CHROM_START CHROM_END

#### Arguments
	CHROM_NAME			name of the human chromosome
	CHROM_START			starting coordinates	
	CHROM_END			ending coordinates

#### Options
	-s,  --source    	source assembly. Default='GRCh37'
	-t,  --target      	target assembly. Default='GRCh38'
    -f,  --file         input file name which is in BED format
    -o,  --output       output file name
    -format             Either BED or JSON. Default JSON


## Installation

The code has been tested on perl v5.34.0 for x86\_64-linux. Before running the script ensure that ensembl perl API has been setup (https://m.ensembl.org/info/docs/api/api\_installation.html). After cloning the repository simply run the command, 

```
$ perl ./human-genome-assembly-converter.pl -s GRCh38 -t GRCh37 10 25000 30000
```

Currently, it supports output in BED and JSON format. You may also provide an input file in BED format to convert the coordinates.

## Tests

The `tests` directory contains a short script to test the various scenarios. 
