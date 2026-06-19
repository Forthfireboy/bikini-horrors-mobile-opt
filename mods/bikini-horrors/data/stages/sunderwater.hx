import openfl.display.BlendMode;

function create() {
    luz.visible = false;
    niebla.visible = false;
    luz.blend = BlendMode.ADD;
    darkLights.camera = camGame;
    darkLights.blend = BlendMode.MULTIPLY;
}

function stepHit(curStep:Int) {
    if (curStep == 304) {
        luz.visible = true;
    }

    if (curStep == 451) {
        niebla.visible = true;
    }
}
