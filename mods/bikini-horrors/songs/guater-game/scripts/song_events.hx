// Script by Chezzar
import funkin.backend.utils.WindowUtils;
import funkin.game.StageCharPos;
var pixel:CustomShader;
var canShake:Bool;
var verySHAKE:Bool;

public var nick:FlxSprite;
public var clan:FlxSprite;

function create() {
    clan = new FlxSprite();
    clan.loadGraphic(Paths.image('logos/clan'));
    clan.scale.set(0.07, 0.07);
    clan.updateHitbox();
    clan.alpha = 0.8;
    clan.scrollFactor.set(0, 0);
    clan.cameras = [camHUD];

    clan.x = FlxG.width - clan.width - 30;
    clan.y = FlxG.height - clan.height - 30;


    add(clan);

    nick = new FlxSprite();
    nick.loadGraphic(Paths.image('logos/nick'));
    nick.scale.set(0.12, 0.12);
    nick.updateHitbox();
    nick.alpha = 0.8;
    nick.scrollFactor.set(0, 0);
    nick.cameras = [camHUD];

    nick.x = FlxG.width - nick.width - 30;
    nick.y = FlxG.height - nick.height - 30;


    add(nick);
    nick.visible = false;
}

function postCreate() {
	pixel = new CustomShader("pixel");
    pixel.blockSize = 1.0;
    pixel.res = [FlxG.width, FlxG.height];
    WindowUtils.winTitle = window.title = "MY UNDERGUATER GAME";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function onDadHit() {
    if (canShake == true)
        if (verySHAKE == false)
            FlxG.camera.shake(0.005, 0.1);
        else
            FlxG.camera.shake(0.008, 0.1);
}

function stepHit(step:Int) {

    if (curStep == 1537) {
        stage.getSprite("souls").visible = false;
        stage.getSprite("jumpscare").visible = false;
    }
    if (curStep == 2479) {
        stage.getSprite("souls").visible = true;
        stage.getSprite("souls").playAnim("apparition");

        stage.getSprite("souls").animation.finishCallback = function(animName:String) {
            if (animName == "apparition") {
                stage.getSprite("souls").playAnim("idle", true);
            }
        };
    }

    if (curStep == 2180) {
        var jump = stage.getSprite("jumpscare");
        jump.visible = true;
        jump.cameras = [camHUD];
        jump.scrollFactor.set(0, 0);
        var isDownscroll:Bool = camHUD.downscroll;

        if (isDownscroll) {
            jump.angle = 180; 
            jump.screenCenter(0x01);
            jump.y = 0;
        } 
        else {
            jump.angle = 0;
            jump.flipY = false;
            jump.screenCenter(0x01);
        }
        jump.playAnim("idle");
    }


	switch (step) {
        case 1:
            verySHAKE = false;
        case 140:
            nick.visible = true;
            clan.visible = false;
            canShake = true;
		case 1035:
			if (pixel != null) {
                FlxG.camera.addShader(pixel);
                FlxTween.num(1, 20, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circOut}, (val:Float) -> {pixel.blockSize = val;});
            }

        case 1052:
            canShake = false;
			if (pixel != null) {
                FlxTween.num(20, 4, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circOut}, (val:Float) -> {pixel.blockSize = val;});
            }

        case 1531:
			if (pixel != null) {
                FlxTween.num(4, 20, (Conductor.stepCrochet / 1000) * 4, {ease: FlxEase.circOut}, (val:Float) -> {pixel.blockSize = val;});
            }

        case 1535:
            canShake = true;
			if (pixel != null) {
                FlxTween.num(20, 0.00001, (Conductor.stepCrochet / 1000) * 4, 
                    { 
                        ease: FlxEase.circOut, 
                        onComplete: (twn:FlxTween) -> {
                            FlxG.camera.removeShader(pixel);
                        }
                    }, 
                    (val:Float) -> {
                        pixel.blockSize = val;
                    }
                );
            }


        case 2047:
            verySHAKE = true;
	}
}