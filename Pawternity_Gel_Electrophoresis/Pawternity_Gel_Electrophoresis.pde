import g4p_controls.*;

String enzyme;
String[] options;

int screen = 0;
int numRacks = 3;

ArrayList<Cat> cats;
ArrayList<Kitten> kittens;
ArrayList<Rack> racks;

PImage plate, machine, machine1, machine2, holder1, holder2, holder3;

boolean sampleTaken;

float dragX, dragY; 

Cat draggedCat = null;
Cat placedCat = null;
Kitten caseKitten;

void setup() {
  size(1000, 800);
  background(100, 200, 255);
  
  plate = loadImage("plate.png");
  machine1 = loadImage("machine_1.png");
  machine2 = loadImage("machine_2.png");
  
  cats = new ArrayList<Cat>();
  kittens = new ArrayList<Kitten>();
  racks = new ArrayList<Rack>();
  
  loadCats();
  loadKittens();
  loadRacks();
  
  surface.setLocation(350, 0); // use setLocation to ensure windows don't overlap
  
  createGUI();
  createDropdownLists();
}

void draw() {
  if (screen == 0) {
    background(100, 200, 255);
    
    sampleButton.setVisible(true);
    label1.setVisible(true);
    label2.setVisible(true);
    caseDropdown.setVisible(true);
    caseButton.setVisible(true);
    enzymeDropdown.setVisible(true);

    if (sampleTaken) {
      machine = machine1; 
    }
    else {
      machine = machine2; 
    }
    
    loadSampleScreen(); 
  }
  else {
    sampleButton.setVisible(false);
  }
}
