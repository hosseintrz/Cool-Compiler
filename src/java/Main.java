import Symbol.Symbol;

import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;


public class Main {
    public static void main(String[] args) {
        try {
            Lexer lexer = new Lexer(new FileReader("src/resources/input.cool"));
            ArrayList<Symbol> tokens = new ArrayList<>();
            while(true){
                Symbol token = lexer.nextToken();
                if(lexer.yyatEOF()){
                    break;
                }
                tokens.add(token);
            }
            LexemeFormatter formatter = new LexemeFormatter();
            formatter.format(tokens);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
