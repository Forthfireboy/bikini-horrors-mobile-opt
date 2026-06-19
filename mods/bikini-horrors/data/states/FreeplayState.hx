import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import funkin.savedata.FunkinSave;
import funkin.savedata.HighscoreEntry;

var coverSprites:Array<FlxSprite> = [];
import funkin.backend.utils.WindowUtils;
var coverBorders:Array<FlxSprite> = [];
var coverPaths:Array<String> = [];

var defaultCover:FlxSprite;
var defaultBorder:FlxSprite;
var defaultPath:String = 'menus/covers/default';

var lastCover:Int = -1;

function checkAllSongsCleared() {
    if (FlxG.save.data.allSongsCleared) return;

    var songList = [
        'guater-game',
        'f-is-for-fevil',
        'infinete',
        'sunderwater',
        'catch-and-fish',
        'bubbletwister'
    ];

    var allCleared = true;

    for (song in songList) {
        var entry = FunkinSave.getSongHighscore(song, "hard");
        if (entry.score <= 0) {
            allCleared = false;
            break;
        }
    }

    if (allCleared) {
        trace("All songs cleared!");
        FlxG.save.data.allSongsCleared = true;
        FlxG.save.flush();
        FlxG.switchState(new ModState("PreMainMenuVideo"));
    }
}




function postCreate() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
    timeUntilAutoplay = 99999999999999999999; 
        // 99,999,999,999,999,999,999 seconds is approximately:
        // = 99,999,999,999,999,999,999 / (60 * 60 * 24 * 365.25)
        // ≈ 3.1709791983764586e+15 years
        // That’s about 3.17 quadrillion years — far longer than the age of the universe!
        
    bg.loadGraphic(Paths.image('menus/menuBob'));


    // DEBUG DEBUG AIKA BORRA BORRA
    /*
    china = FunkinSave.getSongHighscore('made-in-china', 'hard');
    china.score = 0;
    trace(china);
    */

    var laPlayaScore = FunkinSave.getSongHighscore('la-playa', 'hard');




    coverPaths = [
        'menus/covers/guater-game',
        'menus/covers/welcome-back',
        'menus/covers/infinete',
        'menus/covers/infinete-es-mix',
        'menus/covers/sunderwater',
        'menus/covers/catch-and-fish',
        'menus/covers/bubbletwister',
        'menus/covers/wordle',
        'menus/covers/fertility',
        'menus/covers/go-to-eat',
        'menus/covers/la-playa',
        'menus/covers/vash-a-morir',
        'menus/covers/carmaland',
        'menus/covers/paracetamol',
        'menus/covers/powerscaling',
        'menus/covers/made-in-china',
        'menus/covers/barnacles',
        'menus/covers/pool-parti',
        'menus/covers/mega-mortal-madness'
    ];

    if (laPlayaScore != null && laPlayaScore.score != 0) {
        var idx = coverPaths.indexOf('menus/covers/la-playa');
        if (idx != -1) {
            coverPaths[idx] = 'menus/covers/la-playa-2';
        }
    }

    for (path in coverPaths) {
        var xPos = 850;
        var yPos = 215;
        var scaleFactor:Float = (path == 'menus/covers/catch-and-fish' || path == 'menus/covers/guater-game') ? 0.333 : 0.2;

        var sprite = new FlxSprite(xPos, yPos);
        sprite.loadGraphic(Paths.image(path));
        sprite.setGraphicSize(Std.int(sprite.width * scaleFactor), Std.int(sprite.height * scaleFactor));
        sprite.updateHitbox();
        sprite.visible = false;
        sprite.alpha = 0;

        var border = new FlxSprite(xPos, yPos);
        border.makeGraphic(Std.int(sprite.width + 10), Std.int(sprite.height + 10), 0xFFFFFFFF);
        border.offset.set(5, 5);
        border.visible = false;
        border.alpha = 0;

        coverBorders.push(border);
        coverSprites.push(sprite);

        add(border);
        add(sprite);
    }

    defaultCover = new FlxSprite(850, 215);
    defaultCover.loadGraphic(Paths.image(defaultPath));
    defaultCover.setGraphicSize(Std.int(defaultCover.width * 0.2), Std.int(defaultCover.height * 0.2));
    defaultCover.updateHitbox();
    defaultCover.visible = false;
    defaultCover.alpha = 0;

    defaultBorder = new FlxSprite(850, 215);
    defaultBorder.makeGraphic(Std.int(defaultCover.width + 10), Std.int(defaultCover.height + 10), 0xFFFFFFFF);
    defaultBorder.offset.set(5, 5);
    defaultBorder.visible = false;
    defaultBorder.alpha = 0;

    add(defaultBorder);
    add(defaultCover);
    

}

function postUpdate() {
    if (curSelected != lastCover) {
        lastCover = curSelected;
        var nextCover:FlxSprite;

        if (curSelected >= 0 && curSelected < coverSprites.length) {
            nextCover = coverSprites[curSelected];
        } else {
            nextCover = defaultCover;
        }

        for (i in 0...coverSprites.length) {
            var sprite = coverSprites[i];
            var border = coverBorders[i];

            if (sprite != nextCover) {
                FlxTween.cancelTweensOf(sprite);
                FlxTween.cancelTweensOf(border);
                FlxTween.tween(sprite, {alpha: 0}, 0.2);
                FlxTween.tween(border, {alpha: 0}, 0.2);
                sprite.visible = false;
                border.visible = false;
            }
        }

        if (defaultCover != nextCover) {
            FlxTween.cancelTweensOf(defaultCover);
            FlxTween.cancelTweensOf(defaultBorder);
            FlxTween.tween(defaultCover, {alpha: 0}, 0.2);
            FlxTween.tween(defaultBorder, {alpha: 0}, 0.2);
            defaultCover.visible = false;
            defaultBorder.visible = false;
        }

        nextCover.alpha = 0;
        nextCover.visible = true;
        FlxTween.tween(nextCover, {alpha: 1}, 0.2);

        var nextBorder:FlxSprite = (nextCover == defaultCover) ? defaultBorder : coverBorders[coverSprites.indexOf(nextCover)];
        nextBorder.alpha = 0;
        nextBorder.visible = true;
        FlxTween.tween(nextBorder, {alpha: 1}, 0.5);
    }

    checkAllSongsCleared();
}
