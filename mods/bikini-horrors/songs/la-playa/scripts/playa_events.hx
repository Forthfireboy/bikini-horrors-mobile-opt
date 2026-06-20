// Script by Aika

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import funkin.backend.utils.CoolUtil;
import funkin.game.PlayState;
import flixel.text.FlxText;
import flixel.text.FlxTextAlign;
import sys.io.Process;
import flixel.FlxG;
import funkin.backend.utils.Options;
import funkin.backend.utils.WindowUtils;
var hudX:Float = 283.5;
var desiredHudX:Float = 283.5;
var hudY:Float = 564;
var hudTween:FlxTween;
var strumsOffsets:Array = [for (i in 0...4) [0,0]];
var questions:Array<String> = []; 
var question:String;
var kahootQuestion:FlxText;
var answers_text:FlxText;
var answers_number:FlxText;
var isdown:Bool;
var ogStrumX:Array<Float> = [];

// -- POPUP STUFF --
var popup:FlxSprite;
var popupGroup:FlxSpriteGroup;
var iconArray:Array<FlxSprite> = [];
var targetOrder:Array<Int> = [];
var currentStepInput:Int = 0;



function postCreate() {
    var questions = CoolUtil.coolTextFile(Paths.txt("config/tmk/questions"));
    var question = FlxG.random.getObject(questions);
    isdown = camHUD.downscroll;

    kahootQuestion = new FlxText(0, 0, 2000, question);
    kahootQuestion.setFormat(Paths.font("Montserrat-Bold.otf"), 100, 0x333333, "center");
    kahootQuestion.x = dad.x + (dad.width / 2) - (kahootQuestion.width / 2);
    kahootQuestion.y = dad.y - 600;
    kahootQuestion.x -= 50;
    kahootQuestion.scrollFactor.set(1, 1);
    kahootQuestion.visible = false;
    add(kahootQuestion);

    answers_text = new FlxText(100, -300, 600, "Answers");
    answers_text.setFormat(Paths.font("Montserrat-BoldItalic.otf"), 70, 0x333333, "center");
    answers_text.visible = false;
    add(answers_text);

    answers_number = new FlxText(answers_text.x, answers_text.y -100, 600, "0");
    answers_number.setFormat(Paths.font("Montserrat-BoldItalic.otf"), 90, 0x333333, "center");
    answers_number.visible = false;
    add(answers_number);


    popup = new FlxSprite(445, -80).loadGraphic(Paths.image('tmk/popup'));
    popup.scale.set(0.5, 0.5);
    popup.antialiasing = false;
    popup.cameras = [camHUD];
    popup.alpha = 0;
    add(popup);

    popupGroup = new FlxSpriteGroup();
    popupGroup.cameras = [camHUD];
    popupGroup.visible = false;
    add(popupGroup);


    for (spr in playerStrums.members) {
        ogStrumX.push(spr.x);
    }

    setWindowTitle("A LOS RAYOS DEL SOL");
}

function onSongEnd() {
    setWindowTitle("BIKINI HORRORS");
}

var ansCounter:Int = 0;
var isCounting:Bool = false;

