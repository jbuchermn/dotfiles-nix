import os
import pwd
import time
import psutil
import subprocess
import logging

logger = logging.getLogger(__name__)

def execute(command: str) -> str:
    proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
    return proc.stdout.read().decode() if proc.stdout is not None else ""

from pywm import (
    PYWM_MOD_LOGO,
    PYWM_MOD_ALT,

    PYWM_TRANSFORM_90,
    PYWM_TRANSFORM_180,
    PYWM_TRANSFORM_270,
    PYWM_TRANSFORM_FLIPPED,
    PYWM_TRANSFORM_FLIPPED_90,
    PYWM_TRANSFORM_FLIPPED_180,
    PYWM_TRANSFORM_FLIPPED_270,
)

def on_startup():
    os.system("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots")
    os.system("waybar &")
    # os.system("catapult &")

def on_reconfigure():
    os.system("notify-send newm \"Reloaded config\" &")

corner_radius = 20.5
# v0.1
# output_scale = 2.

outputs = [
    { 'name': 'eDP-1', 'pos_x': 0, 'pos_y': 0, 'scale': 2. },
    { 'name': 'virt-1', 'pos_x': 1280, 'pos_y': 0, 'width': 1280, 'height': 720, 'scale': 1., 
        'mHz': 30000, 'anim': False},
    { 'name': 'HDMI-A-2', 'pos_x': 2560, 'width': 3840, 'height': 2160, 'scale': 2.,
        'mHz': 30000}
]

pywm = {
    'xkb_model': "macintosh",
    'xkb_layout': "de,de",
    'xkb_options': "caps:escape",

    'xcursor_theme': 'Adwaita',
    'xcursor_size': 24,

    'encourage_csd': False,
    'enable_xwayland': True,

    'natural_scroll': True,

    'texture_shaders': 'basic'

    # v0.1
    # 'round_scale': 2.
}

def should_float(view):
    if view.app_id == "catapult":
        return True, None, (0.5, 0.25)
    if view.app_id == "pavucontrol":
        return True, (340, 600), (0.15, 0.4)
    # if view.app_id == "rofi":
    #     return True, (800, 800), (0.5, 0.5)
    if view.title is not None and view.title.strip() == "Firefox — Sharing Indicator":
        return True, (100, 40), (0.5, 0.1)
    return None

view = {
    'padding': 8,
    'fullscreen_padding': 0,
    'send_fullscreen': False,

    'should_float': should_float,
    'floating_min_size': False,

    'debug_scaling': True,
    'border_ws_switch': 100,
}

swipe_zoom = {
    'grid_m': 1,
    'grid_ovr': 0.02,
}


mod = PYWM_MOD_LOGO
background = {
    'path': os.environ['HOME'] + '/wallpaper.jpg',
    'time_scale': 0.125,
    'anim': True,
}

anim_time = .25
blend_time = .5

class BacklightManager:
    def __init__(self) -> None:
        self._current = 0
        self._max = 1
        self._enabled = True
        try:
            self._current = int(execute("brightnessctl g"))
            self._max = int(execute("brightnessctl m"))
        except Exception:
            logger.exception("Disabling BacklightManager")
            self._enabled = False

        self._predim = self._current

    def callback(self, code: str) -> None:
        if code in ["lock", "idle-lock"]:
            self._current = int(self._predim / 2)
            execute("brightnessctl s %d" % self._current)
        elif code == "idle":
            self._current = int(self._predim / 1.5)
            execute("brightnessctl s %d" % self._current)
        elif code == "active":
            self._current = self._predim
            execute("brightnessctl s %d" % self._current)

    def adjust(self, factor: float) -> None:
        if self._predim < .3*self._max and factor > 1.:
            self._predim += int(.1*self._max)
        else:
            self._predim = max(0, min(self._max, int(self._predim * factor)))
        self._current = self._predim
        execute("brightnessctl s %d" % self._current)

backlight_manager = BacklightManager()

key_bindings = lambda layout: [
    ("M-h", lambda: layout.move(-1, 0)),
    ("M-j", lambda: layout.move(0, 1)),
    ("M-k", lambda: layout.move(0, -1)),
    ("M-l", lambda: layout.move(1, 0)),
    ("M-t", lambda: layout.move_in_stack(1)),

    ("M-H", lambda: layout.move_focused_view(-1, 0)),
    ("M-J", lambda: layout.move_focused_view(0, 1)),
    ("M-K", lambda: layout.move_focused_view(0, -1)),
    ("M-L", lambda: layout.move_focused_view(1, 0)),

    ("M-C-h", lambda: layout.resize_focused_view(-1, 0)),
    ("M-C-j", lambda: layout.resize_focused_view(0, 1)),
    ("M-C-k", lambda: layout.resize_focused_view(0, -1)),
    ("M-C-l", lambda: layout.resize_focused_view(1, 0)),

    ("M-v", lambda: layout.toggle_focused_view_floating()),
    ("M-w", lambda: layout.change_focused_view_workspace()),
    ("M-W", lambda: layout.move_workspace()),
    ("M-S", lambda: os.system("grim -g \"$(slurp)\" &")),

    ("M-Return", lambda: os.system("alacritty &")),
    ("M-e", lambda: os.system("emacsclient -c -a \"emacs\" &")),
    ("M-c", lambda: os.system("chromium --enable-features=UseOzonePlatform --ozone-platform=wayland &")),
    ("M-m", lambda: os.system("bash /$HOME/.shell/macho-gui.sh &")),
    ("M-q", lambda: layout.close_view()),

    ("M-p", lambda: layout.ensure_locked(dim=True)),
    ("M-P", lambda: layout.terminate()),
    ("M-C", lambda: layout.update_config()),

    # ("M-r", lambda: os.system("catapult &")),
    ("M-r", lambda: os.system("rofi -show run &")),
    ("M-f", lambda: layout.toggle_fullscreen()),

    ("ModPress", lambda: layout.toggle_overview(only_active_workspace=False)),

    ("XF86MonBrightnessUp", lambda: backlight_manager.adjust(1.1)),
    ("XF86MonBrightnessDown", lambda: backlight_manager.adjust(0.9)),
]

bar = {
    'enabled': False,
}

gestures = {
    'lp_freq': 120.,
    'lp_inertia': 0.4
}

swipe = {
    'gesture_factor': 3
}

panels = {
    'lock': {
        'cmd': 'alacritty -e newm-panel-basic lock',
        'w': 0.7,
        'h': 0.6,
        'corner_radius': 50,
        # 'cmd': 'npm run start -- lock',
        # 'cwd': '/home/jonas/newm-panel-nwjs'
    },
    'launcher': {
        'cmd': 'alacritty -e newm-panel-basic launcher',
        'w': 0.7,
        'h': 0.6,
        'corner_radius': 50,
        # 'cmd': 'npm run start -- launcher',
        # 'cwd': '/home/jonas/newm-panel-nwjs'
    },
    'notifiers': {
        # 'cmd': 'npm run start -- notifiers',
        # 'cwd': '/home/jonas/newm-panel-nwjs'
    }
}

grid = {
    'throw_ps': [2, 10]
}

energy = {
    'idle_times': [60, 180],
    'idle_callback': backlight_manager.callback
}

focus = {
    'color': '#92f0f5a1',
    'enabled': True
}


