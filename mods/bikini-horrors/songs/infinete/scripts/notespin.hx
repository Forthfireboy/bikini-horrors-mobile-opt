// Script by Umbra
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.game.Strum;

function notespin() {
    for (sl in PlayState.instance.strumLines.members) {
        if (sl == null) continue;

        sl.forEachAlive(function(strum:Strum) {
            strum.copyStrumAngle = false;
            FlxTween.cancelTweensOf(strum);
            var oldAngle = strum.angle;
            strum.angle = oldAngle + 360;
            FlxTween.tween(strum, {
                angle: oldAngle
            }, 0.16, {
                ease: FlxEase.quadOut
            });
        });
    }
}