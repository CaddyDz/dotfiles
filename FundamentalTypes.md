# Data Types

1- The smallest unit of data in a computer is called a **bit** , the value of a bit can be either **0** or **1**.  
2- A **byte** usually cosists of **8 bits**.
if **N-bit** data type is the most efficient data type supported by a CPU, we consider it to be an **N-bit CPU**: as in **32-bit** CPU, **64-bit** CPU, etc.

## D's Fundamental Data Types

Type|Definition|Initial Value
***REMOVED***-|***REMOVED******REMOVED******REMOVED***-|***REMOVED******REMOVED******REMOVED******REMOVED***-
bool|Boolean type |false
byte|signed 8 bits|0
ubyte|unsigned 8 bits|0
short|signed 16 bits|0
ushort|unsigned 16 bits|0
int|signed 32 bits|0
uint|unsigned 32 bits|0
long|signed 64 bits|0L
ulong|unsigned 64 bits|0L
float|32-bit floating point|float.nan
double|32-bit floating point|double.nan
real|either the largest floating point type that the hardware supports, or double; whichever is larger|real.nan
ifloat|imaginary value type of float|float.nan * 1.0i
idouble|imaginary value type of double|double.nan * 1.0i
ireal|imaginary value type of real|real.nan * 1.0i
cfloat|complex number type made of two floats|float.nan + float.nan * 1.0i
cdouble|complex number type made of two doubles|double.nan + double.nan * 1.0i
creal|complex number type made of two reals|real.nan + real.nan * 1.0i
char|UTF-8 code unit|0xFF
wchar|UTF-16 code unit|0xFFFF
dchar|UTF-32 code unit and Unicode code point|0x0000FFFF

In addition to the above, the keyword **void** represents having *no type*. The keywords **cent** and **ucent** are reserved for future use to represent *signed* and *unsigned* 128 bit values.