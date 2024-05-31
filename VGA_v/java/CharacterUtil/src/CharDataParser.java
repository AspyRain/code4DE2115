

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class CharDataParser {

    public static List<CharacterData> parseCharDataFromFile(String filePath) {
        List<CharacterData> charDataList = new ArrayList<>();
        List<String> currentData = new ArrayList<>();
        String currentName = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                line = line.trim(); // 去除行首行尾的空白字符
                String[] items = line.split(",");
                // 查找 "//" 并检查其后是否有非空白字符
                int commentIndex = line.indexOf("//");
                if (commentIndex != -1) {
                    // 截取 "//" 后面的字符名称
                    currentName = line.substring(commentIndex + 2).trim();
                    // 截取 "//" 之前的数据作为字模数据
                    items = line.substring(0, commentIndex).trim().split(",");
                    for (int i =0; i < items.length; i++) {
                        currentData.add(items[i]);
                    }
                    // 如果当前已经有字符名称，保存当前数据
                    if (currentName != null && !currentData.isEmpty()) {
                        charDataList.add(new CharacterData(currentData, currentName));
                        currentData = new ArrayList<>(); // 重置当前数据列表
                        currentName = null; // 重置字符名称
                    }
                } else if (!line.isEmpty()) {
                    for (int i =0; i < items.length; i++) {
                        currentData.add(items[i]);
                    }
                }
            }
            // 检查文件末尾是否有未保存的数据
            if (currentName != null && !currentData.isEmpty()) {
                charDataList.add(new CharacterData(currentData, currentName));
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return charDataList;
    }
    public static List<String> parseToVGA(List<CharacterData> charDataList) {
        List<String> charData = new ArrayList<>();

        for (int i = 0 ;i<16;i++){
            String data="";
            for (int j = 0; j<charDataList.size();j++) {
                data+=charDataList.get(j).getCharData().get(i*2);
                data+=charDataList.get(j).getCharData().get(i*2+1);
            }
            charData.add(data);
        }
        return charData;
    }
    public static void writeToFile(List<String> charDataList, String filePath) {
        int dataSize = 16; // 每行数据的大小
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {

            // 写入文件
            for (int i = 0; i < charDataList.size(); i++) {
                String lineName = "char_line" + String.format("%02x", i) + "=240'h";
                writer.write(lineName);
                writer.write(charDataList.get(i));
                if(i==charDataList.size()-1){
                    writer.write(";");
                }else {
                    writer.write(",");
                }
                writer.newLine(); // 添加换行符以便分隔每行数据
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        // 假设你的文件路径是 "path/to/your/notepad.txt"
        List<CharacterData> charDataList = parseCharDataFromFile("E:/file.txt");
        // 打印结果，以验证解析是否正确
        for (CharacterData data : charDataList) {
            System.out.println("Character Name: " + data.getCharaName());
            for (String line : data.getCharData()) {
                System.out.println(line);
            }
        }
        List<String> charDataList2 = parseToVGA(charDataList);
        for (String line : charDataList2) {
            System.out.println(line);
        }
        writeToFile(charDataList2, "E:/file_out.txt");
    }
}