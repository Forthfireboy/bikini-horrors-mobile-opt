// Script by Aika

import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.util.FlxTween;
import flixel.util.FlxStringUtil;  
import flixel.util.FlxTimer;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxGradient;
import funkin.savedata.FunkinSave;
import funkin.savedata.HighscoreEntry;
import funkin.savedata.FunkinSave;
import sys.io.FileSystem;
import haxe.Json;
import openfl.utils.Assets;

var uiElements:Array<FlxSprite> = [];
var bar:FlxCamera;
var adCoords:Array<Dynamic> = [];
var ytGradient:FlxSprite;
var timebar = new FlxBar(0, 675, FlxBarFillDirection.LEFT_TO_RIGHT, 1226, 3);
var shitbar = new FlxBar(0, 675, FlxBarFillDirection.LEFT_TO_RIGHT, 1226, 3);
var fadeDuration:Float = 1.0;
var startFillingStep:Int = 1264;
var isFilling:Bool = false;
var maxSteps:Float = 3666;
var pause:FlxSprite;
var skip:FlxSprite;
var volume:FlxSprite;
var adSkip:FlxSprite;
var timeTxt:FlxText = new FunkinText(150 + 60, 687, 0, "", 20, false);
var faked:Bool = false;
var fakeStartTime:Float = 0;
var fakeTotal:Float = 0;
var adMarks:Array<FlxSprite> = [];
var pathSprites:Array<FlxSprite> = [
    "china/ads/pepe",
    "china/ads/how_can_I",
    "china/ads/tutorial",
    "china/ads/who_is_he",
    "china/ads/casino",
    "china/ads/nose",
    "china/ads/alhambrito_sakurai",
    "china/ads/ECUADOR",
    "china/ads/saselandia",
    "china/ads/hungry_shark",
    "china/ads/hola_buenas"
];
var icons:Array<String> = [
    "temu1",
    "temu2",
    "express1",
    "express2",
    "timo1",
    "timo2",
    "simulation1",
    "simulation2"
];
var iconP1Static:FlxSprite;
var iconP2Static:FlxSprite;
var curP1Graphic:String = "";
var curP2Graphic:String = "";
var isTemuPhase2:Bool = false;
var isExpressPhase2:Bool = false;
var adMarkedTriggered:Array<Bool> = [];
var highscore = FunkinSave.getSongHighscore('made-in-china', 'hard');
var firstAd:Bool = true;

var skipStep:Int = 1110;
var vocals:FlxSound;
var events:Array<Event> = [];
var scrubbed:Bool = false;

