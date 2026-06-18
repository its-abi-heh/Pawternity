// Cat class- father cats
class Cat {
  // FIELDS
  String name;
  String[] traits;
  PImage img;
   
  // CONSTRUCTOR
  Cat(String n, String fp, String[] t) {
    this.name = n;
    this.img = loadImage(fp);
    this.traits = t;
  }
 
  // METHODS
  
  // this method gets the dna sequence of the cat from the data file. 
  String loadDnaProfile() {
    // read data from file
    String[] lines = loadStrings("data/catSamples.txt");
    
    for (int i = 0; i < lines.length; i++) {
      // if this line matches the cat's name exactly
      if (lines[i].equals(name)) {
        // the line after the cat's name is the DNA sequence
        return lines[i + 1];
      }
    }
    return null;
  }
}
