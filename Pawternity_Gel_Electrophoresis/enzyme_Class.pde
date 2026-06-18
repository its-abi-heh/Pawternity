// Enzyme class
class Enzyme {
  // FIELDS
  String name;
  String recognitionSite;

  // CONSTRUCTOR
  Enzyme(String n, String site) {
    name = n;
    recognitionSite = site;
  }
  
  // METHODS
  
  // returns all positions where the enzyme will cut the DNA
  ArrayList<Integer> findCutSites(String dna) {
    
    // stores cut positions
    ArrayList<Integer> cuts = new ArrayList<Integer>();

    // run through whole DNA segment
    for (int i = 0; i <= dna.length() - recognitionSite.length(); i++) {
      
      // take out DNA segments equal to the length of the recognition site
      String section = dna.substring(i, i + recognitionSite.length());
      
      // if the section matches the recognition site, a cut will be made there
      if (section.equals(recognitionSite)) {
        cuts.add(i+1);
      }
    }
    return cuts;
  }

  // returns the lengths of DNA fragments after cuts
  ArrayList<Integer> getFragments(String dna) {
    
    // retrieve the position of cuts in the full DNA sequence
    ArrayList<Integer> cuts = findCutSites(dna);
    
    // store fragments
    ArrayList<Integer> fragments = new ArrayList<Integer>();
  
    // store position of last fragment
    int previousCut = 0;

    for (int cut : cuts) {
      
      // calculate difference between cuts
      fragments.add(cut - previousCut);
      previousCut = cut;
    }
    
    // adds the final fragment after the last cut to the end of the DNA
    fragments.add(dna.length() - previousCut);

    return fragments;    // Ex. [10, 5, 20];
  }

  // this function is called "digest" because the enzymes process the DNA 
  // and then return the actual DNA fragments
  ArrayList<String> digest(String dna) {
    
    // once again, initialize fragments and retrieve location of cuts on the sequence
    ArrayList<Integer> cuts = findCutSites(dna);
    ArrayList<String> fragments = new ArrayList<String>();

    int start = 0;

    // loop through all cut positions
    for (int cut : cuts) {
      
      // a fragment spans from the beginning position to the next cut sight
      fragments.add(dna.substring(start, cut));
      start = cut;
    }

    // add the leftover fragment
    fragments.add(dna.substring(start));

    // return the list of DNA strings
    return fragments;
  }
}
