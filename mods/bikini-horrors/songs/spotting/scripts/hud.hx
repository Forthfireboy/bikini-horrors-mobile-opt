import flixel.math.FlxRect;

var heartsEmpty;
var heartsFull;
var heartClip;

function postCreate() {

	health = 2;
	if (healthBar != null) healthBar.visible = false;
	if (healthBarBG != null) healthBarBG.visible = false;
	healthBar.scale.x = 0;

	if (scoreTxt != null) scoreTxt.visible = false;
	if (accuracyTxt != null) accuracyTxt.visible = false;
	if (missesTxt != null) missesTxt.visible = false;
 
	heartsEmpty = new FlxSprite(-105, 800);
	heartsEmpty.loadGraphic(Paths.image("spotting/hearts0"));
	heartsEmpty.scale.x = 0.5;
	heartsEmpty.scale.y = 0.5;
	heartsEmpty.scrollFactor.set(0, 0);
	heartsEmpty.alpha = 0;
	add(heartsEmpty);

	heartsFull = new FlxSprite(-105, 800);
	heartsFull.loadGraphic(Paths.image("spotting/hearts1"));
	heartsFull.scale.x = 0.5;
	heartsFull.scale.y = 0.5;
	heartsFull.scrollFactor.set(0, 0);
	heartsFull.alpha = 0;
	add(heartsFull);

	heartClip = new FlxRect(0, 0, heartsFull.width, heartsFull.height);
	heartsFull.clipRect = heartClip;
}

function postUpdate(elapsed:Float)
{
	var percent = health / 2;
	percent *= 20;
	percent = Math.floor(percent);
	percent /= 20;

	var w = heartsFull.width * percent;

	heartsFull.clipRect = new FlxRect(0, 0, w, heartsFull.height);
}


function stepHit(curStep:Int) {
    if (curStep == 60) {
        FlxTween.tween(heartsEmpty, {alpha: 1.0}, .33);
        FlxTween.tween(heartsFull, {alpha: 1.0}, .33);
    }

    if (curStep == 1568) {
        heartsEmpty.alpha = 0.0;
        heartsFull.alpha = 0.0;
    }
}