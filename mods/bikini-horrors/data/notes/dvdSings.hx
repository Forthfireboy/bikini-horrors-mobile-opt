function onNoteHit(event) {
    if (event.noteType == "dvdSings") {
        event.character = strumLines.members[2].characters[0];
    }
}
