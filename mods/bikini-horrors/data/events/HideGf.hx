// Script by Chezzar

function onEvent(event:ScriptEvent) {
    if (event.event.name == "HideGf") {
        if (event.event.params[0] == true) {
            gf.visible = false;
        }
        else {
            gf.visible = true;
        }
            
    }
}

