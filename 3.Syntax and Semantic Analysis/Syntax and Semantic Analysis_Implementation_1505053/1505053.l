%option noyywrap
%x MYSTATE
%x MYSTRING
%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include<string>
#include<fstream>
#include<string.h>

#define NULL_VALUE -999999
#define INFINITY1 999999

using namespace std;

int line_count=1;
int error_count = 0;

FILE *log;
FILE *token;


Sybol info class

it is the type of object
that we store in table




*/

class SymbolInfo{

  public:
  string Name, Type;
  SymbolInfo *Next;
  SymbolInfo(string a, string b)
  {
      Name=a;
      Type=b;
      Next=NULL;
  }


};

/*

this is the table
that store the object



*/
class scopetable{

    public:
    SymbolInfo **Arr;
    scopetable *parentScope;
    int id,no_of_bucket;
    scopetable(int a, scopetable *parent,int bucket)
    {
        id=a;
        parentScope=parent;
        no_of_bucket=bucket;
        Arr=new SymbolInfo*[bucket];
        for(int i=0;i<bucket;i++)
        {
            Arr[i]=NULL;
        }
    }
    int insert(string a, string b,int pos)
    {
        SymbolInfo *Temp=Arr[pos];
        SymbolInfo *T=new SymbolInfo(a,b);
        //printf("1");
        while(Temp!=NULL)
        {
            if(Temp->Name==a)return -1;
            Temp=Temp->Next;
        }
        //printf("1");
        if(Arr[pos]==NULL)
        {
            Arr[pos]=T;
            return 0;
        }
        Temp=Arr[pos];
        int cnt=0;
        while(Temp->Next!=NULL)
        {
            cnt++;
            Temp=Temp->Next;
        }
        Temp->Next=T;
        return cnt;
    }
    int look_up(string a, int pos)
    {
        SymbolInfo *Temp=Arr[pos];
        while(Temp!=NULL)
        {
            if(Temp->Name==a)return 1;
            Temp=Temp->Next;
        }
        //printf("1");
        //if(temp->name==a)return 1;
        return -1;

    }
    int Delete(string a, int pos)
    {
        SymbolInfo *p=Arr[pos];
        if(p==NULL)return -1;
        if(Arr[pos]->Name==a)
        {
            p=Arr[pos]->Next;
            delete Arr[pos];
            Arr[pos]=p;
            return 0;
        }
        SymbolInfo *q=p->Next;
        int cnt=0;
        while(p->Next!=NULL)
        {
            cnt++;
            if(q->Name==a)
            {
                p->Next=q->Next;
                delete q;
                return cnt;
            }
            q=q->Next;
            p=p->Next;
        }
        return -1;
    }
    void PRINT_SCOPE()
    {
            SymbolInfo *p;
        cout<<"ScopeTable # "<<id<<endl;
        for(int i=0;i<no_of_bucket;i++){
            cout<<i<<" -->  ";
            p=Arr[i];
            while(p!=NULL){
                cout<<"< "<<p->Name<<" : "<<p->Type<<" >   ";
                p=p->Next;
            }
            cout<<endl;
        }
    }

};

class symboltable{

public:
    scopetable *Current;
    int Count_ScopeTable,bucket;

    symboltable(int n){
        Current=NULL;
        Count_ScopeTable=0;
        bucket=n;
        Count_ScopeTable++;
        scopetable *p=new scopetable(Count_ScopeTable,Current,bucket);
        p->parentScope=Current;
        Current=p;
    }



    int Hash_Point(string x){
        int Sum=0;
        for(int i=0;i<x.length();i++){
            Sum+=((int)x[i]%bucket);
            Sum=Sum%bucket;
        }
        return Sum;
    }

