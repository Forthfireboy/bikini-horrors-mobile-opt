function onNoteHit(event) {
    
    if (event.noteType == "EverybodySings") {
        var anims = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
        
        var animToPlay = anims[event.direction];

        if (subaru.animation.getByName(animToPlay) != null) {
            subaru.playAnim(animToPlay, true);
            new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                if (subaru.animation.curAnim != null && subaru.animation.curAnim.name == animToPlay) {
                    subaru.dance();
                }
            });
        }

        if (squid.animation.getByName(animToPlay) != null) {
            squid.playAnim(animToPlay, true);
            new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                if (squid.animation.curAnim != null && squid.animation.curAnim.name == animToPlay) {
                    squid.dance();
                }
            });
        }

        if (krabity.animation.getByName(animToPlay) != null) {
            krabity.playAnim(animToPlay, true);
            new FlxTimer().start(0.5, function(tmr:FlxTimer) {
                if (krabity.animation.curAnim != null && krabity.animation.curAnim.name == animToPlay) {
                    krabity.dance();
                }
            });
        }
    }
}