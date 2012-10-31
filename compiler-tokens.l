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

","               { TOKEN( ',' ); }
";"               { TOKEN( ';' ); }
"("               { TOKEN( '(' ); }
")"               { TOKEN( ')' ); }
"{"               { TOKEN( '{' ); }
"}"               { TOKEN( '}' ); }
"+"               { TOKEN( '+' ); }
"$"               { TOKEN( '$' ); }
"@"               { TOKEN( '@' ); }
"<"               { TOKEN( '<' ); }
">"               { TOKEN( '>' ); }

"if"              { TOKEN( T_IF ); }
"else"            { TOKEN( T_ELSE ); }
"for"             { TOKEN( T_FOR ); }

{L}+({L}|{D})*\$? { yylval.sval = strdup( yytext ); return T_IDENT; }
\$@{L}+({L}|{D})*\$? { yylval.sval = strdup( yytext ); return T_IDENT; }
\.@{L}+({L}|{D})*\$? { yylval.sval = strdup( yytext ); return T_IDENT; }
\${L}+({L}|{D})*\$?  { yylval.sval = strdup( yytext ); return T_IDENT; }
\"[^"]*\"         { yylval.sval = strdup( yytext ); return T_STR; }
-?{D}+            { yylval.ival = atoi( yytext ); return T_INT; }
\/\/.*$           ; // Ignore comments
(\t\ )            ; // Ignore whitespace
\r?\n?            ; // Ignore newlines
.                 ;

%%

