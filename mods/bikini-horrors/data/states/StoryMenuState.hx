var changedState:Bool = false; 

function postCreatecreate() {
	var bg:FlxSprite = new FlxSprite();
    bg.makeGraphic(1280, 720, FlxColor.BLACK);
    add(bg);
}

function update(elapsed:Float) {
    if (!changedState) {
        changedState = true;
        FlxG.switchState(new ModState("VSelectionState"));
    }
}