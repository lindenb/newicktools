%{
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
	https://www.biostars.org/p/83961/
	
	
History:
   * 2015 first commit


*/
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
extern int yylex();
extern FILE* yyin;

extern void* saferealloc(void *ptr, size_t size);
int yywrap() { return 1;}
void yyerror(const char* s) {fprintf(stderr,"Error:\"%s\".\n",s);}

unsigned int id_generator=0;

struct tree_t
	{
	char* label;
	char* length;
	struct tree_t* child;
	struct tree_t* next;
	};

typedef struct tree_t Tree;

static Tree* newTree()
	{
	Tree* t=(Tree*)saferealloc(0,sizeof(Tree));
	memset(t,0,sizeof(Tree));
	return t;
	}
static void freeTree(Tree* t)
	{
	if(t==NULL) return;
	free(t->label);
	free(t->length);
	freeTree(t->child);
	freeTree(t->next);
	free(t);
	}
	
static void escape(FILE* out,const char* s)
	{
	
	if(s==NULL) { fputs("null",out); return;}
	while(*s!=0)
		{
		switch(*s)
			{
			case '\'': fputs("&apos;",out); break;
			case '\"': fputs("&quot;",out); break;
			case '<': fputs("&lt;",out); break;
			case '>': fputs("&gt;",out); break;
			case '&': fputs("&amp;",out); break;
			default : fputc(*s,out); break;
			}
		++s;
		}
	}

static void attribute(FILE* out,const char* key,const char* value)
	{
	if(value==NULL) return;
	fprintf(out," %s=\"",key);
	escape(out,value);
	fputc('\"',out);
	}
	
	
static void printTree(FILE* out,const Tree* t)
	{
	fprintf(out,"<node id=\"n%d\"",++id_generator);
	
	attribute(out,"label",t->label);
	attribute(out,"length",t->length);
	fputc('>',out);
	
	if(t->child!=0)
		{
		const Tree* c=t->child;
		if(c==NULL)
			{
			fputs("<children/>",out);
			}
		else
			{
			fputs("<children>",out)	;
		
			while(c!=NULL)
				{
				printTree(out,c);
				c=c->next;
				}
			fputs("</children>",out);
			}
		}
	fputs("</node>",out);
	}

%}


%union  {
	char* s;
	char* d;
	struct tree_t* tree;
	}

%error-verbose

%token OPAR
%token CPAR
%token COMMA
%token COLON SEMICOLON 
%token<s> STRING
%token<d> NUMBER
%type<s> label optional_label
%type<d> number optional_length
%type<tree> subtree descendant_list_item descendant_list
%start input
%%

input: descendant_list optional_label optional_length SEMICOLON
	{
	Tree* tree=newTree();
	//tree->type=ROOT;
	tree->child=$1;
	tree->label=$2;
	tree->length=$3;
	printTree(stdout,tree);
	freeTree(tree);
	};

descendant_list: OPAR  descendant_list_item CPAR
	{
	$$=$2;
	};

descendant_list_item: subtree
		{
		$$=$1;
		}
	|descendant_list_item COMMA subtree
		{
		Tree* last=$1;
		$$=$1;
		while(last->next!=NULL)
			{
			last=last->next;
			}
		last->next=$3;
		}
	;

subtree : descendant_list optional_label optional_length
		{
		$$=newTree();
		$$->child=$1;
		$$->label=$2;
         	$$->length=$3;
		}
         | label optional_length
         	{
         	$$=newTree();
         	$$->label=$1;
         	$$->length=$2;
         	}
         ;
 
optional_label:  { $$=NULL;} | label  { $$=$1;};
optional_length:  { $$=NULL;} | COLON number { $$=$2;};
label: STRING { $$=$1;};
number: NUMBER { $$=$1;};



%%

int main(int argc,char** argv)
	{
	yyin=stdin;
        yyparse();
        return EXIT_SUCCESS;
	}

