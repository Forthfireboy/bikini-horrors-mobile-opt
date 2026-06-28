import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import openfl.utils.Assets;

var bgSprite:FlxSprite;
var curSelected:Int = 0;
var coversArray:Array<FlxSprite> = [];
var versionPaths:Array<String> = ["v1", "v2", "v3"]; 
var coverSpacing:Float = 280;
var baseScale:Float = 0.9;
var selectedScale:Float = 0.95;
var isV2Unlocked:Bool = true;
var secretV4HoldTimer:Float = 0;
var secretV4HoldRequired:Float = 1.35;
var secretV4Loading:Bool = false;
var secretV4PointerLocked:Bool = false;
var v4UnknownLabel:FlxText = null;

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

    layoutCovers();
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

    var clickedCover:Bool = false;
    for (i in 0...coversArray.length) {
        var spr = coversArray[i];
        if (FlxG.mouse.overlaps(spr)) {
            if (curSelected != i) curSelected = i;
            if (FlxG.mouse.justReleased)
                clickedCover = true;
        }
    }

    if (controls.ACCEPT || clickedCover) {
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

        if (v4UnknownLabel != null && versionPaths[i] == "v4") {
            v4UnknownLabel.alpha = spr.alpha;
            v4UnknownLabel.scale.set(spr.scale.x, spr.scale.y);
            v4UnknownLabel.x = spr.x;
            v4UnknownLabel.y = spr.y + (spr.height * 0.5) - (v4UnknownLabel.height * 0.5);
        }
    }

}

function layoutCovers() {
    var totalGroupWidth:Float = (versionPaths.length - 1) * coverSpacing;
    var startX:Float = (1280 / 2) - (totalGroupWidth / 2);

    for (i in 0...coversArray.length) {
        var cover = coversArray[i];
        var currentItemCenter:Float = startX + (i * coverSpacing);
        cover.x = currentItemCenter - (cover.width / 2);
        cover.y = 360 - (cover.height / 2);

        if (v4UnknownLabel != null && versionPaths[i] == "v4") {
            v4UnknownLabel.fieldWidth = cover.width;
            v4UnknownLabel.x = cover.x;
            v4UnknownLabel.y = cover.y + (cover.height * 0.5) - (v4UnknownLabel.height * 0.5);
        }
    }
}

function handleSecretV4Input(elapsed:Float):Bool {
    var keyboardSecret = controls.SWITCHMOD && FlxG.keys.justPressed.FOUR;
    if (keyboardSecret) {
        loadV4Week();
        return true;
    }

    if (!FlxG.mouse.pressed && !FlxG.mouse.justPressed && !FlxG.mouse.justReleased) {
        secretV4HoldTimer = 0;
        secretV4PointerLocked = false;
        return false;
    }

    var tapX = FlxG.mouse.screenX;
    var tapY = FlxG.mouse.screenY;
    var secretWidth:Float = Math.max(220, FlxG.width * 0.18);
    var secretHeight:Float = Math.max(140, FlxG.height * 0.22);
    var inSecretCorner = tapX >= FlxG.width - secretWidth && tapY <= secretHeight;

    if (!secretV4PointerLocked && inSecretCorner && FlxG.mouse.justPressed)
        secretV4PointerLocked = true;

    if (secretV4PointerLocked) {
        if (FlxG.mouse.pressed) {
            if (inSecretCorner) {
                secretV4HoldTimer += elapsed;
                if (secretV4HoldTimer >= secretV4HoldRequired) {
                    secretV4HoldTimer = 0;
                    loadV4Week();
                }
            } else {
                secretV4HoldTimer = 0;
            }
            return true;
        }

        if (FlxG.mouse.justReleased) {
            secretV4HoldTimer = 0;
            secretV4PointerLocked = false;
            return true;
        }

        return true;
    }

    return inSecretCorner && FlxG.mouse.justReleased;
}

function loadV4Week() {
    if (secretV4Loading)
        return;

    secretV4Loading = true;
    revealV4Cover();
    secretV4Loading = false;
}

function revealV4Cover() {
    var existingIndex:Int = versionPaths.indexOf("v4");
    if (existingIndex >= 0) {
        curSelected = existingIndex;
        changeSelection(0, false);
        return;
    }

    versionPaths.push("v4");

    var cover = new FlxSprite();
    var v4Path = Paths.image('states/vselection/v4');
    if (Assets.exists(v4Path)) {
        cover.loadGraphic(v4Path);
    } else {
        cover.makeGraphic(260, 360, 0xFF050505);
        v4UnknownLabel = new FlxText(0, 0, 260, "?", 150);
        v4UnknownLabel.setFormat(Paths.font("KrabbyPatty.otf"), 150, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        v4UnknownLabel.scrollFactor.set();
    }

    cover.antialiasing = true;
    cover.scale.set(baseScale, baseScale);
    cover.updateHitbox();
    add(cover);
    coversArray.push(cover);

    if (v4UnknownLabel != null)
        add(v4UnknownLabel);

    layoutCovers();
    curSelected = coversArray.length - 1;
    changeSelection(0, false);
    FlxG.sound.play(Paths.sound('menu/confirm'));
}

function changeSelection(change:Int = 0, playSound:Bool = true) {
    curSelected += change;

    if (curSelected < 0) curSelected = coversArray.length - 1;
    if (curSelected >= coversArray.length) curSelected = 0;
}

function selectVersion(index:Int) {
    if (index == 1 && !isV2Unlocked) return;
    if (versionPaths[index] == "v4") {
        FlxG.sound.play(Paths.sound('menu/scroll'));
        return;
    }

    FlxG.save.data.selectedVersion = index;
    FlxG.save.flush();

    FlxG.switchState(new ModState("VersionHandler"));
}
