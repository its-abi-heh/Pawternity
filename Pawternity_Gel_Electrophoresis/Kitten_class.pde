class Kitten {
  String name;
  String[] traits;
  
  PImage img;
  
  Kitten(String n, String fp, String[] t) {
    this.name = n;
    this.img = loadImage(fp);
    this.traits = t;
  } 
  
  String loadDnaProfile() {
    String[] lines = loadStrings("data/kittenSamples.txt");
    
     for (int i = 0; i < lines.length; i++) {
       if (lines[i].equals(name)) {
         return lines[i + 1];
       }
     }
     return null;
   }
}
