import std.stdio;
/* writeln can take more than one argument, It prints them one after the other on the same line
Another thing to put in mind is that we can't actually name our programs with D function names
i.e: naming a source file "writeln.d" returns a compile time error
*/
void main() {
	writeln("Hello world!", "Hello fish!");
}