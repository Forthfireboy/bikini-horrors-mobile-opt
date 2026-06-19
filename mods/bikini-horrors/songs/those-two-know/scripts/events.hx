public var clan:FlxSprite;

function postCreate() {
    WindowUtils.winTitle = window.title = "When Time Itself Fell Silent: The Final Symphony Sung by the Greatest legend Ever Known";

}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function create() {
    clan = new FlxSprite();
    clan.loadGraphic(Paths.image('logos/insta'));
    clan.scale.set(0.07, 0.07);
    clan.updateHitbox();
    clan.alpha = 0.5;
    clan.scrollFactor.set(0, 0);
    clan.cameras = [camHUD];

    clan.x = FlxG.width - clan.width - 30;
    clan.y = FlxG.height - clan.height - 30;

    add(clan);
}