import funkin.backend.utils.WindowUtils;
var camTween:FlxTween;
/*var canShake:Bool = false;
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
*/

function postCreate() {
    WindowUtils.winTitle = window.title = "KETCHUP!!!!!!";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function stepHit() {
    if (curStep == 2431) {
        chaosTween();
        
        FlxG.camera.shake(0.008, 100000);
    }
    if (curStep == 2688) {
        FlxG.camera.shake(0, 0, null, true); 
        if (camTween != null) {
            camTween.cancel();
            FlxTween.tween(camGame, {angle: 0}, 0.5, {ease: FlxEase.cubeOut});
        }
    }
}

function chaosTween() {
    var randomAngle:Float = FlxG.random.float(-2, 2);
    var randomTime:Float = FlxG.random.float(0.4, 1);

    camTween = FlxTween.tween(camGame, {angle: randomAngle}, randomTime, {
        ease: FlxEase.sineInOut,
        onComplete: function(twn:FlxTween) {
            chaosTween();
        }
    });
}
