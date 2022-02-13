import os
import logging

logger = logging.getLogger(__name__)

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

from newm.helper import BacklightManager, WobRunner, PaCtl

def on_startup():
    os.system("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots")

def on_reconfigure():
    os.system("notify-send newm \"Reloaded config\" &")

corner_radius = 20.5

outputs = [
    { 'name': 'eDP-1', 'pos_x': 0, 'pos_y': 0, 'scale': 2. }, #2560/1600 },
    { 'name': 'virt-1', 'pos_x': 1280, 'pos_y': 0, 'width': 1280, 'height': 720, 'scale': 1., 
        'mHz': 30000, 'anim': False},
    { 'name': 'HDMI-A-2', 'pos_x': 2560, 'width': 3840, 'height': 2160, 'scale': 2.,
        'mHz': 30000}
]

pywm = {
    # 'xkb_model': "macintosh",
    'xkb_model': "PLACEHOLDER_xkb_model",
    'xkb_layout': "de,de",
    'xkb_options': "caps:escape",

    'xcursor_theme': 'Adwaita',
    'xcursor_size': 24,

    'encourage_csd': False,
    'enable_xwayland': True,

    'natural_scroll': True,

    'texture_shaders': 'basic',
    'renderer_mode': 'indirect'
}

def rules(view):
    if view.app_id == "catapult":
        return { 'float': True, 'float_pos': (0.5, 0.25) }
    if view.app_id == "pavucontrol":
        return { 'float': True, 'float_size': (340, 600), 'float_pos': (0.15, 0.4) }
    if view.title is not None and view.title.strip() == "Firefox — Sharing Indicator":
        return { 'float': True, 'float_size': (100, 40), 'float_pos': (0.5, 0.1) }
    if view.app_id == "Alacritty":
        return { 'blur': { 'radius': 5, 'passes': 3}}
    if view.app_id == "waybar":
        return { 'blur': { 'radius': 5, 'passes': 3}}
    return None

view = {
    'padding': 8,
    'fullscreen_padding': 0,
    'send_fullscreen': False,
    'accept_fullscreen': False,

    'rules': rules,
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

wob_runner = WobRunner("wob -a bottom -M 100")
backlight_manager = BacklightManager(anim_time=1., bar_display=wob_runner)
kbdlight_manager = BacklightManager(args="--device='*::kbd_backlight'", anim_time=1., bar_display=wob_runner)
def synchronous_update() -> None:
    backlight_manager.update()
    kbdlight_manager.update()

pactl = PaCtl(0, wob_runner)

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

    ("XF86MonBrightnessUp", lambda: backlight_manager.set(backlight_manager.get() + 0.1)),
    ("XF86MonBrightnessDown", lambda: backlight_manager.set(backlight_manager.get() - 0.1)),
    ("XF86KbdBrightnessUp", lambda: kbdlight_manager.set(kbdlight_manager.get() + 0.1)),
    ("XF86KbdBrightnessDown", lambda: kbdlight_manager.set(kbdlight_manager.get() - 0.1)),
    ("XF86AudioRaiseVolume", lambda: pactl.volume_adj(5)),
    ("XF86AudioLowerVolume", lambda: pactl.volume_adj(-5)),
    ("XF86AudioMute", lambda: pactl.mute()),

    ("XF86LaunchA", lambda: None),
    ("XF86LaunchB", lambda: None),
    ("XF86AudioPrev", lambda: None),
    ("XF86AudioPlay", lambda: None),
    ("XF86AudioNext", lambda: None),

    ("M-z", lambda: layout.swallow_focused_view()),
]

bar = {
    'enabled': False,
}

gestures = {
    'lp_freq': 120.,
    'lp_inertia': 0.4,

    'c': PLACEHOLDER_c_gestures,
    'pyevdev': PLACEHOLDER_pyevdev_gestures,
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
    },
    'launcher': {
        'cmd': 'alacritty -e newm-panel-basic launcher',
        'w': 0.7,
        'h': 0.6,
        'corner_radius': 50,
    },
    'bar': {
        'cmd': 'waybar'
    },
    'top_bar': {
        'permanent': 24
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
    'color': '#92f0f5d1',
    'enabled': True
}




