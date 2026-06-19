import hxvlc.flixel.FlxVideoSprite;
import funkin.game.PlayState;

var vid:FlxVideoSprite;
var isCustom:Bool = false;
var exiting:Bool = false;
var cam;

function create(event) {
    var meta = PlayState.SONG.meta;

    if (meta != null && meta.customGameOver != null) {
        isCustom = true;
        event.cancel();
        startVideo(meta.customGameOver);
    }
}

function startVideo(name:String) {
    cam = FlxG.cameras.list[FlxG.cameras.list.length - 1];
    vid = new FlxVideoSprite();
    vid.autoVolumeHandle = false;
    vid.scrollFactor.set(0, 0);
    vid.cameras = [cam];
    add(vid);

    vid.bitmap.onFormatSetup.add(function() {
        vid.setGraphicSize(FlxG.width, FlxG.height);
        vid.updateHitbox();

        vid.setPosition(0, 0);

        vid.width = FlxG.width;
        vid.height = FlxG.height;

        vid.scrollFactor.set(0, 0);
    });

    if (vid.load(Paths.video(name, "mp4"))) {
        vid.bitmap.onEndReached.add(function() {
            retrySong();
        });
        vid.play();
    } else {
        retrySong();
    }
}

function update(elapsed:Float) {
    if (!isCustom || exiting) return;

    if (FlxG.keys.justPressed.ENTER) {
        exiting = true;
        retrySong();
    }

    if (FlxG.keys.justPressed.ESCAPE) {
        exiting = true;
        exitToFreeplay();
    }
}

function cleanupVideo() {
    if (vid != null) {
        vid.stop();
        vid.destroy();
        remove(vid);
        vid = null;
    }
}

function retrySong() {
    cam.fade(FlxColor.BLACK, 0.5, false, function() {
        cleanupVideo();

        PlayState.loadSong(
            PlayState.instance.curSong, 
            PlayState.difficulty
        );

        PlayState.switchToPlayState();
    });
    
}

function exitToFreeplay() {
    cam.fade(FlxColor.BLACK, 0.5, false, function() {
        cleanupVideo();
        FlxG.switchState(new ModState("VersionHandler"));
    });
}
