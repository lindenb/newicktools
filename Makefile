.PHONY:all test
URL=http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&retmode=xml
CC=g++
CFLAGS=-O3 -Wall

all: taxonomy2newick newick2json

newick2json : newick2js.y newick2js.l
	bison -d newick2js.y
	flex newick2js.l
	$(CC) -o $@ $(CFLAGS) newick2js.tab.c lex.yy.c
	

taxonomy2newick : taxonomy2newick.cpp
	$(CC) -o $@ $(CFLAGS) $< `xml2-config --cflags --libs`

test: taxonomy2newick newick2json
	curl -s '${URL}&id=9606' |./taxonomy2newick | ./newick2json
	curl -s '${URL}&id=9606,9605' |./taxonomy2newick | ./newick2json
	curl -s '${URL}&id=9606,10090,9031,7227,562' |./taxonomy2newick | ./newick2json
	

clean:
	rm -f taxonomy2newick newick2json lex.yy.c newick2js.tab.c newick2js.tab.h 
