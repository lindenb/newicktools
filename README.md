# newicktools

Misc tools for the newick format.

* taxonomy2newick  : converts a NCBI XML Taxonomy to newick.
* newick2json  : converts newick to json

## History

* 2015-01 1st commit

## Usage

```
taxonomy2newick (stdin|ncbi-efetch-taxonomy.xml)
newick2json (stdin)
```

## Compilation

taxonomy2newick requires libxml.

newick2json  requires GNU flex and bison.

```
make
```

## ExampleS

```bash
$ curl -s 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&retmode=xml&id=9606,10090,9031,7227,562' |\
 taxonomy2newick | fold -w 60

(((((((Escherichia_coli)Escherichia)Enterobacteriaceae)Enter
obacteriales)Gammaproteobacteria)Proteobacteria)Bacteria,(((
(((((((((((((((((((((((((((((((Drosophila_melanogaster)melan
ogaster_subgroup)melanogaster_group)Sophophora)Drosophila)Dr
osophiliti)Drosophilina)Drosophilini)Drosophilinae)Drosophil
idae)Ephydroidea)Acalyptratae)Schizophora)Cyclorrhapha)Eremo
neura)Muscomorpha)Brachycera)Diptera)Endopterygota)Neoptera)
Pterygota)Dicondylia)Insecta)Hexapoda)Pancrustacea)Mandibula
ta)Arthropoda)Panarthropoda)Ecdysozoa)Protostomia,((((((((((
((((((((((((((Mus_musculus)Mus)Mus)Murinae)Muridae)Muroidea)
Sciurognathi)Rodentia)Glires,((((((((Homo_sapiens)Homo)Homin
inae)Hominidae)Hominoidea)Catarrhini)Simiiformes)Haplorrhini
)Primates)Euarchontoglires)Boreoeutheria)Eutheria)Theria)Mam
malia,(((((((((((((((Gallus_gallus)Gallus)Phasianinae)Phasia
nidae)Galliformes)Galloanserae)Neognathae)Aves)Coelurosauria
)Theropoda)Saurischia)Dinosauria)Archosauria)Archelosauria)S
auria)Sauropsida)Amniota)Tetrapoda)Dipnotetrapodomorpha)Sarc
opterygii)Euteleostomi)Teleostomi)Gnathostomata)Vertebrata)C
raniata)Chordata)Deuterostomia)Bilateria)Eumetazoa)Metazoa)O
pisthokonta)Eukaryota)cellular_organisms;
```

```bash
$ curl -s 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&retmode=xml&id=9606,10090,9031,7227,562' |\
taxonomy2newick |\
newick2json  |\
fold -w 60

{"label":"cellular_organisms","children":[{"label":"Bacteria
","children":[{"label":"Proteobacteria","children":[{"label"
:"Gammaproteobacteria","children":[{"label":"Enterobacterial
es","children":[{"label":"Enterobacteriaceae","children":[{"
label":"Escherichia","children":[{"label":"Escherichia_coli"
}]}]}]}]}]}]},{"label":"Eukaryota","children":[{"label":"Opi
sthokonta","children":[{"label":"Metazoa","children":[{"labe
l":"Eumetazoa","children":[{"label":"Bilateria","children":[
{"label":"Protostomia","children":[{"label":"Ecdysozoa","chi
ldren":[{"label":"Panarthropoda","children":[{"label":"Arthr
(...)
n":[{"label":"Homininae","children":[{"label":"Homo","childr
en":[{"label":"Homo_sapiens"}]}]}]}]}]}]}]}]}]}]}]}]}]},{"la
bel":"Sauropsida","children":[{"label":"Sauria","children":[
{"label":"Archelosauria","children":[{"label":"Archosauria",
"children":[{"label":"Dinosauria","children":[{"label":"Saur
ischia","children":[{"label":"Theropoda","children":[{"label
":"Coelurosauria","children":[{"label":"Aves","children":[{"
label":"Neognathae","children":[{"label":"Galloanserae","chi
ldren":[{"label":"Galliformes","children":[{"label":"Phasian
idae","children":[{"label":"Phasianinae","children":[{"label
":"Gallus","children":[{"label":"Gallus_gallus"}]}]}]}]}]}]}
]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}]}
```

## Author

* Pierre Lindenbaum PhD @yokofakun

## See also

* https://twitter.com/sjackman/status/552597379983998976
* http://plindenbaum.blogspot.fr/2012/07/parsing-newick-format-in-c-using-flex.html
* https://www.biostars.org/p/83961/

