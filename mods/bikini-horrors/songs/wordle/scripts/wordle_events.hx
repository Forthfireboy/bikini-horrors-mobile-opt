var blackoutShader:CustomShader;

function create() {
    
    blackoutShader = new CustomShader("blackOut");
    camGame.addShader(blackoutShader);

}

function update() {
    if (curStep == 120 && blackoutShader != null) {
        camGame.removeShader(blackoutShader);
    }
}

function postCreate() {
    WindowUtils.winTitle = window.title = "THE NEW YORK TIMES GAMES";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}