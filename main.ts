let updown = 0
let pitch = 0
let roll = 0
let cmdString = ""
loops.everyInterval(600, function () {
    updown = 0
    if (input.buttonIsPressed(Button.A)) {
        updown = 1
    } else {
        if (input.buttonIsPressed(Button.B)) {
            updown = -1
        }
    }
    pitch = input.rotation(Rotation.Pitch)
    roll = input.rotation(Rotation.Roll)
    cmdString = "" + convertToText(updown) + "," + convertToText(pitch) + "," + convertToText(roll)
    serial.writeLine(cmdString)
})
