/* The MIT License

   Permission is hereby granted, free of charge, to any person obtaining
   a copy of this software and associated documentation files (the
   "Software"), to deal in the Software without restriction, including
   without limitation the rights to use, copy, modify, merge, publish,
   distribute, sublicense, and/or sell copies of the Software, and to
   permit persons to whom the Software is furnished to do so, subject to
   the following conditions:

   The above copyright notice and this permission notice shall be
   included in all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
   BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
   ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
   CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
   SOFTWARE.

   contact: Pierre Lindenbaum PhD @yokofakun

Motivation:
	https://twitter.com/sjackman/status/552597379983998976
	
	
History:
   * 2015 first commit


*/
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <set>
#include <map>
#include <cctype>
#include <iostream>
#include <unistd.h>
#include <errno.h>
#include <getopt.h>
#include <libxml/tree.h>
#include <libxml/xmlreader.h>

using namespace std;

#define T2N_VERSION "0.1"

/** wrap a Taxon Element */
class Taxon
	{
	private:
		xmlNodePtr root;
		std::string text_content(const char* name)
			{
			std::string s;
			if(root==NULL) return s;
			for(xmlNodePtr c= xmlFirstElementChild(root);
				c!=NULL;
				c = xmlNextElementSibling(c)
				)
				{
				if( strcmp((const char*) c->name,name) != 0 ) continue;
				xmlChar* txt = xmlNodeGetContent(c);
				s.assign((const char*)txt);
				xmlFree(txt);
				break;
				}
			return s;
			}
	public:
		set<string> children;
		Taxon(xmlNodePtr root):root(root)
			{
			if( strcmp((const char*)root->name,"Taxon") != 0 )
				{
				cerr << "Not a <Taxon> !??" << endl;
				exit(EXIT_FAILURE);
				}
			}
		
		std::string id()
			{
			return text_content("TaxId");
			}
		std::string name()
			{
			return text_content("ScientificName");
			}
	};

