import funkin.backend.MusicBeatState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;

var bg:FlxSprite;
var avatar:FlxSprite;
var glowPink:FlxSprite;
var glowBlue:FlxSprite;
var flash:FlxSprite;
var titleText:FlxText;
var subText:FlxText;
var scan:FlxSprite;
var finished:Bool = false;
var t:Float = 0;
var shards:Array<FlxSprite> = [];

function create() {
    MusicBeatState.skipTransIn = true;
    MusicBeatState.skipTransOut = true;
    if (FlxG.sound.music != null)
        FlxG.sound.music.stop();

    bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF020308);
    add(bg);

    createNeonShards();

    glowBlue = createAvatarLayer(0xFF65D8FF, 0.28, 0.88);
    glowPink = createAvatarLayer(0xFFFF6AAC, 0.26, 0.78);
    avatar = createAvatarLayer(0xFFFFFFFF, 0, 0.62);

    titleText = new FlxText(0, FlxG.height / 2 + 185, FlxG.width, "Port By Ajwwk", 36);
    titleText.setFormat(Paths.font("KrabbyPatty.otf"), 36, 0xFFFFFFFF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    titleText.borderSize = 3;
    titleText.alpha = 0;
    titleText.scale.set(0.85, 0.85);
    add(titleText);

    subText = new FlxText(0, titleText.y + 58, FlxG.width, "Bikini Horrors V3 Mobile", 18);
    subText.setFormat(Paths.font("KrabbyPatty.otf"), 18, 0xFF8CE9FF, "center", FlxTextBorderStyle.OUTLINE, 0xFF000000);
    subText.borderSize = 2;
    subText.alpha = 0;
    add(subText);

    scan = new FlxSprite(-FlxG.width, 0).makeGraphic(Std.int(FlxG.width * 0.45), FlxG.height, 0x44FFFFFF);
    scan.angle = -18;
    scan.blend = BlendMode.ADD;
    scan.alpha = 0;
    add(scan);

    flash = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    flash.alpha = 0;
    add(flash);

    startIntroTweens();
}

function createAvatarLayer(color:Int, alpha:Float, targetScale:Float):FlxSprite {
    var spr = new FlxSprite().loadGraphic(Paths.image("menus/port/ajwwk_avatar"));
    spr.antialiasing = true;
    spr.color = color;
    spr.alpha = alpha;
    spr.scale.set(targetScale * 0.28, targetScale * 0.28);
    spr.updateHitbox();
    spr.screenCenter();
    spr.y -= 26;
    spr.blend = alpha > 0 ? BlendMode.ADD : BlendMode.NORMAL;
    add(spr);

    return spr;
}

function createNeonShards() {
    for (i in 0...24) {
        var col = i % 2 == 0 ? 0xFFFF5EA8 : 0xFF58D5FF;
        var shard = new FlxSprite(FlxG.random.float(80, FlxG.width - 80), FlxG.random.float(60, FlxG.height - 60));
        shard.makeGraphic(FlxG.random.int(24, 70), FlxG.random.int(3, 7), col);
        shard.angle = FlxG.random.float(-28, 28);
        shard.alpha = 0;
        shard.blend = BlendMode.ADD;
        add(shard);
        shards.push(shard);
    }
}

function startIntroTweens() {
    FlxTween.tween(glowBlue, {'scale.x': 1.03, 'scale.y': 1.03, alpha: 0.55}, 0.55, {ease: FlxEase.backOut});
    FlxTween.tween(glowPink, {'scale.x': 0.92, 'scale.y': 0.92, alpha: 0.42}, 0.6, {ease: FlxEase.backOut, startDelay: 0.05});
    FlxTween.tween(avatar, {'scale.x': 0.62, 'scale.y': 0.62, alpha: 1}, 0.68, {ease: FlxEase.backOut, startDelay: 0.08});

    for (i in 0...shards.length) {
        var shard = shards[i];
        FlxTween.tween(shard, {
            alpha: FlxG.random.float(0.2, 0.55),
            x: shard.x + FlxG.random.float(-80, 80),
            y: shard.y + FlxG.random.float(-30, 30)
        }, FlxG.random.float(0.45, 0.9), {
            ease: FlxEase.quadOut,
            startDelay: i * 0.015
        });
    }

    FlxTween.tween(titleText, {'scale.x': 1, 'scale.y': 1, alpha: 1}, 0.55, {ease: FlxEase.backOut, startDelay: 0.55});
    FlxTween.tween(subText, {alpha: 1, y: subText.y + 8}, 0.5, {ease: FlxEase.quadOut, startDelay: 0.85});

    FlxTween.tween(scan, {x: FlxG.width * 1.1, alpha: 0.75}, 0.55, {ease: FlxEase.quadInOut, startDelay: 1.0, onComplete: function(_) {
        scan.alpha = 0;
    }});

    new FlxTimer().start(2.35, function(_) {
        finishIntro();
    });
}

function update(elapsed:Float) {
    t += elapsed;

    if (avatar != null && !finished) {
        var pulse = 1 + Math.sin(t * 5.2) * 0.018;
        avatar.scale.set(0.62 * pulse, 0.62 * pulse);
        glowBlue.scale.set((1.02 + Math.sin(t * 3.3) * 0.06), (1.02 + Math.sin(t * 3.3) * 0.06));
        glowPink.scale.set((0.92 + Math.cos(t * 3.8) * 0.05), (0.92 + Math.cos(t * 3.8) * 0.05));
    }

    if (controls.ACCEPT || FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed)
        finishIntro();
}

function finishIntro() {
    if (finished)
        return;

    finished = true;
    FlxTween.tween(flash, {alpha: 1}, 0.14, {ease: FlxEase.quadOut, onComplete: function(_) {
        FlxTween.tween(flash, {alpha: 0}, 0.2, {ease: FlxEase.quadIn, onComplete: function(_) {
            FlxG.switchState(new ModState("BHWarningState"));
        }});
    }});
}
