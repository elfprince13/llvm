class eZ80Reg<string n, bits<16> Enc = 8, int Cost = 0> : Register<n> {
	let Namespace = "eZ80";
	let HWEncoding = Enc; /* Enc = 8 implies it can't be encoded for a normal instruction */
	let CostPerUse = Cost;
}

class eZ80SubRegIndex<int size, int offset = 0> : SubRegIndex<size, offset> {
	let Namespace = "eZ80";
}

def subreg_up : Z80SubRegIndex<8, 16>;
def subreg_hi : Z80SubRegIndex<8, 8>;
def subreg_lo : Z80SubRegIndex<8, 0>;


class eZ80RegWithSubRegs<string n, bits<16> Enc = 8, list<Register> subregs = [], int Cost = 0>
  : eZ80Reg<n, Enc, Cost> {
  let SubRegs = subregs;
  let SubRegIndices = [subreg_up, subreg_hi, subreg_lo];
  let CoveredBySubRegs = 1;
}

class eZ80Reg8Class<dag reglist> : RegisterClass<"eZ80", [i8], 8, reglist> { }
class eZ80Reg24Class<dag reglist> : RegisterClass<"eZ80", [i24], 8, reglist> {}


// Primary register file
def A : eZ80Reg<"a", 7>;
def F : eZ80Reg<"f">;
def B : eZ80Reg<"b", 0>;
def C : eZ80Reg<"c", 1>;
def D : eZ80Reg<"d", 2>;
def E : eZ80Reg<"e", 3>;
def H : eZ80Reg<"h", 4>;
def L : eZ80Reg<"l", 5>;

def AFU : eZ80Reg<"afu">; // This is a virtual register. Relevant for push/pop and not much else
def BCU : eZ80Reg<"bcu">;
def DEU : eZ80Reg<"deu">;
def HLU : eZ80Reg<"hlu">;

def BC : eZ80RegWithSubRegs<"bc",0,[BCU, B, C]>;
def DE : eZ80RegWithSubRegs<"de",1,[DEU, D, E]>;
def HL : eZ80RegWithSubRegs<"hl",2,[HLU, H, L]>;
def AF : eZ80RegWithSubRegs<"af",3,[AFU, A, F]>;

// Shadow file
def AP : eZ80Reg<"a'">;
def FP : eZ80Reg<"f'">;
def BP : eZ80Reg<"b'">;
def CP : eZ80Reg<"c'">;
def DP : eZ80Reg<"d'">;
def EP : eZ80Reg<"e'">;
def HP : eZ80Reg<"h'">;
def LP : eZ80Reg<"l'">;

def AFUP : eZ80Reg<"afu'">; // This is a virtual register. Relevant for push/pop and not much else
def BCUP : eZ80Reg<"bcu'">;
def DEUP : eZ80Reg<"deu'">;
def HLUP : eZ80Reg<"hlu'">;

def BCP : eZ80RegWithSubRegs<"bc'",0,[BCUP, BP, CP]>;
def DEP : eZ80RegWithSubRegs<"de'",1,[DEUP, DP, EP]>;
def HLP : eZ80RegWithSubRegs<"hl'",2,[HLUP, HP, LP]>;
def AFP : eZ80RegWithSubRegs<"af'",3,[AFUP, AP, FP]>;

// Index subregisters
def IXU : eZ80Reg<"ixu", 8, 1>;
def IXH : eZ80Reg<"ixh", 4, 1>;
def IXL : eZ80Reg<"ixl", 5, 1>;
def IYU : eZ80Reg<"iyu", 8, 1>;
def IYH : eZ80Reg<"iyh", 4, 1>;
def IYL : eZ80Reg<"iyl", 5, 1>;

// Index registers
def IX : eZ80Reg<"ix", 2, [IXU, IXH, IXL], 1>;
def IY : eZ80Reg<"iy", 2, [IYU, IYH, IYL], 1>;

// Control registers and flags...
def I : eZ80Reg<"i">;
def MBASE : eZ80Reg<"mbase">;
def R : eZ80Reg<"r">;

def SPL : eZ80Reg<"spl">;
def PC : eZ80Reg<"pc">;

def ADL : eZ80Reg<"adl">;
def MADL : eZ80Reg<"madl">;
def IEF1 : eZ80Reg<"ief1">;
def IEF2 : eZ80Reg<"ief2">;

def GR8 : Z80Reg8Class<(add A, B, C, D, E, H, L)>;
def GR24 : Z80Reg24Class<(add BC, DE, HL)>;
def IR24 : Z80Reg24Class<(add IX, IY)>;
def UR24 : Z80Reg24Class<(add GR24, IR24)>; // Can dags be appended? would make a nice shorthand
