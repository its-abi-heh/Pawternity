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
