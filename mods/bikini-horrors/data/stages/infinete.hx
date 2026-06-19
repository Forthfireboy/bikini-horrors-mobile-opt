var mix: String = "null";

function create() {
    rajoy.alpha = 0;
    EXPLOSION.alpha = 0;
    kennysfront.alpha = 0;
    frontstones.alpha = 0;
    kennysfront.playAnim("loop");
    kennysback.playAnim("loop");
}

function stepHit(curStep:Int) {
    //Base events
    if ( mix == "Base") {
        if (curStep == 300) {
            boke.alpha = 0;
            kennysfront.alpha = 1;
            frontstones.alpha = 1;
        }
        if (curStep == 824) {
            boke.alpha = 1;
            kennysfront.alpha = 0;
            frontstones.alpha = 0;
        }
        if (curStep == 1080) {
            boke.alpha = 0;
            kennysfront.alpha = 1;
            frontstones.alpha = 1;
        }
        if (curStep == 1740) {
            EXPLOSION.alpha = 1;
            EXPLOSION.playAnim("EXPLOSION");
            kennysfront.x = -670;
            kennysfront.y = 970;
            kennysfront.playAnim("suprised");
            kennysback.x = 35;
            kennysback.y = 185;
            kennysback.playAnim("suprised");
        }
        if (curStep == 1884) {
            kennysfront.x = -1736;
            kennysfront.y = 755;
            kennysfront.playAnim("loop");
            kennysback.x = -460;
            kennysback.y = 50;
            kennysback.playAnim("loop");
        }
    }

    //ES events
    if ( mix == "es") {
        if (curStep == 288) {
            boke.alpha = 0;
            kennysfront.alpha = 1;
            frontstones.alpha = 1;
        }
        if (curStep == 816) {
            boke.alpha = 1;
            kennysfront.alpha = 0;
            frontstones.alpha = 0;
            rajoy.alpha = 1;
        }
        if (curStep == 1072) {
            boke.alpha = 0;
            kennysfront.alpha = 1;
            frontstones.alpha = 1;
            rajoy.alpha = 0;
        }
        if (curStep == 1712) {
            EXPLOSION.alpha = 1;
            EXPLOSION.playAnim("EXPLOSION");
            kennysfront.x = -670;
            kennysfront.y = 970;
            kennysfront.playAnim("suprised");
            kennysback.x = -170;
            kennysback.y = 185;
            kennysback.playAnim("suprised");
        }
        if (curStep == 1756) {
            kennysback.x = -122;
            kennysback.y = 178;
            kennysback.playAnim("gilipollas");
        }
    }
}

function setMix(m: String) {
    mix = m;
}
