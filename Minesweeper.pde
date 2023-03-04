import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public static int NUM_MINES = 50;
public static boolean firstClick = true;
public static boolean gameOver = false;
public static int numCounter = 0;
public static int flagsLeft = 0;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 450);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  //your code to initialize buttons goes here
  for (int i = 0; i < NUM_ROWS; i ++) {
    for (int k = 0; k < NUM_COLS; k++) {
      buttons[i][k] = new MSButton(i, k);
      buttons[i][k].myNum = numCounter;
      numCounter++;
    }
    numCounter++;
  }


  setMines();
}
public void setMines()
{
  for (int i = 0; i < NUM_MINES; i++) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    } else {
      NUM_MINES--;
    }
  }
  flagsLeft = NUM_MINES;
}

public void draw ()
{
  background( 0 );
  textSize(15);
  fill(255);
  if (isWon() == true) {
    displayWinningMessage();
    text("YOU WON :DDDDD", 250, 425);
  } else if(gameOver && mines.get(0).clicked){
   text("YOU LOST :CCC", 250, 425); 
  }
  text("Num Flags: " + flagsLeft, 75, 425);
}
public boolean isWon()
{
  for (int row = 0; row < NUM_ROWS; row++) {
    for (int col = 0; col < NUM_COLS; col++) {
      if (!buttons[row][col].isFlagged() && mines.contains(buttons[row][col])) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  gameOver = true;
  for (int i = 0; i < mines.size(); i++) {
    mines.get(i).clicked = true;
  }
}
public void displayWinningMessage()
{
  //your code here
}
public boolean isValid(int r, int c)
{
  return (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row-1; r<=row+1; r++) {
    for (int c = col-1; c<=col+1; c++) {
      if (isValid(r, c) && mines.contains(buttons[r][c])) {
        numMines++;
      }
    }
  }
  if (mines.contains(buttons[row][col])) {
    numMines--;
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol, myNum;
  private float x, y, width, height;
  private boolean clicked, flagged, beenClicked;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = beenClicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if ( firstClick) {
      if (mines.contains(this) || countMines(myRow, myCol) > 0) {
        buttons = new MSButton[NUM_ROWS][NUM_COLS];
        //your code to initialize buttons goes here
        for (int i = 0; i < NUM_ROWS; i ++) {
          for (int k = 0; k < NUM_COLS; k++) {
            buttons[i][k] = new MSButton(i, k);
            buttons[i][k].myNum = numCounter;
            numCounter++;
          }
          numCounter++;
        }
        mines = new ArrayList <MSButton>();
        setMines();
        this.mousePressed();
      }
      firstClick = false;
    }

    if (!gameOver) {
      clicked = true;
      if (mouseButton == RIGHT) {
        if (mines.contains(this) && flagsLeft <= 0) {
          displayLosingMessage();
        }
        if (flagged) {
          flagged = false;
          clicked = false;
          flagsLeft ++;
        } else if (!flagged && !beenClicked && flagsLeft > 0) {
          flagged = true;
          flagsLeft = NUM_MINES;
          for (int row = 0; row < NUM_ROWS; row++) {
            for (int col = 0; col < NUM_COLS; col++) {
              if (buttons[row][col].isFlagged()) {
                flagsLeft --;
              }
            }
          }
        }
      } else if (mines.contains(this) && !flagged) {
        displayLosingMessage();
      } else if (countMines(myRow, myCol) > 0 && !flagged) {
        setLabel(countMines(myRow, myCol));
        this.beenClicked = true;
      } else {

        if (isValid(myRow - 1, myCol - 1) && !buttons[myRow - 1][myCol - 1].clicked) {
          buttons[myRow - 1][myCol - 1].mousePressed();
          buttons[myRow - 1][myCol - 1].beenClicked = true;
        }
        if (isValid(myRow - 1, myCol) && !buttons[myRow - 1][myCol].clicked) {
          buttons[myRow - 1][myCol].mousePressed();
          buttons[myRow - 1][myCol].beenClicked = true;
        }
        if (isValid(myRow - 1, myCol + 1) && !buttons[myRow - 1][myCol + 1].clicked) {
          buttons[myRow - 1][myCol + 1].mousePressed();
          buttons[myRow - 1][myCol + 1].beenClicked = true;
        }
        if (isValid(myRow, myCol - 1) && !buttons[myRow][myCol - 1].clicked) {
          buttons[myRow][myCol - 1].mousePressed();
          buttons[myRow][myCol - 1].beenClicked = true;
        }
        if (isValid(myRow, myCol + 1) && !buttons[myRow][myCol + 1].clicked) {
          buttons[myRow][myCol + 1].mousePressed();
          buttons[myRow][myCol + 1].beenClicked = true;
        }
        if (isValid(myRow + 1, myCol - 1) && !buttons[myRow + 1][myCol - 1].clicked) {
          buttons[myRow + 1][myCol - 1].mousePressed();
          buttons[myRow + 1][myCol - 1].beenClicked = true;
        }
        if (isValid(myRow + 1, myCol) && !buttons[myRow + 1][myCol].clicked) {
          buttons[myRow + 1][myCol].mousePressed();
          buttons[myRow + 1][myCol].beenClicked = true;
        }
        if (isValid(myRow + 1, myCol + 1) && !buttons[myRow + 1][myCol + 1].clicked) {
          buttons[myRow + 1][myCol + 1].mousePressed();
          buttons[myRow + 1][myCol + 1].beenClicked = true;
        }
      }
    }
  }
  public void draw () 
  {    
    if (flagged) {
      fill(0);
    } else if ( clicked && mines.contains(this) ) {
      fill(255, 0, 0);
      displayLosingMessage();
    } else if (clicked) {
      if (myNum % 2 == 0) {
        fill(195, 164, 133);
      } else {
        fill (229, 194, 159);
      }
    } else {
      if (myNum % 2 == 0) {
        fill(142, 189, 53);
      } else {
        fill (170, 215, 81);
      }
    }
    if (flagged) {
      fill(255);
    }

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
