function onPlayerHit(event) {
    
    if (event.noteType == "BothSing") {
        var anims = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
        
        var animToPlay = anims[event.direction];

        if (aikaChar.animation.getByName(animToPlay) != null) {
            aikaChar.playAnim(animToPlay, true);
            new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                if (aikaChar.animation.curAnim != null && aikaChar.animation.curAnim.name == animToPlay) {
                    aikaChar.dance();
                }
            });
        }
    }
}