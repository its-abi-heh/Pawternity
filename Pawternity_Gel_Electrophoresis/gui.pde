/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void takeSample(GButton source, GEvent event) { //_CODE_:sampleButton:691472:
  if (placedCat != null) {    
      String dnaData = placedCat.loadDnaProfile();
  
      for (int i = 0; i < samples.size(); i++) {
        Sample s = samples.get(i);    
        if (s.filled == false) {
          
          s.dnaSequence = dnaData;
          
          // FIX: Calculate and save the enzyme cuts and fragments into the sample object!
          if (enzyme == null) {
            enzyme = new Enzyme("EcoRI", "GAATTC"); // Emergency fallback initialization
          }
          s.cutSites = enzyme.findCutSites(s.dnaSequence);
          s.fragments = enzyme.digest(s.dnaSequence); // This stops the NullPointerException on Line 4!
          s.generateBands(enzyme);

          s.cat = placedCat;
          s.filled = true;
          
          break;
        }
      }
        
      placedCat = null;
    }
  
  //loadTestSamples();
  
} //_CODE_:sampleButton:691472:

public void caseSelected(GDropList source, GEvent event) { //_CODE_:caseDropdown:955074:
  println("caseDropdown - GDropList >> GEvent." + event + " @ " + millis());
} //_CODE_:caseDropdown:955074:

public void showCaseInfo(GButton source, GEvent event) { //_CODE_:caseButton:275004:
  int selectedIndex = caseDropdown.getSelectedIndex();
 
  caseKitten = kittens.get(selectedIndex);
  updateInformationBox();
} //_CODE_:caseButton:275004:

public void enzymeSelected(GDropList source, GEvent event) { //_CODE_:enzymeDropdown:210050:
  String selectedEnzyme = enzymeDropdown.getSelectedText();
  
  println(selectedEnzyme);
  if (selectedEnzyme.equals("EcoRI")) {
    enzyme = new Enzyme("EcoRI", "GAATTC");
  }
  else if (selectedEnzyme.equals("BamHI")) {
    enzyme = new Enzyme("BamHI", "GGATCC");
  }
  else {
    enzyme = new Enzyme("HindIII", "AAGCTT");    
  }

  // FIX: Force all currently held tubes to instantly recalculate with the new enzyme choice
  for (int i = 0; i < samples.size(); i++) {
    Sample s = samples.get(i);
    if (s.filled && s.dnaSequence != null) {
      s.cutSites = enzyme.findCutSites(s.dnaSequence);
      s.fragments = enzyme.digest(s.dnaSequence);
      s.generateBands(enzyme);
    }
  }
} //_CODE_:enzymeDropdown:210050:

public void removeSample(GButton source, GEvent event) { //_CODE_:retakeButton:320982:
  placedCat = null;
} //_CODE_:retakeButton:320982:

public void sample1Selected(GCheckbox source, GEvent event) { //_CODE_:sample1Box:299050:
  if (!sample2Box.isSelected() && !sample3Box.isSelected()) {
    selectedCat = samples.get(0).cat;
  }
} //_CODE_:sample1Box:299050:

public void sample3Selected(GCheckbox source, GEvent event) { //_CODE_:sample3Box:662928:
  if (!sample2Box.isSelected() && !sample1Box.isSelected()) {
    selectedCat = samples.get(1).cat;
  }
} //_CODE_:sample3Box:662928:

public void sample2Selected(GCheckbox source, GEvent event) { //_CODE_:sample2Box:342753:
  if (!sample1Box.isSelected() && !sample3Box.isSelected()) {
    selectedCat = samples.get(2).cat;
  }
} //_CODE_:sample2Box:342753:

synchronized public void win_draw1(PApplet appc, GWinData data) { //_CODE_:window1:528241:
  appc.background(230);
} //_CODE_:window1:528241:

