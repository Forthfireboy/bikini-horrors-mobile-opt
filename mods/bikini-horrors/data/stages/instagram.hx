var canShake:Bool = false;
var com1Y:Float;
var com2Y:Float;
var com3Y:Float;
var com4Y:Float;

function create() {
    camHUD.alpha = 0;
    com1Y = comments1.y;
    com2Y = comments2.y;
    com3Y = comments3.y;
    com4Y = comments4.y;
    comments1.y += 1500;
    comments2.y += 1500;
    comments3.y += 1500;
    comments4.y += 1500;
}


function stepHit(curStep:Int) {
    if (curStep == 120) {
        FlxTween.tween(camHUD, {alpha : 1}, .4, {ease:FlxEase.expoInOut});
    }
    if (curStep == 128) {
        blackOverlay.alpha = 0;
    }
    if (curStep == 1872) {
        FlxTween.tween(this, {defaultCamZoom : 2.67}, 2.1);
    }
    if (curStep == 1904) {
        this.defaultCamZoom = .67;
        dad.x -= 10;
        dad.y -= 10;
        boyfriend.x -= 20;
        gf.x -= 340;
        gf.y -= 100;
    }
    if (curStep == 1431) {
        canShake = true;

        FlxTween.tween(comments1, {
            y: com1Y,
            angle: -2
        }, 8, {ease:FlxEase.expoOut});
    }
    if (curStep == 1500) {
        FlxTween.tween(comments2, {
            y: com2Y,
            angle: 2
        }, 9, {ease:FlxEase.expoOut});
    }
    if (curStep == 1600) {
        FlxTween.tween(comments3, {
            y: com3Y,
            angle: -2
        }, 9, {ease:FlxEase.expoOut});
    }
    if (curStep == 1700) {
        FlxTween.tween(comments4, {
            y: com4Y,
            angle: 2
        }, 8, {ease:FlxEase.expoOut, onComplete: function(twn:FlxTween) {
                canShake = false;
            }
        });
    }
}

function update(elapsed:Float) {
    marimba();
}

function marimba() {
    if (canShake == false) return;
    FlxG.camera.shake(0.0025, 0.1);
}