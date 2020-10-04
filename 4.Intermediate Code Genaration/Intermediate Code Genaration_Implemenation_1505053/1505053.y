
%{
#include <stdio.h>
#include <stdlib.h>

#include<"1505053.h">
#include<"y.tab.c">
#define YYSTYPE double      /* yyparse() stack type */





using namespace std;

extern int yylex();
void yyerror(const char *s);
extern FILE *yyin;
extern int line_count;
extern int error;


int labelCount=0;
int tempCount=0;


char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(lb,b);
	return lb;
}

char *newTemp()
{
	char *t= new char[4];
	strcpy(t,"t");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(t,b);
	return t;
}




%}

%token NEWLINE NUMBER PLUS MINUS SLASH ASTERISK LPAREN RPAREN






%type <f>  arguments
%type <f> argument_list







%type <f> factor
%type <f> unary_expression
%type <f> term
%type <f> simple_expression
%type <f> rel_expression
%type <f> logic_expression
%type <f> expression
%type <f> variable
%type <f> expression_statement
%type <f> statement
%type <f> statements
%type <f> declaration_list
%type <f> type_specifier
%type <f> var_declaration
%type <f> compound_statement
%type <f>  parameter_list 
%type <f>  func_definition
%type <f> func_declaration  
%type <f> unit
%type <f> Program







%type <f>  start



%%
start : program;

program : 	program unit {fprintf(log,"program : program unit\n\n");
		fprintf(parser,"program : program unit\n\n");}


		| unit {fprintf(log,"program :unit\n\n");
			fprintf(parser,"program :unit\n\n");}
		;
	
