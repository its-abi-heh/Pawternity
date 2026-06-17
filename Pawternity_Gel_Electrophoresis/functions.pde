int countMatchingBands(ArrayList<Integer> kittenBands, ArrayList<Integer> fatherBands) {
  int matches = 0;
  
  // track which matched bands
  boolean[] fatherBandUsed = new boolean[fatherBands.size()];

  for (int kb : kittenBands) {
    for (int i = 0; i < fatherBands.size(); i++) {
      int fb = fatherBands.get(i);

      // skip this band if it was already paired with a previous kitten band
      if (fatherBandUsed[i]) continue; 
      
      // Allow slight gel measurement error
      if (abs(kb - fb) <= 2) {
        matches++;
        fatherBandUsed[i] = true; // Mark it as used!
        break; // Move to the next kitten band safely
      }
    }
  }

  return matches;
}

Cat findLikelyFather() {
  String kittenDNA = caseKitten.loadDnaProfile();
  ArrayList<Integer> kittenBands = enzyme.getFragments(kittenDNA);
  int bestScore = -1;
  Cat bestCat = null;
  
  if (caseKitten == null || enzyme == null) {
    return null; 
  }

  for (int i = 0; i < samples.size(); i++) {
    Sample s = samples.get(i);

    if (!s.filled || s.cat == null) continue;

    int score = countMatchingBands(kittenBands, s.bandSizes);

    if (score > bestScore) {
      bestScore = score;
      bestCat = s.cat;
    }
  }
  return bestCat;
}

float calculateMatchPercent(ArrayList<Integer> kittenBands, ArrayList<Integer> fatherBands) {
  int matches = countMatchingBands(kittenBands, fatherBands);
  
  if (kittenBands.isEmpty()) {
    return 0.0f;
  }
  return 100.0f * float(matches) / float(kittenBands.size());
}

int traitMatches(String[] kittenTraits, String[] fatherTraits) {
  int matches = 0;

  for (int i = 0; i < kittenTraits.length; i++) {

    if (kittenTraits[i].equals(
        fatherTraits[i])) {

      matches++;
    }
  }
  return matches;
}

void updateInformationBox() {
  String info = "";
  String[] traits = null;
  String name = "";

  if (infoCat != null) {
    name = infoCat.name;
    traits = infoCat.traits;
  } 
  else if (caseKitten != null) {
    name = caseKitten.name;
    traits = caseKitten.traits;
  }

  // generate following structure if traits data was successfully retrieved
  if (traits != null && traits.length >= 4) {
    info = "NAME: " + name + "\n";
    info += "TRAITS:\n";
    info += "Eye color: " + traits[0] + "\n";
    info += "Fur color: " + traits[1] + "\n";
    info += "Fur length: " + traits[2] + "\n";
    info += "Fur pattern: " + traits[3];
  } 
  else {
    info = "Select a cat or case to view profile.";
  }
  infoBox.setText(info);
}

// populate G4P dropdown lists
void createDropdownLists() {
  // initialize and fill the options array with kitten names
  options = new String[kittens.size()];

  for (int i = 0; i < kittens.size(); i++) {
    options[i] = kittens.get(i).name;
  }
  
  caseDropdown.setItems(options, 0);
  enzymeDropdown.setItems(enzymeOptions, 0);
  
  // set default case kitten to avoid null pointer exception
  caseKitten = kittens.get(0);
}

void loadRacks() {
  for (int i = 0; i < numRacks; i ++) {
    Sample sample = new Sample(500+i*150, 300);
    samples.add(sample);
  } 
}

void loadCats() {
  String[] lines = loadStrings("data/cats.txt");

  if (lines == null) {
    return;
  }

  for (int i = 0; i < lines.length; i += 3) {
    if (i + 1 >= lines.length) break; // Safety check
    
    String[] info = split(lines[i], ',');
    String[] traits = split(lines[i + 1], ',');

    Cat cat = new Cat(info[0], info[1], traits);
    cats.add(cat);
  }
}

void loadKittens() {
  String[] lines = loadStrings("data/kittens.txt");
  
  if (lines == null) {
    return;
  }
  
  for (int i = 0; i < lines.length; i += 3) {
    if (i + 1 >= lines.length) break; // Safety check
    
    String[] info = split(lines[i], ',');
    String[] traits = split(lines[i + 1], ',');

    Kitten kitten = new Kitten(info[0], info[1], traits);
    kittens.add(kitten);
  }
}

void mouseDragged() {
  // if dragging a cat, update its position to match the mouse
  if (draggedCat != null && screen == 1) {
    dragX = mouseX;
    dragY = mouseY;
  }
}

void mousePressed() {
  int iconSize = 75; 
  int spacing = 15;
  
  if (screen == 1) {  
    for (int i = 0; i < cats.size(); i++) {
      int row = i / 6;
      int col = i % 6;
      int x = 10 + spacing + col * (iconSize + spacing);
      int y = 50 + spacing + row * (iconSize + 40 + spacing);
  
      if (mouseX >= x && mouseX <= x + iconSize && mouseY >= y && mouseY <= y + iconSize) {
        draggedCat = cats.get(i); 
        infoCat = cats.get(i); 
        
        updateInformationBox();
        
        dragX = mouseX;
        dragY = mouseY;
        
        break; 
      }
    }
    
    for (int i = 0; i < samples.size(); i++) {
      Sample s = samples.get(i);
      if (mouseX >= s.x_pos && mouseX <= s.x_pos + 175 &&
          mouseY >= s.y_pos && mouseY <= s.y_pos + 300) {
        if (s.filled) {
          if (trash != null) {
            trash.play();
          }
          s.filled = false;
          s.cat = null;          
          s.dnaSequence = null;
          break;
        }
      }
    }
  }
}

void mouseReleased() {
  if (draggedCat != null && screen == 1) {
    // check if cat has been dragged onto a plate
    if (mouseX >= 25 && mouseX <= 225 &&
        mouseY >= 350 && mouseY <= 550) {
      
      placedCat = draggedCat; // place cat on plate
    }
    
    // no cat is being dragged anymore
    draggedCat = null; 
  }
}