    void ENTER_SCOPE(){
        Count_ScopeTable++;
        scopetable *p=new scopetable(Count_ScopeTable,Current,bucket);
        p->parentScope=Current;
        Current=p;
        p=NULL;
    }
    void INSERT(string x,string y){
        int pos=Hash_Point(x);
       // printf("  1  ");
        int ans=Current->insert(x,y,pos);


        if(ans==-1){
            cout<<"Can't insert as a variable type with this name is decleared before."<<endl;
        }
        else cout<<"Inserted in ScopeTable# "<<Current->id<<" at position "<<pos<<","<<ans<<endl;
    }
    void EXIT_SCOPE(){
        scopetable *p;
        p=Current->parentScope;
        delete Current;
        Current=p;
    }
    void REMOVE(string x)
    {
        int pos=Hash_Point(x);
        int ans=Current->Delete(x,pos);
        if(ans==-1)cout<<"Not found"<<endl;
        else {
            cout<<"Found in ScopeTable# "<<Current->id<<" at position "<<pos<<","<<ans<<endl;
            cout<<"Deleted entry at "<<pos<<","<<ans<<"from current ScopeTable"<<endl;
        }

    }
    void LOOK_UP(string x)
    {
        int pos=Hash_Point(x);

        int ans=Current->look_up(x,pos);
        //printf(" ans=%d ",ans);
        if(ans==-1)cout<<"Not found"<<endl;
        else {
            cout<<"Inserted in ScopeTable# "<<endl;
        }
    }
    void PRINT_CURRENTSCOPE(){
        Current->PRINT_SCOPE();
    }
    void PRINT_ALLSCOPE()
    {
        scopetable *node=Current;
        while(node!=NULL){
            node->PRINT_SCOPE();
            node=node->parentScope;
        }

    }
};





int n = 31;
SymbolTable g;
int ind = 0;
string temp;

void cmain(string s)
{

    int random = n;
    SymbolInfo v;
    if(ind == 0){
	g.setnRow(n);
	ind = 1;
	}
    v.name = yytext;
    v.type = s;
    int u = g.hashFunction(v,random);
    int j = g.look_up(v.name,u);
    if (j != -1 ) {
        string t = "<" + v.name + "," + v.type + "> " + " Already exists!\n";
        char a[250];
        strcpy(a,t.c_str());
	a[sizeof(a) - 1] = 0;
	fprintf(log,"%s",a);
    }
    else{
        g.Insert(u, v);
       // cout << "<" << v.name << "," << v.type << "> " << " Inserted at " << u << "," << g.getDegree(u) - 1;
    }
    g.printSymbolTable();
}

%}

WHITESPACE [ \t\f\r\v]+
NEWLINE \n
DIGIT [0-9]
LETTER [a-zA-Z]
CHARACTER '[A-Za-z0-9]'
DIGITS       {DIGIT}+
FLOAT_NUMBER {DIGITS}?(.{DIGITS})?(E[+-]?{DIGITS})?
SINGLE_LINE_COMMENT "//"[^\n]*
ILL_FORMATED_CHAR '[A-Za-z0-9][A-Za-z0-9]+'
IDENTIFIER ([A-Za-z_]([A-Za-z0-9_]*)?)
SPEC_CHAR '\\[tvar"afb0n]'|'\\'
INVALID_ID {DIGITS}{IDENTIFIER}
UNDETERMINED_CHAR '[A-Za-z0-9]*'
UNTER_CHAR	 '({CHARACTER})
UNFINISHED_STRING \"([^\"\n]|(\\{NEWLINE}))*
DECIMAL_POINT_ERROR [0-9]*[.][0-9]*([.]+[0-9]*)*
ILL_FORMATED_NUMBER  [0-9]*((E[+-]?[0-9]+)([.][0-9]+)*)(E[+-]?[0-9]+)?([.][0-9]+)*
UNFINISHED_STRING1 \"[^\\\"]*[^\\]^\"{WHITESPACE}






ONLINE_FLOAT  0x{DIGITS}+[.]+{DIGITS}+[p]+{DIGITS}






B2 "\*"
%%



{NEWLINE} {	line_count++;

		}
{WHITESPACE} {}

"if"	{
			fprintf(token,"<IF>");
			fprintf(log,"Line no %d: TOKEN <IF> Lexeme %s found\n\n",line_count,yytext);
		}

"else"	{
			fprintf(token,"<ELSE>");
			fprintf(log,"Line no %d: TOKEN <ELSE> Lexeme %s found\n\n",line_count,yytext);
		}


"for"	{
			fprintf(token,"<FOR>");
			fprintf(log,"Line no %d: TOKEN <FOR> Lexeme %s found\n\n",line_count,yytext);
	}
"while"	{
			fprintf(token,"<WHILE>");
			fprintf(log,"Line no %d: TOKEN <WHILE> Lexeme %s found\n\n",line_count,yytext);
	}