unit :		 var_declaration {fprintf(log,"unit : var_declaration\n\n");
				fprintf(parser,"unit : var_declaration\n\n");}

     		| func_declaration  {fprintf(log,"unit : func_declaration\n\n");
			        	fprintf(parser,"unit : func_declaration\n\n");}


     		| func_definition  {fprintf(log,"unit : func_defination\n\n");
					fprintf(parser,"unit : func_defination\n\n");}
     		;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON {fprintf(log,"func_declaration : type_specifier ID LPAREN 			parameter_list RPAREN SEMICOLON \n\n");
                fprintf(parser,"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON \n\n");}
		
		| type_specifier ID LPAREN RPAREN SEMICOLON  {fprintf(log,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON 		\n\n");
		fprintf(parser,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON 		\n\n");}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement {fprintf(log,"func_definition : func_defination\n\n");
		fprintf(parser,"func_definition : func_defination\n\n");}

		| type_specifier ID LPAREN RPAREN compound_statement {fprintf(log,"func_definition : func_defination\n\n");
		fprintf(parser,"func_definition : func_defination\n\n");}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID {fprintf(log,"parameter_list : parameter_list COMMA type_specifier ID \n\n");
							fprintf(parser,"parameter_list : parameter_list COMMA type_specifier ID \n\n");}
		

		| parameter_list COMMA type_specifier {fprintf(log,"parameter_list : parameter_list COMMA type_specifier\n\n");
							fprintf(parser,"parameter_list : parameter_list COMMA type_specifier\n\n");}


 		| type_specifier ID {fprintf(log,"parameter_list : type_specifier ID\n\n");
					fprintf(parser,"parameter_list : type_specifier ID\n\n");}


		| type_specifier{fprintf(log,"parameter_list : type_specifier\n\n");
				fprintf(parser,"parameter_list : type_specifier\n\n");}

 		;

 		
compound_statement : LCURL statements RCURL     {	
							$$=$2;
						}

 		    | LCURL RCURL  {
							$$=new SymbolInfo("compound_statement","dummy");
						}
					;
 		    
var_declaration : type_specifier declaration_list SEMICOLON {fprintf(log,"var_declaration :type_specifier declaration_list SEMICOLON\n\n");
							fprintf(parser,"var_declaration :type_specifier declaration_list SEMICOLON\n\n");}
 		 ;
 		 
type_specifier	: INT  {fprintf(log,"type_specifier : INT\n\n");i_f = 0;}
 		| FLOAT {fprintf(log,"type_specifier : FLOAT\n\n");i_f = 1;
			}
 		| VOID
 		;
 		
declaration_list : declaration_list COMMA ID
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  | ID
 		  | ID LTHIRD CONST_INT RTHIRD
 		  ;
 		  

statements : statement   {fprintf(log,"statements : statement\n\n");}
	   | statements statement   {fprintf(log,"statements : statements statement\n\n");}
	   ;
	   
statement : var_declaration
	  | expression_statement  {
					$$=$1;
				}
	  | compound_statement  {
					$$=$1;
				}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement {fprintf(log,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n");}
	  | IF LPAREN expression RPAREN statement  {fprintf(log,"statement :IF LPAREN expression RPAREN statement\n\n");}
	  | IF LPAREN expression RPAREN statement ELSE statement  {fprintf(log,"statement :IF LPAREN expression RPAREN statement ELSE statement\n\n");}
	  | WHILE LPAREN expression RPAREN statement  {fprintf(log,"statement : WHILE LPAREN expression RPAREN statement\n\n");}
	  | PRINTLN LPAREN ID RPAREN SEMICOLON   {fprintf(log,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON \n\n");}
	  | RETURN expression SEMICOLON  {fprintf(log,"statement : RETURN expression SEMICOLON\n\n");}
	  ;
	  
expression_statement 	: SEMICOLON	{
							$$=new SymbolInfo(";","SEMICOLON");
							$$->code="";
					}			
								| expression SEMICOLON  {
							$$=$1;
					}		
					;
			
	  
variable : ID 		{
				
				$$= new SymbolInfo($1);
				$$->code="";
				$$->setType("notarray");
		}	
	 | ID LTHIRD expression RTHIRD  {
				
				$$= new SymbolInfo($1);
				$$->setType("array");
				

				$$->code=$3->code+"mov bx, " +$3->getSymbol() +"\nadd bx, bx\n";
				
				delete $3;
		}	
		;
	 
	 
 expression : logic_expression	{fprintf(log,"expression : logic expression\n\n");}
	   | variable ASSIGNOP logic_expression 	
	   ;
			
logic_expression :  rel_expression {
					$$= $1;		
				}
		 | rel_expression LOGICOP rel_expression{
					$$=$1;
					$$->code+=$3->code;
					
					if($2->getSymbol()=="&&"){
						/* 
						Check whether both operands value is 1. If both are one set value of a            							temporary       variable          to 1
						otherwise 0
						*/
					}
					else if($2->getSymbol()=="||"){
						
					}
					delete $3;
				}	
			;
			
rel_expression	: simple_expression  {
				$$= $1;
			}			
				| simple_expression RELOP simple_expression {
				$$=$1;
				$$->code+=$3->code;
				$$->code+="mov ax, " + $1->getSymbol()+"\n";
				$$->code+="cmp ax, " + $3->getSymbol()+"\n";
				char *temp=newTemp();
				char *label1=newLabel();
				char *label2=newLabel();
				if($2->getSymbol()=="<"){
					$$->code+="jl " + string(label1)+"\n";
				}
				else if($2->getSymbol()=="<="){
				}
				else if($2->getSymbol()==">"){
				}
				else if($2->getSymbol()==">="){
				}
				else if($2->getSymbol()=="=="){
				}
				else{
				}
				
				$$->code+="mov "+string(temp) +", 0\n";
				$$->code+="jmp "+string(label2) +"\n";
				$$->code+=string(label1)+":\nmov "+string(temp)+", 1\n";
				$$->code+=string(label2)+":\n";
				$$->setSymbol(temp);
				delete $3;
			}	
		;
		if(strcmp("<",$2) == 0)$$ = $1 < $3;
		else if(strcmp("<=",$2) == 0)$$ = $1 <= $3;
		else if(strcmp(">",$2) == 0)$$ = $1 > $3;
		else if(strcmp(">=",$2) == 0)$$ = $1 >= $3;
		else if(strcmp("!=",$2) == 0)$$ = $1 != $3;
		else if(strcmp("==",$2) == 0)$$ = $1 == $3;
}		
		;
				
simple_expression : term          {
				$$= $1;
			}
		  | simple_expression ADDOP term {
				$$=$1;
				$$->code+=$3->code;
				
				// move one of the operands to a register, perform addition or subtraction with the other operand and move 					the result in a temporary variable  

				if($2->getSymbol()=="+"){
				
				}
				else{
				
				}
				delete $3;
				cout << endl;
			}
				;
					
term :	unary_expression	 {
						$$= $1;
						}
     |  term MULOP unary_expression  {
						$$=$1;
						$$->code += $3->code;
						$$->code += "mov ax, "+ $1->getSymbol()+"\n";
						$$->code += "mov bx, "+ $3->getSymbol() +"\n";
						char *temp=newTemp();
						if($2->getSymbol()=="*"){
							$$->code += "mul bx\n";
							$$->code += "mov "+ string(temp) + ", ax\n";
						}
						else if($2->getSymbol()=="/"){
							// clear dx, perform 'div bx' and mov ax to temp
						}
						else{
							// clear dx, perform 'div bx' and mov dx to temp
						}
						$$->setSymbol(temp);
						cout << endl << $$->code << endl;
						delete $3;
						}
	 ;

unary_expression : ADDOP unary_expression {
							$$=$2;
							// Perform NEG operation if the symbol of ADDOP is '-'
						}
		 | NOT unary_expression {
							$$=$2;
							char *temp=newTemp();
							$$->code="mov ax, " + $2->getSymbol() + "\n";
							$$->code+="not ax\n";
							$$->code+="mov "+string(temp)+", ax";
						}
		 | factor  {
							$$=$1;
						}
					;
	
factor	: variable {
			$$= $1;
			
			if($$->getType()=="notarray"){
				
			}
			
			else{
				char *temp= newTemp();
				$$->code+="mov ax, " + $1->getSymbol() + "[bx]\n";
				$$->code+= "mov " + string(temp) + ", ax\n";
				$$->setSymbol(temp);
			}
			}
		| ID LPAREN argument_list RPAREN
	| LPAREN expression RPAREN {
			$$= $2;
			}
	| CONST_INT  {
			$$= $1;
			}
		| CONST_FLOAT {
			$$= $1;
			}
	| variable INCOP  {
			$$=$1;
			// perform incop depending on whether the varaible is an array or not
			}
	
        | variable DECOP  {
			$$= $1;
			};
	
argument_list : arguments   {fprintf(log,"argument_list :arguments\n\n");}

			  |{        }

			  ;
	
arguments : arguments COMMA logic_expression  {fprintf(log,"arguments : arguments COMMA logic_expression\n\n");}
	      | logic_expression   {fprintf(log,"arguments :logic_expression\n\n");}
	      ;
 

%%
/*
main()
{
    yyparse();
    exit(0);
}

*/
void yyerror(const char *s){
	cout << "Error at line no " << line_count << " : " << s << endl;
}

int main(int argc, char * argv[]){
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	

	yyin= fin;
	yyparse();
	cout << endl;
	cout << endl << "\t\tsymbol table: " << endl;
	//table->dump();
	
	printf("\nTotal Lines: %d\n",line_count);
	printf("\nTotal Errors: %d\n",error);
	
	printf("\n");
	return 0;
}
