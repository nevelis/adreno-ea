%error-verbose
%locations

%{
   #include <stdio.h>
   #include <stdlib.h>
   #include <iostream>
   using namespace std;

   int yylex();
   extern int yyparse();
   extern void yyerror( const char* s );
   extern FILE* yyin;
   extern int yylineno;
%}

%union {
   int ival;
   char* sval;
}

%token <ival> T_INT Q_GLOBAL_TEMP
%token <sval> T_STR T_IDENT

%token T_IF T_ELSE T_FOR
%token T_EOL T_EOF 0

%start eascript

%%

eascript : code_block
         ;

code_block : '{' code_fragment '}'
           ;

code_fragment : code
              | code_fragment code
              ;

code : statement ';'
     | label ':'
     | if_stmt
     | for_loop
     ;

statement : expression
          ;

label : T_IDENT
      ;

expression_list : expression
                | expression_list ',' expression
                ;

expression : constant_expression
           | function_call
           | operation
           | comparison
           | T_IDENT
           ;

comparison : expression '>' expression
           | expression '<' expression
           ;

operation : expression '+' expression
          ;

constant_expression : T_STR
                    | T_INT
                    ;

function_call : T_IDENT '(' ')'
              | T_IDENT '(' expression_list ')'
              | T_IDENT expression_list
              ;

if_stmt : T_IF '(' expression ')' code_block
        | if_stmt T_ELSE code_block
        ;

for_loop : T_FOR '(' statement ';' expression ';' statement ')' code_block
         ;

%%

void
usage( const char* cmd )
{
   printf( "Usage: %s <filename>\n", cmd );
   exit( -1 );
}

int
main( int argc, char* argv[] )
{
   if( argc != 2 ) {
      usage( argv[ 0 ] );
   }

   FILE* f = fopen( argv[ 1 ], "r" );
   if( !f ) {
      perror( "fopen" );
      exit( -1 );
   }

   yyin = f;
   do {
      yyparse();
   } while( !feof( yyin ) );

   return 0;
}

void yyerror( const char* s ) {
   printf( "autobot.bs:%d: %s\n", yylineno, s );
   exit( -1 );
}