"do"	{
			fprintf(token,"<DO>");
			fprintf(log,"Line no %d: TOKEN <DO> Lexeme %s found\n\n",line_count,yytext);
		}
"int"	{
			fprintf(token,"<INT>");
			fprintf(log,"Line no %d: TOKEN <INT> Lexeme %s found\n\n",line_count,yytext);
	}
"float"	{
			fprintf(token,"<FLOAT>");
			fprintf(log,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n\n",line_count,yytext);

		}
"void"		{
			fprintf(token,"<VOID>");
			fprintf(log,"Line no %d: TOKEN <VOID> Lexeme %s found\n\n",line_count,yytext);
		}
"switch"	{
			fprintf(token,"<SWITCH>");
			fprintf(log,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n\n",line_count,yytext);
		}
"case"	{
			fprintf(token,"<CASE>");
			fprintf(log,"Line no %d: TOKEN <CASE> Lexeme %s found\n\n",line_count,yytext);
		}

"default"	{
			fprintf(token,"<DEFAULT>");
			fprintf(log,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n\n",line_count,yytext);
		}
"break"	{
			fprintf(token,"<BREAK>");
			fprintf(log,"Line no %d: TOKEN <BREAK> Lexeme %s found\n\n",line_count,yytext);
		}

"continue"	{
			fprintf(token,"<CONTINUE>");
			fprintf(log,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n\n",line_count,yytext);
		}

"double"	{
			fprintf(token,"<DOUBLE>");
			fprintf(log,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n\n",line_count,yytext);
		}

"char"	{
			fprintf(token,"<CHAR>");
			fprintf(log,"Line no %d: TOKEN <CHAR> Lexeme %s found\n\n",line_count,yytext);
		}
"return"	{
			fprintf(token,"<RETURN>");
			fprintf(log,"Line no %d: TOKEN <RETURN> Lexeme %s found\n\n",line_count,yytext);
		}



{DIGIT}+ 	{
				fprintf(token,"<CONST_INT,%s>",yytext);
				fprintf(log,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n\n",line_count,yytext);
				cmain("CONST_INT");
		}

{FLOAT_NUMBER}	{
				fprintf(token,"<CONST_FLOAT,%s>",yytext);
				fprintf(log,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n\n",line_count,yytext);
				cmain("CONST_FLOAT");
		}

{ONLINE_FLOAT}  {
                               fprintf(token,"<ONLINE_FLOAT,%s>",yytext);
				fprintf(log,"Line no %d: TOKEN <ONLINE_FLOAT> Lexeme %s found\n\n",line_count,yytext);
				cmain("CONST_FLOAT");
			
				
 

		}





{CHARACTER}	{
				fprintf(token,"<CONST_CHAR,%s>",yytext);
				fprintf(log,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n\n",line_count,yytext);
				cmain("CONST_CHAR");
		}
{SPEC_CHAR}     {		fprintf(token,"<ID,%s>",yytext);
				fprintf(log,"Line no %d:  Unterminated character %s found\n\n",line_count,yytext);
		}

{UNTER_CHAR}    {
				fprintf(log,"ERROR AT Line no %d: Unterminated character %s \n\n",line_count,yytext);
		}




{IDENTIFIER}	{
				fprintf(token,"<ID,%s>",yytext);
				fprintf(log,"Line no %d: TOKEN <ID> Lexeme %s found\n\n",line_count,yytext);
				cmain("ID");
		}

{INVALID_ID}	{
                   		fprintf(log,"Error at line no %d:Invalid prefix on ID or invalid suffix on Number%s\n\n",line_count,yytext);
			error_count++;
		


		}


[*/%]		{
			fprintf(token,"<MULOP,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <MULOP> Lexeme %s found\n\n",line_count,yytext);
			cmain("MULOP");
		}


[+-]		{
			fprintf(token,"<ADDOP,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n\n",line_count,yytext);
			cmain("ADDOP");
		}


"++"|"--"    {
			fprintf(token,"<INCOP,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <INCOP> Lexeme %s found\n\n",line_count,yytext);
			cmain("INCOP");
	    }

"="		{
			fprintf(token,"<ASSIGNOP,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n\n",line_count,yytext);
			cmain("ASSIGNOP");
			}

">"|">="|"<"|"<="|"=="|"!="		{
			fprintf(token,"<RELOP,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <RELOP> Lexeme %s found\n\n",line_count,yytext);
			cmain("RELOP");
			}

"&&"|"||"|"!"		{
			fprintf(token,"<LOGICOP,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n\n",line_count,yytext);
			cmain("LOGICOP");
			}
"("		{
			fprintf(token,"<LPAREN,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n\n",line_count,yytext);
			cmain("LPAREN");
			}
")"		{
			fprintf(token,"<RPAREN,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n\n",line_count,yytext);
			cmain("RPAREN");
			}
"{"		{
			fprintf(token,"<LCURL,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <LCURL> Lexeme %s found\n\n",line_count,yytext);
			cmain("LCURL");
			}
"}"		{
			fprintf(token,"<RCURL,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <RCURL> Lexeme %s found\n\n",line_count,yytext);
			cmain("RCURL");
			}
"["		{
			fprintf(token,"<LBRACKET,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <LBRACKET> Lexeme %s found\n\n",line_count,yytext);
			cmain("LBRACKET");
			}
"]"		{
			fprintf(token,"<RBRACKET,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <RBRACKET> Lexeme %s found\n\n",line_count,yytext);
			cmain("RBRACKET");
			}
";"		{
			fprintf(token,"<SEMICOLON,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n\n",line_count,yytext);
			cmain("SEMICOLON");
			}
","		{
			fprintf(token,"<COMMA,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <COMMA> Lexeme %s found\n\n",line_count,yytext);
			cmain("COMMA");
			}

<MYSTRING>{NEWLINE}     {
			line_count++;
			//fprintf(log,"%s",yytext);
			}
\"      {
			BEGIN (MYSTRING);
			fprintf(token,"<STRING>,%s",yytext);
			fprintf(log,"Line no %d: TOKEN <STRING> Lexeme %s ",line_count,yytext);

		}


<MYSTRING>\"    {
			fprintf(token,"\">");
			fprintf(log,"%s found\n\n",yytext);
			BEGIN INITIAL;
			//line_count++;
		}


<MYSTRING>([\.])*     {
			fprintf(log,"%s",yytext);
		      }




{SINGLE_LINE_COMMENT} {
			//fprintf(token,"<COMMENT,%s>",yytext);
			fprintf(log,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n\n",line_count,yytext);
                     }


{DECIMAL_POINT_ERROR} {
			fprintf(log,"Error at line no %d: Too many decimal point %s\n\n",line_count,yytext);
			error_count++;
		      }

{ILL_FORMATED_NUMBER} {
			fprintf(log,"Error at line no %d: Ill formatted number %s\n\n",line_count,yytext);
			error_count++;
			}


{ILL_FORMATED_CHAR} {
			fprintf(log,"Error at line no %d: Multi character constant error  %s\n\n",line_count,yytext);
			error_count++;
			}
{UNDETERMINED_CHAR} {
			fprintf(log,"Error at line no %d: Undetermined character %s\n\n",line_count,yytext);
			error_count++;
			}
{UNFINISHED_STRING} {
			fprintf(log,"Error at line no %d: Unfinished string %s\n\n",line_count,yytext);
			error_count++;
			}

<MYSTATE>{NEWLINE}     {
			line_count++;
			fprintf(log,"%s",yytext);
			}
"/*"      	{
			BEGIN (MYSTATE);
			//fprintf(log,"Error at line no %d: Unterminated comment %s",line_count,yytext);
			fprintf(log,"Line no %d: TOKEN <COMMENT> Lexeme %s",line_count,yytext);


		}

<MYSTATE>"*/"    {
			fprintf(log,"%s found\n\n",yytext);
			BEGIN INITIAL;
			//line_count++;
			}
<MYSTATE>[^\n]  {
			fprintf(log,"%s",yytext);
			if(yytext[0] == '\n')line_count++;
			}

<MYSTATE><<EOF>> 	{
			fprintf(log,"Total Line Number: %d\n\n",line_count);
			fprintf(log,"Total Errors: %d\n",error_count);
			g.~SymbolTable();
			return 0;
			}
<<EOF>> 	{
			fprintf(log,"Total Line Number: %d\n\n",line_count);
			fprintf(log,"Total Errors: %d\n",error_count);
			g.~SymbolTable();
			return 0;
			}

%%

int main(int argc,char *argv[]){

	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}

	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}

	log= fopen("1505053_log.txt","w");
	token= fopen("1505053_token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(token);
	fclose(log);
	return 0;
}
