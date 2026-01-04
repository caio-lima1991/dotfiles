import board

from kmk.kmk_keyboard import KMKKeyboard
from kmk.keys import KC
from kmk.scanners import DiodeOrientation
from kmk.modules.layers import Layers
from kmk.extensions.international import International

keyboard = KMKKeyboard()
keyboard.modules.append(Layers())
keyboard.extensions.append(International())

keyboard.row_pins = (board.GP0, board.GP1, board.GP2, board.GP3, board.GP4)
keyboard.col_pins = (board.GP5, board.GP6, board.GP7, board.GP8, board.GP9, 
                     board.GP10, board.GP11, board.GP12, board.GP13, board.GP14, 
                     board.GP20, board.GP21)
keyboard.coord_mapping = [
        1,  2,  0,  3,  4,  5,   6,  7,  8,  9,  11, 10,
        13, 14, 12, 15, 16, 17,  18, 19, 20, 21, 23, 22,
        25, 26, 24, 27, 28, 29,  30, 31, 32, 33, 35, 34,
        37, 38, 36, 39, 40, 41,  42, 43, 44, 45, 47, 46,
                48, 51, 52, 53,  54, 55, 56, 57
    ]
keyboard.diode_orientation = DiodeOrientation.COL2ROW

keyboard.keymap = [
    [
        KC.ESC,     KC.N1,      KC.N2,      KC.N3,      KC.N4,      KC.N5,      KC.N6,      KC.N7,      KC.N8,      KC.N9,      KC.N0,      KC.BSPC,
        KC.TAB,     KC.Q,       KC.W,       KC.E,       KC.R,       KC.T,       KC.Y,       KC.U,       KC.I,       KC.O,       KC.P,       KC.DELETE,
        KC.LCTRL,   KC.A,       KC.S,       KC.D,       KC.F,       KC.G,       KC.H,       KC.J,       KC.K,       KC.L,       KC.SCLN,    KC.QUOT,
        KC.LSFT,    KC.Z,       KC.X,       KC.C,       KC.V,       KC.B,       KC.N,       KC.M,       KC.COMM,    KC.DOT,     KC.SLSH,    KC.RSFT,
                                KC.LGUI,    KC.ENTER,   KC.MO(1),   KC.HOME,    KC.END,     KC.MO(1),   KC.SPACE,   KC.RALT
    ],
    [
        KC.F12,     KC.F1,      KC.F2,      KC.F3,      KC.F4,      KC.F5,      KC.F6,      KC.F7,      KC.F8,      KC.F9,      KC.F10,         KC.F11,
        KC.GRV,     KC.MPRV,    KC.MNXT,    KC.MPLY,    KC.NO,      KC.NO,      KC.MINS,    KC.EQL,     KC.RBRC,    KC.BSLS,    KC.NONUS_BSLASH,KC.LBRC,
        KC.LCTRL,   KC.MUTE,    KC.VOLD,    KC.VOLU,    KC.PGDOWN,  KC.PGUP,    KC.LEFT,    KC.DOWN,    KC.UP,      KC.RIGHT,   KC.NO,          KC.NO,
        KC.LSFT,    KC.CAPS,    KC.NO,      KC.NO,      KC.NO,      KC.NO,      KC.NO,      KC.NO,      KC.NO,      KC.NO,      KC.NO,          KC.RSFT,
                                KC.NO,      KC.LCTL,    KC.NO,      KC.NO,      KC.NO,      KC.TRNS,    KC.NO,      KC.NO
    ]]

if __name__ == '__main__':
    keyboard.go()
