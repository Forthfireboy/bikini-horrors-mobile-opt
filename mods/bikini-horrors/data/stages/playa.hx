import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.utils.WindowUtils;
import funkin.game.StageCharPos;

var canShake:Bool = false;
var verySHAKE:Bool = false;
public var nick:FlxSprite;
var STATIC_TWEEN_TIME:Float = 1.0;
var og_xTMK:Float;
var og_yTMK:Float;
var og_xAnt:Float;
var og_yAnt:Float;
var originalWinX:Int = 0;
var originalWinY:Int = 0;
var isWindowShaking:Bool = false;
var winShakeIntensity:Int = 6;

function postCreate() {
    og_xTMK = dad.x;
    og_yTMK = dad.y;
    og_xAnt = boyfriend.x;
    og_yAnt = boyfriend.y;

    gf.alpha = 0;
    dissolve = new CustomShader("dissolve");
}

function update(elapsed:Float) {
    if (isWindowShaking && !window.maximized && !window.fullscreen) {
        window.x = originalWinX + FlxG.random.int(-winShakeIntensity, winShakeIntensity);
        window.y = originalWinY + FlxG.random.int(-winShakeIntensity, winShakeIntensity);
    }
}

function tweenAlpha(sprite:FlxSprite, targetAlpha:Float) {
    if (sprite == null) return;

    FlxTween.tween(sprite, { alpha: targetAlpha }, STATIC_TWEEN_TIME, {
        ease: FlxEase.quadOut
    });
}

function stepHit(curStep:Int) {
    if(curStep == 440) 
    {
        bgplaya.alpha = 0;
        cielo.alpha = 1;
        suelo.alpha = 1;
        boyfriend.y += 65;
        boyfriend.x -= 20;
    }

    if(curStep == 872) 
    {
        cielo.alpha = 0;
        suelo.alpha = 0;
        canShake = true;
        boyfriend.x += 200;
        trace(boyfriend.x);
        trace(boyfriend.y);
    }

    if (curStep == 1008)
    {
        kahoot_bg.alpha = 1;
    }

    if (curStep == 1264)
    {
        boyfriend.x -= 200;
        canShake = false;
        kahoot_bg.alpha = 0;
        boyfriend.visible = false;
        kahoot_game.alpha = 1;
        dad.x = -1120;
        dad.y = -830;
    }

    if (curStep == 1504)
    {
        FlxTween.tween(staticsprite, { alpha: 0.5 }, 1.2);
    }

    if (curStep == 1520)
    {
        staticsprite.alpha = 0;
        kahoot_game.alpha = 0;
        pov.alpha = 1;
        dad.x = -640;
        dad.y = 0;
    }

    if (curStep == 1780)
    {
        tweenAlpha(staticsprite, 1);
    }

    if (curStep == 1792) {
        pov.alpha = 0;
        linux.alpha = 1;
        boyfriend.visible = true;
        dad.y = -700;
        dad.x = -1200;
        boyfriend.y = -700;
        tweenAlpha(staticsprite, 0);
    }
    
    if (curStep == 1920) {
        boyfriend.x += 200;
        linux.alpha = 0;
        kahoot_bg.alpha = 1;
        dad.x = og_xTMK;
        dad.y = og_yTMK;
        boyfriend.x = 80;
        boyfriend.y = -185;
        trace(boyfriend.x);
        trace(boyfriend.y);
        canShake = true;
    }

    if (curStep == 2176)
    {
        verySHAKE = true;
    }

    if (curStep == 2288)
    {
        gf.alpha = 1;
        
    }


    if (curStep == 2814)
    {
        gf.alpha = 0;
        kahoot_bg.alpha = 0;
    }

    if (curStep == 2820)
    {
        startWindowShake(1);
        canShake = false;
    }

    if (curStep == 2948)
    {
        stopWindowShake();
        FlxTween.tween(dad, { alpha: 0 }, 1.2);
    }
}

function onDadHit()
{
    if (!canShake) return;

    var damage:Float = 0;

    if (verySHAKE)
    {
        FlxG.camera.shake(0.008, 0.1);
        damage = 0.08; 
    }
    else
    {
        FlxG.camera.shake(0.003, 0.1);
        damage = 0.03; 
    }

    health = Math.max(0.1, health - damage);
}

function startWindowShake(intensity:Int)
{
    if (window.maximized || window.fullscreen) return;

    if (!isWindowShaking) {
        originalWinX = window.x;
        originalWinY = window.y;
    }
    winShakeIntensity = intensity;
    isWindowShaking = true;
}

function stopWindowShake()
{
    if (isWindowShaking) {
        isWindowShaking = false;
        if (!window.maximized && !window.fullscreen) {
            window.x = originalWinX;
            window.y = originalWinY;
        }
    }
}
