var screenCoverer:FlxSprite;

function postCreate() {
    screenCoverer = new FlxSprite();
    screenCoverer.loadGraphic(Paths.image("jumpscare"));
    screenCoverer.setGraphicSize(FlxG.width, FlxG.height, true);
    screenCoverer.scrollFactor.set(0, 0);
    screenCoverer.alpha = 1;
    screenCoverer.screenCenter();

    add(screenCoverer);
    screenCoverer.cameras = [camHUD];
    screenCoverer.visible = false;
}

var alphaTween:FlxTween = null;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "JumpscarePhanes") {
        if (params[0] == false)
            screenCoverer.visible = false;
        else {
            screenCoverer.visible = true;
        }
    }
}