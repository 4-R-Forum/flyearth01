let updown = 0
let pitch = 0
let roll = 0
loops.everyInterval(500, function () {
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
    basic.showString("" + convertToText(updown) + "\",\"" + convertToText(pitch) + "\",\"" + convertToText(roll))
})
