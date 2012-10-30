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

"@"               { TOKEN( T_AT ); }
"$"               { TOKEN( T_DOLLAR ); }
"#"               { TOKEN( T_HASH ); }
"."               { TOKEN( T_DOT ); }
"'"               { TOKEN( T_SQUOTE ); }
";"               { TOKEN( T_SEMICOLON ); }
":"               { TOKEN( T_COLON ); }
","               { TOKEN( T_COMMA ); }
"\t"              { TOKEN( T_TAB ); }
" "               { TOKEN( T_SPACE ); }
"{"               { TOKEN( T_LBRACE ); }
"}"               { TOKEN( T_RBRACE ); }
"("               { TOKEN( T_LPAREN ); }
")"               { TOKEN( T_RPAREN ); }
"=="              { TOKEN( T_EQU ); }

"monster"         { TOKEN( T_MONSTER ); }
"boss_monster"    { TOKEN( T_BOSS_MONSTER ); }
"script"          { TOKEN( T_SCRIPT ); }

"if"              { TOKEN( T_IF ); }
"else"            { TOKEN( T_ELSE ); }

{L}+({L}|{D})*    { yylval.sval = strdup( yytext ); return T_IDENT; }
\/\/.*$           ; // Comment
\r?\n?            { TOKEN( T_EOL ); }
\"[^"]*\"         { yylval.sval = strdup( yytext ); return T_STR; }
-?{D}+            { yylval.ival = atoi( yytext ); return T_INT; }
.                 ;

%%

