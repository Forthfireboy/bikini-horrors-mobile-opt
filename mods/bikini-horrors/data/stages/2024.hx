function create() {
    darkLights.camera = camGame;
    darkLights.blend = BlendMode.MULTIPLY;
}

function stepHit(curStep:Int) {
    if (curStep == 1808) {
        remove(fondoFinal);
        remove(montanaOne);
        remove(montanaTwo);
        remove(calle);
        remove(edificio);
        remove(boyfriend);
        remove(dad);
        add(fondoFinal);
        
        add(montanaOne);
        add(dad);
        add(montanaTwo);
        
        add(calle);
        add(boyfriend);
        add(edificio);

        dad.cameraOffset.y -= 90;
    }
}
