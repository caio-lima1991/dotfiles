import board
import digitalio
import storage
import usb_cdc

# Safety switch: If GP0 and GP6 are connected at boot, keep the drive accessible
# for editing. Otherwise, hide the drive to prevent accidental corruption.
ROW_PIN = board.GP0
COL_PIN = board.GP6

row = digitalio.DigitalInOut(ROW_PIN)
row.direction = digitalio.Direction.OUTPUT
row.value = False

col = digitalio.DigitalInOut(COL_PIN)
col.direction = digitalio.Direction.INPUT
col.pull = digitalio.Pull.UP

# If button is NOT pressed, disable the USB drive (standard KMK practice)
if col.value:
    storage.disable_usb_drive()
    usb_cdc.disable()
