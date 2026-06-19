import hxvlc.flixel.FlxVideoSprite;
import funkin.backend.utils.WindowUtils;
import openfl.Lib;
import openfl.net.URLRequest;
import sys.Sys;



var vid:FlxVideoSprite;
function create() {
    FlxG.sound.music.stop();
    WindowUtils.winTitle = window.title = "MORE GAMERS NEXTER TIME";

    vid = new FlxVideoSprite();
    vid.load(Assets.getPath(Paths.video('VERYSCARYANIM', 'mkv')));
    vid.scale.set(FlxG.width / 1920, FlxG.height / 1080);
    vid.x = FlxG.width / 2 - 1920 / 2;
    vid.y = FlxG.height / 2 - 1080 / 2;
    vid.play();
    add(vid);

    vid.bitmap.onEndReached.add(function() {
        Sys.command("start", ["https://www.minijuegos.com/juego/super-mario-moto"]);
       FlxG.switchState(new FreeplayState());
    });
}