public void infoChanged(GTextArea source, GEvent event) { //_CODE_:infoBox:755543:
  println("infoBox - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:infoBox:755543:

public void goHome(GButton source, GEvent event) { //_CODE_:homeButton:825313:
  println("homeButton - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:homeButton:825313:

public void goSampleScreen(GButton source, GEvent event) { //_CODE_:collectButton:715923:
  screen = 1;
} //_CODE_:collectButton:715923:

public void goVisualize(GButton source, GEvent event) { //_CODE_:visualizeButton:568749:
  boolean allSamplesFilled = true; // Start by assuming everything is perfect
    
    for (int i = 0; i < samples.size(); i++) {
      Sample s = samples.get(i);    
      
      if (s.filled == false) {
        allSamplesFilled = false;
        break; 
      }
    }
    
    if (allSamplesFilled == true && enzyme != null) {
      screen = 2;
      animationStartTime = millis();
      
    } else {
      println("You must fill ALL 3 sample slots and select an enzyme first.");
    }
} //_CODE_:visualizeButton:568749:

public void goEvaluate(GButton source, GEvent event) { //_CODE_:evaluateCaseButton:379020:
  boolean allSamplesFilled = true; // Start by assuming everything is perfect
    
    for (int i = 0; i < samples.size(); i++) {
      Sample s = samples.get(i);    
      
      if (s.filled == false) {
        allSamplesFilled = false;
        break; 
      }
    }
    
    if (allSamplesFilled == true && enzyme != null) {
      screen = 3;
      animationStartTime = millis();
      
    } else {
      println("You must fill ALL 3 sample slots and select an enzyme first.");
    }
} //_CODE_:evaluateCaseButton:379020:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  sampleButton = new GButton(this, 374, 485, 80, 30);
  sampleButton.setText("SCAN");
  sampleButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  sampleButton.addEventHandler(this, "takeSample");
  label1 = new GLabel(this, 610, 80, 80, 20);
  label1.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label1.setText("Select Case");
  label1.setOpaque(false);
  caseDropdown = new GDropList(this, 610, 110, 340, 100, 4, 10);
  caseDropdown.setItems(loadStrings("list_955074"), 0);
  caseDropdown.addEventHandler(this, "caseSelected");
  caseButton = new GButton(this, 610, 140, 100, 30);
  caseButton.setText("See Case Info");
  caseButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  caseButton.addEventHandler(this, "showCaseInfo");
  label2 = new GLabel(this, 610, 190, 150, 20);
  label2.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label2.setText("Select Restriction Enzyme");
  label2.setOpaque(false);
  enzymeDropdown = new GDropList(this, 610, 220, 340, 80, 3, 10);
  enzymeDropdown.setItems(loadStrings("list_210050"), 0);
  enzymeDropdown.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  enzymeDropdown.addEventHandler(this, "enzymeSelected");
  retakeButton = new GButton(this, 343, 550, 112, 39);
  retakeButton.setText("Retake Sample");
  retakeButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  retakeButton.addEventHandler(this, "removeSample");
  sample1Box = new GCheckbox(this, 360, 540, 150, 20);
  sample1Box.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sample1Box.setText("checkbox text");
  sample1Box.setOpaque(false);
  sample1Box.addEventHandler(this, "sample1Selected");
  sample3Box = new GCheckbox(this, 360, 575, 150, 20);
  sample3Box.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sample3Box.setText("checkbox text");
  sample3Box.setOpaque(false);
  sample3Box.addEventHandler(this, "sample3Selected");
  sample2Box = new GCheckbox(this, 540, 540, 150, 20);
  sample2Box.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  sample2Box.setText("checkbox text");
  sample2Box.setOpaque(false);
  sample2Box.addEventHandler(this, "sample2Selected");
  window1 = GWindow.getWindow(this, "Window title", 0, 0, 350, 800, JAVA2D);
  window1.noLoop();
  window1.setActionOnClose(G4P.KEEP_OPEN);
  window1.addDrawHandler(this, "win_draw1");
  infoBox = new GTextArea(window1, 20, 340, 300, 108, G4P.SCROLLBARS_NONE);
  infoBox.setOpaque(true);
  infoBox.addEventHandler(this, "infoChanged");
  label3 = new GLabel(window1, 20, 310, 120, 20);
  label3.setText("Information Box");
  label3.setOpaque(false);
  homeButton = new GButton(window1, 20, 20, 300, 50);
  homeButton.setText("Go Home");
  homeButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  homeButton.addEventHandler(this, "goHome");
  collectButton = new GButton(window1, 20, 100, 300, 50);
  collectButton.setText("Collect Samples");
  collectButton.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  collectButton.addEventHandler(this, "goSampleScreen");
  visualizeButton = new GButton(window1, 20, 180, 300, 50);
  visualizeButton.setText("Prep Samples");
  visualizeButton.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  visualizeButton.addEventHandler(this, "goVisualize");
  evaluateCaseButton = new GButton(window1, 20, 250, 300, 40);
  evaluateCaseButton.setText("Evaluate Results");
  evaluateCaseButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  evaluateCaseButton.addEventHandler(this, "goEvaluate");
  label4 = new GLabel(window1, 150, 60, 40, 40);
  label4.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label4.setText("↓ ");
  label4.setOpaque(false);
  label5 = new GLabel(window1, 130, 150, 80, 20);
  label5.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label5.setText("↓ ");
  label5.setOpaque(false);
  label6 = new GLabel(window1, 130, 230, 80, 20);
  label6.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label6.setText("↓ ");
  label6.setOpaque(false);
  window1.loop();
}

// Variable declarations 
// autogenerated do not edit
GButton sampleButton; 
GLabel label1; 
GDropList caseDropdown; 
GButton caseButton; 
GLabel label2; 
GDropList enzymeDropdown; 
GButton retakeButton; 
GCheckbox sample1Box; 
GCheckbox sample3Box; 
GCheckbox sample2Box; 
GWindow window1;
GTextArea infoBox; 
GLabel label3; 
GButton homeButton; 
GButton collectButton; 
GButton visualizeButton; 
GButton evaluateCaseButton; 
GLabel label4; 
GLabel label5; 
GLabel label6; 
