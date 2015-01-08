# newicktools

Misc tools for the newick format.

* taxonomy2newick  : converts a NCBI XML Taxonomy to newick.
* newick2json  : converts newick to json
* newick2dot  : converts newick to graphviz dot


## History

* 2015-01 1st commit

## Usage

```
taxonomy2newick (stdin|ncbi-efetch-taxonomy.xml)
newick2json (stdin)
newick2dot (stdin)
```

## Compilation

taxonomy2newick requires libxml.

newick2json and  newick2dot require GNU flex and bison.

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

```
$ curl -s 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&retmode=xml&id=9606' |\
./taxonomy2newick | ./newick2dot 

digraph G {
id31[label="cellular_organisms"];
id30[label="Eukaryota"];
id29[label="Opisthokonta"];
id28[label="Metazoa"];
id27[label="Eumetazoa"];
id26[label="Bilateria"];
id25[label="Deuterostomia"];
id24[label="Chordata"];
id23[label="Craniata"];
id22[label="Vertebrata"];
id21[label="Gnathostomata"];
id20[label="Teleostomi"];
id19[label="Euteleostomi"];
id18[label="Sarcopterygii"];
id17[label="Dipnotetrapodomorpha"];
id16[label="Tetrapoda"];
id15[label="Amniota"];
id14[label="Mammalia"];
id13[label="Theria"];
id12[label="Eutheria"];
id11[label="Boreoeutheria"];
id10[label="Euarchontoglires"];
id9[label="Primates"];
id8[label="Haplorrhini"];
id7[label="Simiiformes"];
id6[label="Catarrhini"];
id5[label="Hominoidea"];
id4[label="Hominidae"];
id3[label="Homininae"];
id2[label="Homo"];
id1[label="Homo_sapiens"];
id2 ->  id1
id3 ->  id2
id4 ->  id3
id5 ->  id4
id6 ->  id5
id7 ->  id6
id8 ->  id7
id9 ->  id8
id10 ->  id9
id11 ->  id10
id12 ->  id11
id13 ->  id12
id14 ->  id13
id15 ->  id14
id16 ->  id15
id17 ->  id16
id18 ->  id17
id19 ->  id18
id20 ->  id19
id21 ->  id20
id22 ->  id21
id23 ->  id22
id24 ->  id23
id25 ->  id24
id26 ->  id25
id27 ->  id26
id28 ->  id27
id29 ->  id28
id30 ->  id29
id31 ->  id30
}
```

## Author

* Pierre Lindenbaum PhD @yokofakun

## See also

* https://twitter.com/sjackman/status/552597379983998976
* http://plindenbaum.blogspot.fr/2012/07/parsing-newick-format-in-c-using-flex.html
* https://www.biostars.org/p/83961/

