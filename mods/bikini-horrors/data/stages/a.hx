import openfl.Lib;
var blackOverlay:FlxSprite;
public var flames:CustomShader;

function create() {
	flames = new CustomShader("roaring_flame_cut"); 
    flames.time = 0; flames.intensitiy = 0; flames.zoom = 1;
    if (flames != null) stage.getSprite("rflames").shader = flames;
    stage.getSprite("rflames").flipY = false;
}

function postCreate() {
	blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    bg_barnacles1.visible = false;
    bg_barnacles2.visible = false;
    fg_barnacles.visible = false;
}

var tottalTimer:Float = FlxG.random.float(1000, 5000); 
function update(elapsed) {
	tottalTimer += elapsed;
    flames.time = tottalTimer;
    flames.zoom = 1 / (Lib.application.window.width/FlxG.width);
}

function stepHit(curStep:Int) {

	switch(curStep){
		case 8:
		    FlxTween.tween(blackOverlay, {alpha: 0}, 1.5, {
		        onComplete: function(twn:FlxTween) {
		            remove(blackOverlay);
		            blackOverlay.destroy();
		        }
		    });

		case 445:
			gacha.visible = false;
			bg_barnacles1.visible = true;
		    bg_barnacles2.visible = true;
		    fg_barnacles.visible = true;

		case 1226:
			bg_barnacles1.visible = false;
		    bg_barnacles2.visible = false;
		    gf.visible = false;
		    boyfriend.flipX = false;
		
		case 1230:
			fg_barnacles.alpha = 0;

		case 1769:
			fg_barnacles.alpha = 1;
			fg_barnacles.visible = false;

		case 2277:
			bg_barnacles1.visible = true;
		    bg_barnacles2.visible = true;
		    fg_barnacles.visible = true;

		case 3469:
			if (Options.gameplayShaders) {
				flames.intensitiy = 6;
			}
		
		case 3820:
			FlxG.switchState(new ModState("BarnaclesCutscenesState"));
    }
}
