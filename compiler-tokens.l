%option noyywrap
%option yylineno

%{
   #include "botscript.h"
   #include "compiler-parser.tab.h"

	#define TOKEN( x ) return ( yylval.ival = ( x ) )
%}

D [0-9]
L [A-Za-z_]

%%

"monster"      { TOKEN( T_MONSTER ); }
"boss_monster" { TOKEN( T_BOSS_MONSTER ); }
","            { TOKEN( T_COMMA ); }
"\t"           { TOKEN( T_TAB ); }
" "            { TOKEN( T_SPACE ); }
{L}+({L}|{D})* { yylval.sval = strdup( yytext ); return T_IDENT; }
\/\/.*$           ; // Comment
\r?\n?         { TOKEN( T_EOL ); }
\"[^"]*\"      { yylval.sval = strdup( yytext ); return T_STR; }
-?{D}+         { yylval.ival = atoi( yytext ); return T_INT; }
.              ;

%%

