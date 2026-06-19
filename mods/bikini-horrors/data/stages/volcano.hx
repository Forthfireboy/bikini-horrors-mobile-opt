var blackOverlay;
var trychar;
var p1IconOffset : Int = 0;
var p2IconOffset : Int = 0;

function create() {
    gasta.playAnim("gasta_idle");
    
}

function postCreate() {
	blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    trything.cameras = [camHUD];
    trything.screenCenter();
    trything.alpha = 0;
    
    trychar = strumLines.members[2].characters[0];
    trychar.alpha = 0;


    cielo_lava.alpha = 0;
    volcan_lava.alpha = 0;
    monte3_lava.alpha = 0;
    monte2_lava.alpha = 0;
    monte_lava.alpha = 0;
    suelo_lava.alpha = 0;

    healthBar.flipX = true;
    p1IconOffset = 1280/2 - iconP1.x;
    p2IconOffset = 1280/2 - iconP2.x;



}

function postUpdate(elapsed:Float) {
    var p1 = strumLines.members[1].characters[0];
    var p2 = strumLines.members[0].characters[0];

    iconP1.setIcon(p2.icon);
    iconP2.setIcon(p1.icon);

    var screenCenter = 1280 / 2;
    var barPercent = healthBar.percent; 
    iconP1.x = screenCenter + (healthBar.width * (barPercent / 100 - 0.5)) - p1IconOffset;
    iconP2.x = screenCenter + (healthBar.width * (barPercent / 100 - 0.5)) - p2IconOffset;
}

function stepHit(curStep:Int) {
	switch(curStep){
		case 728:
			trything.alpha = 1;

        case 752:
            trything.alpha = 0;
            trychar.alpha = 1;
            gasta.playAnim("gasta_que");

        case 3201:
            cielo.alpha = 0;
            volcan.alpha = 0;
            monte3.alpha = 0;
            monte2.alpha = 0;
            monte.alpha = 0;
            suelo.alpha = 0;
            gasta.playAnim("gasta_die");

            cielo_lava.alpha = 1;
            volcan_lava.alpha = 1;
            monte3_lava.alpha = 1;
            monte2_lava.alpha = 1;
            monte_lava.alpha = 1;
            suelo_lava.alpha = 1;

        case 3208:
            FlxG.camera.shake(0.01, 0.2);

        case 3745:
            FlxTween.tween(strumLines.members[2].characters[0], {x: strumLines.members[2].characters[0].x + 1500}, 3);
	}
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 1.5, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
	
}
