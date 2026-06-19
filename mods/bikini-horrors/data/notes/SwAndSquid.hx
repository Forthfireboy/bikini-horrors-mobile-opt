function onNoteHit(event) {
    
    if (event.noteType == "SwAndSquid") {
        var anims = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
        
        var animToPlay = anims[event.direction];

        if (squid.animation.getByName(animToPlay) != null) {
            squid.playAnim(animToPlay, true);
            new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                if (squid.animation.curAnim != null && squid.animation.curAnim.name == animToPlay) {
                    squid.dance();
                }
            });
        }
    }
}