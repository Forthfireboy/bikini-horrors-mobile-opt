var crt:CustomShader = null;
var tottalTimer:Float = FlxG.random.float(20, 100);

function create() {
    camGame.pixelPerfectRender = true;

    if (Options.gameplayShaders) {
        crt = new CustomShader('staticScanlines');

        crt.staticAmount = 0.6;
        crt.staticScale = 30.5;
        crt.staticSpeed = 0.5;

        camHUD.addShader(crt);
        camGame.addShader(crt);
    }

    pixelScript = scripts.getByName("pixel.hx");
    if (pixelScript == null) return;

    pixelScript.set("enablePixelUI", false);
    pixelScript.set("enableCameraHacks", false);
    pixelScript.set("enablePauseMenu", false);
    pixelScript.set("pixelNotesForDad", false);
}



function postCreate() {

    blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    gf.alpha = 0;
}


function update(elapsed:Float) {
    if (crt != null) {
        crt.time = (tottalTimer += elapsed);
    }
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1:
            FlxTween.tween(blackOverlay, { alpha: 0 }, 0.5, {
                onComplete: function(twn:FlxTween) {
                    remove(blackOverlay);
                    blackOverlay.destroy();
                }
            });

    }
}
