# newicktools
Misc tools for newick format.

* taxonomy2newick  : convert a NCBI XML Taxonomy to newick.

## History

* 2015-01 1st commit

## Usage

```
taxonomy2newick (stdin|ncbi-efetch-taxonomy.xml)
```

## Compilation

libxml is required.

```
make
```

## Example

```
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

## Author

* Pierre Lindenbaum PhD @yokofakun


