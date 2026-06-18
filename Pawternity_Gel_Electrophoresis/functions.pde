// draws the kitten dna ladder at a certain x position
void drawKittenBands(float laneX) {
  // get the kitten's dna sequence
  String dna = caseKitten.loadDnaProfile();
  
  // get fragments from DNA
  ArrayList<Integer> bands = enzyme.getFragments(dna);
  
  // loop through every band size and get the largest fragment base to determine the bounds of the ladder
  float maxBP = 100;
  
  // use a dark blue color for the DNA bands
  fill(10, 20, 80);
  noStroke();

  //for every fragment
  for (int size : bands) {

    // convert the length of a fragment to a pixel vertical height
    float y = map(size, 0, maxBP, 455, 75);

    // draw the band
    rect(laneX - 18, y - 2, 36, 5);
  }
}

// draw the bands of the cats
void drawSampleBands(Sample s, float laneX) {

  // check every band size and get the largest one to determine grid size
  float maxBP = 100;

  fill(10, 20, 80);
  noStroke();

  // for each fragment, convert the length of the fragment to a pixel y position
  for (int size : s.bandSizes) {
    float y = map(size, 0, maxBP, 455, 75);

    rect(laneX - 18, y - 2, 36, 5);
  }
}

// compares two lists of DNA bands and figures out ow many of them match
int countMatchingBands(ArrayList<Integer> kittenBands, ArrayList<Integer> fatherBands) {
  int matches = 0;
  
  // tracks which bands from the father cat has already been analyzed
  boolean[] used = new boolean[fatherBands.size()]; 

  //loop through every band in the kitten DNA
  for (int kb : kittenBands) {
  
    // stores index of the matching band from the father's DNA
    int bestIndex = -1;

    for (int i = 0; i < fatherBands.size(); i++) {
      
      // if this band has already been matched, skip to the next one
      if (used[i]) {
        continue;
      }
      
      // calculate how close the kitten bad is to the father band
      // in terms of length
      int diff = abs(kb - fatherBands.get(i));

      // check if this band is more closer to a match than the other ones 
      if (diff <= sensitivity) {
        
        // update the closest difference so far
        sensitivity = diff;
        bestIndex = i;
      }
    }
  
    // if a match has already been found, mark that band as used
    if (bestIndex != -1) {
      used[bestIndex] = true;
      
      // increase the number of matched bands
      matches++;
    }
  }
  return matches;
}

// calculate the percentage match between a kitten and a cat
float calculateMatchPercent(ArrayList<Integer> kittenBands, ArrayList<Integer> fatherBands) {

  // matched bands between kitten and father
  int matches = countMatchingBands(kittenBands, fatherBands);

  // return a percentage based on the number of matched bands in comparison to the kitten DNA bands
  return 100.0f * matches / kittenBands.size();
}

// updates the information box with information on a cat or kitten
void updateInformationBox() {
  // variables
  String info = "";
  String name = "";
  String[] traits = null;
  
  // if a cat has been selected, then display its information. 
  // default to show a cat's information over a kittens information
  if (infoCat != null) {
    name = infoCat.name;
    traits = infoCat.traits;
  } 
  
  // if a case kitten has been selected, show its information
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
  
  // if a cat hasn't been selected, set a default message
  else {
    info = "Select a cat or case to view profile.";
  }
  
  // update the text area object
  infoBox.setText(info);
}

// determines the kcat that is most likely the father of the kitten
Cat findLikelyFather() {
  
  // load the kitten's DNA and process it by cutting it using the enzyme and generating the bands
  ArrayList<Integer> kittenBands = enzyme.getFragments(caseKitten.loadDnaProfile());
  float bestScore = -1;    // stores highest match percentage so far
  Cat bestCat = null;      // highest scoring cat

  // check every cat sample tested
  for (Sample s : samples) {
    
    // compute once per sample, get cat band DNA
    ArrayList<Integer> fatherBands = enzyme.getFragments(s.cat.loadDnaProfile());

    // stores how similar the cat is to the kitten
    float score = calculateMatchPercent(kittenBands, fatherBands);

    // if this score is better than the previous ones, this cat is the closest match to the kitten's DNA.
    if (score > bestScore) {
      bestScore = score;
      bestCat = s.cat;
    }
  }
  return bestCat;
}

// populate G4P dropdown lists
void createDropdownLists() {
  // initialize and fill the options array with kitten names (dropdowns expect string[] parameters)
  options = new String[kittens.size()];

  // set options to be the same as the kitten items
  for (int i = 0; i < kittens.size(); i++) {
    options[i] = kittens.get(i).name;
  }
  
  // set default items
  caseDropdown.setItems(options, 0);
  enzymeDropdown.setItems(enzymeOptions, 0);
  
  // set default case kitten to avoid null pointer exception
  caseKitten = kittens.get(0);
}

// initialize samples to empty racks
void loadRacks() {
  for (int i = 0; i < numRacks; i ++) {
    // create sample
    Sample sample = new Sample(500+i*150, 300);
    
    // add sample to list
    samples.add(sample);
  } 
}

// load all cats from the data file
void loadCats() {
  
  // read txt file data
  String[] lines = loadStrings("data/cats.txt");
  
  // go through every line
  for (int i = 0; i < lines.length; i += 3) {

    // load all cat data (info) and split the last line of the info into traits
    String[] info = split(lines[i], ',');
    String[] traits = split(lines[i + 1], ',');

    // create a new cat using info data
    Cat cat = new Cat(info[0], info[1], traits);
    
    // add the cat to the list
    cats.add(cat);
  }
}

// a similar function to load data on all the kittens
void loadKittens() {
  
  // read data from the txt file
  String[] lines = loadStrings("data/kittens.txt");
  
  // run through the lines to get kitten information
  for (int i = 0; i < lines.length; i += 3) {
    String[] info = split(lines[i], ',');
    String[] traits = split(lines[i + 1], ',');
    
    // create a new kitten, and add it to the list of kittens
    Kitten kitten = new Kitten(info[0], traits);
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
  
  // if we are on the sample screen, check if a cat has been selected.
  if (screen == 1) {  
    // for each cat in the list, check which cat is being pressed
    for (int i = 0; i < cats.size(); i++) {
      int row = i / 6;
      int col = i % 6;
      int x = 25 + col * 90; 
      int y = 65 + row * 155;
  
      // if the mouse click is within the image icon
      if (mouseX >= x && mouseX <= x + 75 && mouseY >= y && mouseY <= y + 75) {
        
        // set the dragged cat and info cat to the selected cat
        draggedCat = cats.get(i); 
        infoCat = cats.get(i); 
        
        // update the text area with info on the selected cat
        updateInformationBox();
        
        // update the drag mouse positions
        dragX = mouseX;
        dragY = mouseY;
        
        // we can break the loop because we have already found the selected cat
        break; 
      }
    }
    
    // check if a sample has been selected
    for (int i = 0; i < samples.size(); i++) {
      Sample s = samples.get(i);
      
      // if the mouse position is close enough
      if (mouseX >= s.x_pos && mouseX <= s.x_pos + 175 &&
          mouseY >= s.y_pos && mouseY <= s.y_pos + 300) {
            
        // if the sample is not empty
        if (s.filled) {

          // reset the sample
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
