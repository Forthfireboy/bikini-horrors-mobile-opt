//Script by Aika and Chezzar
import lime.system.System;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.backend.utils.WindowUtils;
import lime.app.Application;
import Sys;
import sys.io.Process;
import openfl.display.BitmapData;
import sys.FileSystem;
import sys.io.File;
import flash.display.BitmapData;
import haxe.Json;
import sys.io.File;
import Reflect;
import funkin.savedata.FunkinSave;
import funkin.savedata.HighscoreEntry;

var randomSpritesData:Dynamic;

var window = Application.current.window;
var blackOverlay:FlxSprite;

public var blooming:CustomShader = null;
var dissolveShader:CustomShader = null;
public var yellowShader:CustomShader = null; 
public var redShader:CustomShader = null;
var splitShader:CustomShader = null;
var bloomingTween:FlxTween = null;
var curblooming:Float = 1;
var bgBeat:Bool = false;
var bloomToBeat = 4;
var beatInterval:Int = 1;
var msg;
var letters:Bool = false;
var galletaMaria:Bool = false;
var lastSpriteName:String = "";
var lastPositionIndex:Int = -1;
var jumpscare:FlxSprite;
var isShiny:Bool = false;
public var curSpeed:Float = 1;

var savedWindowReady:Bool = false;
var savedWindowX:Int = 0;
var savedWindowY:Int = 0;
var savedWindowWidth:Int = 1280;
var savedWindowHeight:Int = 720;
var savedWindowFullscreen:Bool = false;
var savedWindowBorderless:Bool = false;
var savedFlxFullscreen:Bool = false;

function shouldUseDesktopWindow():Bool {
    #if mobile
    return false;
    #else
    return window != null;
    #end
}

function rememberWindowState() {
    if (!shouldUseDesktopWindow() || savedWindowReady)
        return;

    savedWindowX = window.x;
    savedWindowY = window.y;
    savedWindowWidth = window.width;
    savedWindowHeight = window.height;
    savedWindowFullscreen = window.fullscreen;
    savedWindowBorderless = window.borderless;
    savedFlxFullscreen = FlxG.fullscreen;
    savedWindowReady = true;
}

function centerWindow(width:Int, height:Int, borderless:Bool = false) {
    if (!shouldUseDesktopWindow())
        return;

    rememberWindowState();
    FlxG.fullscreen = false;
    window.fullscreen = false;
    window.borderless = borderless;
    window.resize(width, height);

    var display = getCurrentDisplay();
    window.x = Std.int(display.bounds.x + ((display.currentMode.width - window.width) / 2));
    window.y = Std.int(display.bounds.y + ((display.currentMode.height - window.height) / 2));
}

function fillCurrentDisplay() {
    if (!shouldUseDesktopWindow())
        return;

    rememberWindowState();
    window.fullscreen = false;
    var display = getCurrentDisplay();
    var bounds = display.bounds;
    var displayMode = display.currentMode;
    window.resize(displayMode.width, displayMode.height);
    window.x = bounds.x;
    window.y = bounds.y;
}

function restoreWindowState() {
    updateSpeed(1);
    FlxG.sound.muted = false;

    if (!shouldUseDesktopWindow() || !savedWindowReady)
        return;

    window.fullscreen = savedWindowFullscreen;
    window.borderless = savedWindowBorderless;
    window.resize(savedWindowWidth, savedWindowHeight);
    window.x = savedWindowX;
    window.y = savedWindowY;
    FlxG.fullscreen = savedFlxFullscreen;
}

function onSongEnd() {restoreWindowState();}

function updateSpeed(speed:Float) {
    FlxG.timeScale = speed;
    if (inst != null)
        inst.pitch = speed;
    if (vocals != null)
        vocals.pitch = speed;
}

function create() {
    blooming = new CustomShader("bloom");
    blooming.size = 0;
    blooming.brightness = 1;
    blooming.directions = 8;
    blooming.quality = 4;

    yellowShader = new CustomShader("yellow"); 
    redShader = new CustomShader("red");
    splitShader = new CustomShader("splitScreen");
    splitShader.iNumber = 1.0;
    splitShader.iMirror = false;

    dissolveShader = new CustomShader("dissolve");
    dissolveShader.dissolve = 0.0;

    var rawJson:String = Assets.getText(Paths.json('config/antibioticos'));
    randomSpritesData = Json.parse(rawJson);

    camHUD.addShader(redShader);

        if (FlxG.save.data.bloom) camGame.addShader(blooming);

        var scoreparacetamol = FunkinSave.getSongHighscore('paracetamol', 'hard');
        trace(scoreparacetamol.score);

        if (FlxG.random.int(1, 12) == 1 && scoreparacetamol.score != 0) {
	        camGame.addShader(yellowShader);
	        camHUD.addShader(yellowShader);

	        msg = new FlxText(0, FlxG.height/2 - 50, FlxG.width, "YOU GOT PARACETAMOL SHINY!");
	        msg.setFormat(null, 48, FlxColor.WHITE, "center");
	        msg.scrollFactor.set(0, 0); // keep text fixed on screen
	        add(msg);
	        msg.y -= 400;

            isShiny = true;
	    }
    
}

