import Symbol.Symbol;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;


public class Main {
    public static void main(String[] args) {
        try {
            Lexer lexer = new Lexer(new FileReader("src/resources/input2.cool"));
            ArrayList<String> tokens = new ArrayList<>();
            while(true){
                Symbol token = lexer.nextToken();
                if(lexer.yyatEOF()){
                    break;
                }
                System.out.println(token.toString());
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
