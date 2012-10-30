%option noyywrap
%option yylineno

%{
   #include "botscript.h"
   #include "compiler-parser.tab.hpp"

	#define TOKEN( x ) return ( yylval.ival = ( x ) )
%}

D [0-9]
L [A-Za-z_]

%%

","               { TOKEN( T_COMMA ); }
" "               { TOKEN( T_SPACE ); }
"\t"              { TOKEN( T_TAB ); }

"monster"         { TOKEN( T_MONSTER ); }
"boss_monster"    { TOKEN( T_BOSS_MONSTER ); }
"script"          { TOKEN( T_SCRIPT ); }

\r?\n?            { TOKEN( T_EOL ); }
{L}+({L}|{D})*    { yylval.sval = strdup( yytext ); return T_IDENT; }
\"[^"]*\"         { yylval.sval = strdup( yytext ); return T_STR; }
-?{D}+            { yylval.ival = atoi( yytext ); return T_INT; }
.                 ;
\/\/.*$           ; // Comment

%%

