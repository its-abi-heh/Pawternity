void getSample() {
  
}

void updateInformationBox() {
  String info;

  if (caseKitten != null) {
    String stringTraits = join(caseKitten.traits, ", ");

    info = "NAME: " + caseKitten.name + "\n";
    info += "TRAITS: " + stringTraits;
  }
  else {
   info = "nothing to see here."; 
    
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
  
  caseDropdown.setItems(options, 0);   // defaults to the 1st kitten (index 0)
  enzymeDropdown.setItems(options, 1); // make enzymes later
  
  caseKitten = kittens.get(0);
  //enzyme = kittens.get(1); 
}

void loadRacks() {
  for (int i = 0; i < numRacks; i ++) {
    Rack rack = new Rack(500+i*150, 300);
    racks.add(rack);
  } 
}

void loadCats() {

  // get father cat info and traits from data file
  String[] lines = loadStrings("data/cats.txt");

  for (int i = 0; i < lines.length; i += 3) {
    String[] info = split(lines[i], ',');
    String[] traits = split(lines[i + 1], ',');

    //Cat cat = new Cat(info[0], info[1], traits);
    Cat cat = new Cat(info[0], "mittens.png", traits);

    cats.add(cat);
  }
}

void loadKittens() {

  // get kitten data from text file
  String[] lines = loadStrings("data/kittens.txt");

  for (int i = 0; i < lines.length; i += 3) {
    String[] info = split(lines[i], ',');
    String[] traits = split(lines[i + 1], ',');

    Kitten kitten = new Kitten(info[0], "mittens.png", traits);
    kittens.add(kitten);
  }
}


void mouseDragged() {
  // if dragging a cat, update its position to match the mouse
  if (draggedCat != null) {
    dragX = mouseX;
    dragY = mouseY;
  }
}
void mousePressed() {
  int iconSize = 75; 
  int cols = Math.min(cats.size(), 6);
  if (cols < 1) cols = 1;
  
  int spacing = 15;

  for (int i = 0; i < cats.size(); i++) {
    int row = i / cols;
    int col = i % cols;
    int x = 10 + spacing + col * (iconSize + spacing);
    int y = 50 + spacing + row * (iconSize + 40 + spacing);

    // check if click hits inside the actual 75x75 cat icon
    if (mouseX >= x && mouseX <= x + iconSize && mouseY >= y && mouseY <= y + iconSize) {
      draggedCat = cats.get(i); 
      dragX = mouseX;
      dragY = mouseY;
      break; 
    }
  }
  
  print(mouseX, mouseY);
}

void mouseReleased() {
  if (draggedCat != null) {
    // check if cat has been dragged onto a plate
    if (mouseX >= 25 && mouseX <= 225 &&
        mouseY >= 350 && mouseY <= 550) {
      
      placedCat = draggedCat; // place cat on plate
    }
    
    // no cat is being dragged anymore
    draggedCat = null; 
  }
}
