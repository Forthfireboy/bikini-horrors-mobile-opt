// Script by Chezzar
import funkin.backend.utils.WindowUtils;

public var nick:FlxSprite;
var shader:CustomShader = null;
var tacon : Bool = false;

function create() {
    nick = new FlxSprite();
    nick.loadGraphic(Paths.image('logos/nick'));
    nick.scale.set(0.12, 0.12);
    nick.updateHitbox();
    nick.alpha = 0.8;
    nick.scrollFactor.set(0, 0);
    nick.cameras = [camHUD];

    nick.x = FlxG.width - nick.width - 30;
    nick.y = FlxG.height - nick.height - 30;


    add(nick);
}

function onNoteHit(event)
{
    // Ignore sustain/hold pieces
    if (event.note.isSustainNote) return;
    if (tacon) {
        var taconIndex:Int = FlxG.random.int(1, 6);
        FlxG.sound.play(Paths.sound("tacon/" + taconIndex), 0.5);
    }
}

function postCreate() {
    shader = new CustomShader("green");
    WindowUtils.winTitle = window.title = "VERDE TAN VERDE";
    camHUD.addShader(shader);
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function stepHit(step:Int) {
    switch (step) {
        case 288:
            camHUD.removeShader(shader);
            tacon = true;
        case 816:
            camHUD.addShader(shader);
            tacon = false;
        case 1072:
            camHUD.removeShader(shader);
            tacon = true;
        case 1712:
            FlxG.camera.shake(0.05, 1);
            stage.getSprite("EXPLOSION").visible = true;
            remove(dad);
            remove(stage.getSprite("infinetefondomajins"));
            remove(stage.getSprite("EXPLOSION"));

            add(stage.getSprite("infinetefondomajins"));
            add(dad);
            add(stage.getSprite("EXPLOSION"));
            stage.getSprite("EXPLOSION").playAnim("EXPLOSION");

    }
}
