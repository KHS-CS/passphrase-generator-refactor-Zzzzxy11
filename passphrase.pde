String[] words = new String[66667];
ArrayList<String> current = new ArrayList<String>();
ArrayList<String> saved = new ArrayList<String>();

int selected = -1;

PFont fontBig, fontSmall;

void setup() {
  size(1000, 800);
  fontBig = createFont("Arial", 48);
  fontSmall = createFont("Arial", 22);

  String[] lines = loadStrings("eff_large_wordlist.txt");
  for (int i = 0; i < lines.length; i++) {
    String[] p = lines[i].split("\t");
    words[int(p[0])] = p[1];
  }
}

void keyPressed() {
  if (key == ' ' || key == ENTER || key == RETURN) {
    String code = "";
    for (int i = 0; i < 5; i++) code += int(random(1, 7));
    current.add(words[int(code)]);
    selected = current.size() - 1;
  }

  if (key == 'r' || key == 'R') saved.add(join(current.toArray(new String[0]), ""));
  if (key == 's' || key == 'S') saveStrings("saved_passwords.txt", saved.toArray(new String[0]));

  if (keyCode == RIGHT && current.size() > 0) selected = min(selected + 1, current.size() - 1);
  if (keyCode == LEFT && current.size() > 0) selected = max(selected - 1, 0);

  if (key == '1' && selected >= 0) {
    String w = current.get(selected);
    if (w.length() > 0) {
      if (Character.isUpperCase(w.charAt(0)))
        current.set(selected, w.substring(0,1).toLowerCase()+w.substring(1));
      else
        current.set(selected, w.substring(0,1).toUpperCase()+w.substring(1));
    }
  }

  if (key == '2' && selected >= 0) {
    String w = current.get(selected);
    if (w.equals(w.toUpperCase()))
      current.set(selected, w.toLowerCase());
    else
      current.set(selected, w.toUpperCase());
  }

  if (keyCode == DELETE || keyCode == BACKSPACE) {
    if (current.size() > 0) {
      current.remove(selected);
      selected = min(selected, current.size() - 1);
    }
  }
}

void draw() {
  background(250);

  String combined = "";
  for (String w : current) combined += w;

  textFont(fontBig);
  float tw = textWidth(combined);

  float desired = 900 / tw * 48;
  float finalSize = constrain(desired, 12, 48);
  textFont(createFont("Arial", finalSize));

  float spacing = 0;
  float totalWidth = 0;
  for (String w : current) totalWidth += textWidth(w) + spacing;

  float x = width/2 - totalWidth/2;
  float y = height * 0.30;

  for (int i = 0; i < current.size(); i++) {
    String w = current.get(i);
    float ww = textWidth(w);

    if (i == selected) fill(220,40,40);
    else fill(0);

    text(w, x, y);
    x += ww + spacing;
  }

  textFont(createFont("Arial", 30));
  fill(0);
  text("Saved Passwords:", 80, height * 0.45);

  float yy = height * 0.50;
  for (String s : saved) {
    text(s, 80, yy);
    yy += 28;
  }

  textFont(createFont("Arial", 14));
  fill(80);
  float bx = 80;

  text("SPACE = generate word", bx, height - 120);
  text("R = record   |   S = save to file", bx, height - 100);
  text("← / → = select word", bx, height - 80);
  text("1 = toggle first-letter uppercase", bx, height - 60);
  text("2 = toggle ALL CAPS", bx, height - 40);

}
