
function postCreate() {
    WindowUtils.winTitle = window.title = "NINTENDO DIRECT 06-06-2026";
}

function cleanupCameraEffects() {
    for (camera in [FlxG.camera, camGame, camHUD]) {
        if (camera == null)
            continue;

        camera.stopFX();
        camera.shake(0, 0, null, true);
        camera.alpha = 1;
        camera.visible = true;
    }
}

function onSongEnd() {
    cleanupCameraEffects();
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function destroy() {
    cleanupCameraEffects();
}
