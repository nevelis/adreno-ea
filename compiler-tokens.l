%option noyywrap
%option yylineno

%{
   #include "botscript.h"
   #include "compiler-parser.tab.h"
%}

D [0-9]
L [A-Za-z_]

%%

{L}+({L}|{D})* { yylval.sval = strdup( yytext ); return T_IDENT; }
\/\/.*$           ; // Comment
\r?\n?         { return ( yylval.ival = T_EOL ); }
\"[^"]*\"      { yylval.sval = strdup( yytext ); return T_STR; }
-?{D}+         { yylval.ival = atoi( yytext ); return T_INT; }
.              ;

%%

