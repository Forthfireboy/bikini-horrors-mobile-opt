// Script by Chezzar
import funkin.backend.MusicBeatState;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.savedata.FunkinSave;
import funkin.savedata.HighscoreEntry;
import lime.system.System;

import haxe.Json;
import flixel.text.FlxText.FlxTextAlign;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxTextBorderStyle;
import lime.app.Application;

var water:CustomShader = null;
var water2:CustomShader = null;
var bgCam:FlxCamera = new FlxCamera();
var gameCam:FlxCamera = new FlxCamera();
var transitioning:Bool = false;
var logo:FlxSprite;

var menuActive:Bool = false;
var menuItems:Array = [];
var selectedIndex:Int = 0;
var itemLabels:Array<String> = ["Free Pay", "Optiones", "Credits"];
var menuInputDelay:Float = 0;
var enterMouseUsed:Bool = false;
var mobilePadFadeShown:Bool = false;
var textWidth;
var shadow = new FlxSprite();
var warn:FlxText;

var shake_time:Float = 0;
var shake_duration:Float = 0;
var shake_power:Float = 0;

var shakeSeedX:Float = FlxG.random.float(0, 9999);
var shakeSeedY:Float = FlxG.random.float(0, 9999);

var selecPrisonMusic = null;
var storyPrisonHitSound = null;

function create() {

    // DEBUG DEBUG CHEZZAR BORRA BORRA
    /*tmk = FunkinSave.getSongHighscore('la-playa', 'hard');
    tmk.score = 0;
    trace(tmk);*/
    trace(FlxG.save.data.storyStage + FlxG.save.data.lastSeenStage);
    if (FlxG.save.data.storyStage > FlxG.save.data.lastSeenStage){
        if (shouldPlayPrisonHitNotification())
            storyPrisonHitSound = FlxG.sound.play(Paths.sound('prison-hit'), 1.0, false);
    }


    menuActive = false;
    transitioning = false;

    if (FlxG.sound.music == null || FlxG.sound.music.assetPath != Paths.music('freakyMenu')) {
        FlxG.sound.playMusic(Paths.music('freakyMenu'), 1.0, true);
    }

    bgCam.bgColor = 0x00000000;
    gameCam.bgColor = 0x00000000;
    bgCam.useBgAlphaBlending = true;
    gameCam.useBgAlphaBlending = true;

    if (Options.gameplayShaders) {
        water = new CustomShader("waterDistortion");
        water.strength = 0.5;
        bgCam.addShader(water);

        water2 = new CustomShader("waterDistortion");
        water2.strength = 0.1;
        gameCam.addShader(water2);
    }

    FlxG.cameras.add(bgCam, false);
    FlxG.cameras.add(gameCam, false);

    var bgArt = new FlxSprite();
    bgArt.loadGraphic(Paths.image('title-bg'));
    bgArt.scale.set(0.65, 0.65);
    bgArt.alpha = 0;
    bgArt.updateHitbox();
    bgArt.camera = bgCam;
    add(bgArt);

    FlxTween.tween(bgArt, {alpha: 0.7}, 6.2, {ease: FlxEase.quartOut});

    var vignette = new FlxSprite();
    vignette.loadGraphic(Paths.image('vignette'));
    vignette.scale.set(1, 1);
    vignette.updateHitbox();
    vignette.camera = gameCam;
    add(vignette);

    shadow = new FlxSprite();
    shadow.loadGraphic(Paths.image('menus/titlescreen/SPONGEFUNESLOGO'));
    shadow.scale.set(0.5, 0.5);
    shadow.updateHitbox();
    shadow.color = 0xFF000000; // black
    shadow.alpha = 0.5;
    shadow.x = (FlxG.width - shadow.width) / 2 + 14;
    shadow.y = -shadow.height + 14;
    shadow.camera = gameCam;
    add(shadow);

    FlxTween.tween(shadow, {y: (FlxG.height - shadow.height) / 2 + 14}, 4.2, {
        ease: FlxEase.quartOut,
        onComplete: (_) -> {
            FlxTween.tween(shadow, {y: shadow.y - 15}, 1.4, {
                type: FlxTween.PINGPONG,
                ease: FlxEase.sineInOut
            });
        }
    });


    logo = new FlxSprite();
    logo.loadGraphic(Paths.image('menus/titlescreen/SPONGEFUNESLOGO'));
    logo.scale.set(0.5, 0.5);
    logo.updateHitbox();
    logo.x = (FlxG.width - logo.width) / 2;
    logo.y = -logo.height;
    logo.camera = gameCam;
    add(logo);

    FlxTween.tween(logo, {y: (FlxG.height - logo.height) / 2}, 4.2, {
        ease: FlxEase.quartOut,
        onComplete: (_) -> {
            FlxTween.tween(logo, {y: logo.y - 15}, 1.4, {
                type: FlxTween.PINGPONG,
                ease: FlxEase.sineInOut
            });
        }
    });


    jailSprite =  new FunkinSprite(650, 85, Paths.image("menus/prison/horror_bob_jail"));
    jailSprite.camera = gameCam;
    jailSprite.scale.set(0.5,0.5);
    jailSprite.x = 1260 - jailSprite.width/2 - 150 * jailSprite.scale.x;
    jailSprite.y = FlxG.height - jailSprite.height/2 - 150 * jailSprite.scale.y;
    
    add(jailSprite);
    jailSprite.visible = false;
    jailSprite.animation.addByPrefix("horror_jail", "horror_jail", 24, true);
    jailSprite.animation.addByPrefix("sound", "sound", 24, false);
    jailSprite.addOffset("sound", 36, 15);

    if (FlxG.save.data.currentStage >= 2){
        jailSprite.alpha = 0;
    }

    jailSprite.playAnim("horror_jail");


    warn = new FlxText(0, 0, 0, "Press enter to play me game", 25); 
    warn.setFormat(Paths.font("KrabbyPatty.otf"), 25, 0xFFFFFF, "center", FlxTextBorderStyle.NONE);
    warn.screenCenter();
    warn.y += 280;
    add(warn);
    
    var baseY = warn.y;
    FlxTween.num(0, 1, 2, { type: FlxTween.PINGPONG, ease: FlxEase.sineInOut }, (val:Float) -> {
        warn.y = baseY - 10 + (val * 20);
    });



    for (i in 0...itemLabels.length) {
        textWidth = 400;
        var item = new FlxText(0, 230 + i * 70, textWidth, itemLabels[i], 85);
        item.setFormat(Paths.font("KrabbyPatty.otf"), 32, 0xFFFFFF, FlxTextAlign.RIGHT, 0x000000);
        item.antialiasing = false;
        item.borderSize = 2;
        item.borderColor = 0xFF170E41;
        item.borderStyle = FlxTextBorderStyle.OUTLINE;
        item.visible = false;
        item.camera = gameCam;

        item.x = FlxG.width / 2 + 120 - textWidth;

        add(item);
        menuItems.push(item);
    }
    
    menuItems.push(jailSprite);

    if (FlxG.save.data.currentStage >= 2)
        remove(jailSprite);
        
    addMobilePad("UP_DOWN", "A_B");

    if (mobileManager != null && mobileManager.mobilePad != null) {
        mobileManager.mobilePad.alpha = 0;
    }
}


