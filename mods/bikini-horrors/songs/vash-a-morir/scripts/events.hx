var canShake:Bool = false;
var verySHAKE:Bool = false;

function onDadHit() {
    if (canShake == true) {
        if (verySHAKE == false) {
            FlxG.camera.shake(0.005, 0.1);
        }
        else {
            FlxG.camera.shake(0.008, 0.1);
        }
    }
}

function stepHit() {
    if (curStep == 1279) {
        camMoveOffset = 40;
        camAngleOffset = .30;
    }
    if (curStep == 1536) {
        camMoveOffset = 15;
        camAngleOffset = .3;
        canShake = true;
    }
    if (curStep == 1778) {
        verySHAKE = true;
    }
}

function postCreate() {
    WindowUtils.winTitle = window.title = "CACA";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}