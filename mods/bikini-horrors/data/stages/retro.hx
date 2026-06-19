function create() {
    hi.alpha = 0;
    freinds.alpha = 0;
    no.alpha = 0;
    die.alpha = 0;
    
}

function stepHit(curStep:Int) {
    if (curStep == 16) {
        hi.alpha = 1;
    }

    if (curStep == 32) {
        hi.alpha = 0;
        freinds.alpha = 1;
    }

    if (curStep == 64) {
        freinds.alpha = 0;
        no.alpha = 1;
    }

    if (curStep == 97) {
        no.alpha = 0;
        die.alpha = 1;
    }

    if (curStep == 124) {
        die.alpha = 0;
    }
}