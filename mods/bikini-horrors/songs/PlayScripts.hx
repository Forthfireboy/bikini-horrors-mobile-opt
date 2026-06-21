// Thanks Nex for msot of this script :3 - Chezzar
import flixel.math.FlxRect;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.ui.FlxBar;
import flixel.util.FlxAxes;
import funkin.game.HealthIcon;
import flixel.FlxSprite;
import funkin.game.PlayState;

public var sonicMode:Bool = false;

static var healthColors = [0xFF000000, 0xFF000000];
var newBar:FlxSprite;
var _barRect:FlxRect = new FlxRect();

var falseHealth:Float = health;
var healthpercent:Float = falseHealth / maxHealth;
var xPos = 390;

public var cinematicTOP:FlxSprite;
public var cinematicLOWER:FlxSprite;

public var timeBar:FlxBar;
public var timePassedTxt:FunkinText;
public var totalTimeTxt:FunkinText;

public var angle : Float = 0;

public var rankTxt:FunkinText;

public var camMoveOffset:Float = 15;
public var camAngleOffset:Float = .3;

var stopPlayTweens:Bool = false;

var misses:Int = null;
var accuracy:Float = null;
var oldImagePath:String->String = null;

function isMadeInChinaSong():Bool {
    var songName = PlayState.SONG == null || PlayState.SONG.meta == null ? "" : PlayState.SONG.meta.name.toLowerCase();
    var songId = PlayState.instance == null ? "" : PlayState.instance.curSongID.toLowerCase();

    songName = songName.split(" ").join("").split("-").join("").split("_").join("");
    songId = songId.split(" ").join("").split("-").join("").split("_").join("");

    return songName == "madeinchina" || songId == "madeinchina";
}

function layoutMadeInChinaHud() {
    if (!isMadeInChinaSong())
        return;

    var topY:Float = 10;
    var padding:Float = 16;
    var spacing:Float = 18;
    var rightWidth:Float = FlxG.width - padding * 2;

    for (txt in [scoreTxt, accuracyTxt, missesTxt]) {
        if (txt == null)
            continue;

        txt.cameras = [camHUD];
        txt.scrollFactor.set();
        txt.y = topY;
        txt.visible = true;
        txt.updateHitbox();
    }

    if (scoreTxt != null) {
        scoreTxt.x = padding;
        scoreTxt.fieldWidth = 0;
        scoreTxt.alignment = "left";
        scoreTxt.updateHitbox();
    }

    if (accuracyTxt != null) {
        accuracyTxt.x = (scoreTxt != null ? scoreTxt.x + scoreTxt.width + spacing : padding);
        accuracyTxt.fieldWidth = 0;
        accuracyTxt.alignment = "left";
        accuracyTxt.updateHitbox();
    }

    if (missesTxt != null) {
        missesTxt.x = padding;
        missesTxt.fieldWidth = rightWidth;
        missesTxt.alignment = "right";
        missesTxt.updateHitbox();
    }

    for (txt in [timePassedTxt, totalTimeTxt, rankTxt]) {
        if (txt == null)
            continue;

        txt.visible = false;
        txt.alpha = 0;
    }

    if (timeBar != null) {
        timeBar.visible = false;
        timeBar.alpha = 0;
    }
}

function onEvent(eventEvent)
{
    if (sonicMode) return;

    if (eventEvent.event.name == "Stop Play Tweens"){
        trace("event received");
        trace(eventEvent.event.name);
        trace(eventEvent.event.params[0]);
        stopPlayTweens = eventEvent.event.params[0];
    }
}

public function clockFormat(milliseconds:Float):String {
    return "";
}

function applyKadeTextStyle(txt:FunkinText, big:Bool = false) {
    if (txt == null) return;

    txt.font = Paths.font("KrabbyPatty.otf");
    txt.size = big ? 90 : 75;
    txt.color = 0xFFFFFFFF;
    txt.borderStyle = FlxTextBorderStyle.OUTLINE;
    txt.borderColor = FlxColor.BLACK;
    txt.borderSize = 7;
    txt.scale.set(0.2, 0.2);
    txt.antialiasing = true;
    txt.updateHitbox();
}

function create() {
    Note.swagWidth = 112; 
    PauseSubState.script = "data/states/pauseMenu.hx";
}

function postCreate() {
    if (sonicMode) return;
    minDigitDisplay = -1;

    healthBar.visible = true;
    healthBarBG.antialiasing = true;
    doIconBop = true;

    comboGroup.setPosition(FlxG.width / 2 - 57, 120);

    for (txt in [accuracyTxt, missesTxt, scoreTxt, timePassedTxt, totalTimeTxt]) {
        if (txt == null) continue;

        applyKadeTextStyle(txt, txt == totalTimeTxt);
        txt.color = 0xFFFFFFFF;
        txt.alignment = txt == timePassedTxt ? "left" : "center";
        txt.fieldWidth *= 2;
        txt.updateHitbox();

        txt.x = xPos;

        xPos += txt.width + 10;
        add(txt);
    }

    layoutMadeInChinaHud();
}