class Tax2Newick
	{
	private:
		/** root of the tree of life */
		Taxon* life;
		/** map taxonomy-ncbi-id to Taxon */
		std::map<std::string,Taxon*> id2taxon;
		
		void recursive(xmlNodePtr root)
			{
			if(root==NULL) return;
			Taxon* prevTaxon = NULL;
			for(xmlNodePtr c= xmlFirstElementChild(root);
				c!=NULL;
				c = xmlNextElementSibling(c)
				)
				{
				if( strcmp((const char*) c->name,"Taxon") == 0 )
					{
					Taxon* tax=new Taxon(c);
					std::map<std::string,Taxon*>::iterator r = id2taxon.find(tax->id());
					if( r== id2taxon.end())
						{
						id2taxon.insert(make_pair(tax->id(),tax));
						}
					else
						{
						delete tax;
						tax = r->second;
						
						}
					
					//prev in lineage found ?
					if(prevTaxon!=0 )
						{
						prevTaxon->children.insert( tax->id());
						
						}

					if( c->parent!=NULL &&
					    strcmp((const char*) c->parent->name,"LineageEx") == 0 )
						{
						// first of LineageEx/Taxon ?
						if(prevTaxon==0 && this->life==NULL)
							{
							this->life =  tax ;
							}
						//flag to link with children
						prevTaxon = tax;
						
						// last in LineageEx/Taxon, add link to current Taxon Record ?
						if(  c->parent->parent!=NULL &&
					    		strcmp((const char*) c->parent->parent->name,"Taxon") == 0 &&
					    		xmlNextElementSibling(c) == NULL )
							{
							Taxon tmp(c->parent->parent);
							r = id2taxon.find(tmp.id());
							if( r== id2taxon.end())
								{
								cerr << "Error !" << endl;
								exit(EXIT_FAILURE);
								}
							tax->children.insert(tmp.id());
							}
						}
					
					
					}
				recursive(c);
				}
			}
		void dump(Taxon* node)
			{
			if(node==NULL) return;
			if(!node->children.empty())
				{
				int first=1;
				cout << "(";
				for(std::set<string>::iterator r= node->children.begin();
					r != node->children.end();
					++r)
					{
					if(!first) cout << ",";
					
					std::map<std::string,Taxon*>::iterator r2 = id2taxon.find(*r);
					if( r2 == id2taxon.end())
						{
						cerr << "Error !" << endl;
						exit(EXIT_FAILURE);
						}
					dump(r2->second);
					first=0;
					}
				cout << ")";
				}
			string name(node->name());
			for(size_t i=0;i< name.size();++i)
				{
				char c=name[i];
				c= (isspace(c) || c==',' ? '_':c);
				cout << c;
				}
			}
	public:
		Tax2Newick()
			{
			}
		
		void usage(std::ostream& out)
			{
			out	<< "Compilation:\n\t" << __DATE__ <<" " << __TIME__ << endl
				<< "Version:\n\t" << T2N_VERSION<< "\n"
				<< "Author:\n\tPierre Lindenbaum PhD @yokofakun\n"
				<< "WWW:\n\thttps://github.com/lindenb/newick\n"
				<< "Usage:\n\tcurl (ncbi-efetch-tax.xml) | taxonomy2newick\n"
				<< "Options:\n"
				<< "\t-h|--help help (this screen)\n"
				<< "\t-v|--version print version.\n"
				<< endl;
			}
		
		int main(int argc,char** argv)
			{
			xmlDocPtr dom=NULL;
			life=NULL;
			for(;;)
				{
				static struct option long_options[] =
				     {
					{"help",   no_argument, 0, 'h'},
					{"version",   no_argument, 0, 'v'},
				       {0, 0, 0, 0}
				     };
				int option_index = 0;
				int c = getopt_long (argc, argv, "hv",
						    long_options, &option_index);
				if (c == -1) break;
				switch (c)
				   	{
					case 'v': printf("%s\n",T2N_VERSION); return EXIT_SUCCESS;
				   	case 'h': usage(cout); return EXIT_SUCCESS;
					case '?': cerr << "Unknown option \'-" << (char)optopt << "\'.\n";
				       		return EXIT_FAILURE;
					default: cerr << "Bad input.\n";
				       		return EXIT_FAILURE;
					}
				  
				}

			if(argc==optind)
				{
				dom = xmlReadFd(STDIN_FILENO, 
					 NULL, 
					 NULL, 
					0);
				}
			else if(optind+1==argc)
				{
				dom = xmlReadFile(argv[optind],"UTF-8",0);
				}
			else
				{
				cerr << "Illegal Number of arguments." << endl;
				return EXIT_FAILURE;
				}
			if(dom==NULL)
				{
				cerr << "Cannot read XML input" << endl;
				return EXIT_FAILURE;
				}
			xmlNodePtr rootElement = xmlDocGetRootElement(dom);
			if( rootElement == NULL )
				{
				cerr << "Root element missing" << endl;
				return EXIT_FAILURE;
				}
			if( strcmp((const char*)rootElement->name,"TaxaSet") != 0 )
				{
				cerr << "Not a <TaxaSet> root." << endl;
				return EXIT_FAILURE;
				}
			
			recursive( rootElement );
			
			if(life==NULL)
				{
				cerr << "Cannot get Root of life" << endl;
				return EXIT_FAILURE;
				}
			dump(life);
			cout << ";" << endl;
			
			
			//cleanup
			for(std::map<std::string,Taxon*>::iterator r = id2taxon.begin();
				r!= id2taxon.end();
				++r)
				{
				delete r->second;
				}
			this->life=NULL;
			id2taxon.clear();
			xmlFreeDoc(dom);
			return EXIT_SUCCESS;
			}
	};

int main(int argc,char** argv)
	{
	Tax2Newick app;
	return app.main(argc,argv);
	}

