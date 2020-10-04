
%{
#include <stdio.h>
#include <stdlib.h>

#include<"1505053.h">
#include<"y.tab.c">
#define YYSTYPE double      /* yyparse() stack type */

void yyerror(char *s){
	printf("%s\n",s);
}

int yylex(void);

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

 		
compound_statement : LCURL statements RCURL {fprintf(log,"compound_statement :LCURL statements RCURL\n\n");
						fprintf(parser,"compound_statement :LCURL statements RCURL\n\n");}

 		    | LCURL RCURL  {fprintf(log,"compound_statement : LCURL RCURL\n\n");
					fprintf(parser,"compound_statement : LCURL RCURL\n\n");}
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
	  | expression_statement  {fprintf(log,"statement : expression_statement\n\n");}
	  | compound_statement   {fprintf(log,"statement : compound_statement\n\n");}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement {fprintf(log,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n\n");}
	  | IF LPAREN expression RPAREN statement  {fprintf(log,"statement :IF LPAREN expression RPAREN statement\n\n");}
	  | IF LPAREN expression RPAREN statement ELSE statement  {fprintf(log,"statement :IF LPAREN expression RPAREN statement ELSE statement\n\n");}
	  | WHILE LPAREN expression RPAREN statement  {fprintf(log,"statement : WHILE LPAREN expression RPAREN statement\n\n");}
	  | PRINTLN LPAREN ID RPAREN SEMICOLON   {fprintf(log,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON \n\n");}
	  | RETURN expression SEMICOLON  {fprintf(log,"statement : RETURN expression SEMICOLON\n\n");}
	  ;
	  
expression_statement 	: SEMICOLON	{fprintf(log,"expression_statement : SEMICOLON\n\n");}		
			| expression SEMICOLON {fprintf(log,"expression_statement :expression SEMICOLON\n\n");}
			;
	  
variable : ID 		
	 | ID LTHIRD expression RTHIRD 
	 ;
	 
 expression : logic_expression	{fprintf(log,"expression : logic expression\n\n");}
	   | variable ASSIGNOP logic_expression 	
	   ;
			
logic_expression :  rel_expression {fprintf(log,"logic_expression : rel_expression\n\n");$$ = $1;
		$$ = $$;}	
		 | rel_expression LOGICOP rel_expression {fprintf(log,"logic_expression :rel_expression LOGICOP rel_expression \n\n 				");if(strcmp("&&",$2) == 0)$$ = $1 && $3;
			else if(strcmp("||",$2) == 0)$$ = $1 || $3;
}		
		 ;
			
rel_expression	: simple_expression  {fprintf(log,"rel_expression : simple_expression\n\n ");$$ = $1;}
		| simple_expression RELOP simple_expression {fprintf(log,"rel_expression : simple_expression RELOP simple_expression\n\n");
		if(strcmp("<",$2) == 0)$$ = $1 < $3;
		else if(strcmp("<=",$2) == 0)$$ = $1 <= $3;
		else if(strcmp(">",$2) == 0)$$ = $1 > $3;
		else if(strcmp(">=",$2) == 0)$$ = $1 >= $3;
		else if(strcmp("!=",$2) == 0)$$ = $1 != $3;
		else if(strcmp("==",$2) == 0)$$ = $1 == $3;
}		
		;
				
simple_expression : term           {fprintf(log,"simple_expression : term\n\n");$$ = $1;}
		  | simple_expression ADDOP term {fprintf(log,"simple_expression : simple_expression ADDOP term\n\n");    				if(strcmp("+",$2) == 0)$$ = $1 + $3;
			else if(strcmp("-",$2) == 0)$$ = $1 - $3;		
} 
		  ;
					
term :	unary_expression     {fprintf(log,"term : unary_expression\n\n");$$ = $1;}
     |  term MULOP unary_expression  {fprintf(log,"term : term MULOP unary_expression\n\n");
	if(strcmp("*",$2) == 0)$$ = $1 * $3;
	else if(strcmp("/",$2) == 0)$$ = $1 / $3;
	//  confused
	//    else if(strcmp("%",$2) == 0){mf1 = $1;mf2 = $3;$$ = (int)$1 % (int)$3;}
}
     ;
       
unary_expression : ADDOP unary_expression  {fprintf(log,"unary_expression : ADDOP unary_expression\n\n");
		if(strcmp("+",$1) == 0)$$ += $2;
			else if(strcmp("-",$1) == 0)$$ -= $2;
}
		 | NOT unary_expression  {fprintf(log,"unary_expression : NOT unary_expression\n\n");$$ = !$2;}
		 | factor  {fprintf(log,"unary_expression : factor\n\n");$$ = $1;}
		 ;
	
factor	: variable {fprintf(log,"factor : variable\n\n");$$ = $1;}
	| ID LPAREN argument_list RPAREN
	| LPAREN expression RPAREN {fprintf(log,"factor :LPAREN expression RPAREN \n\n ");$$ = $2;}
	| CONST_INT  {fprintf(log,"factor : CONST_INT\n\n");fprintf(log,"%d\n\n",$1);$$ = $1;}
	| CONST_FLOAT {fprintf(log,"factor : CONST_FLOAT\n\n");fprintf(log,"%f\n\n",$1);$$ = $1;}
	| variable INCOP {fprintf(log,"factor : variable INCOP\n\n");$$ = $1++;}
	| variable DECOP  {fprintf(log,"factor : variable DECOP\n\n");$$ = $1--;}
	;
	
argument_list : arguments   {fprintf(log,"argument_list :arguments\n\n");}

			  |{        }

			  ;
	
arguments : arguments COMMA logic_expression  {fprintf(log,"arguments : arguments COMMA logic_expression\n\n");}
	      | logic_expression   {fprintf(log,"arguments :logic_expression\n\n");}
	      ;
 

%%

main()
{
    yyparse();
    exit(0);
}
