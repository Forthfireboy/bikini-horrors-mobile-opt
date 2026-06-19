//var blackOverlay;

var playerXBase: Int;
var playerYBase: Int;
var oppXBase: Int;
var oppYBase: Int;
var originalScrollX: Float;
var originalScrollY: Float;

function postCreate() {
    playerXBase = boyfriend.x;
    playerYBase = boyfriend.y;
    oppXBase = dad.x;
    oppYBase = dad.y;
    originalScrollX = FlxG.camera.scroll.x;
    originalScrollY = FlxG.camera.scroll.y;

    forest.alpha = 0;
    ground.alpha = 0;
    foreground1.alpha = 0;
    foreground2.alpha = 0;
    dad.alpha = 0;
    gf.alpha = 0;

    screenVignette = new FlxSprite();
    screenVignette.loadGraphic(Paths.image("vignette"));
    screenVignette.setGraphicSize(FlxG.width, FlxG.height, true);
    screenVignette.scrollFactor.set(0, 0);
    screenVignette.alpha = 0.5;
    screenVignette.color = FlxColor.BLACK;
    screenVignette.screenCenter();

    add(screenVignette);
    screenVignette.cameras = [camHUD];

    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.alpha = 0;
    iconP2.alpha = 0;
    scoreTxt.alpha = 0;
    accuracyTxt.alpha = 0;
    missesTxt.alpha = 0;
    missesTxt.alpha = 0;

    camHUD.alpha = 0;
}

function stepHit(curStep:Int) {
    if (curStep == 3) {
        FlxTween.tween(epicas.scale, {x: 1.05, y: 1.05}, 2.6);
        FlxTween.tween(epicas, {alpha: 1}, 0.15);
    }
    if (curStep == 20) {
        FlxTween.tween(camHUD, {alpha: 1}, 1);
        FlxTween.tween(epicas, {alpha: 0}, 1);
    }
    if (curStep == 32) {
        FlxTween.tween(blackOverlay, {alpha: 0}, 2);
    }
    if (curStep == 148) {
        FlxTween.tween(dad, {alpha: 1}, .5);
    }
    if (curStep == 160) {
        forest.alpha = 1;
        ground.alpha = 1;
        foreground1.alpha = 1;
        foreground2.alpha = 1;
        FlxTween.tween(healthBar, {alpha: 1}, 1);
        FlxTween.tween(healthBarBG, {alpha: 1}, 1);
        FlxTween.tween(scoreTxt, {alpha: 1}, 1);
        FlxTween.tween(accuracyTxt, {alpha: 1}, 1);
        FlxTween.tween(missesTxt, {alpha: 1}, 1);
        FlxTween.tween(iconP1, {alpha: 1}, 1);
        FlxTween.tween(iconP2, {alpha: 1}, 1);
    }
    if (curStep == 416) {
        blackOverlay.alpha = 1;
    }
    if (curStep == 448) {
        blackOverlay.alpha = 0;
    }
    if (curStep == 976) {
        blackOverlay.alpha = 1;
    }
    if (curStep == 992) {
        boyfriend.x = boyfriend.x * -1;
        dad.alpha = 0;
        dad.x -= 800;
        dad.y -= 100;
        forest.alpha = 0;
        ground.alpha = 0;
        foreground1.alpha = 0;
        foreground2.alpha = 0;
        originalScrollX = FlxG.camera.scroll.x;
        originalScrollY = FlxG.camera.scroll.y;

        FlxTween.tween(blackOverlay, {alpha: 0}, 0.5);
        FlxTween.tween(boyfriend, {x: boyfriend.x - 200}, 1.5);
        FlxTween.tween(boyfriend, {y: boyfriend.y - 100}, 12.57);
        FlxTween.tween(camGame, {zoom: 0.77}, 12.57);
    }
    if (curStep == 1120) {
        FlxTween.tween(boyfriend, {x: playerXBase - 200}, 0.25);
        FlxTween.tween(dad, {alpha: 1}, .2);
        FlxTween.tween(dad, {x: oppXBase + 100}, 0.2);
        camGame.scroll.x = originalScrollX;
        camGame.scroll.y = originalScrollY;
    }
    if (curStep == 1248) {
        boyfriend.x = playerXBase;
        boyfriend.y = playerYBase;
        dad.x = oppXBase;
        dad.y = oppYBase;
        forest.alpha = 1;
        ground.alpha = 1;
        foreground1.alpha = 1;
        foreground2.alpha = 1;
    }
    if (curStep == 2063) {
        blackOverlay.alpha = 1;
    }
    if (curStep == 2080) {
        boyfriend.x = boyfriend.x * -1 + 100;
        boyfriend.y = boyfriend.x - 100;
        dad.x = oppXBase + 100;
        dad.y -= 100;
        blackOverlay.alpha = 0;
        forest.alpha = 0;
        ground.alpha = 0;
        foreground1.alpha = 0;
        foreground2.alpha = 0;
        trace(blackOverlay.alpha);
    }
    if (curStep == 2352) {
        FlxTween.tween(blackOverlay, {alpha: 1}, 1.8);
        FlxTween.tween(healthBar, {alpha: 0}, 1);
        FlxTween.tween(healthBarBG, {alpha: 0}, 1);
        FlxTween.tween(scoreTxt, {alpha: 0}, 1);
        FlxTween.tween(accuracyTxt, {alpha: 0}, 1);
        FlxTween.tween(missesTxt, {alpha: 0}, 1);
        FlxTween.tween(iconP1, {alpha: 0}, 1);
        FlxTween.tween(iconP2, {alpha: 0}, 1);
        FlxTween.tween(camHUD, {alpha: 0}, 1);
    }
}
