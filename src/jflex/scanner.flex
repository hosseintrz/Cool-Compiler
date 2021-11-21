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


%state STRING
%state SPECIAL_CHARACTERS

%%


<YYINITIAL> {
  {LineTerminator}               {return symbol(SymbolType.LINE_TERMINATOR,"\n");}

  {KeyWord}                     { return symbol(SymbolType.KEYWORD,yytext()); }

  {Identifier}                { return symbol(SymbolType.IDENTIFIER,yytext()); }

  {DecimalInteger}            { return symbol(SymbolType.DECIMAL_INTEGER,yytext()); }
  {Hexadecimal}               { return symbol(SymbolType.HEXADECIMAL_INTEGER,yytext());}
  {RealNumber}                { return symbol(SymbolType.REAL_NUMBER,yytext());}
  {ScientificNotation}        { return symbol(SymbolType.SCIENTIFIC,yytext());}
  {Operators}                 { return symbol(SymbolType.OPERATOR,yytext());}

  \"                          { string.setLength(0); yybegin(STRING); }

  {Comment}                      { return symbol(SymbolType.COMMENT,yytext()); }

  {WhiteSpace}                   { return symbol(SymbolType.WHITE_SPACE," "); }
 
}

<STRING> {
  \" {
    yybegin(YYINITIAL);
    return symbol(SymbolType.STRING_LITERAL,string.toString());
  }

  [^\n\r\"\\]+ {
    string.append( yytext() );
  }

  \\n|\\t|\\r|\\\"|\\\'|\\\\ { 
    yybegin(SPECIAL_CHARACTERS);
    s_char = new String(yytext());
    return symbol(SymbolType.STRING_LITERAL,string.toString()); 
  }

 
  
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
[^] {return symbol(SymbolType.UNDEFINED,yytext());}
//[^] { throw new Error("Illegal character <" + yytext()+"> at line : "+yyline + " & col :" + yycolumn ); }