function postCreate() {
    addExtraHitboxKey("SPACE");

    var adPos:Array<Int> = [];
    var jsonPath:String = Paths.file('data/config/china/adPositions.json');
    var rawJson:String = Assets.getText(jsonPath);
    var jsonParsed = Json.parse(rawJson);
    adPos = jsonParsed.positions;
    adCoords = jsonParsed.coords;

    caca = FlxG.save.data.adUnlocked;
    trace (caca);

    bar = new FlxCamera(0, 0, FlxG.width, FlxG.height);
    bar.bgColor = 0x00000000;
    FlxG.cameras.add(bar, false);

    var p1Y:Float;
    var p2Y:Float;

    if (downscroll) {
        p1Y = 25;
        p2Y = 535;
    } else {
        p1Y = 540;
        p2Y = 30;
    }


    iconP1.visible = false;
    iconP2.visible = false;
    iconP1Static = new FlxSprite();
    iconP1Static.cameras = [camHUD];
    iconP1Static.scale.set(0.8, 0.8);
    iconP1Static.alpha = 0;
    
    iconP2Static = new FlxSprite();
    iconP2Static.cameras = [camHUD];
    iconP2Static.scale.set(0.8, 0.8);
    iconP2Static.alpha = 0;

    iconP1Static.x = -15; 
    iconP1Static.y = p1Y;

    iconP2Static.x = -15; 
    iconP2Static.y = p2Y; 


    add(iconP1Static);
    add(iconP2Static);

    ytGradient = FlxGradient.createGradientFlxSprite(FlxG.width, 100, [0x00000000, 0xA4000000], 1, 90);
    ytGradient.cameras = [bar];
    ytGradient.x = 0; 
    ytGradient.y = 620; 
    add(ytGradient);

    shitbar.createFilledBar(0x50ffffff, 0x50ffffff);
    shitbar.numDivisions = 1000;
    shitbar.cameras = [bar];
    shitbar.screenCenter(FlxAxes.X);
    add(shitbar);


    if (FlxG.save.data.mech == false) {
        for (x in adPos) {
            var rect = new FlxSprite(x, 675).makeGraphic(5, 3, FlxColor.YELLOW);
            rect.cameras = [bar];
            add(rect);
            adMarks.push(rect);
            adMarkedTriggered.push(false);
        }
    }

    timebar.createFilledBar(0xFFFFEE00, 0xFFFFEE00);
    timebar.numDivisions = 1000;
    timebar.cameras = [bar];
    timebar.screenCenter(FlxAxes.X);
    add(timebar);


    pause = new FlxSprite(0, 650).loadGraphic(Paths.image('china/pause'));
    pause.scale.set(0.65, 0.65);
    pause.cameras = [bar];
    add(pause);

    skip = new FlxSprite(pause.x + 60, 650).loadGraphic(Paths.image('china/skip'));
    skip.scale.set(0.65, 0.65);
    skip.cameras = [bar];
    add(skip);

    volume = new FlxSprite(skip.x + 60, 650).loadGraphic(Paths.image('china/volume'));
    volume.scale.set(0.65, 0.65);
    volume.cameras = [bar];
    add(volume);

    adSkip = new FlxSprite(-120,timebar.y - 200).loadGraphic(Paths.image('china/ad'));
    adSkip.alpha = 0;
    adSkip.scale.set(0.45, 0.45);
    adSkip.cameras = [bar];
    adSkip.visible = false;
    if (highscore.score > 0 || FlxG.save.data.adUnlocked == true) {
        add(adSkip);
    } else {
        adSkip.x = -999999999; //Arreglao
        add(adSkip);
    }

    timeTxt.text = '0:00 / ' + FlxStringUtil.formatTime(inst.length / 1000);
    timeTxt.cameras = [bar];
    timeTxt.font = Paths.font('Roboto-Regular.ttf');
    add(timeTxt);

    uiElements = [pause, skip, volume, timeTxt];


    if (PlayState.instance.healthBar != null && PlayState.instance.healthBarBG != null) {
        PlayState.instance.healthBar.angle = 90;
        PlayState.instance.healthBarBG.angle = 90;
        PlayState.instance.healthBarBG.x = -240.5;
        PlayState.instance.healthBar.x = -236.5;
        PlayState.instance.healthBarBG.y = 348;
        PlayState.instance.healthBar.y = 352;
        
        PlayState.instance.healthBar.scale.set(0.7, 0.7);
        PlayState.instance.healthBarBG.scale.set(0.7, 0.7);
    }

    PlayState.instance.scripts.set("iconP1Static", iconP1Static);
    PlayState.instance.scripts.set("iconP2Static", iconP2Static);
}

function update() {
    if (adSkip.overlapsPoint(FlxG.mouse.getScreenPosition(bar), true, bar) && FlxG.mouse.justPressed && !scrubbed) {
        if (vocals == null) vocals = PlayState.instance.vocals;
        jumpToStep(skipStep);
        scrubbed = true;
        FlxTween.tween(adSkip, { alpha: 0 }, fadeDuration - 0.5, { type: FlxTween.EASE_OUT });
    }


    if (mobileSpaceJustPressed()) {
        if (adSprites.length > 0) {
            var sprite = adSprites[adSprites.length - 1];
            if (sprite != null && sprite.exists) {
                var s = sprite;
                FlxTween.tween(s.scale, { y: 0 }, 0.1, {
                    ease: FlxEase.quadInOut,
                    onComplete: function() {
                        s.kill();
                    }
                });

                adSprites.pop();
            }
        }
    }

}

