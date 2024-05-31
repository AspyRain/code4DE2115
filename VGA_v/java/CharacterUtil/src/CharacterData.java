import java.util.List;

public class CharacterData {
    private List<String> charData;
    private String charaName;

    public CharacterData(List<String> charData, String charaName) {
        this.charData = charData;
        this.charaName = charaName;
    }

    // Getters and Setters
    public List<String> getCharData() {
        return charData;
    }

    public void setCharData(List<String> charData) {
        this.charData = charData;
    }

    public String getCharaName() {
        return charaName;
    }

    public void setCharaName(String charaName) {
        this.charaName = charaName;
    }
}