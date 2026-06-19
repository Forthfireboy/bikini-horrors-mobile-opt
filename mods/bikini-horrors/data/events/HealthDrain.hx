// Script by Aika

var enabled = false;

function onEvent(event) {
    if (event.event.name == "HealthDrain") {
        enabled = event.event.params[0];
        drainAm = event.event.params[1];
        limit = event.event.params[2];
    }
}

function onDadHit() for (event in PlayState.SONG.events) if (event.name == "HealthDrain") {
    if (enabled && health > limit) {
        health -= drainAm;
    }
}
