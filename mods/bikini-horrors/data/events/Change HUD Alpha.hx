var hudTween:FlxTween;

function onEvent(eventEvent) {
    var params:Array = eventEvent.event.params;
    if (eventEvent.event.name == "Change HUD Alpha") {
        var targetAlpha:Float = params[1];
        var duration:Float = ((Conductor.crochet / 4) / 1000) * params[2];
        var flxease:String = params[3] + (params[3] == "linear" ? "" : params[4]);
        var easeFunc = Reflect.field(FlxEase, flxease);
        var extraIcon1 = PlayState.instance.scripts.get("iconP1Static");
        var extraIcon2 = PlayState.instance.scripts.get("iconP2Static");

        if (params[0] == false) {
            healthBar.alpha = targetAlpha;
            healthBarBG.alpha = targetAlpha;
            iconP1.alpha = targetAlpha;
            iconP2.alpha = targetAlpha;
            scoreTxt.alpha = targetAlpha;
            accuracyTxt.alpha = targetAlpha;
            missesTxt.alpha = targetAlpha;
            if (extraIcon1 != null) extraIcon1.alpha = targetAlpha;
            if (extraIcon2 != null) extraIcon2.alpha = targetAlpha;
            setHudArrowsAlpha(targetAlpha);

        } else {
            if (hudTween != null) hudTween.cancel();

            hudTween = FlxTween.tween(healthBar, {alpha: targetAlpha}, duration, {ease: easeFunc});
            FlxTween.tween(healthBarBG, {alpha: targetAlpha}, duration, {ease: easeFunc});
            FlxTween.tween(iconP1, {alpha: targetAlpha}, duration, {ease: easeFunc});
            FlxTween.tween(iconP2, {alpha: targetAlpha}, duration, {ease: easeFunc});
            FlxTween.tween(scoreTxt, {alpha: targetAlpha}, duration, {ease: easeFunc});
            FlxTween.tween(accuracyTxt, {alpha: targetAlpha}, duration, {ease: easeFunc});
            FlxTween.tween(missesTxt, {alpha: targetAlpha}, duration, {ease: easeFunc});
            if (extraIcon1 != null) FlxTween.tween(extraIcon1, {alpha: targetAlpha}, duration, {ease: easeFunc});
            if (extraIcon2 != null) FlxTween.tween(extraIcon2, {alpha: targetAlpha}, duration, {ease: easeFunc});
            setHudArrowsAlpha(targetAlpha, duration, easeFunc);
        }
    }
}
