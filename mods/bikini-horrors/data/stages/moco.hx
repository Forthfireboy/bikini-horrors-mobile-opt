
function create(){
    camHUD.alpha = 0;
}

function onCountdown(event) {
    event.scale = 0.1;
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 0:
            FlxTween.tween(camHUD, {alpha : 1}, .5);
            FlxTween.tween(blackCover, {alpha : 0}, 2);
        case 1008:
            FlxTween.tween(ramirez2, {alpha : 1}, 1.33);
        case 1792:
            FlxTween.tween(blackCover, {alpha : 1}, 1.24);
        case 1808:
            fondo.alpha = 1;
            FlxTween.tween(blackCover, {alpha : 0}, .33);
        case 2108:
            blackCover.alpha = 1.0;
            fondo.alpha = 0;
        case 2112:
            blackCover.alpha = 0.0;
        case 2368:
            FlxTween.tween(frank, {y : -47}, 2, {ease:FlxEase.expoOut});
            FlxTween.tween(platform, {y : -151}, 3, {ease:FlxEase.expoOut});
        case 2776:
            blackCover.alpha = 1;
    }
}
