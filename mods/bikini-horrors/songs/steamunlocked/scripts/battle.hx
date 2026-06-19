// Script by Ug32t ^v^
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import flixel.text.FlxText.FlxTextAlign;

class Rectangle {
    public var x:Float;
    public var y:Float;
    public var width:Float;
    public var height:Float;

    public function new(x:Float, y:Float, width:Float, height:Float)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}

//some general scope variables
var isActive:Bool = false;
var isSinging:Bool = true;
var debugMode:Bool = false;

//collisions!!
var solidColliders:Array<Rectangle> = [];
//attacks!!
var attackColliders:Array<Rectangle> = [];

//player vars (the rectangle's origin is at the center)
public var playerX:Float;
public var playerY:Float;

var velX:Float = 0;
var velY:Float = 0;

var accel:Float = 6000;
var friction:Float = 0.003;

var playerHitbox:Rectangle;
var playerDebugVisual:FlxSprite = null;

var iFrames:Float = 0;
var battleJoyMoveX:Float = 0;
var battleJoyMoveY:Float = 0;

//steps, duh, for attacks n all
function stepHit(curStep:Int) {
    if ([1814, 1942, 2068].contains(curStep)) {
        isSinging = true;
    }

    if ([1896, 2008, 2136].contains(curStep)) {
        isSinging = false;
    }

    switch (curStep) {
        case 1752:
            isActive = true;
            isSinging = false;
            onCreate();
            showBattleJoyStick();
        case 1896:
            spawnAttack(false, playerX);
        case 1900:
            spawnAttack(true, playerY);
        case 1908:
            spawnAttack(false, playerX);
        case 1928:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 1932:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 2012:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 2016:
            spawnAttack(true, playerY);
        case 2022:
            spawnAttack(false, playerX);
        case 2030:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 2040:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 2048:
            spawnAttack(false, playerX);
        case 2049:
            spawnAttack(true, playerY);
        case 2054:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 2136:
            spawnAttack(true, playerY);
        case 2144:
            spawnAttack(false, playerX);
        case 2152:
            spawnAttack(true, playerY);
        case 2160:
            spawnAttack(false, playerX);
        case 2168:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);  
        case 2176:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);  
        case 2184:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 2192:
            spawnAttack(true, playerY);
            spawnAttack(false, playerX);
        case 2200:
            spawnAttack(true, playerY);
        case 2204:
            spawnAttack(false, playerX);
        case 2208:
            spawnAttack(true, playerY);
        case 2212:
            spawnAttack(false, playerX);
        case 2216:
            spawnAttack(true, playerY);
        case 2220:
            spawnAttack(false, playerX);
        case 2224:
            spawnAttack(true, playerY);
        case 2228:
            spawnAttack(false, playerX);
        case 2232:
            spawnAttack(true, playerY);
        case 2236:
            spawnAttack(false, playerX);
        case 2240:
            spawnAttack(true, playerY);
        case 2244:
            spawnAttack(false, playerX);
        case 2248:
            spawnAttack(true, playerY);
        case 2252:
            spawnAttack(false, playerX);
        case 2256:
            spawnAttack(true, playerY);
        case 2264:
            isActive = false;
            isSinging = true;
            hideBattleJoyStick();
  
    }
}

//------------------------------------------------------------ Functions ------------------------------------------------------------

var horizontalAtlas;
var verticalAtlas;
var glitchAtlas;

//attack pool (parti)
var rowWarningPool:Array<FunkinSprite> = [];
var colWarningPool:Array<FunkinSprite> = [];
var glitchPool:Array<FunkinSprite> = [];

//tracker for active attacks
var activeAttacks:Array<Dynamic> = [];

