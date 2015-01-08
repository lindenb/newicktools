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

#include "newick2js.tab.h"

static size_t string_length=0;
void* saferealloc(void *ptr, size_t size)
        {
        void* p= (void*)realloc(ptr,sizeof(char)*(size));
        if(p==NULL)
                {
                fprintf(stderr,"out of memory");
                exit(EXIT_FAILURE);
                }
        return p;
        }
static char* copy(const char* s,size_t length)
        {
        char* p= (char*)saferealloc(NULL,sizeof(char)*(length+1));
        strncpy(p,s,length);
        p[length]=0;
        return p;
        }

static char* append(size_t* len,const char* s2,size_t len2)
        {
        yylval.s= (char*)saferealloc( yylval.s,sizeof(char)*(*len+len2+1));
        strncpy(&yylval.s[*len],s2,len2);
        yylval.s[*len+len2]=0;
        *len+=len2;
        return yylval.s;
        }

%}

%s apos
%s quot
%option noyywrap

%%
<quot>{
\\\"    append(&string_length,"\"",1);
\'      append(&string_length,"\'",1);
\"      {BEGIN(INITIAL);return STRING;}
}

<apos>{
\\\'    append(&string_length,"\'",1);
\"      append(&string_length,"\"",1);
\'      {BEGIN(INITIAL);return STRING;}
}

<apos,quot>{
\\n     append(&string_length,"\n",1);
\\t     append(&string_length,"\t",1);
\\\\    append(&string_length,"\\",1);
([^\"\'\\]|\n)+ append(&string_length,yytext,yyleng);
        }

\:      return COLON;
\;      return SEMICOLON;
\)      return CPAR;
\(      return OPAR;
\,      return COMMA;
\"      {string_length=0;BEGIN(quot); }
\'      {string_length=0;BEGIN(apos); }
[a-zA-Z_][a-zA-Z_0-9]* {yylval.s=copy(yytext,yyleng); return STRING;}
[\+|\-]?[0-9]+  {yylval.d=copy(yytext,yyleng); return NUMBER;}
[\+|\-]?[0-9]+\.[0-9]+([e|E][0-9]+)? {yylval.d=copy(yytext,yyleng); return NUMBER;}
[ \t\n\r]       ;
.       {fprintf(stderr,"Syntax error (%c)\n",yytext[0]);exit(EXIT_FAILURE);}
%%
