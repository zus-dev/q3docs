<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
changequote([*,*])dnl
changecom([*<!--*],[*-->*])dnl
undefine([*format*])dnl
define(ENT_title,[*Quake 3 Virtual Machine (Q3VM) Specifications*])dnl
define(TITLE,<h1>$1</h1>)dnl
define(SYNOPSIS,<h2>Synopsis</h2><p>$1</p>)dnl
define(ENT_mod,game module)dnl
define(ENT_angbra,[*&lt;*])dnl
define(ENT_angket,[*&gt;*])dnl
define(ENT_amp,[*&amp;*])dnl
define(ENT_authornick,PhaethonH)dnl
define(ENT_authormail,[*PhaethonH@gmail.com*])dnl
define(FILENAME,<tt>$1</tt>)dnl
define(FUNCNAME,<var>$1</var>)dnl
define(VARNAME,<var>$1</var>)dnl
define(CONSTNAME,<tt>$1</tt>)dnl
define(VERBATIM,<hr><pre>$1</pre><hr>)dnl
define(KEYB,<tt>$1</tt>)dnl
define(_P,<p>$1)dnl
define(SECT,<a name="$1"></a><h3>$2</h3>[*undefine([*_SN*])define(_SN,$1)*])dnl
define(SECT1,<h4>$2</h4>)dnl
define(SECT2,<h5>$2</h5>)dnl
define(QUOT,&quot;$1&quot;)dnl
define(XREF,[*<a href="#$1">$2</a>*])dnl
define(QV,[*See also <a href="#$1">$1</a>*])dnl quod vide -> "see which"
define(LIST_ORDERED,<ol>$1</ol>)dnl
define(LIST_UNORDERED,<ul>$1</ul>)dnl
define(LIST_DICT,<dl>$1</dl>)dnl
define(LI,<li>$1</li>)dnl
define(DT,<dt>$1</dt>)dnl
define(DD,<dd>$1</dd>)dnl
define(DICT,[*DT(<a name="_SN().$1">[*$1*]</a>)DD([*$2*])*])dnl
define(ADDRESS,[*<address>$1</address>*])dnl
define(EMAIL,[*<a href="mailto:$1">$1</a>*])dnl
define(_LF,[*<br>*])dnl
define(_EM,[*<em>$1</em>*])dnl
define(_ST,[*<strong>$1</strong>*])dnl
define(LCC_I4,signed 32-bit integer)dnl
define(LCC_I2,signed 16-bit integer)dnl
define(LCC_I1,signed 8-bit integer)dnl
define(LCC_U4,unsigned 32-bit integer)dnl
define(LCC_U2,unsigned 32-bit integer)dnl
define(LCC_U1,unsigned 32-bit integer)dnl
define(LCC_P4,pointer value)dnl
define(LCC_F4,IEEE-754 floating point number)dnl
define(HORIZRULEz,<hr id="footer" width="42%" align="left">)dnl
define(ADDRESS,[*<address>$1</address>*])dnl
define(_LF,[*<br>*])dnl
dnl
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>
ENT_title
</title>
</head>
<body>
TITLE(ENT_title)

SYNOPSIS([*A description of the Q3VM architecture and operations.*])

SECT(intro,Introduction)
_P([*
The Q3VM is a virtual machine used by Quake III to run the game module.
The VM is a sort of sandbox to limit the damage a rogue or malicious QVM program can wreak.
Though not perfect, it certainly is much safer than full access to native machine language, which could otherwise more easily allow the spread of viruses or the corruption of system resources.
In addition, Q3VM programs, similar to JVM's, are write-once run-on-many-platforms (at least for which a Q3VM interpreter or compiler exists).
*])

_P([*
The instruction set for the Q3VM is derived from the bytecode interpreter target of LCC, with minor differences.
The VM heavily relies on stack operations (stack-based machine).
*])

SECT(memory,Memory)
_P([*
Memory bus of little-endian, unsigned 32 bits, flat memory space, zero-based addressing, octet-accessible.
*])

_P([*
Memory is accessible in words of 4 octets (32 bits), 2 octets (16 bits), and single octect (8 bits).
*])

_P([*
Code and data occupy distinct address spaces.
Thus code address 0 is not the same as data address 0.
This separation also precludes self-modifying code.
*])

SECT1(codesegment,Code segment)
_P([*
Q3VM is CISC-like in the sense that opcodes do not occupy equal amounts of space.
Some opcodes take a parameter embedded in the code segment.
As a result, the length of the code segment has no bearing on the number of instructions in the code segment.
The QVM file format header manifests this distinction.
*])

