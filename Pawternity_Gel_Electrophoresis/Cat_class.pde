class Cat {
 String name;
 String[] traits;
 PImage img;
 
 Cat(String n, String fp, String[] t) {
 this.name = n;
 this.img = loadImage(fp);
 this.traits = t;
 }
 
  String loadDnaProfile() {
    String[] lines = loadStrings("data/catSamples.txt");
    
    for (int i = 0; i < lines.length; i++) {
      // if this line matches the cat's name exactly
      if (lines[i].equals(name)) {

        // split DNA sequence into separate bases
        String dnaData = lines[i + 1];
        return dnaData;
      }
    }
    return null;
  }
}
