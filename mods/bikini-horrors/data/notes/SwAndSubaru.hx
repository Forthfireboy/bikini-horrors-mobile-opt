function onNoteHit(event) {
    
    if (event.noteType == "SwAndSubaru") {
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
    }
}