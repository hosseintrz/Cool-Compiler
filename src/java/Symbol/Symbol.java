package Symbol;

public class Symbol {

    private SymbolType type;
    private int line;
    private int column;
    private Object value;

    public Symbol(SymbolType type ,int line,int column,Object value){
        this.type = type;
        this.line = line;
        this.column = column;
        this.value = value;
    }
    public Symbol(SymbolType type ,int line,int column){
        this(type,line,column,null);
    }

    @Override
    public String toString() {
        return "Symbol.Symbol.Symbol.Symbol{" +
                "type=" + type +
                ", line=" + (line+1) +
                ", column=" + column +
                ", value=" + value +
                '}';
    }
}
