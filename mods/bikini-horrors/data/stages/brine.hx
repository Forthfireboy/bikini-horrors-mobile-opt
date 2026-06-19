var baseX: Float;
var starsBaseY: Float;

function postCreate() {
    camHUD.alpha = 0;
    baseX = boyfriend.x;
    boyfriend.x = baseX + 450;
    dad.alpha = 0;
    gf.alpha = 0;
    sign1.alpha = 0;
    sign2.alpha = 0;
    sign3.alpha = 0;
    moon.alpha = 0;
    totem.alpha = 0;
    lunabg.alpha = 0.0;
    starsBaseY = stars.y;
    blackBgOverlay.alpha = 0.0;
}


function stepHit(curStep:Int) {
    if (curStep == 1) {
        FlxTween.tween(blackOverlay, {alpha: 0.0}, 2.0);
        FlxTween.tween(stars, {y: starsBaseY - 70}, 61.0);
    }
    if (curStep == 28) {
        FlxTween.tween(boyfriend, {x: baseX}, 1.86);
    }
    if (curStep == 48) {
        dad.alpha = 1.0;
    }
    if (curStep == 60) {
        FlxTween.tween(camHUD, {alpha: 1.0}, 1.0);
    }
    if (curStep == 156) {
        ojitos.alpha = 1.0;
        ojitos.playAnim("ojitos");
        leaves.alpha = 0.0;
    }
    if (curStep == 160) {
        ojitos.alpha = 0.0;
    }
    if (curStep == 316) {
        gf.alpha = 1.0;
        gf.playAnim("appear");
    }
    if (curStep == 340) {
        gf.playAnim("idle");
    }
    if (curStep == 381) {
        boyfriend.alpha = 0;
        FlxTween.tween(boyfriend, {alpha: 1}, 0.26, {ease: FlxEase.bounceOut});
        dad.alpha = 0;
        FlxTween.tween(dad, {alpha: 1}, 0.26, {ease: FlxEase.bounceOut});
        foreground.alpha = 0.0;
        shadowleaves.alpha = 0.0;
        blackBgOverlay.alpha = 1.0;
        gf.alpha = 0.0;
    }
    if (curStep == 384) {
        foreground.alpha = 1.0;
        shadowleaves.alpha = 1.0;
        blackBgOverlay.alpha = 0.0;
        gf.alpha = 1.0;
        boyfriend.alpha = 1;
        dad.alpha = 1;
    }
    if (curStep == 704) {
        lunabg.alpha = 1.0;
        foreground.alpha = 0.0;
        shadowleaves.alpha = 0.0;
        gf.alpha = 0.0;
        //boyfriend.flipX = true;
        //dad.flipX = true;
    }
    if (curStep == 832) {
        stars.y = starsBaseY;
        moon.alpha = 1.0;
        lunabg.alpha = 0.0;
        foreground.alpha = 1.0;
        shadowleaves.alpha = 1.0;
        gf.alpha = 1.0;
        FlxTween.tween(stars, {y: starsBaseY - 70}, 61.0);
        FlxTween.tween(moon, {y: moon.y - 30}, 61.0);
        //boyfriend.flipX = false;
        //dad.flipX = false;
    }
    if (curStep == 1031) {
        sign1.alpha = 1.0;
    }
    if (curStep == 1032) {
        sign2.alpha = 1.0;
    }
    if (curStep == 1033) {
        sign3.alpha = 1.0;
    }
    if (curStep == 1165) {
        sign1.alpha = 0.0;
        sign2.alpha = 0.0;
        sign3.alpha = 0.0;
        foreground.alpha = 0.0;
        shadowleaves.alpha = 0.0;
        blackBgOverlay.alpha = 1.0;
        gf.alpha = 0.0;
    }
    if (curStep == 1169) {
        sign1.alpha = 1.0;
        sign2.alpha = 1.0;
        sign3.alpha = 1.0;
        foreground.alpha = 1.0;
        shadowleaves.alpha = 1.0;
        blackBgOverlay.alpha = 0.0;
        gf.alpha = 1.0;
    }
    if (curStep == 1296) {
        sign1.alpha = 0.0;
        sign2.alpha = 0.0;
        sign3.alpha = 0.0;
        foreground.alpha = 0.0;
        shadowleaves.alpha = 0.0;
        blackBgOverlay.alpha = 1.0;
        gf.alpha = 0.0;
        FlxTween.tween(totem, {alpha: 1.0}, 1);
    }
    if (curStep == 1312) {
        sign1.alpha = 1.0;
        sign2.alpha = 1.0;
        sign3.alpha = 1.0;
        foreground.alpha = 1.0;
        shadowleaves.alpha = 1.0;
        blackBgOverlay.alpha = 0.0;
        totem.alpha = 0.0;
        gf.alpha = 1.0;
    }
    if (curStep == 1556) {
        FlxTween.tween(blackOverlay, {alpha: 1.0}, 1);
        FlxTween.tween(camHUD, {alpha: 0.0}, 1);
    }
    if (curStep == 1568) {
        cobalea.alpha = 1.0;
        camHUD.alpha = 0.0;
        blackOverlay.alpha = 0.0;
    }
    if (curStep == 1669) {
        blackOverlay.alpha = 1.0;
    }
}