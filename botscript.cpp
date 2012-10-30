#include "botscript.h"
#include "compiler-parser.tab.h"
#include <sstream>
#include <stdlib.h>

size_t SymbolRegistrar::symnum = 0;
map<string, string> SymbolRegistrar::symbols;

string
SymbolRegistrar::RegisterSymbol( const string& s )
{
   string symname = NewSymbolName();
   ostringstream oss;
   oss << "STR " << s.size() << " " << s << endl;
   symbols[ symname ] = oss.str();
   return symname;
}


string
SymbolRegistrar::RegisterLabel()
{
   return NewSymbolName();
}

string
SymbolRegistrar::RegisterSymbol( BSFunctionDefinition* func )
{
   ostringstream oss;
   oss << "FUNC " << func->args->size() << endl;
   for( IdentifierList::iterator it = func->args->begin(); it !=
      func->args->end(); ++it ) {
      oss << "   POP " << ( *it )->value << endl;
   }
   func->body->codegen( oss );

   string symname = NewSymbolName();
   symbols[ symname ] = oss.str();
   return symname;
}

void
SymbolRegistrar::codegen( ostream& oss )
{
   map<string, string>::iterator it;
   for( it = symbols.begin(); it != symbols.end(); ++it ) {
      oss << it->first << " " << it->second;
   }
}
