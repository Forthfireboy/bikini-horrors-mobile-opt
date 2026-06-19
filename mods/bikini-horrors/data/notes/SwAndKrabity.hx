function onNoteHit(event) {
    
    if (event.noteType == "SwAndKrabity") {
        var anims = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
        
        var animToPlay = anims[event.direction];

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