function onCreate()
{
    horizontalAtlas = Paths.getSparrowAtlas("sirope/alerta_columna_horizontal");
    verticalAtlas = Paths.getSparrowAtlas("sirope/alerta_columna_vertical");
    glitchAtlas = Paths.getSparrowAtlas("sirope/glitch_attack");

    //Creation of items for the pool
    for (x in 0...10){
        var horizontal:FunkinSprite = new FunkinSprite(0, 0);
        horizontal.frames = horizontalAtlas;
        horizontal.animation.addByPrefix("alert", "alertacolumnahorizontal", 24, true);
        horizontal.visible = false;
        horizontal.active = false;
        add(horizontal);
        rowWarningPool.push(horizontal);

        var vertical:FunkinSprite = new FunkinSprite(0, 0);
        vertical.frames = verticalAtlas;
        vertical.animation.addByPrefix("alert", "alertacolumnavertical", 24, true);
        vertical.visible = false;
        vertical.active = false;
        add(vertical);
        colWarningPool.push(vertical);

        var glitch:FunkinSprite = new FunkinSprite(0, 0);
        glitch.frames = glitchAtlas;
        glitch.animation.addByPrefix("attack", "glitchattack", 24, true);
        glitch.visible = false;
        glitch.active = false;
        add(glitch);
        glitchPool.push(glitch);
    }
    debugMode = false;

    // spawn player (center-based)
    playerX = -1240;
    playerY = 1530;

    playerHitbox = new Rectangle(playerX, playerY, 50, 70);

    if (debugMode)
    {
        playerDebugVisual = new FlxSprite(playerX, playerY);
        playerDebugVisual.makeGraphic(playerHitbox.width, playerHitbox.height, 0x66FF0000);
        playerDebugVisual.origin.set(playerHitbox.width/2, playerHitbox.height/2);
        playerDebugVisual.updateHitbox();
        add(playerDebugVisual);
    }

    solidColliders.push(new Rectangle (-1340,2000,2000,100));
    solidColliders.push(new Rectangle (-1340,1030,2000,100));
    solidColliders.push(new Rectangle (-2290, 1515, 600, 1070));
    solidColliders.push(new Rectangle (-390, 1515, 300, 1070));
    //createWallsPreview();
}

function update(elapsed:Float)
{
    if (!isActive){
        return;
    }

    if (iFrames >= 0)
        iFrames -= elapsed;
    else
        iFrames = 0;

    updatePlayer(elapsed);
    updateAttacks(elapsed); 
    
    checkHurt();
}

function updatePlayer(elapsed:Float)
{
    var moveX = 0;
    var moveY = 0;
    if (!isSinging){
        if (FlxG.onMobile) {
            moveX += battleJoyMoveX;
            moveY += battleJoyMoveY;
        }
        else {
            if (controls.LEFT_P || FlxG.keys.pressed.A) moveX -= 1;
            if (controls.RIGHT_P || FlxG.keys.pressed.D) moveX += 1;
            if (controls.UP_P || FlxG.keys.pressed.W) moveY -= 1;
            if (controls.DOWN_P || FlxG.keys.pressed.S) moveY += 1;
        }
    }

    if (moveX > 1) moveX = 1;
    else if (moveX < -1) moveX = -1;
    if (moveY > 1) moveY = 1;
    else if (moveY < -1) moveY = -1;

    if (moveX != 0 || moveY != 0)
    {
        var mod = Math.sqrt(moveX * moveX + moveY * moveY);

        velX += (moveX / mod) * accel * elapsed;
        velY += (moveY / mod) * accel * elapsed;
    }

    if (isSinging){
        velX *= Math.pow(0.05, elapsed);
        velY *= Math.pow(0.05, elapsed);
    }
    else{
        velX *= Math.pow(friction, elapsed);
        velY *= Math.pow(friction, elapsed);
    }

    playerX += velX * elapsed;
    checkCollisions(true, elapsed);

    playerY += velY * elapsed;
    checkCollisions(false, elapsed);

    updateHitbox();

    boyfriend.x = playerX - 380;
    boyfriend.y = playerY - 500;

    if (isSinging || iFrames > 0)
        return;

    if (moveY == -1){
        boyfriend.playAnim("moveup");
    }
    else if (moveY == 1){
        boyfriend.playAnim("movedown");
    }
    else if (moveX == 1){
        boyfriend.playAnim("moveleft");
    }
    else if (moveX == -1){
        boyfriend.playAnim("moveright");
    }
    else{
        boyfriend.playAnim("idle");
    }

}

public function hidePool() {
    // Hide pooled sprites
    for (spr in rowWarningPool) {
        spr.visible = false;
        spr.active = false;
    }

    for (spr in colWarningPool) {
        spr.visible = false;
        spr.active = false;
    }

    for (spr in glitchPool) {
        spr.visible = false;
        spr.active = false;
    }

    // Hide sprites currently in use
    for (atk in activeAttacks) {
        if (atk.visual != null) {
            atk.visual.visible = false;
            atk.visual.active = false;
        }

        if (atk.glitch != null) {
            atk.glitch.visible = false;
            atk.glitch.active = false;
        }
    }
}

