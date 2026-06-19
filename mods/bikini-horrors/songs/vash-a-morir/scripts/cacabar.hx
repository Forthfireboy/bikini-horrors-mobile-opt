import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import funkin.game.PlayState;

var cagarLevels:Array<Int> = [0, 25, 40, 55, 65, 75, 90, 100];
var patchypositions:Array<Int> = [580, 500, 430, 350, 280, 210, 140];
var barcam:FlxCamera;
var brownbar:FlxBar = new FlxBar(80, 153, FlxBarFillDirection.BOTTOM_TO_TOP, 30, 500);
var vater:FlxSprite;
var icons:Array<String> = ["patchy1", "patchy2", "dvd1", "dvd2"];
var icon1:FlxSprite;
var icon2:FlxSprite;
var missCount:Int = 0;
var posCount:Int = 0;

function postCreate() {
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.visible = false;
    iconP2.visible = false;

    if (FlxG.save.data.mech == false) {
        FlxG.cameras.add(barcam = new FlxCamera(), false);
        barcam.bgColor = 0x00000000;

        brownbar.createFilledBar(0x00FFFFFF, 0xFF7E5808);
        brownbar.numDivisions = cagarLevels.length - 1;
        brownbar.cameras = [barcam];
        brownbar.percent = cagarLevels[0];
        brownbar.alpha = 0;
        add(brownbar);
        

        vater = new FlxSprite(35, 0).loadGraphic(Paths.image('vam/cagometro'));
        vater.scale.set(0.9, 0.9);
        vater.cameras = [barcam];
        vater.alpha = 0;
        add(vater);
        

        icon1 = new FlxSprite(100, patchypositions[0]).loadGraphic(Paths.image('vam/' + icons[0]));
        icon1.scale.set(0.9, 0.9);
        icon1.cameras = [barcam];
        icon1.alpha = 0;
        add(icon1);
        

        icon2 = new FlxSprite(100, 50).loadGraphic(Paths.image('vam/' + icons[2]));
            icon2.alpha = 0;
        icon2.scale.set(0.9, 0.9);
        icon2.cameras = [barcam];
        add(icon2);
    }
    
}

function stepHit(curStep:Int) {
    if (curStep == 256) {
            healthBar.alpha = 0;
            healthBarBG.alpha = 0;
        }
    if (FlxG.save.data.mech == false) {
        if (curStep == 255) {
            brownbar.alpha = 1;
            vater.alpha = 1;
            icon1.alpha = 1;
            icon2.alpha = 1;
        }
        if (curStep == 2272) {
            brownbar.alpha = 0;
            vater.alpha = 0;
            icon1.alpha = 0;
            icon2.alpha = 0;
        }
    }

    if (FlxG.save.data.mech == true) {
        if (curStep == 255) {
            healthBar.alpha = 1;
            healthBarBG.alpha = 1;
            iconP1.visible = true;
            iconP2.visible = true;
        }
        if (curStep == 2272) {
            healthBar.alpha = 0;
            healthBarBG.alpha = 0;
            iconP1.visible = false;
            iconP2.visible = false;
        }
    }
}

function onMiss():Void {
    if (FlxG.save.data.mech == false) {
        if (missCount < cagarLevels.length - 1) {
            missCount++;
        }
        if (posCount < patchypositions.length - 1) {
            posCount++;
        }
        if (patchypositions[posCount] == 280) {
            icon1.loadGraphic(Paths.image('vam/' + icons[1]));
        }
        if (patchypositions[posCount] == 140) {
            icon2.loadGraphic(Paths.image('vam/' + icons[3]));
        }

        brownbar.percent = cagarLevels[missCount];
        icon1.y = patchypositions[posCount];
        FlxG.sound.play(Paths.sound("vam/pedico"), 2, false);
    }
}


function update(elapsed:Float):Void {
    if (FlxG.save.data.mech == false) {
        var misses:Int = PlayState.instance.misses;

        if (misses > missCount) {
            onMiss();
        }

        if (brownbar.percent == 100) {
            gameOver();
        }
    }
}
