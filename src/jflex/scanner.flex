import Symbol.*;
%%

%class Lexer
%unicode
%function nextToken
%line
%column
%type Symbol

%{
  StringBuffer string = new StringBuffer();
  String s_char = new String();

  private Symbol symbol(SymbolType type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(SymbolType type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Letter = [a-zA-Z]
Digit = [0-9]
PositiveInteger = 0 | [1-9][0-9]*
DecimalInteger = {PositiveInteger}

Hexadecimal = 0 ("x"|"X") ([a-fA-F]|{Digit})*
RealNumber = {DecimalInteger}("."){DecimalInteger}?
ScientificNotation = ({DecimalInteger} | {RealNumber})("E"|"e")([-+]?{PositiveInteger})

Identifier = {Letter}+ ({Letter}|{Digit}|"_"){0,30}

KeyWord = "let" | "void" | "int" | "real" | "bool" | "string" | "static" | "class" | "for" |
"rof" | "loop" | "pool" | "while" | "break" | "continue" | "if" | "fi" | "else" | "then" |
"new" | "Array" | "return" | "in_string" | "in_int" | "print" | "len"

Operators = "+" | "-" | "*" | "/" | "+=" | "-=" |"*=" | "/=" | "++" | "--" | "<" | "<=" | ">" | ">=" | "!=" |
"==" | "=" | "%" | "&&" | "||" | "&" | "|" | "^" | "!" | "." | "," | ";" | "[" | "]" | "(" | ")" | "{" | "}"

// SpecialCharacters = "\\n" | "\\t" | "\\r" | "\\\'" | "\\\"" | "\\\\";

%state STRING
%state SPECIAL_CHARACTERS

%%

/* keywords */

<YYINITIAL> {

  {KeyWord}                     { return symbol(SymbolType.KEYWORD,yytext()); }

  /* identifiers */
  {Identifier}                { return symbol(SymbolType.IDENTIFIER,yytext()); }

  {DecimalInteger}            { return symbol(SymbolType.DECIMAL_INTEGER,yytext()); }
  {Hexadecimal}               { return symbol(SymbolType.HEXADECIMAL_INTEGER,yytext());}
  {RealNumber}                { return symbol(SymbolType.REAL_NUMBER,yytext());}
  {ScientificNotation}        { return symbol(SymbolType.SCIENTIFIC,yytext());}
  {Operators}                 { return symbol(SymbolType.OPERATOR,yytext());}
  // {SpecialCharacters}         { return symbol(SymbolType.SPECIAL_CHARACTER,yytext());}
  /* literals */

  \"                          { string.setLength(0); yybegin(STRING); }

  /* operators */
  // "="                            { return symbol(SymbolType.EQ); }
  // "=="                           { return symbol(SymbolType.EQEQ); }
  // "+"                            { return symbol(SymbolType.PLUS); }

  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
}

<STRING> {
  \" {
    yybegin(YYINITIAL);
    return symbol(SymbolType.STRING_LITERAL,string.toString());
  }

  [^\n\r\"\\]+ {
    string.append( yytext() );
  }

  // \\t { return symbol(SymbolType.SPECIAL_CHARACTER,"\\t");}
  \\n|\\t|\\r|\\\"|\\\'|\\\\ { 
    yybegin(SPECIAL_CHARACTERS);
    s_char = new String(yytext());
    return symbol(SymbolType.STRING_LITERAL,string.toString()); 
  }

  // \\r  { return symbol(SymbolType.SPECIAL_CHARACTER,"\\r"); }
  // \\\" { return symbol(SymbolType.SPECIAL_CHARACTER,"\\\\"); }
  // \\   { return symbol(SymbolType.SPECIAL_CHARACTER,"\\"); }
  
}

<SPECIAL_CHARACTERS>{
  [^] {
    string.setLength(0);
    string.append(yytext());
    if(string.toString().equals("\"")){
      yybegin(YYINITIAL);
    }else{
      yybegin(STRING);
    }
    return symbol(SymbolType.SPECIAL_CHARACTER,s_char);
  }
}

/* error fallback */
[^] { throw new Error("Illegal character <" + yytext()+"> at line : "+yyline + " & col :" + yycolumn ); }