var adSprites:Array<FlxSprite> = [];

function postUpdate(elapsed:Float) {
    if (FlxG.sound.music != null && isFilling) {
        var currentStep:Float = Conductor.curStepFloat;
        var clampedStep:Float = Math.max(currentStep - startFillingStep, 0);
        var targetPercent:Float = (clampedStep / (maxSteps - startFillingStep)) * 100;
        var smoothSpeed:Float = 10;
        timebar.percent += (targetPercent - timebar.percent) * elapsed * smoothSpeed;
    }

    var barLeft:Float = timebar.x;
    var barWidth:Float = timebar.barWidth;
    var filledX:Float = barLeft + (timebar.percent / 100) * barWidth;

    for (i in 0...adMarks.length) {
        var rect = adMarks[i];
        if (!adMarkedTriggered[i]) {
            if (filledX >= rect.x) {
                showAdSprite();
                adMarkedTriggered[i] = true;
            }
        }
    }

    if (FlxG.sound.music != null && faked) {
        var fakeElapsed = Conductor.songPosition - fakeStartTime;
        timeTxt.text = FlxStringUtil.formatTime(fakeElapsed / 1000) + " / " + FlxStringUtil.formatTime(fakeTotal / 1000);
    } else if (Conductor.songPosition < 0) {
        timeTxt.text = "0:00 / 2:39";
    } else {
        timeTxt.text = FlxStringUtil.formatTime(Conductor.songPosition/1000) + " / " + "2:39";
    }

    if (iconP1Static != null) {
        iconP1Static.scale.x += (0.7 - iconP1Static.scale.x) * elapsed * 12;
        iconP1Static.scale.y += (0.7 - iconP1Static.scale.y) * elapsed * 12;
    }
    if (iconP2Static != null) {
        iconP2Static.scale.x += (0.7 - iconP2Static.scale.x) * elapsed * 12;
        iconP2Static.scale.y += (0.7 - iconP2Static.scale.y) * elapsed * 12;
    }

    

    updateStaticIcons();
}

var debugArea:Bool = false;

function showAdSprite():Void {
    if (FlxG.save.data.mech == false) {
        var path:String = "";

        if (firstAd) {
            path = "china/ads/tutorial";
            firstAd = false;
        } else {
            path = pathSprites[FlxG.random.int(0, pathSprites.length - 1)];
        }
        
        var sprite = new FlxSprite().loadGraphic(Paths.image(path));
        var scaleX = 300 / sprite.width;
        var scaleY = 300 / sprite.height;
        sprite.scale.set(scaleX, scaleY);
        sprite.updateHitbox();

        if (adCoords.length > 0) {
            var randomSlot = adCoords[FlxG.random.int(0, adCoords.length - 1)];
            sprite.setPosition(randomSlot.x, randomSlot.y);
        } else {
            sprite.setPosition(850, 150);
        }

        sprite.scale.y = 0;
        add(sprite); 
        sprite.cameras = [bar];
        sprite.scrollFactor.set(0, 0);
        FlxTween.tween(sprite.scale, { y: scaleY }, 0.1, { ease: FlxEase.quadInOut });

        adSprites.push(sprite);
    }
}

function tweenUI(alpha:Float, ?duration:Float = 1.0) {
    for (element in uiElements) {
        FlxTween.tween(element, { alpha: alpha }, duration, { type: FlxTween.EASE_OUT });
    }

    for (ad in adMarks) {
        FlxTween.tween(ad, { alpha: alpha }, duration, { type: FlxTween.EASE_OUT });
    }
}