function stepHit(curStep:Int) {
    var offset:Float = -670; 
    var duration:Float = 1;
    var gap:Float = 300;

    if (curStep == 880)
    {
        setWindowTitle("TOO MUCH KAHOOT");
    }

    if (curStep == 912)
    {
        SansMessage("Sans Antivirus", "PRESS ARROWS IN ORDER TO UNBLOCK");
    }

    if (curStep == 1024)
    {
        generateSequence();
    }

    if (curStep == 1136)
    {
        generateSequence();
    }


    if (curStep == 1264)
    {
        var startX:Float = playerStrums.members[0].x;

        playerStrums.forEach(function(spr) {
            ogStrumX.push(spr.x); 
            spr.x = startX + (spr.ID * gap) + offset; 
            
            if (spr.ID == 3 && isdown == false) {
                goDownscroll();
            }
        });

        // 4. Mostrar interfaz de Kahoot
        kahootQuestion.visible = true;
        answers_text.visible = true;
        answers_number.visible = true;
    }



    if (curStep == 1256)
    {
        FlxTween.tween(healthBar, {alpha: 0}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(healthBarBG, {alpha: 0}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(iconP1, {alpha: 0}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(iconP2, {alpha: 0}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(scoreTxt, {alpha: 0}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(accuracyTxt, {alpha: 0}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(missesTxt, {alpha: 0}, duration, {ease: FlxEase.quadOut});
    }

    if (curStep == 1267) {
        SansMessage("Sans Antivirus", "DONT GO UNDER 30 ANSWERS");
    }


    if (curStep == 1519 && !curBotplay && ansCounter < 30) {
        SansMessage("Sans Antivirus", "I warned you...");
        gameOver();
    }


    if (curStep == 1520) 
    {
        playerStrums.forEach(function(spr) {
            spr.x = ogStrumX[spr.ID];
            if (spr.ID == 3 && isdown == false) {
                goUpscroll();
            }
        });
        
        kahootQuestion.visible = false;
        answers_text.visible = false;
        answers_number.visible = false;
    }

    if (curStep == 1792) {
        FlxTween.tween(healthBar, {alpha: 1}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(healthBarBG, {alpha: 1}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(iconP1, {alpha: 1}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(iconP2, {alpha: 1}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(scoreTxt, {alpha: 1}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(accuracyTxt, {alpha: 1}, duration, {ease: FlxEase.quadOut});
        FlxTween.tween(missesTxt, {alpha: 1}, duration, {ease: FlxEase.quadOut});
    }


    if (curStep == 2048)
    {
        generateSequence();
    }

    if (curStep == 2204)
    {
        generateSequence();
    }

    if (curStep == 2456)
    {
        generateSequence();
        
    }

    if (curStep == 2560)
    {
        generateSequence();
    }

}

function update() { 
    if (curStep >= 1264 && curStep <= 1520) {
        isCounting = true;
    } 


    if (popupGroup != null && popupGroup.visible && iconArray.length > 0) {
        var pressed:Int = -1;
        if (player.controls.NOTE_LEFT_P) pressed = 0;
        else if (player.controls.NOTE_DOWN_P) pressed = 1;
        else if (player.controls.NOTE_UP_P) pressed = 2;
        else if (player.controls.NOTE_RIGHT_P) pressed = 3;

        if (pressed != -1) {
            if (iconArray[0].ID == pressed) {
                var correctIcon = iconArray.shift();
                popupGroup.remove(correctIcon);
                correctIcon.destroy();
                
                if (iconArray.length == 0) {
                    popup.alpha = 0.99; 
                    FlxTween.tween(popup, {alpha: 0}, 0.3, {ease: FlxEase.quartIn});
                    FlxTween.tween(popup.scale, {x: 0, y: 0}, 0.3, {
                        ease: FlxEase.backIn, 
                        onComplete: function(twn:FlxTween) {
                            popup.visible = false;
                            popupGroup.visible = false;
                            popup.scale.set(0.5, 0.5);
                        }
                    });
                }
            } else {
                generateSequence(true);
            }
        }
    }
}

function onPlayerHit(event) {
    if (popupGroup != null && popupGroup.visible) {
        event.cancel();
        
        if (event.note != null) {
            health -= 0.05;
            misses++;
            FlxG.sound.play(Paths.sound('missnote' + FlxG.random.int(1, 3)), FlxG.random.float(0.1, 0.2));
            event.note.kill();
            playerStrums.members[event.note.noteData].playAnim("static");
        }
        return;
    }

    if (isCounting && !event.note.isSustainNote) {
        ansCounter++;
        answers_number.text = Std.string(ansCounter);
    }
}

function goDownscroll() {
    PlayState.instance.downscroll = true;
    
    for (strum in playerStrums.members) {
        strum.downscroll = true;
        strum.y = 570;
    }
}

function goUpscroll() {
    PlayState.instance.downscroll = false;

    for (strum in playerStrums.members) {
        strum.y = 50; 
    }
}

function SansMessage(title:String, message:String) {
    if (FlxG.onMobile) {
        trace(title + ": " + message);
        return;
    }

    var powershellCmd:String = "[reflection.assembly]::LoadWithPartialName('System.Windows.Forms'); " +
                               "$obj = New-Object System.Windows.Forms.NotifyIcon; " +
                               "$obj.Icon = [System.Drawing.SystemIcons]::Information; " +
                               "$obj.BalloonTipTitle = '" + title + "'; " +
                               "$obj.BalloonTipText = '" + message + "'; " +
                               "$obj.Visible = $True; " +
                               "$obj.ShowBalloonTip(5000);";

    try {
        new Process("powershell", ["-WindowStyle", "Hidden", "-Command", powershellCmd]);
    } catch (e:Dynamic) {
        trace(e);
    }
}

function setWindowTitle(title:String) {
    if (FlxG.onMobile)
        return;

    WindowUtils.winTitle = window.title = title;
}

function generateSequence(isReset:Bool = false) {
    if (FlxG.save.data.mech == false) {
        popup.visible = true;
        popupGroup.visible = true;

        if (!isReset) {
            popup.alpha = 0;
            popup.scale.set(0, 0);
            popup.origin.set(popup.width / 2, popup.height / 2);
            FlxTween.tween(popup, {alpha: 1}, 0.4, {ease: FlxEase.quartOut});
            FlxTween.tween(popup.scale, {x: 0.5, y: 0.5}, 0.5, {ease: FlxEase.backOut});
        } else {
            popup.alpha = 1;
            popup.scale.set(0.5, 0.5);
        }

        for (i in iconArray) {
            popupGroup.remove(i);
            i.destroy();
        }
        iconArray = [];
        targetOrder = [0, 1, 2, 3];
        FlxG.random.shuffle(targetOrder);
        currentStepInput = 0;

        for (i in 0...targetOrder.length) {
            var iconId = targetOrder[i];
            var arrowypos = (isdown) ? popup.y + 50 : popup.y + 80; 
            var icon = new FlxSprite(popup.x + 220 + (i * 115), arrowypos);
            icon.loadGraphic(Paths.image('tmk/arrows/arrow' + iconId));
            icon.antialiasing = false;
            icon.ID = iconId;
            icon.alpha = 0;

            icon.scale.set(0, 0);
            iconArray.push(icon);
            popupGroup.add(icon);

            FlxTween.tween(icon, {alpha: 1}, 0.3, {ease: FlxEase.quartOut, startDelay: 0.3 + (i * 0.05)});
            FlxTween.tween(icon.scale, {x: 0.4, y: 0.4}, 0.4, {ease: FlxEase.backOut, startDelay: 0.3 + (i * 0.05)});
        }
    }
}
