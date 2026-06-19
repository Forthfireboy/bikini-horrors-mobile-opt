var hansPosX;
var patchyPosX;

function postCreate(){
    hansPosX = hans.x;
    hans.x += 1000;
    patchyPosX = boyfriend.x;
    boyfriend.x += 1000;
    stage.cameras = [bgCam];
    gravestones.cameras = [bgCam];
    entrance.cameras = [bgCam];
    foreground.cameras = [bgCam];
    sky.cameras = [bgCam];
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 40:
            FlxTween.tween(hans, {x:hansPosX}, 2,{ease:FlxEase.quadOut});
            FlxTween.tween(boyfriend, {x:patchyPosX}, 2,{ease:FlxEase.quadOut});
        case 70:
            FlxTween.tween(hans, {x:hansPosX+1000}, 1,{ease:FlxEase.quadIn});
    }
}