var canShake:Bool;
var verySHAKE:Bool;
public var nick:FlxSprite;

var dadBaseY:Float = 0;
var dadSineTime:Float = 2;
var dadSineAmount:Float = 10;
var dadSineSpeed:Float = 4;
var bobFly:Bool = false;

function create() {

    nick = new FlxSprite();
    nick.loadGraphic(Paths.image('logos/tiktok'));
    nick.scale.set(0.12, 0.12);
    nick.updateHitbox();
    nick.alpha = 0.8;
    nick.scrollFactor.set(0, 0);
    nick.cameras = [camHUD];

    nick.x = FlxG.width - nick.width - 30;
    nick.y = FlxG.height - nick.height - 30;

    pared2.visible = false;
    suelo2.visible = false;
    pilar2.visible = false;


    add(nick);
}

function postCreate()
{
    camZooming = true;
    canShake = true;

    dadBaseY = dad.y;

}

function update(elapsed:Float) {
    if (bobFly) {
        dadSineTime += elapsed * dadSineSpeed;
        dad.y = dadBaseY + Math.cos(dadSineTime / 2) * 2 * dadSineAmount;
    }
}

function onDadHit() {
    if (canShake == true)
        if (verySHAKE == false)
            FlxG.camera.shake(0.02, 0.1);
        else
            FlxG.camera.shake(0.02, 0.1);
}


function stepHit(step:Int) {

    if (curStep == 384) {
        canShake = false;
    }

    if (curStep == 416) {
        canShake = true;
    }

    if (curStep == 904) {
        nick.alpha = 0;
    }

    if (curStep == 968) {
        nick.alpha = 1;
        pared2.visible = true;
        suelo2.visible = true;
        pilar2.visible = true;
        pared.visible = false;
        suelo.visible = false;
        pilar.visible = false;
    }

    if (curStep == 1736) {
        bobFly = true;
        canShake = false;
    }

    if (curStep == 1864) {
        canShake = true;
    }
}