var tottalTimer:Float = FlxG.random.float(100, 1000);

function update(elapsed:Float) {
    if (shake_time > 0)
    {
        shake_time -= elapsed;

        var strength = shake_power * (shake_time / shake_duration);

        var t = tottalTimer * 35;

        var offsetX = Math.sin(t + shakeSeedX) * strength * FlxG.width;
        var offsetY = Math.cos(t + shakeSeedY) * strength * FlxG.height;

        // SAME OFFSET → BOTH CAMERAS
        gameCam.x = offsetX;
        gameCam.y = offsetY;
        bgCam.x = offsetX;
        bgCam.y = offsetY;

        if (shake_time <= 0)
        {
            gameCam.x = 0;
            gameCam.y = 0;
            bgCam.x = 0;
            bgCam.y = 0;
        }
    }

    water?.time = (tottalTimer += elapsed);
    water2?.time = (tottalTimer += elapsed);

    if (FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = false;
        persistentDraw = true;
        openSubState(new EditorPicker());
    }

    var upP = controls.UP_P;
            var downP = controls.DOWN_P;
            var scroll = FlxG.mouse.wheel;

            if (controls.BACK)
                FlxG.switchState(new TitleState());

            if (controls.SWITCHMOD) {
                openSubState(new ModSwitchMenu());
                persistentUpdate = false;
                persistentDraw = true;
            }

    if (menuInputDelay > 0) {
        menuInputDelay -= elapsed;
        if (menuInputDelay <= 0) menuInputDelay = 0;
    }

    var mouseEnterClick:Bool = FlxG.mouse.justReleased && !enterMouseUsed && !menuActive && !transitioning;

    if ((controls.ACCEPT || mouseEnterClick) && !menuActive && !transitioning) {
        if (mouseEnterClick) enterMouseUsed = true;
    
        FlxG.sound.play(Paths.sound('menu/scroll'));
        menuActive = true;
        menuInputDelay = 0.4;
        startMenuTransition();
    }

    if (menuActive && !transitioning && menuInputDelay <= 0) {
        
        if (controls.UP_P) {
            FlxG.sound.play(Paths.sound('menu/scroll'));
            selectedIndex = (selectedIndex - 1 + menuItems.length) % menuItems.length;
            updateMenuVisuals();
        }
        if (controls.DOWN_P) {
            FlxG.sound.play(Paths.sound('menu/scroll'));
            selectedIndex = (selectedIndex + 1) % menuItems.length;
            updateMenuVisuals();
        }

        if (controls.ACCEPT) {
            if (selectedIndex != 2)
                transitioning = true;
                
            FlxG.sound.play(Paths.sound('menu/confirm'));
            startPixelTransition(selectedIndex);
        }

    }
}

