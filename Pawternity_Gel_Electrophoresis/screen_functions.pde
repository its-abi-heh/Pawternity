void drawHomeScreen() {
  println(0);
  imageMode(CENTER);
  image(logo, 500, 325);
  
}

void drawKittenBands(float laneX, float gelY, float gelHeight) {

  if (caseKitten == null || enzyme == null) {
    return;
  }
  
  String dna = caseKitten.loadDnaProfile();
  if (dna == null) {
    return;
  }
  
  ArrayList<Integer> bands = enzyme.getFragments(dna);
  if (bands == null || bands.size() == 0) {
    return;
  }
  
  float maxBP = 0;
  for (int b : bands) {
    if (b > maxBP) maxBP = b;
  }

  if (maxBP <= 0) {
    return;
  }
  fill(10, 20, 80);
  noStroke();

  for (int size : bands) {

    float y = map(size, 0, maxBP, 65 + 400 - 10, 65 + 10);

    rect(laneX - 18, y - 2, 36, 5);
  }
}

void drawSampleBands(Sample s, float laneX, float gelY, float gelHeight) {

  if (s == null || s.cat == null || s.bandSizes == null) {
    return;
  }
  if (s.bandSizes.size() == 0) {
    return;
  }
  float maxBP = 0;

  for (int b : s.bandSizes) {
    if (b > maxBP) maxBP = b;
  }

  if (maxBP <= 0) {
    return;
  }
  
  fill(10, 20, 80);
  noStroke();

  for (int size : s.bandSizes) {

    float y = map(size, 0, maxBP, 65 + 400 - 10, 65 + 10);

    rect(laneX - 18, y - 2, 36, 5);
  }
}

void drawGelPad() {

  background(210);
  fill(235);
  stroke(90);
  rect(220, 65, 560, 400);

  float[] sampleLaneX = new float[3];

  for (int i = 0; i < 3; i++) {
    sampleLaneX[i] = 290 + 140 * (i + 1);
  }

  // lane dividers
  stroke(140);
  for (int i = 1; i < 4; i++) {
    float x = 220 + 140 * i;
    line(x, 65, x, 465);
  }

  // labels
  fill(0);
  textAlign(CENTER);
  textSize(14);

  if (caseKitten != null) {
    text(caseKitten.name, 290, 65 - 15);
  }

  for (int i = 0; i < samples.size() && i < 3; i++) {
    if (samples.get(i).cat != null) {
      text(samples.get(i).cat.name, sampleLaneX[i], 65 - 15);
    }
  }

  // bp ladder
  int[] bp = {800,700,600,500,400,300,200,100};

  textAlign(RIGHT);
  textSize(10);

  for (int b : bp) {

    // 800 at top, 100 at bottom
    float y = map(b, 800, 100, 100, 430);

    fill(0);
    text(b, 220 - 8, y);

    stroke(170);
    line(220, y, 220 + 560, y);
  }

  if (caseKitten != null) {
    drawKittenBands(290, 100, 430 - 100);
  }

  for (int i = 0; i < samples.size() && i < 3; i++) {
    drawSampleBands(samples.get(i), sampleLaneX[i], 100, 430 - 100);
  }
  
  fill(100, 200, 255);
  rect(0, 500, 1000, 800);
  fill(0);
  textSize(20);
  text("Who is " + caseKitten.name + "'s father?", 250, 550);
}

void drawEnzymeScreen() {

  float startX = 50;
  float startY = 100;

  animationStep = (millis() - animationStartTime) / 5000 + 1;
  
  if (animationStep > 5) {
    animationStep = 5;
  }
  
  fill(255);
  textAlign(CENTER);
  textSize(26);

  String stepDescription = "";

  if (animationStep == 1) {
    stepDescription = "Step 1: DNA Sample Loaded";
  }
  else if (animationStep == 2) {
    stepDescription = "Step 2: Enzyme " + enzyme.name + " binds " + enzyme.recognitionSite;
  }
  else if (animationStep == 3) {
  stepDescription = "Step 3: DNA Cut";
  }
  else if (animationStep == 4) {
  stepDescription = "Step 4: Fragments Formed";
  }
  else {
  stepDescription = "Step 5: Ready for Gel";
  }

  text(stepDescription, width/2, 40);

  for (int i = 0; i < samples.size(); i++) {

    Sample s = samples.get(i);

    if (s == null || s.cat == null) {
      continue;
    }
    
    float y = startY + i * 140;

    fill(0);
    textAlign(LEFT);
    textSize(16);

    text(s.cat.name, startX, y - 20);

    s.drawDNA(startX, y);

    if (animationStep >= 3) {
      s.drawCutSites(startX, y + 30);
    }
    if (animationStep >= 4) {
      s.drawFragments(startX, y + 60);
    }
    if (animationStep >= 5) {
      s.drawFragmentLabels(startX, y + 90);
    }
  }
}

void loadSampleScreen() {
  textAlign(LEFT); 
  int cols = Math.min(cats.size(), 6); 
  int spacing = 15;
  int iconSize = 75;
  int rows = ceil((float)cats.size() / cols);
  int boxWidth = cols * iconSize + (cols + 1) * spacing;
  int boxHeight = rows * (iconSize + 40) + (rows + 1) * spacing;
  
  // background panels
  fill(220); 
  noStroke();
  rect(10, 50, boxWidth, boxHeight);
  rect(boxWidth + 25, 50, 400, boxHeight);

  // title
  fill(0);
  textSize(24);
  text("Select a Cat to Sample", 10, 30);

  // draw cat grid
  for (int i = 0; i < cats.size(); i++) {
    int row = i / cols;
    int col = i % cols;
    int x = 10 + spacing + col * (iconSize + spacing); 
    int y = 50 + spacing + row * (iconSize + 40 + spacing);

    Cat c = cats.get(i);
    if (c.img != null) {
      imageMode(CORNER);
      image(c.img, x, y, iconSize, iconSize);
    }

    fill(0);
    textSize(14);
    textAlign(CENTER);
    text(c.name, x + 37, y + 95);
  }
  
  for (int i = 0; i < samples.size(); i++) {
    samples.get(i).drawRack();  
  }
  
  // draw machine and Plate
  image(machine, 250, 330, 225, 225);
  image(plate, 25, 350, 200, 200);

  // draw a cat if placed onto the plate
  if (placedCat != null) {
    image(placedCat.img, 65, 390, 120, 120); 
  }

  // draw a dragged cat
  if (draggedCat != null) {
    image(draggedCat.img, dragX - 37, dragY - 37, 75, 75);
  }
}