function onCameraMove(event) {
    if (sonicMode) return;
    if (event.strumLine?.characters[0] != null && ! stopPlayTweens) {
        var suffix = event.strumLine.animSuffix;
        switch (event.strumLine.characters[0].animation.name) {
            case "singLEFT" + suffix: event.position.x -= camMoveOffset; angle = -camAngleOffset;
            case "singDOWN" + suffix: event.position.y += camMoveOffset; angle = -camAngleOffset/2;
            case "singUP" + suffix: event.position.y -= camMoveOffset; angle = camAngleOffset/2;
            case "singRIGHT" + suffix: event.position.x += camMoveOffset; angle = camAngleOffset;
            default: angle = 0;
        }
    }
}

function onNoteHit(event){
    if (sonicMode) return;

        event.ratingScale = 0.5;

}

function onPlayerHit(event)
{
    if (!sonicMode) return;

    var name:String;

    switch (event.rating)
    {
        case "sick": name = "sick";
        case "good": name = "good";
        case "bad": name = "bad";
        case "shit": name = "shit";
        default: name = "sick";
    }

    spawnSonicRating(
        name,
        FlxG.width * 0.4,
        FlxG.height * 0.35
    );
}

function spawnHitMsText(x:Float, y:Float)
{
    var ms:Int = FlxG.random.int(-100000, 9999999999999);

    var txt:FunkinText = new FunkinText(x, y, 0, ms + "ms");
    txt.setFormat(Paths.font("Camera.ttf"), 30, 0x00FFFF, true);

    txt.borderStyle = FlxTextBorderStyle.OUTLINE;
    txt.borderColor = FlxColor.BLACK;
    txt.borderSize = 0.5;

    txt.antialiasing = true;
    txt.scrollFactor.set(0, 0);
    txt.cameras = [camGame];

    add(txt);

    FlxTween.tween(txt, { y: y - 40, alpha: 0 }, 0.6, {
        ease: FlxEase.quadOut,
        onComplete: (_) -> txt.destroy()
    });
}


function spawnSonicRating(name:String, x:Float, y:Float)
{
    var spr = new FlxSprite(x, y);

    spr.loadGraphic(Paths.image("game/score/kade_" + name));
    
    spr.cameras = [camGame];
    spr.antialiasing = true;
    spr.x += 800;
    spr.y -= 50;

    spr.velocity.y = -60;
    spr.velocity.x = FlxG.random.float(-20, 20);
    spr.acceleration.y = 200;

    spr.scale.set(0.8, 0.8);
    spr.alpha = 1;

    add(spr);

    FlxTween.tween(spr, {alpha: 0}, 0.4, {
        startDelay: 0.3,
        onComplete: (_) -> spr.kill()
    });

        var x = spr.x - 700;
        var y = spr.y + 60;

        spawnHitMsText(x, y);
}


function postUpdate() {
    layoutMadeInChinaHud();


    if (sonicMode){
        comboGroup.forEachAlive(function(spr) {
            spr.visible = false;
            
        });
        return;
    } 

    var misses:Int = PlayState.instance.misses;
    var accuracy:Float = PlayState.instance.accuracy;

    comboGroup.forEachAlive(function(spr) {
        if (spr.camera != camHUD) spr.camera = camHUD;
        if (spr.acceleration.y != 0) {
            spr.acceleration.y = 0;
            spr.velocity.set(0, 0);

            FlxTween.cancelTweensOf(spr);

            var randomScale:Float = FlxG.random.float(0.7, 0.9);
            FlxTween.tween(spr, {'scale.x': spr.scale.x*randomScale, 'scale.y': spr.scale.x*randomScale}, FlxG.random.float(.075, .125), {ease: FlxEase.circInOut, onComplete: (_) -> {
                FlxTween.tween(spr, {'scale.x': spr.scale.x*.4, 'scale.y': spr.scale.x*.4, alpha: 0, angle: FlxG.random.float(0, 0) * FlxG.random.sign()}, .1+FlxG.random.float(.255, .255), {ease: FlxEase.circInOut, onComplete: (_) -> {
                    spr.kill();
                }});
            }});
        }
    });
    if (! stopPlayTweens){
        camGame.angle = CoolUtil.fpsLerp(camGame.angle, angle, 1/10);
    }


    if (FlxG.save.data.fc == true) {
        if (misses > 0) {
            gameOver();
        }
    }

    if (FlxG.save.data.pm == true) {
        if ((accuracy >= 0 && accuracy < 1.0)) {
            gameOver();
        }
    }
}


override function onSongEnd()
{
    trace("Song ended successfully");

    if (FlxG.save.data.clearedSongs == null)
    {
        FlxG.save.data.clearedSongs = [
            "guater-game",
            "f-is-for-fevil",
            "sunderwater",
            "catch-and-fish",
            "bubbletwister"
        ];
    }

    var currentSongName:String = PlayState.SONG.meta.name.toLowerCase();

    if (!FlxG.save.data.clearedSongs.contains(currentSongName))
    {
        FlxG.save.data.clearedSongs.push(currentSongName);
        FlxG.save.flush();
    }
}
