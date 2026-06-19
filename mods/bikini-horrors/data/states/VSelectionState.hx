import funkin.backend.week.Week;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

var bgSprite:FlxSprite;
var curSelected:Int = 0;
var coversArray:Array<FlxSprite> = [];
var versionPaths:Array<String> = ["v1", "v2", "v3"]; 
var coverSpacing:Float = 280;
var baseScale:Float = 0.9;
var selectedScale:Float = 0.95;
var isV2Unlocked:Bool = true;

function create() {
    isV2Unlocked = FlxG.save.data.unlockedV2;
    //FlxG.mouse.visible = true;

    bgSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("states/vselection/bg"));
    bgSprite.scale.set(0.7, 0.7);
    bgSprite.updateHitbox();
    bgSprite.screenCenter();
    add(bgSprite);

    var totalGroupWidth:Float = (versionPaths.length - 1) * coverSpacing;
    var startX:Float = (1280 / 2) - (totalGroupWidth / 2);

    for (i in 0...versionPaths.length) {
        var cover:FlxSprite = new FlxSprite();
        cover.loadGraphic(Paths.image('states/vselection/' + versionPaths[i]));

        if (i == 1 && !isV2Unlocked) {
            var originalWidth:Int = Std.int(cover.width);
            var originalHeight:Int = Std.int(cover.height);
            cover.makeGraphic(originalWidth, originalHeight, FlxColor.BLACK);
        }

        cover.antialiasing = true;
        cover.scale.set(baseScale, baseScale);
        cover.updateHitbox();

        var currentItemCenter:Float = startX + (i * coverSpacing);
        cover.x = currentItemCenter - (cover.width / 2);
        cover.y = 360 - (cover.height / 2);

        add(cover);
        coversArray.push(cover);
    }

    changeSelection(0, false);
    
    addMobilePad("NONE", "B");
}

function update(elapsed:Float) {
    if (controls.BACK) {
        FlxG.mouse.visible = false;
        FlxG.switchState(new ModState("BHTitleState"));
    }

    if (controls.LEFT) changeSelection(-1, true);
    if (controls.RIGHT) changeSelection(1, true);

    if (FlxG.mouse.wheel > 0) {
        changeSelection(-1, true);
    } else if (FlxG.mouse.wheel < 0) {
        changeSelection(1, true);
    }

    for (i in 0...coversArray.length) {
        var spr = coversArray[i];
        if (FlxG.mouse.overlaps(spr)) {
            if (curSelected != i) curSelected = i;
        }
    }

    if (controls.ACCEPT || FlxG.mouse.justReleased) {
        selectVersion(curSelected);
    }

    for (i in 0...coversArray.length) {
        var spr = coversArray[i];
        var targetScale:Float = baseScale;
        var targetAlpha:Float = 0.6;

        if (i == curSelected) {
            targetScale = selectedScale;
            targetAlpha = 1.0;
        }

        if (i == 1 && !isV2Unlocked) {
            targetScale = baseScale;
            targetAlpha = 1;
        }

        spr.scale.x += (targetScale - spr.scale.x) * (elapsed * 8);
        spr.scale.y += (targetScale - spr.scale.y) * (elapsed * 8);
        spr.alpha += (targetAlpha - spr.alpha) * (elapsed * 8);
    }

    if (controls.SWITCHMOD && FlxG.keys.justPressed.FOUR) {
        PlayState.loadWeek(Week.loadWeek('v4', false), "hard");
        PlayState.switchToPlayState();
    }
}

function changeSelection(change:Int = 0, playSound:Bool = true) {
    curSelected += change;

    if (curSelected < 0) curSelected = coversArray.length - 1;
    if (curSelected >= coversArray.length) curSelected = 0;
}

function selectVersion(index:Int) {
    if (index == 1 && !isV2Unlocked) return;

    FlxG.save.data.selectedVersion = index;
    FlxG.save.flush();

    FlxG.switchState(new ModState("VersionHandler"));
}