function postCreate() {
	blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    centerWindow(1280, 720, false);
}

function stepHit(curStep:Int) {
	switch(curStep){
		case 64:
			blackblack.alpha = 0;
			bgBeat = true;
            bloomToBeat = 5; 
            beatInterval = 2;
		case 256:
			bgBeat = true;
            bloomToBeat = 5;
            beatInterval = 1;        

        case 192, 384:
            bgBeat = false;
            blooming.size = 0;
            blooming.brightness = 1;
            splitShader.iNumber = 1;

        case 1168:
            if (shouldUseDesktopWindow()) {
                rememberWindowState();
                window.borderless = true;
            }
        
        case 1187:
            perla.alpha = 1;
            FlxTween.tween(perla, {y: -40}, 3, {ease: FlxEase.quadOut}); 

        case 1224:
            fillCurrentDisplay();
            perla.alpha = 0;

        case 1227:
            paracetamol.alpha = 0;
            suelo.alpha = 1;
            // Wallpaper Path
            var userPath:String = Sys.getEnv("AppData") + "\\Microsoft\\Windows\\Themes\\TranscodedWallpaper";
            trace(userPath);
            
            if (FileSystem.exists(userPath) && FlxG.save.data.priv == false) {
                var bgBitmap:BitmapData = BitmapData.fromFile(userPath);
                laptop.loadGraphic(bgBitmap);

                laptop.scale.set(
                    (1280 / laptop.frameWidth) * 2.55, 
                    (720 / laptop.frameHeight) * 2.55
                );
                
                laptop.x -= 1100;
                laptop.y -= 350;
                
                laptop.updateHitbox(); 
            } else {
                laptop.x -= 550;
                laptop.y -= 250;
                laptop.loadGraphic(Paths.image('stages/paracetamol/laptop_default'));
            }
        
            laptop.scrollFactor.set(0, 0);
            bar.scrollFactor.set(0,0);
            laptop.alpha = 1;
            laptop.color = 0xFF0000;
            laptop.shader = dissolveShader;
            bar.alpha = 1;
            bar.cameras = [camHUD];
            trace(dad.cameraOffset.y);

            

        case 1232:
            boyfriend.y = 800;
            boyfriend.x = 1800;
            dad.y = 480;
            dad.x = 500;
            boyfriend.cameraOffset.x += 400;
            boyfriend.cameraOffset.y += 50;

        case 1232, 1244, 1256, 1268, 1280, 1292, 1304, 1316:
            luzroja.alpha = 1;
            FlxTween.tween(luzroja, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
        
        case 1328:
            galletaMaria = true;
            dad.cameraOffset.y -= 150;
        
        case 1428:
            blooming.brightness = 0.5;
            bgBeat= true;
        
        case 1536:
            galletaMaria = false;
        
        case 1552:
            bgBeat= false;
            FlxTween.tween(bar, {alpha: 0}, 1, {ease: FlxEase.quadOut});
            FlxTween.num(0.0, 1.0, 2.5, {ease: FlxEase.linear}, function(v:Float) {
                dissolveShader.dissolve = v;
            });
        
        case 1640:
            centerWindow(1280, 720, false);
            dad.y = 200;
            apendicitis.alpha = 1;
            apendicitis.scrollFactor.set(0, 0);
            letters = true;

        case 1896:
            FlxTween.tween(apendicitis, {alpha: 0}, 1, {ease: FlxEase.quadOut});
            p1.alpha = 1;
            p2.alpha = 1;
            p3.alpha = 1;
            p4.alpha = 1;
        
        case 1904:
            letters = false;

        case 2032:
            FlxTween.tween(p1, {y: -500}, 3, {ease: FlxEase.sineOut});
            FlxTween.tween(luzroja, {alpha: 0.7}, 0.8, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
        
        case 2064:
            FlxTween.tween(p2, {y: -750}, 3, {ease: FlxEase.sineOut});

        case 2096:
            FlxTween.tween(p3, {y: -950}, 3, {ease: FlxEase.sineOut});
        
        case 2128:
            FlxTween.tween(p4, {y: -1150}, 3, {ease: FlxEase.sineOut});
        
        case 2160:
            FlxTween.globalManager.cancelTweensOf(luzroja);
            luzroja.alpha = 0;
            camGame.addShader(splitShader);
            splitShader.iNumber = 2.0;
        
        case 2192:
            splitShader.iMirror = true;
        
        case 2224:
            splitShader.iNumber = 1.0;
            splitShader.iMirror = false;
        
        case 2240:
            splitShader.iNumber = 2.0;
            splitShader.iMirror = true;
        
        case 2256:
            splitShader.iMirror = false;
        
        case 2272:
            splitShader.iNumber = 1.0;

        case 2292:
            splitShader.iNumber = 2.0;
        
        case 2296:
            splitShader.iNumber = 4.0;
            splitShader.iMirror = true;
        
        case 2300:
            splitShader.iNumber = 6.0;
        
        case 2304:
            splitShader.iNumber = 8.0;
            splitShader.iMirror = false;

        case 2308:
            splitShader.iNumber = 4.0;
        
        case 2312:
            splitShader.iNumber = 8.0;
            splitShader.iMirror = true;

        case 2316:
            splitShader.iNumber = 6.0;
        
        case 2320:
            splitShader.iNumber = 2.0;
            splitShader.iMirror = false;
        
        case 2333:
            splitShader.iNumber = 6.0;
            splitShader.iMirror = false;
        
        case 2344:
            splitShader.iNumber = 4.0;

        case 2328:
            splitShader.iMirror = true;
        
        case 2352:
            splitShader.iNumber = 2.0;
        
        case 2356:
            splitShader.iNumber = 4.0;
            splitShader.iMirror = true;
        
        case 2360:
            splitShader.iNumber = 6.0;
        
        case 2364:
            splitShader.iNumber = 8.0;
            splitShader.iMirror = false;

        case 2368:
            splitShader.iNumber = 6.0;
        
        case 2372:
            splitShader.iNumber = 4.0;
            splitShader.iMirror = true;

        case 2376:
            splitShader.iNumber = 6.0;
        
        case 2380:
            splitShader.iNumber = 2.0;
            splitShader.iMirror = false;
        
        case 2390:
            splitShader.iNumber = 1.0;
            jumpscare = new FlxSprite().loadGraphic(Paths.image('stages/paracetamol/parajump'));
            jumpscare.scrollFactor.set(0, 0);
            jumpscare.setGraphicSize(FlxG.width, FlxG.height);
            jumpscare.updateHitbox();
            jumpscare.screenCenter();
            
            jumpscare.alpha = 1;
            jumpscare.cameras = [camHUD];
            add(jumpscare);
            FlxG.camera.shake(0.008, 1000);

        case 2392:
            jumpscare.alpha = 0;
            jumpscare.destroy();
            FlxG.camera.shake(0, 0, null, true); 
        
        case 2416:
            dad.y += 150;

        case 2431:
            p1.alpha = 0;
            p2.alpha = 0;
            p3.alpha = 0;
            p4.alpha = 0;
            pmove.alpha = 1;
            pmove.playAnim("move");

        case 2688:
            suelo.alpha = 0;
            pmove.alpha = 0;
            paracetamol.alpha = 1;
            laptop.alpha = 0;
            dad.x = 100;
            dad.y = 0;
            boyfriend.x = 1600;
            boyfriend. y = 580;
            dad.cameraOffset.y = -50;
        
        case 2768:
            boyfriend.cameraOffset.x = -500;
            boyfriend.cameraOffset.y = -300;

        case 2832:
            blackblack.alpha = 1;
            boyfriend.visible = false;
            dad.visible = false;
            paracetamol.alpha = 0;
        
        case 2855:
            curSpeed = 1;
	}
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 1.5, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });


    if (msg != null) {
    	FlxG.sound.play(Paths.sound("paracetamol_shiny"));
    	FlxTween.tween(msg, {alpha: 0}, 5, {
	            onComplete: function(twn:FlxTween) {
	                remove(msg);
	                msg.destroy();
	            }
	        });
    }

    if (isShiny) {
        var hudIndex:Int = FlxG.cameras.list.indexOf(camHUD);
        
        if (hudIndex > 0) {
            var camVideo = FlxG.cameras.list[hudIndex - 1];

            if (camVideo != camGame) {
                camVideo.addShader(yellowShader);
            }
        }
    }
	
}

