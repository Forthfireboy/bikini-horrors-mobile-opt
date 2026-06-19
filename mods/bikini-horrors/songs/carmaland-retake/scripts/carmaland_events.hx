var tottalTimer = 0;
var blackCover;

function create(){
    camGame.pixelPerfectRender = true;

    if (Options.gameplayShaders) {
        crt = new CustomShader('staticScanlines');

        crt.staticAmount = 0.3;
        crt.staticScale = 30.5 * 5;
        crt.staticSpeed = 0.25;


        camGame.addShader(crt);
    }

}

function postCreate() {
    WindowUtils.winTitle = window.title = "QUIERO SER UN CHIQUE CARMALAND (RETAKE)";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 120:
            FlxTween.tween(this, {defaultCamZoom : 6}, 1, {ease:FlxEase.expoInOut});
    }
}

function update(elapsed:Float) {
    tottalTimer += elapsed;
    if (crt != null) {
        crt.time = (tottalTimer += elapsed);
    }
}
