import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.text.FlxText.FlxTextBorderStyle;
import openfl.display.BlendMode;
import flixel.group.FlxGroup;

var canSelect:Bool = false;
var unselectedScale:Float = 0.15;
var selectedScale:Float = 0.18;

var coverSprites:Array<FlxSprite> = [];
var selector:FlxSprite;
var curSelected:Int = 1;
var mixTitle:FlxText;
var bgOverlay:FlxSprite;

var songs:Array<Dynamic>;
var mixList:Array<String> = [];
var songData:Dynamic = null;
var signSprite;
var group:FlxSpriteGroup = new FlxSpriteGroup(); 

function create() {
    // Pull from save data instead of publicArray
    if (FlxG.save.data.mixList != null) {
        mixList = FlxG.save.data.mixList;
        songData = FlxG.save.data.songData;
    }

    trace("Mixes loaded: " + mixList);

    bgOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
    bgOverlay.alpha = 0;
    bgOverlay.blend = BlendMode.MULTIPLY;
    FlxTween.tween(bgOverlay, {alpha: 0.7}, 0.3);
    add(bgOverlay);
    
    signSprite = new FlxSprite(0, -0);
    signSprite.loadGraphic(Paths.image('states/freeplay/sign2'));
    signSprite.scale.set(0.53, 0.53);
    signSprite.updateHitbox();
    signSprite.screenCenter();
    signSprite.alpha = 1;
    signSprite.y = -2000;
    add(signSprite);
    
    if (mixList == null || mixList.length == 0) {
        close();
        return;
    }

    mixTitle = new FlxText(0, -FlxG.height * 2, FlxG.width, "SELECT VERSION");
    mixTitle.setFormat(Paths.font("KrabbyPatty.otf"), 60, 0xFFFFFFFF, "center");
    mixTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
    add(mixTitle);
    FlxTween.tween(mixTitle, {y: 130}, 1, {ease: FlxEase.expoOut});

    var spacing:Float = FlxG.width / (mixList.length + 1);

    for (i in 0...mixList.length) {
        var mixName = mixList[i];
        var cover = new FlxSprite(spacing * (i + 1), -FlxG.height * 2); 
        
        cover.loadGraphic(Paths.image('menus/covers/' + mixName));
        cover.antialiasing = true;
        cover.scale.set(unselectedScale, unselectedScale);
        cover.updateHitbox();
        
        var targetY:Float = (FlxG.height / 2) - (cover.height / 2) + 50;
        cover.x -= (cover.width / 2);
        cover.ID = i;
        cover.alpha = 0;
        
        FlxTween.tween(cover, {y: targetY, alpha: 0.7}, 1, {
            ease: FlxEase.expoOut 
        });

        coverSprites.push(cover);
        add(cover);
        group.add(cover);
    }

    var totalWaitTime:Float = (mixList.length * 0.1) + 1; 
    new FlxTimer().start(totalWaitTime, function(tmr:FlxTimer) {
        canSelect = true;
        curSelected = -1;
        changeSelection(1);
    });

    songs = FreeplaySonglist.get().songs;
    group.add(mixTitle);
    FlxTween.tween(signSprite, {y:-190}, 1, {ease: FlxEase.expoOut});
    
    addMobilePad("LEFT_RIGHT", "A_B");
}

function update(elapsed:Float) {
    group.x =-10;
    if (!canSelect){
        return;
    }
    
    if (controls.LEFT_R) changeSelection(-1);
    if (controls.RIGHT_R) changeSelection(1);

    if (controls.ACCEPT) {
        if (songData != null) {
            if (FlxG.sound.music != null) FlxG.sound.music.stop();
            PlayState.loadSong(mixList[curSelected], songData.difficulties[0]);
            FlxG.switchState(new ModState("StartCredits"));
        }
    }

    if (controls.BACK) {
        if (FlxG.sound.music != null) FlxG.sound.music.resume();
        close();
    }
}

function changeSelection(change:Int) {
    curSelected += change;
    if (curSelected < 0) curSelected = mixList.length - 1;
    if (curSelected >= mixList.length) curSelected = 0;

    var selectedMixName:String = Std.string(mixList[curSelected]);

    for (sprite in coverSprites) {
        FlxTween.cancelTweensOf(sprite.scale);
        FlxTween.cancelTweensOf(sprite.alpha);
        var targetScale:Float = (sprite.ID == curSelected) ? selectedScale : unselectedScale;
        var targetAlpha:Float = (sprite.ID == curSelected) ? 1.0 : 0.7;
        FlxTween.tween(sprite.scale, {x: targetScale, y: targetScale}, 0.5, {ease: FlxEase.expoOut}); 
        FlxTween.tween(sprite, {alpha : targetAlpha}, 0.2, {ease: FlxEase.quadOut}); 
        if (sprite.ID == curSelected) {
            for (s in songs) {
                if (s.name == selectedMixName) {
                    songData = s;
                    break;
                }
            }
        }
    }
    
    mixTitle.text = selectedMixName.toUpperCase().split('-').join(' ');
}