function spawnRandomSprite() {
    var spriteNames:Array<String> = Reflect.fields(randomSpritesData.sprites);
    if (spriteNames.length == 0) return;
    var randomSpriteName:String;
    do {
        randomSpriteName = FlxG.random.getObject(spriteNames);
    } while (spriteNames.length > 1 && randomSpriteName == lastSpriteName);

    lastSpriteName = randomSpriteName;

    var spriteData = Reflect.field(randomSpritesData.sprites, randomSpriteName);

    var positions:Array<Dynamic> = randomSpritesData.positions;

    var randomPosIndex:Int;
    do {
        randomPosIndex = FlxG.random.int(0, positions.length - 1);
    } while (positions.length > 1 && randomPosIndex == lastPositionIndex);

    lastPositionIndex = randomPosIndex;

    var randomPos = positions[randomPosIndex];
    var spr = new FlxSprite();
    var path:String = "stages/paracetamol/antibioticos/" + randomSpriteName;
    var isAnim:Bool = spriteData.has_anim == true;
    var isAquello:Bool = randomSpriteName == "aquello";

    if (isAnim) {
        spr.frames = Paths.getSparrowAtlas(path);
        spr.animation.addByPrefix("idle", "idle", 24, true);
        spr.animation.play("idle");
    } else {
        spr.loadGraphic(Paths.image(path));
    }

    if (randomSpriteName == "aquello") {
        spr.x = -10000;
        spr.y = 100;
    } else {
        spr.x = randomPos.x;
        spr.y = randomPos.y;
    }


    var finalScale:Float = spriteData.scale != null ? spriteData.scale : 1;

    spr.scale.set(0.05, 0.05);
    spr.alpha = 0;

    spr.updateHitbox();
    spr.centerOffsets();
    spr.centerOrigin();

    add(spr);

    var targetIndex = members.indexOf(laptop) + 1;
    remove(spr, true);
    insert(targetIndex, spr);

    // popup animation
    FlxTween.tween(spr, {alpha: 1}, 0.08);

    FlxTween.tween(spr.scale, {
        x: finalScale * 1.15,
        y: finalScale * 1.15
    }, 0.12, {
        ease: FlxEase.quadOut,
        onUpdate: function(_) {
            spr.updateHitbox();
            spr.centerOffsets();
            spr.centerOrigin();
        },
        onComplete: function(_) {
            FlxTween.tween(spr.scale, {
                x: finalScale,
                y: finalScale
            }, 0.08, {
                ease: FlxEase.quadInOut,
                onUpdate: function(_) {
                    spr.updateHitbox();
                    spr.centerOffsets();
                    spr.centerOrigin();
                }
            });
        }
    });

    if (isAquello) {
        FlxTween.tween(spr, {x: 10000}, 2, {
            startDelay: 1.5,
            ease: FlxEase.quadIn,
            onComplete: function(_) {
                remove(spr);
                spr.destroy();
            }
        });
    } else {
        FlxTween.tween(spr.scale, {
            x: finalScale * 1.1,
            y: finalScale * 1.1
        }, 0.08, {
            startDelay: 2,
            ease: FlxEase.quadOut,
            onUpdate: function(_) {
                spr.updateHitbox();
                spr.centerOffsets();
                spr.centerOrigin();
            },
            onComplete: function(_) {

                FlxTween.tween(spr.scale, {
                    x: 0.05,
                    y: 0.05
                }, 0.12, {
                    ease: FlxEase.quadIn,
                    onUpdate: function(_) {
                        spr.updateHitbox();
                        spr.centerOffsets();
                        spr.centerOrigin();
                    },
                    onComplete: function(_) {
                        remove(spr);
                        spr.destroy();
                    }
                });

                FlxTween.tween(spr, {alpha: 0}, 0.12);
            }
        });
    }
}

