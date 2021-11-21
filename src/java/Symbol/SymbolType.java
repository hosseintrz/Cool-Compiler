package Symbol;

public enum SymbolType {
    IDENTIFIER("#FFFFFF"),
    KEYWORD("#FC618D"),
    DECIMAL_INTEGER("#F59762"),
    HEXADECIMAL_INTEGER("#F59762"),
    SCIENTIFIC("#F59762"),
    REAL_NUMBER("F59762"),
    STRING_LITERAL("#FCE566"),
    OPERATOR("#00FFFF"),
    SPECIAL_CHARACTER("#EE82EE"),
    LINE_TERMINATOR(""),
    WHITE_SPACE(""),
    UNDEFINED("#FF0000"),
    COMMENT("#69676C");

    private String color;
    public String getColor(){
        return this.color;
    }
    SymbolType(String color){
        this.color = color;
    }


}