_P([*
Jump addresses are specified in terms of instructions, rather than bytes.
Thus, the VM code memory requires special processing when loading the code segment to identify instruction offsets.
*])

SECT(processor,Processor/CPU)
_P([*
While the Q3VM is currently implemented only in emulation, the concept of a VM's CPU is a convenient notion.
*])

SECT1(registers,Registers)
_P([*
Theses are guesses derived from modern machines, other fictional machines, and Forth.
LIST_UNORDERED([*
LI([*Program Counter (PC)*])
LI([*Stack Pointer (SP) (QUOT(the stack))*])
LI([*Local Pointer (LP) (QUOT(start of local variable space))*])
LI([*Frame Pointer (FP) (QUOT(start of subroutine stack space))*])
*])
*])

SECT1(opcodes,Opcodes)
_P([*
List of opcodes recognized by the Q3VM.
All opcodes occupy one octet, and take 1 or 4 additional octets as parameters.
All multi-octet values are treated as little-endian (a legacy of Id's MS-DOS days).
*])

_P([*
Opcode mnemonics (QUOT(names)) follow a pattern (intriguingly, the opcode values don't, as they do on other architectures).
Up to four letters for the operation name, then a letter indicating a data type, then a digit indicating data size (usually the number of required octets).
*])

define(QVM_Ctype,[*Corresponds to Q3VM's C data type QUOT([*$1*])*])

_P([*
Data type and size codes:
LIST_DICT([*
DICT(B,[*block (sequence of octets, of arbitrary length (e.g. character strings or structs))*])
DICT(F4,[*little-endian IEEE-754 32-bit single-precision floating point value.*])
DICT(P4,[*Four-octet pointer (memory address) value.*])
DICT(I4,[*Four-octet signed integer.  QVM_Ctype(signed int).*])
DICT(I2,[*Two-octet signed integer.  QVM_Ctype(signed short).*])
DICT(I1,[*One-octet signed integer.  QVM_Ctype(signed char).*])
DICT(U4,[*Four-octet unsigned integer.  QVM_Ctype(unsigned int).*])
DICT(U2,[*Two-octet unsigned integer.  QVM_Ctype(unsigned short).*])
DICT(U1,[*One-octet unsigned integer.  QVM_Ctype(unsigned char).*])
*])
*])

_P([*
Generalized opcodes list (lcc bytecode):
LIST_DICT([*
DICT(CNST[**]_EM(t) _EM(v),[*
CONSTANT.
Reads _EM(v) as a value of type _EM(t).
For floats, _EM(v) is the bit pattern of the float value.
*])
DICT(ASGN[**]_EM(t),[*
ASSIGN.
Pops a value from stack, interpreted according to _EM(t), to use as the assignment value.
Pops another value from stack, interpreted as a pointer value (memory address) to use as the assignment destination.
*])
DICT(INDIR[**]_EM(t),[*
INDIRECTION.
Pops a value from stack, interpreted as a pointer value (memory address).
Retrieves the 32-bit value from the indicated memory location, and interprets the 32-bit value according to _EM(t), then pushes to stack.
(think of it as pointer dereferencing)
*])
DICT(CVF[**]_EM(t),[*
CONVERT TO FLOAT.
Pops a value from stack, interpreted according to _EM(t), converted to its equivalent float (F4) form, then pushed to stack.
*])
DICT(CVI[**]_EM(t),[*
CONVERT TO (signed) INTEGER.
Pops a value from stack, interpreted according to _EM(t), converted to its equivalent signed integer (I4) form, then pushed to stack.
*])
DICT(CVU[**]_EM(t),[*
CONVERT TO UNSIGNED INTEGER.
Pops a value from stack, interpreted according to _EM(t), converted to its equivalent unsigned integer (U4) form, then pushed to stack.
*])
DICT(CVP[**]_EM(t),[*
CONVERT TO UNSIGNED INTEGER.
Pops a value from stack, interpreted according to _EM(t), converted to its equivalent pointer (P4) form, then pushed to stack.
*])
DICT(NEG[**]_EM(t),[*
ARITHMETIC NEGATE.
Pops a value from stack, interpreted according to _EM(t), negated arithmeticaly (multiplied by -1 or -1.0), then pushed to stack.
*])
DICT(ADDRGP4 _EM(v),[*
ADDR[**]ESS OF GLOBAL (pointer).
Takes _EM(v) as a memory address, takes the 32-bit value at the address, pushes the 32-bit value to stack (i.e. get value of a global variable/function/symbol).
*])
DICT(ADDRLP4 _EM(v),[*
ADDR[**]ESS OF (from?) LOCAL (pointer).
Address of a local variable.
Local Pointer(?) plus _EM(v).
First local variable is at 0.
*])
DICT(ADDRFP4 _EM(v),[*
ADDR[**]ESS (from?) FRAME (pointer).
Address of an argument (with repect to the frame pointer).
Frame Pointer plus (minus?) _EM(v).
First argument is at 0, second argument at 4, etc (XXX: verify).
*])
DICT(ADD[**]_EM(t),[*
ADD.
Pops a value from stack, interpreted according to _EM(t), as second operand.
Pops another value from stack, interpreted _EM(t), as first operand.
The two values are arithmeticaly added, pushes sum to stack.
*])
DICT(SUB[**]_EM(t),[*
SUBTRACT.
Pops a value from stack, interpreted _EM(t), as second operand.
Pops another value from stack, interpreted _EM(t), as first operand.
Subtracts second operand from first operand, pushes difference to stack.
*])
DICT(MUL[**]_EM(t),[*
MULTIPLY.
Pops a value from stack, interpreted _EM(t), as second operand.
Pops another value from stack, interpreted _EM(t), as first operand.
Multiplies the values together, pushes product to stack.
*])
DICT(DIV[**]_EM(t),[*
DIVIDE.
Pops a value from stack, interpreted _EM(t), as second operand.
Pops another value from stack, interpreted _EM(t), as first operand.
Second operand divides into first operand, pushes quotient to stack
(XXX: integer division C style?).
*])
DICT(MOD[**]_EM(t),[*
MODULUS.
Pops a value from stack, as _EM(t), as second operand.
Pops another value from stack, as _EM(t), as first operand.
The second operand divides into the first operand, pushes remainder to stack.
*])
DICT(LSH[**]_EM(t),[*
LEFT SHIFT.
Pops a value from stack, as _EM(t), as second operand.
Pops another value from stack, as _EM(t), as first operand.
First operand bit-wise shifts left by number of bits specified by second operand, pushes result to stack.
*])
DICT(RSH[**]_EM(t),[*
RIGHT SHIFT.
Pops a value from stack, as _EM(t), as second operand.
Pops another value from stack, as _EM(t), as first operand.
First operand bit-wise shifts right by number of bits specified by second operand, pushes result to stack.
Sign-extension depends on _EM(t).
*])
DICT(BAND[**]_EM(t),[*
BINARY/BITWISE AND.
Pops a value from stack (_EM(t)) as second operand.
Pops another value from stack (_EM(t)) as first operand.
The two operands combine by bitwise AND, pushes result to stack.
*])
DICT(BCOM[**]_EM(t),[*
BINARY/BITWISE COMPLEMENT.
Pops a value from stack (_EM(t)).
Flips (almost-)every bit to its opposite value.
Changing the high bit (bit 31) depends on _EM(t).
*])
DICT(BOR[**]_EM(t),[*
BINARY/BITWISE OR.
Pops a value from stack (_EM(t)) as second operand.
Pops another value from stack (_EM(t)) as first operand.
Combines the two operands by bitwise OR, pushes result to stack.
*])
DICT(BXOR[**]_EM(t),[*
BINARY/BITWISE XOR.
Pops two values, XORs, pushes result to stack.
*])
DICT(EQ[**]_EM(t) _EM(v),[*
EQUAL-TO.
Pops two values from stack (as type _EM(t)), compares the two values.
Jumps to address _EM(v) if true.
*])
DICT(GE[**]_EM(t) _EM(v),[*
GREATER-THAN OR EQUAL-TO.
Pops a value from stack (type _EM(t)) as second operand.
Pops another value from stack (type _EM(t)) as first operand.
Compares if first operand is equal to the second operand.
Jumps to address _EM(v) if true.
*])
DICT(GT[**]_EM(t) _EM(v),[*
GREATER-THAN.
Pops a second operand (type _EM(t)) then a first operand (type _EM(t)).
Compares if first operand is greater than the second operand.
Jumps to address _EM(v) if true.
*])
DICT(LE[**]_EM(t) _EM(v),[*
LESS-THAN OR EQUAL-TO.
Pops a second operand (type _EM(t)) then a first operand (type _EM(t)).
Compares if first operand is less than or equal to the second operand.
Jumps to address _EM(v) if true.
*])
DICT(LT[**]_EM(t) _EM(v),[*
LESS-THAN.
Pops a second operand (_EM(t)) then a first operand (_EM(t)).
Compares if first operand is less than the second operand.
Jumps to address _EM(v) if true.
*])
DICT(NE[**]_EM(t) _EM(v),[*
NOT-EQUAL.
Pops two values (_EM(t)), compares the two values.
Compares if first operand is not equal to the second operand.
Jumps to address _EM(v) if true.
*])
DICT(JUMPV,[*
Pops a pointer value from stack, sets PC to the value (jump).
*])
DICT(RET[**]_EM(t),[*
Pop value from stack,
shrink stack to eliminate local frame,
push value back to stack.
Or copy top of stack to bottom of frame and shrink stack size/pointer?
*])
DICT(ARG[**]_EM(t),[*
Pop value from stack as type _EM(t),
store into arguments-marshalling space.
*])
DICT(CALL[**]_EM(t),[*
Pops value from stack as address of a function.
Makes a procedure call to the function, which is expected to return a value of type _EM(t).
*])
DICT(pop,[*
Pop stack (discard top of stack).
(functions of void type still return a (nonsense) 32-bit value)
*])
*])dnl LIST_DICT
*])dnl _P


_P([*
List of assembly directives:
LIST_DICT([*
DICT(equ _EM(s) _EM(v),[*
Assign integer value _EM(v) to symbol _EM(s).
*])
DICT(data,[*
Assemble to DATA segment (initialized 32-bit variables).
*])
DICT(code,[*
Assemble to CODE segment (instructions).
*])
DICT(lit,[*
Assemble to LIT segment (initialized 8-bit variables).
*])
DICT(bss,[*
Assemble to BSS segment (uninitialized block storage segment).
*])
DICT(LABELV _EM(symbol),[*
Assigns the value of the currently computed Program Counter to the symbol named _EM(symbol).
(i.e. the current assembled address value is assigned to _EM(symbol)).
*])
DICT(byte _EM(l) _EM(v),[*
Write initialized value _EM(v) of _EM(l) octets.
1-octet values go into LIT segment.
2-octet values are invalid (fatal error).
4-octet values go into DATA segment.
*])
DICT(skip _EM(v),[*
Skip _EM(v) octets in the segment, leaving the octets uninitialized.
*])
DICT(export _EM(s),[*
Export symbol _EM(s) for external linkage.
*])
DICT(import _EM(s),[*
Import symbol _EM(s).
*])
DICT(align _EM(v),[*
Ensure memory alignment at a multiple of _EM(v), skipping octets if needed.
*])
DICT(address _EM(x),[*
???
(evaluates expression _EM(x) and append result to DATA segment)
*])
DICT(file _EM(filename),[*
Set filename to _EM(filename) for status and error reporting.
*])
DICT(line _EM(lineno),[*
Indicates current source line of _EM(lineno).
*])
DICT(proc _EM(locals) _EM(args),[*
Start of procedure (function) body.
Set aside _EM(locals) octets for local variables, and _EM(args) octets for arguments marshalling (for all possible subcalls within this procedure).
*])
DICT(endproc _EM(locals) _EM(args),[*
End of procedure body.
Clean up _EM(args) bytes (for arguments marshalling) and _EM(locals) bytes (for local variables).
*])
*])dnl LIST_DICT
*])dnl _P


SECT1(bytecodes, Q3VM Bytecodes)
_P([*
Specific opcodes (Q3VM bytecode):

define([*opnumber*],0)dnl
dnl define([*OPENTRY*],[*opnumber define([*opnumber*],incr(opnumber))OP_$1 -- ifelse($2,,(none),$2) -- $3*])dnl
define([*OPENTRY*],[*<TR><TD>opnumber </TD><TD> define([*opnumber*],incr(opnumber))$1 </TD><TD ALIGN="CENTER"> ifelse($2,,-,$2) </TD><TD> $3</TD></TR>*])dnl
dnl define([*CMP*],[*4-octet: jump address*])dnl
define([*CMP*],[*4*])dnl
(TOS = Top Of Stack; NIS = Next In Stack (next value after TOS))
(Hack syntax: $PARM = code parameter)
<TABLE BORDER=1>
<TR>
<TH>Byte</TH><TH>Opcode</TH><TH>Parameter size</TH><TH>Description</TH>
</TR>
OPENTRY([*UNDEF*],,[*undefined opcode.*])
OPENTRY([*IGNORE*],,[*no-operation (nop) instruction.*])
OPENTRY([*BREAK*],,[*??*])
OPENTRY([*ENTER*],[*4*],[*Begin procedure body, adjust stack $PARM octets for frame (always at least 8 (i.e. 2 words)).  Frame contains all local storage/variables and arguments space for any calls within this procedure.*])
OPENTRY([*LEAVE*],[*4*],[*End procedure body, $PARM is same as that of the matching ENTER.*])
OPENTRY([*CALL*],,[*make call to procedure (code address <- TOS).*])
OPENTRY([*PUSH*],,[*push nonsense (void) value to opstack (TOS <- 0).*])
OPENTRY([*POP*],,[*pop a value from stack (remove TOS, decrease stack by 1).*])
OPENTRY([*CONST*],[*4*],[*push literal value onto stack (TOS <- $PARM)*])
OPENTRY([*LOCAL*],[*4*],[*get address of local storage (local variable or argument) (TOS <- (frame + $PARM)).*])
OPENTRY([*JUMP*],,[*branch (code address <- TOS)*])
OPENTRY([*EQ*],CMP,[*check equality (signed integer) (compares NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*NE*],CMP,[*check inequality (signed integer) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*LTI*],CMP,[*check less-than (signed integer) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*LEI*],CMP,[*check less-than or equal-to (signed integer) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*GTI*],CMP,[*check greater-than (signed integer) (NIS vs TOS), jump to $PARM if true.*])
OPENTRY([*GEI*],CMP,[*check greater-than or equal-to (signed integer) (NIS vs TOS), jump to $PARM if true.*])
OPENTRY([*LTU*],CMP,[*check less-than (unsigned integer) (NIS vs TOS), jump to $PARM if true.*])
OPENTRY([*LEU*],CMP,[*check less-than or equal-to (unsigned integer) (NIS vs TOS), jump to $PARM if true.*])
OPENTRY([*GTU*],CMP,[*check greater-than (unsigned integer) (NIS vs TOS), jump to $PARM if true.*])
OPENTRY([*GEU*],CMP,[*check greater-than or equal-to (unsigned integer) (NIS vs TOS), jump to $PARM if true.*])
OPENTRY([*EQF*],CMP,[*check equality (float) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*NEF*],CMP,[*check inequality (float) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*LTF*],CMP,[*check less-than (float) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*LEF*],CMP,[*check less-than or equal-to (float) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*GTF*],CMP,[*check greater-than (float) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*GEF*],CMP,[*check greater-than or equal-to (float) (NIS vs TOS, jump to $PARM if true).*])
OPENTRY([*LOAD1*],,[*Load 1-octet value from address in TOS (TOS <- [TOS])*])
OPENTRY([*LOAD2*],,[*Load 2-octet value from address in TOS (TOS <- [TOS])*])
OPENTRY([*LOAD4*],,[*Load 4-octet value from address in TOS (TOS <- [TOS])*])
OPENTRY([*STORE1*],,[*lowest octet of TOS is 1-octet value to store, destination address in next-in-stack ([NIS] <- TOS).*])
OPENTRY([*STORE2*],,[*lowest two octets of TOS is 2-octet value to store, destination address in next-in-stack ([NIS] <- TOS).*])
OPENTRY([*STORE4*],,[*TOS is 4-octet value to store, destination address in next-in-stack ([NIS] <- TOS).*])
OPENTRY([*ARG*],[*1*],[*TOS is 4-octet value to store into arguments-marshalling space of the indicated octet offset (ARGS[offset] <- TOS).*])
OPENTRY([*BLOCK_COPY*],,[*???*])
OPENTRY([*SEX8*],,[*Sign-extend 8-bit (TOS <- TOS).*])
OPENTRY([*SEX16*],,[*Sign-extend 16-bit (TOS <- TOS).*])
OPENTRY([*NEGI*],,[*Negate signed integer (TOS <- -TOS).*])
OPENTRY([*ADD*],,[*Add integer-wise (TOS <- NIS + TOS).*])
OPENTRY([*SUB*],,[*Subtract integer-wise (TOS <- NIS - TOS).*])
OPENTRY([*DIVI*],,[*Divide integer-wise (TOS <- NIS / TOS).*])
OPENTRY([*DIVU*],,[*Divide unsigned integer (TOS <- NIS / TOS).*])
OPENTRY([*MODI*],,[*Modulo (signed integer) (TOS <- NIS mod TOS).*])
OPENTRY([*MODU*],,[*Modulo (unsigned integer) (TOS <- NIS mod TOS).*])
OPENTRY([*MULI*],,[*Multiply (signed integer) (TOS <- NIS * TOS).*])
OPENTRY([*MULU*],,[*Multiply (unsigned integer) (TOS <- NIS * TOS).*])
OPENTRY([*BAND*],,[*Bitwise AND (TOS <- NIS & TOS).*])
OPENTRY([*BOR*],,[*Bitwise OR (TOS <- NIS | TOS).*])
OPENTRY([*BXOR*],,[*Bitwise XOR (TOS <- NIS ^ TOS).*])
OPENTRY([*BCOM*],,[*Bitwise complement (TOS <- ~TOS).*])
OPENTRY([*LSH*],,[*Bitwise left-shi[**]ft (TOS <- NIS << TOS).*])
OPENTRY([*RSHI*],,[*Algebraic (signed) right-shi[**]ft (TOS <- NIS >> TOS).*])
OPENTRY([*RSHU*],,[*Bitwise (unsigned) right-shi[**]ft (TOS <- NIS >> TOS).*])
OPENTRY([*NEGF*],,[*Negate float value (TOS <- -TOS).*])
OPENTRY([*ADDF*],,[*Add floats (TOS <- NIS + TOS).*])
OPENTRY([*SUBF*],,[*Subtract floats (TOS <- NIS - TOS).*])
OPENTRY([*DIVF*],,[*Divide floats (TOS <- NIS / TOS).*])
OPENTRY([*MULF*],,[*Multiply floats (TOS <- NIS x TOS).*])
OPENTRY([*CVIF*],,[*Convert signed integer to float (TOS <- TOS).*])
OPENTRY([*CVFI*],,[*Convert float to signed integer (TOS <- TOS).*])
</TABLE>

*]) dnl _P


SECT(qvmfile,QVM File Format)
_P([*
QVM file format.
Multi-octet words are little-endian (LE).
define([*SLOT*], [*<TR><TD ALIGN="RIGHT">$1</TD><TD ALIGN="CENTER">$2</TD><TD>$3</TD></TR>*])
<TABLE BORDER=1>
<TR><TD COLSPAN=3>QVM header</TD></TR>
SLOT(offset,size,description)
SLOT(0, 4, [*magic (0x12721444 LE, 0x44147212 BE)*])
SLOT(4, 4, [*instruction count*])
SLOT(8, 4, [*length of CODE segment*])
SLOT(12, 4, [*offset of CODE segment*])
SLOT(16, 4, [*lenth of DATA segment*])
SLOT(20, 4, [*offset of DATA segment*])
SLOT(24, 4, [*length of LIT segment*])
SLOT(28, 4, [*length of BSS segment*])
</TABLE>

*]) dnl _P

_P([*
Following the header is the code segment, aligned on a 4-byte boundary.
The code segment can be processed octet-by-octet to identify instructions.
For bytecodes that take a multi-octet parameter, the parameter is stored in LE order.
Big-endian machines may want to byte-swap the parameter for native-arithmetic purposes.
The instruction count field in the header identifies when the sequence of instructions end.
Comparisons of code length, instruction counts, and file positions can be used to verify proper processing.
*]) dnl _P

_P([*
The data segment follows the code segment.
The assembler (qvm generator) needs to ensure the data segment begins on a 4-octet boundary (by padding with zeroes).
The data segment consists of a series of 4-octet LE values that are copied into VM memory.
For big-endian machines, each word may be optionally byte-swapped (for native arithmetic) on copy.
*]) _P

_P([*
The lit segment immediately follows the data segment.
This segment should already be aligned on a 4-octet boundary.
The lit segment consists of a series of 1-octet values, copied verbatim to VM memory.
No byte-swapping is needed.
*])

_P([*
The bss segment is not stored in the qvm file, since this segment consists of unitialized values (i.e. values that don't need to be stored).
The VM must ensure there is still sufficient memory to accomodate the bss segment.
The QVM header specifies the size of the bss segment.
The VM may optionally initialize the bss portion of memory with zeroes.
*])

HORIZRULEz
_P([*
Updated 2003.02.23 _LF()
Updated 2011.07.11 - change of contact e-mail _LF()
ADDRESS([*
ENT_authornick
ENT_angbra ENT_authormail ENT_angket
*])dnl ADDRESS
*])dnl _P


</body>
</html>
