var customBar:FlxSprite;
var customFill:FlxSprite;
var customFil2:FlxSprite;
var customBG:FlxSprite;

function postCreate()
{
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;

    customBG = new FlxSprite(170, 600);
    customBG.loadGraphic(Paths.image("game/healthbar/fondo"));
    customBG.cameras = [camHUD];
    customBG.scale.set(0.6, 0.6);
    customBG.updateHitbox(); 
    add(customBG);

    customFill = new FlxSprite(645, 642);
    customFill.loadGraphic(Paths.image("game/healthbar/trikitroy"));
    customFill.scale.set(0.1, 0.6);
    customFill.cameras = [camHUD];
    customFill.updateHitbox();
    add(customFill);

    customFil2 = new FlxSprite(228, 642);
    customFil2.loadGraphic(Paths.image("game/healthbar/troytriki"));
    customFil2.scale.set(0.1, 0.6);
    customFil2.cameras = [camHUD];
    customFil2.updateHitbox();
    add(customFil2);
    
    customBar = new FlxSprite(170, 600);
    customBar.loadGraphic(Paths.image("game/healthbar/contra"));
    customBar.cameras = [camHUD];
    customBar.scale.set(0.6, 0.6);
    customBar.updateHitbox(); 
    add(customBar);

    updateIconLayers();
}

function update(elapsed)
{
    var percent = health / 2;
    customFill.scale.x = percent;
    customFill.updateHitbox();

    var percen2 = 1 - percent;
    customFil2.scale.x = percen2;
    customFil2.updateHitbox();
}

function updateIconLayers() {
    if (iconP1 != null && members.indexOf(iconP1) < members.indexOf(customBar)) {
        remove(iconP1);
        insert(members.length, iconP1);
    }
    if (iconP2 != null && members.indexOf(iconP2) < members.indexOf(customBar)) {
        remove(iconP2);
        insert(members.length, iconP2);
    }
}

function postUpdate(elapsed:Float)
{
    updateIconLayers();

    if (iconP1 != null) {
        iconP1.x = 600;
        iconP1.y = 570; 
    }

    if (iconP2 != null) {
        iconP2.x = 540;
        iconP2.y = 580; 
        iconP2.flipX = true;

    }
}