import Symbol.*;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.apache.commons.io.FileUtils;
import org.jsoup.nodes.Element;
import org.jsoup.parser.Tag;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class LexemeFormatter {

    public void format(List<Symbol> tokens){
        Element line = new Element(Tag.valueOf("div"),"");
        Element page = new Element(Tag.valueOf("div"),"");
        page.attr("style","background-color:black");
        tokens.forEach(token -> {
            if(token.getType().equals(SymbolType.LINE_TERMINATOR)){
                line.attr("style","display:flex;flex-direction:row;");
                page.appendChild(line.clone());
                line.text("");
            }else{
                Element elem = new Element(Tag.valueOf("p"),"");
                if(token.getType().equals(SymbolType.WHITE_SPACE))
                    elem.append("&nbsp");
                else
                    elem.append(token.getValue().toString());
                if(token.getType().getColor().length()>0)
                    elem.attr("style","color:"+token.getType().getColor());
                line.appendChild(elem);
            }
        });
        if(!line.toString().equals(""))
            page.appendChild(line);
        Document doc = Jsoup.parseBodyFragment(page.toString());
        File output = new File("src/output/lexicalAnalyze.html");
        try {
            FileUtils.writeStringToFile(output, doc.outerHtml(), StandardCharsets.UTF_8);
        }catch(IOException e){
            e.printStackTrace();
        }
    }
}
