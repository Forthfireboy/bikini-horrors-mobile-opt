import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
var shaderTween:FlxTween; 

function postCreate(){
    shader = new CustomShader("greenPixel");
    shader.strength = 0;
    camGame.addShader(shader);
    camHUD.addShader(shader);
    bgCam.addShader(shader);
}


function enableGameboyEffect(time = "2")
{
    time = Std.parseFloat(time);
    if (shaderTween != null)
        shaderTween.cancel();

    shaderTween = FlxTween.num(
        shader.strength,
        1,
        time,
        {
            ease: FlxEase.sineInOut,

            onUpdate: function(twn)
            {
                shader.strength = twn.value;
            }
        }
    );
}

function setGameboyEffect(bool){
    bool = bool == "true";
    if (bool){
        shader.strength = 1;
    }
    else{
        shader.strength = 0;
    }
}

function disableGameboyEffect(time = "2")
{
    time = Std.parseFloat(time);
    if (shaderTween != null)
        shaderTween.cancel();

    shaderTween = FlxTween.num(
        shader.strength,
        0,
        time,
        {
            ease: FlxEase.sineInOut,

            onUpdate: function(twn)
            {
                shader.strength = twn.value;
            }
        }
    );
}