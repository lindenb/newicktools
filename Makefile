.PHONY:all test
URL=http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&retmode=xml
CC=g++
CFLAGS=-O3 -Wall
all: taxonomy2newick

taxonomy2newick: taxonomy2newick.cpp
	$(CC) -o $@ $(CFLAGS) $< `xml2-config --cflags --libs`

test: taxonomy2newick
	curl -s '${URL}&id=9606' |./taxonomy2newick
	curl -s '${URL}&id=9606,9605' |./taxonomy2newick
	curl -s '${URL}&id=9606,10090,9031,7227,562' |./taxonomy2newick

clean:
	rm -f taxonomy2newick