function showBattleJoyStick()
{
    battleJoyMoveX = 0;
    battleJoyMoveY = 0;

    if (!FlxG.onMobile)
        return;

    if (mobileManager != null && mobileManager.joyStick != null) {
        forceBattleJoyStickVisible();
        return;
    }

    addJoyStick(70, FlxG.height - 300, "JoyStick/joystick", updateBattleJoyStick, 0.75);
    addJoyStickCamera();
    forceBattleJoyStickVisible();
}

function forceBattleJoyStickVisible()
{
    if (mobileManager == null || mobileManager.joyStick == null)
        return;

    var visualAlpha = Options.controlsAlpha;
    if (visualAlpha < 0.65)
        visualAlpha = 0.65;

    mobileManager.joyStick.visible = true;
    mobileManager.joyStick.alpha = visualAlpha;

    if (mobileManager.joyStick.base != null) {
        mobileManager.joyStick.base.visible = true;
        mobileManager.joyStick.base.alpha = 1;
    }

    if (mobileManager.joyStick.thumb != null) {
        mobileManager.joyStick.thumb.visible = true;
        mobileManager.joyStick.thumb.alpha = 1;
    }
}

function hideBattleJoyStick()
{
    battleJoyMoveX = 0;
    battleJoyMoveY = 0;
    if (mobileManager != null && mobileManager.joyStick != null)
        removeJoyStick();
}

function updateBattleJoyStick(angle:Float, strength:Float, directionID:Float, directionName:String)
{
    battleJoyMoveX = 0;
    battleJoyMoveY = 0;

    if (strength < 10 || directionName == null || directionName == "NONE")
        return;

    if (directionName.indexOf("LEFT") != -1) battleJoyMoveX -= 1;
    if (directionName.indexOf("RIGHT") != -1) battleJoyMoveX += 1;
    if (directionName.indexOf("UP") != -1) battleJoyMoveY -= 1;
    if (directionName.indexOf("DOWN") != -1) battleJoyMoveY += 1;
}

function destroy()
{
    hideBattleJoyStick();
}

function updateAttacks(elapsed:Float)
{
    var i:Int = activeAttacks.length - 1;
    while (i >= 0)
    {
        var atk = activeAttacks[i];
        atk.timer -= elapsed;

        if (atk.timer <= 0)
        {
            if (atk.stage == "warning")
            {
                //hide the warning sprite, then return to pool
                atk.visual.visible = false;
                atk.visual.active = false;
                if (atk.isRow) rowWarningPool.push(atk.visual); else colWarningPool.push(atk.visual);
                atk.visual = null;

                //ternary operator assignments for the target collider box
                atk.attackRect = new Rectangle(
                    atk.isRow ? originX : atk.position, 
                    atk.isRow ? atk.position : originY, 
                    atk.width, 
                    atk.height
                );
                attackColliders.push(atk.attackRect);

                //grab the glitch sprite from the pool
                var g:FunkinSprite = glitchPool.length > 0 ? glitchPool.pop() : new FunkinSprite(0, 0);
                if (g.frames == null) {
                    g.frames = glitchAtlas;
                    g.animation.addByPrefix("attack", "glitchattack", 24, true);
                    add(g);
                }

                g.visible = true;
                g.active = true;
                g.angle = atk.isRow ? 0 : 90;
                g.x = atk.attackRect.x - g.width / 2;
                g.y = atk.attackRect.y - g.height / 2;
                g.playAnim("attack");
                FlxG.sound.play(Paths.sound("sirope/glitch" + (FlxG.random.int(1,3))), 0.75);
                atk.glitch = g;
                atk.stage = "glitch";
                atk.timer = 0.3; 
            }
            else if (atk.stage == "glitch")
            {
                attackColliders.remove(atk.attackRect);
                
                if (atk.glitch != null) {
                    atk.glitch.visible = false;
                    atk.glitch.active = false;
                    glitchPool.push(atk.glitch);
                }

                activeAttacks.splice(i, 1);
            }
        }
        i--;
    }
}

