importScript("data/scripts/rain-shader");
static var aikaChar:Character;

function postCreate() {

    aikaChar = new Character(aika.x - 38, aika.y + 83, "aika_hypno", true);
    add(aikaChar); 
}

function stepHit(curStep:Int) {

    switch (curStep) {

        case 1:
            boyfriend.cameraOffset.x = -100;
            dad.cameraOffset.x = 120;
        case 188:
            dad.cameraOffset.x = -80;
        case 218:
            boyfriend.cameraOffset.x = -270;
        case 272:
            sergio.playAnim("walk");
        case 416:
            zipi.playAnim("walk");
        case 576:
            sergio.playAnim("walk");
        case 640:
            zipi.playAnim("walk");
        case 736:
            zipi.playAnim("walk");
        case 784:
            zipi.playAnim("walk");
    }
}