import funkin.backend.MusicBeatState;

var script = importScript("data/scripts/in-state-cutscene");

function create() {
    script.call("startVideo", ["warning_bh", () -> {
        MusicBeatState.skipTransOut = true;
        FlxG.switchState(new ModState("BHTitleState"));
    }, "mp4"]);
}