function checkCollisions(horizontal:Bool = true, elapsed:Float)
{
    updateHitbox();

    for (wall in solidColliders)
    {
        if (doRectanglesOverlap(playerHitbox, wall))
        {
            if (horizontal)
                collisionX(wall, elapsed);
            else
                collisionY(wall, elapsed);
        }
    }
}

function updateHitbox()
{
    playerHitbox.x = playerX;
    playerHitbox.y = playerY;

    if (playerDebugVisual != null)
    {
        playerDebugVisual.x = playerX - playerHitbox.width / 2;
        playerDebugVisual.y = playerY - playerHitbox.height / 2;
    }
}

function collisionX(touchedRect:Rectangle, elapsed:Float)
{
    if (velX == 0)
        return;

    var steps = Math.ceil(Math.abs(velX * elapsed));

    for (i in 0...steps)
    {
        if (!doRectanglesOverlap(playerHitbox, touchedRect))
            break;

        playerX -= velX / Math.abs(velX);
        updateHitbox();
    }
    velX = 0;
}

function collisionY(touchedRect:Rectangle, elapsed:Float)
{
    if (velY == 0)
        return;

    var steps = Math.ceil(Math.abs(velY * elapsed));

    for (i in 0...steps)
    {
        if (!doRectanglesOverlap(playerHitbox, touchedRect))
            break;

        playerY -= velY / Math.abs(velY);
        updateHitbox();
    }
    velY = 0;
}

function checkHurt(){
    updateHitbox();

    for (attack in attackColliders)
    {
        if (doRectanglesOverlap(playerHitbox, attack))
        {
            hurtIsaac();
        }
    }
}

function hurtIsaac(){
    if (iFrames <= 0){
        health -= 0.5;
        iFrames = 0.5;
        boyfriend.playAnim("hurt");
    }
}

function doRectanglesOverlap(A:Rectangle, B:Rectangle):Bool
{
    var aLeft = A.x - A.width / 2;
    var aRight = A.x + A.width / 2;
    var aTop = A.y - A.height / 2;
    var aBottom = A.y + A.height / 2;

    var bLeft = B.x - B.width / 2;
    var bRight = B.x + B.width / 2;
    var bTop = B.y - B.height / 2;
    var bBottom = B.y + B.height / 2;

    if (aRight <= bLeft ||
        aLeft >= bRight ||
        aBottom <= bTop ||
        aTop >= bBottom)
    {
        return false;
    }

    return true;
}

function createWallsPreview(){
    for (wall in solidColliders){
        var visual = new FlxSprite(wall.x,wall.y);
        visual.makeGraphic(wall.width, wall.height, FlxColor.BLACK);
        visual.origin.set(wall.width/2,wall.height/2);
        visual.updateHitbox();
        visual.x = wall.x - wall.width / 2;
        visual.y = wall.y - wall.height / 2;
        visual.alpha = 0.5;
        add(visual);
    }
}

var originX:Float = -1320;
var originY:Float = 1525;

function spawnAttack(isRow:Bool = true, position:Float = 0)
{

    if (FlxG.save.data.mech == true){
        return;
    }

    var visual:FunkinSprite;

    if (isRow) {
        visual = rowWarningPool.length > 0 ? rowWarningPool.pop() : new FunkinSprite(0, 0);
    } else {
        visual = colWarningPool.length > 0 ? colWarningPool.pop() : new FunkinSprite(0, 0);
    }

    if (visual.frames == null) {
        visual.frames = isRow ? horizontalAtlas : verticalAtlas;
        visual.animation.addByPrefix("alert", isRow ? "alertacolumnahorizontal" : "alertacolumnavertical", 24, true);
        add(visual);
    }

    visual.visible = true;
    visual.active = true;

    var w = visual.width;
    var h = visual.height;
    
    var startX = isRow ? originX : position;
    var startY = isRow ? position : originY;

    visual.x = startX - w / 2;
    visual.y = startY - h / 2;
    visual.playAnim("alert");
    
    var attackData = {
        isRow: isRow,
        position: position,
        visual: visual,
        glitch: null,
        timer: 0.75, 
        stage: "warning",
        attackRect: null,
        width: w,       
        height: h       
    };
    
    activeAttacks.push(attackData);
}
