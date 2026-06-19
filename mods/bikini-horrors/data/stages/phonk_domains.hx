// Script by Meiart
var screenVignette:FlxSprite;
var blackOverlay;
public var nick:FlxSprite;
var camAngle:Float = 0;
var targetAngle:Float = 0;

function create() {


    nick = new FlxSprite();
    nick.loadGraphic(Paths.image('logos/fiff'));
    nick.scale.set(0.3, 0.3);
    nick.updateHitbox();
    nick.scrollFactor.set(0, 0);
    nick.cameras = [camHUD];

    nick.x = FlxG.width - nick.width - 30;
    nick.y = FlxG.height - nick.height - 30;


    add(nick);
}

function update(elapsed:Float) {
    camAngle = FlxMath.lerp(camAngle, targetAngle, 0.05);
    camGame.angle = camAngle;
}

function stepHit(curStep:Int) {
    
    if(curStep == 1900) {
        targetAngle = -5;
    }
}