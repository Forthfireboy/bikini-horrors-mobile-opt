import hxvlc.flixel.FlxVideoSprite;


var vid:FlxVideoSprite;

function postCreate() {
    startVideo("gormitis");
}

function startVideo(name:String) {
    var ext = "mp4";

    vid = new FlxVideoSprite();
    vid.autoVolumeHandle = false; 
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

function onFinish() {
    if (vid != null) {
        vid.stop();
        vid.destroy();
        remove(vid);
        vid = null;
        FlxG.switchState(new ModState("VersionHandler"));
    }
}
