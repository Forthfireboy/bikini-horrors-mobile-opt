var hearts:Array<FlxSprite> = [];
var maxHearts:Int = 5;

function create() {
    createHearts(maxHearts, 35, FlxG.height - 45, 5);

}

function postCreate(){
    health = 2;
}

function createHearts(amount:Int, posX:Float,posY:Float,scale:Float) {
    for (i in 0...amount) {
        var heart:FlxSprite = new FlxSprite(20 + (i * 32), 20);

        heart.ID = i;
        heart.loadGraphic(Paths.image("game/ui/sirope/1"));


        heart.cameras = [camHUD];
        heart.scale.x = scale;
        heart.scale.y = scale;
        heart.x = posX + i * heart.width * (heart.scale.x/1.25);
        heart.y = posY;

        heart.antialiasing = false;

        add(heart);
        hearts.push(heart);
    }
}

function postUpdate(elapsed:Float) {
    updateHearts();
}

function updateHearts() {
    // Assuming health ranges from 0 to maxHearts
    var currentHealth:Float = (health/2) * hearts.length;

    for (heart in hearts) {

        heart.alpha = strumLines.members[1].members[0].alpha;
        var heartValue:Float = currentHealth - heart.ID;

        if (heartValue >= 1) {
            // Full heart
            heart.loadGraphic(Paths.image("game/ui/sirope/1"));
        }
        else if (heartValue >= 0.5) {
            // Half heart
            heart.loadGraphic(Paths.image("game/ui/sirope/0.5"));
        }
        else {
            // Empty heart
            heart.loadGraphic(Paths.image("game/ui/sirope/0"));
        }
    }
}

function killHearts() {
    for (heart in hearts) {
        remove(heart);
        heart.destroy();
    }
    hearts = [];
}

var gameplayHudElements:Array = [];

var dice:FunkinSprite;
var map:FunkinSprite;
var redDice:FunkinSprite;
var redMap:FunkinSprite;

function createGameplayHud(){
    dice = new FunkinSprite(40, 100, Paths.image("game/ui/sirope/gameplay/hud_d6"));
    map = new FunkinSprite(FlxG.width - 130, 80, Paths.image("game/ui/sirope/gameplay/hud_map"));
    redDice = new FunkinSprite(40, 100, Paths.image("game/ui/sirope/gameplay/hud_d6_red"));
    redMap = new FunkinSprite(FlxG.width - 130, 80, Paths.image("game/ui/sirope/gameplay/hud_map_red"));
    dice.addAnim("anim", "hud_d6", 24,true);
    map.addAnim("anim", "hud_map", 24,true);
    redDice.addAnim("anim", "hud_d6_red", 24, true);
    redMap.addAnim("anim", "hud_map_red", 24, true);

    gameplayHudElements = [dice,map,redDice,redMap];
    for (element in gameplayHudElements){
        element.cameras = [camHUD];
        element.scale.x = 3;
        element.scale.y = 3;
        element.playAnim("anim");
    }

    insert(0,dice);
    insert(0,map);
    insert(0,redDice);
    insert(0,redMap);
    dice.alpha = 0;
    map.alpha = 0;
    redDice.alpha = 0;
    redMap.alpha = 0;
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1745:
            createGameplayHud();
            dice.alpha = 1;
            map.alpha = 1;
            killHearts();
            createHearts(maxHearts, 150, 45, 3);
        case 2200:
            dice.alpha = 0;
            map.alpha = 0;
            redDice.alpha = 1;
            redMap.alpha = 1;
        case 2264:
            redDice.alpha = 0;
            redMap.alpha = 0;
            killHearts();
        case 3092:
            createHearts(maxHearts, 35, FlxG.height - 45, 5);
            accuracyTxt.alpha = 1;
            missesTxt.alpha = 1;
            scoreTxt.alpha = 1;
    }
}

