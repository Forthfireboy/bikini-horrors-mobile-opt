// Script by Chezzar
public var nick:FlxSprite;

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

    WindowUtils.winTitle = window.title = "ESTO E' UN PARTY DEBAJO DEL AGUA";

    add(nick);
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}