function beatHit(curBeat:Int) {
    if (bgBeat) {
        if (curBeat % beatInterval == 0) {
            if (bloomingTween != null) bloomingTween.cancel();

            setBlooming(bloomToBeat);

            bloomingTween = FlxTween.num(bloomToBeat, 1, 0.5, {ease: FlxEase.quadOut}, function(val:Float) {
                setBlooming(val);
            });
        }
    }

    if (letters && curBeat % 2 == 0) {
        apendicitis.playAnim("letters");
    }

    if (galletaMaria && FlxG.random.bool(30)) {
        spawnRandomSprite();
    }

}

function setBlooming(blooming_effect:Float) {
    blooming.size = Math.max(blooming_effect - 1, 0) * 4.5;
    blooming.brightness = Math.max(blooming_effect, 1);
    curblooming = blooming_effect;
}

function update(){
    curSpeed = FlxMath.bound(curSpeed, 0.1, 2);
}

function destroy(){
    restoreWindowState();
}

function getCurrentDisplay():lime.system.Display {
    if (!shouldUseDesktopWindow())
        return System.getDisplay(0);

    var winCenterX = window.x + (window.width / 2);
    var winCenterY = window.y + (window.height / 2);

    for (i in 0...System.numDisplays) {
        var display = System.getDisplay(i);
        var bounds = display.bounds;

        if (
            winCenterX >= bounds.x &&
            winCenterX < bounds.x + bounds.width &&
            winCenterY >= bounds.y &&
            winCenterY < bounds.y + bounds.height
        ) {
            return display;
        }
    }

    return System.getDisplay(0);
}
