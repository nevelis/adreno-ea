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

%token T_COMMA T_TAB T_LPAREN T_RPAREN T_COLON
%token T_MAPFLAG T_MONSTER T_BOSS_MONSTER T_FUNCTION T_SCRIPT T_DUPLICATE T_WARP T_SHOP
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

statement_block : '{' statements '}'
                ;

statements : T_EOL
           | statement T_EOL
           | statements statement T_EOL
           ;

statement : 'todo'
          ;

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

