var crtUsa:CustomShader = null;

var blackOverlay;

var shitnoBg;

function create()
{
    camZooming = true;

    if (Options.gameplayShaders) {
    crtUsa = new CustomShader('crtUsa');

    crtUsa.curvature = 0;
    crtUsa.scanlines = 1;
    crtUsa.rgbShift = 0;
    crtUsa.blur = 0.8;

    camHUD.addShader(crtUsa);
    camGame.addShader(crtUsa);
    }

}

function postCreate()
{
    mintos.alpha = 0;
    plataforma_shitno.alpha = 0;
    fondaco.alpha = 0;
    rock.alpha = 0;

    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.alpha = 0;
    iconP2.alpha = 0;
    scoreTxt.alpha = 0;
    accuracyTxt.alpha = 0;
    missesTxt.alpha = 0;

    blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1280, 200, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

}


function onSongStart() {
    setHudArrowsAlpha(0);
}

function stepHit() { 

    if (curStep == 1) {
        FlxTween.tween(gris, {x: gris.x + 1500}, 6.3);
        FlxTween.tween(poja, {x: poja.x + 1500}, 6.3);
        FlxTween.tween(gf, {y: gf.y + 1500}, 6.3);

    }

    if (curStep == 64) {
        gris.alpha = 0;
        poja.alpha = 0;
        black.alpha = 0;

        remove(blackOverlay);
        blackOverlay.destroy();
    }

    if (curStep == 1776) {
        fondo.alpha = 0;
        bg.alpha = 0;
        suelo.alpha = 0;
        foreground.alpha = 0;
        dad.alpha = 0;
    }

    if (curStep == 2092) {
        camGame.scroll.x = camGame.scroll.x - 10000;
    }

    if (curStep == 2210) {
        rock.alpha = 1;
    }

    if (curStep == 2212) {
        FlxTween.tween(rock, {x: rock.x + 8500}, 20);
    }

    if (curStep == 2432) {
        FlxTween.tween(boyfriend, {alpha: 0}, 0.7);
    }

    if (curStep == 2456) {
        FlxTween.tween(plataforma_shitno, {alpha: 1}, 0.5);
        FlxTween.tween(dad, {alpha: 1}, 0.5);
        rock.alpha = 0;
    }

    if (curStep == 2568) {
        FlxTween.tween(gf, {y: gf.y - 1500}, 0.2);
    }

    if (curStep == 2592) {
        FlxTween.tween(gf, {y: gf.y + 1500}, 0.2);
    }

    if (curStep == 3808) {
        mintos.alpha = 1;
    }

    if (curStep == 3776) {
        boyfriend.alpha = 0;
    }

    if (curStep == 4288) {
        FlxTween.tween(fondaco, {alpha: 0.7}, 0.7);
    }

    if (curStep == 4544) {
        FlxTween.tween(fondaco, {alpha: 0}, 1);
    }

}
