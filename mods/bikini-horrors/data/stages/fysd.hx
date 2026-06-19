

function create() {
    fb_1.alpha = 0;
    fb_2.alpha = 0;
    fb_3.alpha = 0;
    fb_4.alpha = 0;
    fb_5.alpha = 0;
    fb_6.alpha = 0;
    fb_7.alpha = 0;
    fb_8.alpha = 0;
    fb_9.alpha = 0;
    desmotivacion.alpha = 0;
    jellyfield.alpha = 0;
    strumLines.members[3].characters[0].alpha = 0;
}

function postCreate() {
	blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(1280, 720, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.visible = false;
    iconP2.visible = false;
}

function stepHit(curStep:Int) {

	if (curStep == 8) {
        FlxTween.tween(blackOverlay, {alpha: 0}, 1.5, {
		        onComplete: function(twn:FlxTween) {
		            remove(blackOverlay);
		            blackOverlay.destroy();
		        }
		    });
    }

    if (curStep == 192) {
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 2000}, 7);
    }
    
    if (curStep == 480) {
        FlxTween.tween(jellyfield, {alpha: 1}, 1);
    }

    if (curStep == 660) {
        FlxTween.tween(camGame.scroll, {x: -2487}, 1.6, {ease: FlxEase.quartInOut});
        FlxTween.tween(camGame.scroll, {y: 292}, 1.6, {ease: FlxEase.quartInOut});
    }

    if (curStep == 1296) {
        FlxTween.tween(fb_1, {alpha: 1}, 1);
        FlxTween.tween(fb_1, {x: fb_1.x + 200}, 20);
    }

    if (curStep == 1344) {
        FlxTween.tween(fb_1, {alpha: 0}, 1);
        FlxTween.tween(fb_2, {alpha: 1}, 1);
        FlxTween.tween(fb_2, {x: fb_1.x - 200}, 20);
    }

    if (curStep == 1393) {
        FlxTween.tween(fb_2, {alpha: 0}, 1);
        FlxTween.tween(fb_3, {alpha: 1}, 1);
        FlxTween.tween(fb_3, {y: fb_3.y - 200}, 20);
    }

    if (curStep == 1416) {
        FlxTween.tween(fb_3, {alpha: 0}, 0.6);
        FlxTween.tween(fb_4, {alpha: 1}, 0.6);
        FlxTween.tween(fb_4, {y: fb_3.y + 200}, 20);
    }

    if (curStep == 1440) {
        FlxTween.tween(fb_4, {alpha: 0}, 1);
        FlxTween.tween(fb_5, {alpha: 1}, 1);
        FlxTween.tween(fb_5, {x: fb_5.x + 200}, 20);
    }

    if (curStep == 1488) {
        FlxTween.tween(fb_5, {alpha: 0}, 1);
        FlxTween.tween(fb_6, {alpha: 1}, 1);
        FlxTween.tween(fb_6, {x: fb_6.x - 200}, 20);
    }

    if (curStep == 1536) {
        FlxTween.tween(fb_6, {alpha: 0}, 1);
        FlxTween.tween(fb_7, {alpha: 1}, 1);
        FlxTween.tween(fb_7.scale, {x: 0.7, y: 0.7}, 20);
    }

    if (curStep == 1572) {
        FlxTween.tween(fb_7, {alpha: 0}, 1);
        FlxTween.tween(fb_8, {alpha: 1}, 1);
        FlxTween.tween(fb_8.scale, {x: 0.7, y: 0.7}, 20);
    }

    if (curStep == 1608) {
        fb_8.alpha = 0;
        fb_9.alpha = 1;
    }

    if (curStep == 1632) {
        fb_9.alpha = 0;
    }

    if (curStep == 2016) {
        FlxTween.tween(citi, {alpha: 0}, 0.5);
        FlxTween.tween(boyfriend, {alpha: 0}, 0.5);
        FlxTween.tween(dad, {alpha: 0}, 0.5);
    }

    if (curStep == 2400) {
        boyfriend.alpha = 0;
        dad.alpha = 0;
    }

    if (curStep == 2484) {
        FlxTween.tween(boyfriend, {alpha: 1}, 1.5);
        FlxTween.tween(boyfriend, {x: boyfriend.x + 200}, 20);
    }

    if (curStep == 2568) {
        FlxTween.tween(dad, {alpha: 1}, 1.5);
        FlxTween.tween(dad, {x: dad.x - 200}, 20);
    }

    if (curStep == 2664) {
        FlxTween.tween(dad, {alpha: 0}, 1.5);
    }
    
    if (curStep == 2688) {
    FlxTween.tween(boyfriend, {alpha: 0}, 1.5);
    }

    if (curStep == 2760) {
    FlxTween.tween(desmotivacion, {alpha: 1}, 2.5);
    }
}