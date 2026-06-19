// Script by Chezzar
import funkin.backend.utils.WindowUtils;

public var nick:FlxSprite;
var shader:CustomShader = null;


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

function postCreate() {
    shader = new CustomShader("green");
    WindowUtils.winTitle = window.title = "GREEN SO GREEN";
    camHUD.addShader(shader);
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function stepHit(step:Int) {
    switch (step) {
        case 300:
            camHUD.removeShader(shader);
        case 824:
            camHUD.addShader(shader);
        case 1080:
            camHUD.removeShader(shader);
        case 1740:
            FlxG.camera.shake(0.05, 1);
    }
}
