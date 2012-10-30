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

%token <ival> T_INT T_SPACE
%token <sval> T_STR T_IDENT

%token T_COMMA T_TAB T_LPAREN T_RPAREN T_LBRACE T_RBRACE T_SEMICOLON T_COLON T_EQU
%token T_IF T_ELSE
%token T_MAPFLAG T_MONSTER T_BOSS_MONSTER T_FUNCTION T_SCRIPT T_DUPLICATE T_WARP T_SHOP
%token T_AT T_DOLLAR T_DOT T_HASH T_SQUOTE
%token T_EOL T_EOF 0

%start eascript

%%

eascript : declarations T_EOF
         ;

declarations : declaration
             | declarations declaration
             ;

declaration : mapflag
            | monster
            | warp_point
            | shop
            | npc
            | function
            | T_EOL
            ;

mapflag : map_name T_TAB T_MAPFLAG T_TAB mapflag_arg
        ;

map_name : T_IDENT
         ;

npc_name : npc_name_components
         ;

npc_name_components : npc_name_component
                    | npc_name_components npc_name_component
                    ;

npc_name_component : T_IDENT
                   | T_INT
                   | T_SPACE
                   | T_HASH
                   | T_COLON T_COLON
                   ;

mapflag_arg : T_IDENT
            | mapflag_arg T_COMMA T_IDENT
            ;

map_location_facing : map_location T_COMMA T_INT
                    ;

map_location : map_name T_COMMA area
             ;

monster : map_location T_COMMA area T_TAB monster_type T_TAB npc_name T_TAB T_INT T_COMMA T_INT T_COMMA T_INT T_COMMA T_INT T_COMMA monster_properties
        | map_location T_COMMA area T_TAB monster_type T_TAB npc_name T_TAB T_INT T_COMMA T_INT T_COMMA T_INT T_COMMA T_INT T_COMMA T_INT
        ;

monster_type : T_MONSTER
             | T_BOSS_MONSTER
             ;

area : T_INT T_COMMA T_INT
     ;

duplicate : T_DUPLICATE T_LPAREN npc_name T_RPAREN
          ;

npc : map_location_facing T_TAB T_SCRIPT T_TAB npc_name T_TAB T_INT T_COMMA statement_block
    | map_location_facing T_TAB T_SCRIPT T_TAB npc_name T_TAB T_INT T_COMMA area T_COMMA statement_block
    | map_location_facing T_TAB duplicate T_TAB npc_name T_TAB T_INT
    ;

shop : map_location_facing T_TAB T_SHOP T_SHOP T_TAB npc_name T_TAB T_INT T_COMMA shop_list
     ;

shop_list : T_INT T_COLON T_INT
          | shop_list T_COMMA T_INT T_COLON T_INT
          ;

warp_point : map_location_facing T_WARP T_TAB npc_name T_TAB area T_COMMA map_location

monster_properties : T_STR
                   ;

function : T_FUNCTION T_TAB T_SCRIPT T_TAB function_name T_TAB statement_block
         ;

function_name : T_IDENT
              ;

statement_block : T_LBRACE statements T_RBRACE
                ;

statements : T_EOL
           | statement T_EOL
           | statements statement T_EOL
           ;

statement : label
          | builtin_func
          | if_stmt
          | expression_statement
          ;

if_stmt : T_IF T_LPAREN expression T_RPAREN block
        | T_IF T_LPAREN expression T_RPAREN block T_ELSE block
        ;

expression_statement : expression T_SEMICOLON
                     ;


block : statement
      | statement_block
      ;

builtin_func : T_IDENT function_args T_COLON
             ;

function_args : expression
              | function_args expression
              ;

label : T_IDENT T_COLON
      ;

expression : constant_expression
           | comparison
           | variable
           ;

constant_expression : T_INT
                    | T_STR
                    ;

comparison : expression T_EQU expression
           ;

variable : var_player
         | var_player_tmp
         | var_global
         | var_global_tmp
         | var_npc
         | var_scope
         | var_account
         | var_account_global
         ;

var_player     : T_IDENT ;
var_player_tmp : T_AT T_IDENT;
var_global     : T_DOLLAR T_IDENT;
var_global_tmp : T_DOLLAR T_AT T_IDENT;
var_npc        : T_DOT T_IDENT;
var_scope      : T_DOT T_AT T_IDENT;
var_account    : T_HASH T_IDENT;
var_account_global : T_HASH T_HASH T_IDENT;


%%

void
usage( const char* cmd )
{
   printf( "Usage: %s <filename>\n", cmd );
   exit( -1 );
}

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
}

void yyerror( const char* s ) {
   printf( "autobot.bs:%d: %s\n", yylineno, s );
   exit( -1 );
}

