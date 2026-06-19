import hxvlc.flixel.FlxVideoSprite;

var callback:Void->Void = null;
var vid:FlxVideoSprite;

function startVideo(name:String, ?theCallback:Void->Void, ?ext:String) {
    callback = theCallback;
    ext ??= "mp4";

    vid = new FlxVideoSprite();
    vid.autoVolumeHandle = true; 
    add(vid);

    vid.bitmap.onFormatSetup.add(function() {
        vid.setGraphicSize(FlxG.width, FlxG.height);
        vid.updateHitbox();
        vid.screenCenter();
    });

    if (vid.load(Paths.video(name, ext))) {
        vid.bitmap.onEndReached.add(onFinish);
        vid.play();
    } else {
        onFinish();
    }
}

function update() {
    if (FlxG.keys.justPressed.ENTER || FlxG.mouse.justPressed) {
        onFinish();
    }
}

function onFinish() {
    if (vid != null) {
        vid.stop();
        vid.destroy();
        remove(vid);
        vid = null;
    }

    if (callback != null) callback();
}