function startPixelTransition(index:Int) {

    if (index == 2) {
        System.openURL("https://bikinihorrors.neocities.org/credits");
        return;
    }
    var fade = new FlxSprite(0, 0);
    fade.makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    fade.alpha = 0;
    fade.scrollFactor.set();
    fade.camera = gameCam;
    add(fade);


    FlxTween.tween(fade, {alpha: 1}, 1.5, {
        ease: FlxEase.quadInOut,
        onComplete: (_) -> {
            switch (index) {
                case 0: FlxG.switchState(new ModState("VSelectionState"));
                case 1: FlxG.switchState(new OptionsMenu());
                case 2: System.openURL("https://bikinihorrors.neocities.org/credits");
                case 3: FlxG.switchState(new ModState("PrisonState"));
            }
        }
    });
}


function startMenuTransition() {
    if (!mobilePadFadeShown && mobileManager != null && mobileManager.mobilePad != null) {
        mobilePadFadeShown = true;
        mobileManager.mobilePad.alpha = 0;
        FlxTween.tween(mobileManager.mobilePad, {alpha: 1}, 0.8, {
            ease: FlxEase.quartOut
        });
    }

    var targetLogoX = logo.x - 120;
    FlxTween.tween(logo, {x: targetLogoX}, 1.2, {
        ease: FlxEase.quartInOut
    });

    FlxTween.tween(shadow, {x: targetLogoX + 14}, 1.2, {
        ease: FlxEase.quartInOut
    });

    FlxTween.tween(warn, {alpha: 0}, 0.6, {ease: FlxEase.quartInOut});


    for (i in 0...menuItems.length) {

        var item = menuItems[i];

        if (Std.isOfType(item, FlxText)) {

            item.visible = true;
            item.alpha = 0;
            item.x = FlxG.width + 100;

            FlxTween.tween(item, {
                x: FlxG.width - 130 - textWidth,
                alpha: 1
            }, 1.0 + i * 0.05, {
                ease: FlxEase.quartOut,
                onComplete: (_) -> updateMenuVisuals()
            });
        }

        else {
            item.visible = true;
            item.alpha = 0;

            FlxTween.tween(item, {alpha: 1}, 1, {
                ease: FlxEase.quartOut
            });
        }
    }
}

function updateMenuVisuals() {
    for (i in 0...menuItems.length) {
        var item = menuItems[i];
        var isSelected = (i == selectedIndex);

        FlxTween.cancelTweensOf(item);
        
        
        if (item == jailSprite){
            if (selecPrisonMusic != null){FlxTween.cancelTweensOf(selecPrisonMusic);}
            
            FlxTween.cancelTweensOf(FlxG.sound.music);
            FlxTween.cancelTweensOf(item.scale);
            FlxTween.tween(item.scale, {x: isSelected ? 0.57 : 0.5, y: isSelected ? 0.57 : 0.5}, 0.5, {ease: FlxEase.elasticOut});
            if (isSelected){
                jailSprite.playAnim("sound", false);
                startShake(0.01, 0.13);
                FlxG.sound.play(Paths.sound('prison-hit'), 1.0, false);
                FlxTween.tween(FlxG.sound.music, {volume:0.05}, 0.1);
                if (selecPrisonMusic == null){
                    selecPrisonMusic = FlxG.sound.play(Paths.music('prison_select'), 0.2, true);
                }
                else{
                    FlxTween.tween(selecPrisonMusic, {volume:0.2}, 0.4);
                }   
            }
            else{
                jailSprite.playAnim("horror_jail", false);
                FlxTween.tween(FlxG.sound.music, {volume:1}, 0.4);
                if (selecPrisonMusic != null){
                    FlxTween.tween(selecPrisonMusic, {volume:0}, 0.4);
                }
            }
        };
        else{
            FlxTween.tween(item.scale, {x: isSelected ? 1.3 : 1.0, y: isSelected ? 1.3 : 1.0}, 0.25, {ease: FlxEase.quartOut});
            item.color = isSelected ? 0x7A1A26 : 0xFFFFFFFF;
            item.borderColor = 0xFF170E41;


            FlxTween.tween(item, {
                x: (FlxG.width - 130 - item.width) + (isSelected ? -60 : 0)
            }, 0.25, {ease: FlxEase.quartOut});
        }
    }
}


function startShake(power:Float, duration:Float)
{
    shake_power = power;
    shake_duration = duration;
    shake_time = duration;
}

function destroySoundSafe(sound) {
    if (sound != null && sound.exists) {
        sound.stop();
        sound.destroy();
    }
}

function destroy() {
    destroySoundSafe(storyPrisonHitSound);
    destroySoundSafe(selecPrisonMusic);
    storyPrisonHitSound = null;
    selecPrisonMusic = null;
}
