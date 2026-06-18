import g4p_controls.*;

// VARIABLES
ArrayList<Cat> cats;
ArrayList<Kitten> kittens;
ArrayList<Sample> samples;

boolean sampleTaken;

float dragX, dragY; 

int screen = 0;    // home (0)  samples (1)    enzymes (2)  gel setup (3)
int numRacks = 3;
int animationStartTime;
int animationStep = 1;

// this is like a tolerance window, so the code only accepts a match if it is within
// <sensitivity> base difference with another one
int sensitivity = 0;
    
PImage plate, machine, holder1, holder2, holder3, logo;

String[] options;
String[] enzymeOptions = {"EcoRI", "BamHI", "HindIII"};
String result = "";

Enzyme enzyme; 

Cat draggedCat = null;
Cat placedCat = null;
Cat selectedCat = null;
Cat infoCat = null;

Kitten caseKitten;

void setup() {
  size(1000, 650);
  background(100, 200, 255);

  // initialize images and variables
  plate = loadImage("plate.png");
  machine = loadImage("machine_1.png");
  logo = loadImage("logo.png");
  
  cats = new ArrayList<Cat>();
  kittens = new ArrayList<Kitten>();
  samples = new ArrayList<Sample>();
  enzyme = new Enzyme("EcoRI", "GAATTC");

  // initialize available cats and kittens, and draw sample racks
  loadCats();
  loadKittens();
  loadRacks();
   
  // draw g4p window and populate drop down lists
  createGUI();
  createDropdownLists();
  
  surface.setLocation(350, 0); // use setLocation to ensure windows don't overlap  
}

void draw() {
  // reset the background every loop
  background(100, 200, 255);
   
  // draw logo
  if (screen == 0) {
   drawHomeScreen(); 
  }
  
  // draw the sample taking screen
  if (screen == 1) {
    // sample screen GUI objects
    sampleButton.setVisible(true);
    label1.setVisible(true);
    label2.setVisible(true);
    caseDropdown.setVisible(true);
    caseButton.setVisible(true);
    enzymeDropdown.setVisible(true);
    
    // the retake button will only appear if a cat has been dragged onto the plate
    if (placedCat != null) {
      retakeButton.setVisible(true);
    }
    else {
      retakeButton.setVisible(false);      
    }
    // function to take care of sample screen logic
    loadSampleScreen(); 
  }
  else {
    // set visibility of sample screen objects to false
    sampleButton.setVisible(false);
    label1.setVisible(false);
    label2.setVisible(false);
    caseDropdown.setVisible(false);
    caseButton.setVisible(false);
    enzymeDropdown.setVisible(false);
    retakeButton.setVisible(false);
  }
  
  // this screen visualized how a restriction enzyme creates fragments, this screen has no objects
  if (screen == 2) { 
    drawEnzymeScreen();
  }
  
  // analysis screen where the user can view data samples and guess the father of the kitten
  if (screen == 3) {
    // set visibility of objects to true
    label7.setVisible(true);
    sensitivitySlider.setVisible(true);
    checkButton.setVisible(true);
    sample1Box.setVisible(true);
    sample2Box.setVisible(true);
    sample3Box.setVisible(true);
    
    // set checkbox options to the names of retrieved sample cats
    sample1Box.setText(samples.get(0).cat.name);
    sample2Box.setText(samples.get(1).cat.name);
    sample3Box.setText(samples.get(2).cat.name);
    
    //function to take care of analysis screen logic
    drawGelPad();
    
    // if the paternity result has been determined, display it
    if (!result.equals("")) {
      textSize(14);
      textAlign(LEFT);
      text(result, 70, 575);
    }
  }
  else {
    // set visibility of objects to false
    label7.setVisible(false);
    checkButton.setVisible(false);
    sensitivitySlider.setVisible(false);
    sample1Box.setVisible(false);
    sample2Box.setVisible(false);
    sample3Box.setVisible(false); 
    
    // reset checkboxes
    sample1Box.setSelected(false);
    sample2Box.setSelected(false);
    sample3Box.setSelected(false);
  }  
}
