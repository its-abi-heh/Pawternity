// Kitten class- cat we want to find the paternity of
class Kitten {
  // FIELDS
  String name;
  String[] traits;
    
  // CONSTRUCTOR
  Kitten(String n, String[] t) {
    this.name = n;
    this.traits = t;
  } 
  
  // METHODS
  
  // this method gets the dna sequence of the cat from the data file. 
  String loadDnaProfile() {
    // read data from file
    String[] lines = loadStrings("data/kittenSamples.txt");
    
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
