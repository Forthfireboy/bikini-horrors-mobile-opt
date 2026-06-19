var diagonalMask:FlxSprite;
var overlayCamera:FlxCamera;
var transitionTween:FlxTween;

function create(event) {
    event.cancelled = true;

    overlayCamera = new FlxCamera();
    overlayCamera.bgColor = 0x00000000;
    FlxG.cameras.add(overlayCamera, false);

    var size = FlxG.width + FlxG.height;
    diagonalMask = new FlxSprite(-size, size);
    diagonalMask.makeGraphic(size * 2, size * 2, FlxColor.BLACK);
    diagonalMask.angle = -45;
    diagonalMask.scrollFactor.set(0, 0);
    diagonalMask.cameras = [overlayCamera];

    add(diagonalMask);

    var startX = FlxG.width;
    var startY = FlxG.height;
    var endX = -size;
    var endY = -size;

    if (!event.transOut) {
        diagonalMask.setPosition(endX, endY);
        transitionTween = FlxTween.tween(diagonalMask, {x: startX, y: startY}, 1, {
            onComplete: () -> finish()
        });
    } else {
        diagonalMask.setPosition(startX, startY);
        transitionTween = FlxTween.tween(diagonalMask, {x: endX, y: endY}, 1, {
            onComplete: () -> finish()
        });
    }
}

function destroy() {
    if (diagonalMask != null) {
        diagonalMask.destroy();
        diagonalMask = null;
    }

    if (overlayCamera != null && FlxG.cameras.list.indexOf(overlayCamera) != -1) {
        FlxG.cameras.remove(overlayCamera, true);
        overlayCamera = null;
    }

}
