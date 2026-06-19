
function stepHit(step:Int) {
    switch (step) {
        case 1904:
            stage.getSprite("aura").playAnim("idle");
        case 2132:
            stage.getSprite("calamardo").playAnim("turn");
        case 1880:
            camGame.angle = 12;
    }
}

function postCreate() {
    WindowUtils.winTitle = window.title = "Hello, old friend...";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}