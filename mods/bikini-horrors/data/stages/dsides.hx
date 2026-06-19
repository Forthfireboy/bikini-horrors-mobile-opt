import openfl.display.BlendMode;

var baseCharY : Int;
public var bopStrength : Float = 1;


function postCreate(){
    baseCharY = personajes.y;
    luz.alpha = 0;
    foco.y -= 1000;
    luz.blend = BlendMode.ADD;
}

function stepHit(step:Int) {
    switch (step) {
        case 360:
            FlxTween.tween(foco, {y:0}, 3, {ease:FlxEase.quartOut});
        case 384:
            members.remove(luz);
            add(luz);
            FlxTween.tween(luz, {alpha:0.3}, 2, {ease:FlxEase.quartOut});
    }
}

function update(){
    var beat = Conductor.songPosition / Conductor.crochet;
    personajes.y = baseCharY - Math.abs(Math.sin(beat * Math.PI) * 10*bopStrength);
    personajes.scale.x = 1 - Math.abs(Math.sin(beat * Math.PI) * 0.01*bopStrength);
    personajes.scale.y = 1 - Math.abs(Math.cos(beat * Math.PI) * 0.01*bopStrength);

}