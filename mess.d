import std.stdio;
void main() {
	writeln(sub(5, 15)); // Output 0
}
int sub(int a, int b) {
	return b % a;
}