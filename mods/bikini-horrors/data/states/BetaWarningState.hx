import flixel.FlxSprite;

var water:FlxSprite;

function create(){
	water = new FlxSprite(0, 0);
    water.loadGraphic(Paths.image('underguater'));
    water.scale.set(1.2, 1.2);
    water.updateHitbox();
    water.visible = true;
    water.alpha = 0.1;
    water.screenCenter();
    add(water);
}
function postCreate(){
	disclaimer.text = "Are you ready to enfrent myself? You willn't survive. \n\nPrepear to get an underwater game.";
	disclaimer.color = 0xFFFF4444;

	
}