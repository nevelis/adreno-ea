all : compiler

compiler : compiler-parser.o compiler-tokens.o botscript.o
	g++ -o $@ compiler-parser.o compiler-tokens.o botscript.o

compiler-parser.o : compiler-parser.tab.c compiler-parser.tab.h botscript.h
	g++ -g -c -o $@ compiler-parser.tab.c

botscript.o : botscript.cpp botscript.h compiler-parser.tab.h
	g++ -g -c -o $@ botscript.cpp

compiler-parser.tab.c compiler-parser.tab.h : compiler-parser.y
	bison -v -d compiler-parser.y

compiler-tokens.o : compiler-tokens.c botscript.h
	g++ -g -c -o $@ compiler-tokens.c

compiler-tokens.c : compiler-tokens.l compiler-parser.tab.h
	flex -o $@ compiler-tokens.l

code-generator.o : code-generator.cpp code-generator.h assembler-parser.tab.h bit-stream.h
	g++ -g -c -o $@ code-generator.cpp

bit-stream.o : bit-stream.h
	g++ -g -c -o $@ bit-stream.cpp

symbol-table.o : symbol-table.cpp symbol-table.h
	g++ -g -c -o $@ symbol-table.cpp

clean :
	rm -f *.o *.output *.tab.* *tokens.c compiler


