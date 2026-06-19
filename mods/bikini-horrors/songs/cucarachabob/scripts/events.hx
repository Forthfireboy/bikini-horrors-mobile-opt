function postCreate() {
    WindowUtils.winTitle = window.title = "ADOPT A CUCARACHABOB!!!! ONLY 1$!!!!!!";
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.alpha = 0;
    iconP2.alpha = 0;
    scoreTxt.alpha = 0;
    accuracyTxt.alpha = 0;
    missesTxt.alpha = 0;
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}