class Enzyme {
  String name;
  String recognitionSite;

  Enzyme(String n, String site) {
    name = n;
    recognitionSite = site;
  }

  ArrayList<Integer> findCutSites(String dna) {
    ArrayList<Integer> cuts = new ArrayList<Integer>();

    for (int i = 0; i <= dna.length() - recognitionSite.length(); i++) {
      String section = dna.substring(i, i + recognitionSite.length());
      if (section.equals(recognitionSite)) {
        cuts.add(i+1);
      }
    }
    return cuts;
  }

  ArrayList<Integer> getFragments(String dna) {
    ArrayList<Integer> cuts = findCutSites(dna);
    ArrayList<Integer> fragments = new ArrayList<Integer>();
  
    int previousCut = 0;

    for (int cut : cuts) {
      fragments.add(cut - previousCut);
      previousCut = cut;
    }

    fragments.add(dna.length() - previousCut);

    return fragments;
  }

  ArrayList<String> digest(String dna) {
    ArrayList<String> fragments = new ArrayList<String>();
    ArrayList<Integer> cuts = findCutSites(dna);

    int start = 0;

    for (int cut : cuts) {
      fragments.add(dna.substring(start, cut));
      start = cut;
    }

    fragments.add(dna.substring(start));

    return fragments;
  }
}