function stepHit(curStep:Int) {
    if (curStep == 10) {
        adSkip.visible = true;
        FlxTween.tween(adSkip, { alpha: 0.7 }, fadeDuration - 0.5, { type: FlxTween.EASE_OUT});
    }
    if (curStep == 128) {
        FlxTween.tween(adSkip, { alpha: 0 }, fadeDuration - 0.5, { type: FlxTween.EASE_OUT});
        scrubbed = true;
    }
    if (curStep == 1116) {
        FlxG.save.data.adUnlocked = true;
    }
    if (curStep == 1123) {
        FlxTween.tween(timebar, { alpha: 0 }, fadeDuration, { type: FlxTween.EASE_OUT });
        FlxTween.tween(shitbar, { alpha: 0 }, fadeDuration, { type: FlxTween.EASE_OUT });
        tweenUI(0, fadeDuration);
    }
    if (curStep == 1264) {
        isTemuPhase2 = true;
    }

    if (curStep == startFillingStep) {
        timebar.createFilledBar(0x00ffffff, 0xFFFF0000);
        shitbar.alpha = 1;
        isFilling = true;
        timebar.alpha = 1;
        for (element in uiElements) element.alpha = 1;
        for (ad in adMarks) ad.alpha = 1;
        faked = true;
        fakeStartTime = Conductor.songPosition;
        fakeTotal = inst.length - fakeStartTime;
    }
    if (curStep == 2694) {
        fadeDuration = 0.2;
        FlxTween.tween(timebar, { alpha: 0 }, fadeDuration, { type: FlxTween.EASE_OUT });
        FlxTween.tween(shitbar, { alpha: 0 }, fadeDuration, { type: FlxTween.EASE_OUT });
        tweenUI(0, fadeDuration);
    }
    if (curStep == 3031) {
        FlxTween.tween(timebar, { alpha: 1 }, fadeDuration, { type: FlxTween.EASE_OUT });
        FlxTween.tween(shitbar, { alpha: 1 }, fadeDuration, { type: FlxTween.EASE_OUT });
        tweenUI(1, fadeDuration);
    }
    if (curStep == 3212) {
        isExpressPhase2 = true;
    }
}

function getStepTime(step:Int):Float {
    return step * Conductor.stepCrochet; 
}

function jumpToStep(step:Int) {
    var newTime = getStepTime(step);

    if (FlxG.sound.music != null) FlxG.sound.music.time = newTime;
    if (strumLines.members[0].vocals != null) strumLines.members[0].vocals.time = newTime;
    if (strumLines.members[1].vocals != null) strumLines.members[1].vocals.time = newTime;
    Conductor.songPosition = newTime;

    for (strumLine in PlayState.instance.strumLines.members) {
        strumLine.generate(strumLine.data, newTime);
    }

    events = [for (e in PlayState.SONG.events) if (e.time >= newTime) e];
}


function updateStaticIcons() {
    if (PlayState.instance.healthBar == null) return;

    var targetP1:String = "";
    var targetP2:String = "";

    if (!isTemuPhase2) {
        targetP1 = (health < 0.2) ? "china/icons/express2" : "china/icons/express1";
        targetP2 = (health > 1.8) ? "china/icons/temu2" : "china/icons/temu1";
        
    } else {
        if (!isExpressPhase2) {
            targetP1 = (health < 0.2) ? "china/icons/express2" : "china/icons/express1";
            targetP2 = (health > 1.8) ? "china/icons/timo2" : "china/icons/timo1"; 
        } else {
            targetP1 = (health < 0.2) ? "china/icons/simulation2" : "china/icons/simulation1";
            targetP2 = (health > 1.8) ? "china/icons/timo2" : "china/icons/timo1"; 
        }
    }

    if (curP1Graphic != targetP1) {
        curP1Graphic = targetP1;
        iconP1Static.loadGraphic(Paths.image(curP1Graphic));
    }
    if (curP2Graphic != targetP2) {
        curP2Graphic = targetP2;
        iconP2Static.loadGraphic(Paths.image(curP2Graphic));
    }
}

function beatHit(curBeat:Int) {
    if (iconP1Static != null) iconP1Static.scale.set(0.9, 0.9);
    if (iconP2Static != null) iconP2Static.scale.set(0.9, 0.9);
}
