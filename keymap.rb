require 'naginata'

# Initialize a Keyboard
kbd = Keyboard.new

# Initialize GPIO assign
kbd.init_pins(
  #[ 8, 9, 10, 11, 12 ], # row0, row1,... respectively
  #[ 2, 3, 4, 5, 6, 7 ]  # col0, col1,... respectively
  # If you put USB port on the right side, use below instead
  [ 7, 8, 9, 10 ],
  [ 15, 14, 13, 12, 11, 20, 19, 18, 17, 16]
)

# default layer should be added at first
# +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------
kbd.add_layer :default, %i[
  KC_Q      KC_W      KC_E      KC_R      KC_T      KC_Y      KC_U      KC_I      KC_O      KC_P     
  KC_A      KC_S      KC_D      KC_F      KC_G      KC_H      KC_J      KC_K      KC_L      KC_SCOLON
  KC_Z      KC_X      KC_C      KC_V      KC_B      KC_N      KC_M      KC_COMMA  KC_DOT    KC_SLASH 
  KC_LCTL   KC_LGUI   KC_LSFT   LOWER     SFTSPC    SFTENT    RAISE     KC_LALT   KC_TAB    KC_QUOTE    
]
# +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------
kbd.add_layer :raise, %i[
  KC_TILD   KC_AT     KC_HASH   KC_DLR    KC_NO     KC_NO     KC_HOME   KC_UP     KC_END    KC_BSPACE   
  KC_CIRC   KC_AMPR   KC_QUES   KC_PERC   KC_QUOTE  KC_NO     KC_LEFT   KC_DOWN   KC_RIGHT  KC_DELETE 
  KC_GRAVE  KC_PIPE   KC_EXLM   KC_UNDS   KC_BSLASH KC_NO     KC_NO     KC_NO     KC_NO     KC_NO
  KC_LCTL   KC_GUI    KC_LSFT   LOWER     KC_SPACE  KC_ENTER  RAISE     KC_LALT   KC_NO     KC_NO     
]
# +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------
kbd.add_layer :lower, %i[
  KC_ESCAPE KC_NO      KC_COLN  KC_SCOLON KC_NO     KC_SLASH  KC_7      KC_8      KC_9      KC_MINUS
  KC_NO    KC_LBRACKET KC_LCBR  KC_LPRN   KC_LT     KC_ASTER  KC_4      KC_5      KC_6      KC_PLUS
  KC_NO    KC_RBRACKET KC_RCBR  KC_RPRN   KC_GT     KC_0      KC_1      KC_2      KC_3      KC_EQUAL  
  KC_LCTL  KC_LGUI     KC_LSFT  LOWER     KC_SPACE  KC_ENTER  RAISE     KC_LALT   KC_NO     KC_NO     
]
# +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------
kbd.add_layer :naginata, %i[
  NG_Q      NG_W      NG_E      NG_R      NG_T      NG_Y      NG_U      NG_I      NG_O      NG_P     
  NG_A      NG_S      NG_D      NG_F      NG_G      NG_H      NG_J      NG_K      NG_L      NG_SCOLON
  NG_Z      NG_X      NG_C      NG_V      NG_B      NG_N      NG_M      NG_COMMA  NG_DOT    NG_SLASH 
  KC_TRNS   KC_TRNS   KC_TRNS   KC_TRNS   KC_SFT    KC_SFT2   KC_TRNS   KC_TRNS   KC_TRNS   KC_TRNS
]
# +---------+---------+---------+---------+---------+---------+---------+---------+---------+---------

NG_KEYCODE = %i[
  NG_Q      NG_W      NG_E      NG_R      NG_T      NG_Y      NG_U      NG_I      NG_O      NG_P     
  NG_A      NG_S      NG_D      NG_F      NG_G      NG_H      NG_J      NG_K      NG_L      NG_SCOLON
  NG_Z      NG_X      NG_C      NG_V      NG_B      NG_N      NG_M      NG_COMMA  NG_DOT    NG_SLASH 
  KC_SFT   KC_SFT2
]

# Tip: You can also switch current layer by single click like this:
kbd.define_mode_key :RAISE,      [ nil, :naginata , nil, nil ]
kbd.define_mode_key :LOWER,      [ nil, :lower , nil, nil ]
kbd.define_mode_key :SFTSPC,     [ :KC_SPACE, :KC_LSFT, 150, 150 ]
kbd.define_mode_key :SFTENT,     [ :KC_ENTER, :KC_LSFT, 150, 150 ]

class Keyboard
  def pressed_keys()
    keymap = @keymaps[@locked_layer || @layer || @default_layer]
    r = []
    @switches.each do |s|
      kc = keymap[s[0]][s[1]]
      if Naginata::NG_KEYCODE.include?(kc)
        r << kc
      end
    end
    r
  end
end

pressed_keys = []
ng = Naginata.new

kbd.before_report do
  p1 = kbd.pressed_keys()
  d = p1.length - pressed_keys.length
  if d > 0
    k = ng.subtract(p1, pressed_keys)
    puts "press    #{k.join(', ')} : #{p1.join(', ')}"
    pressed_keys = p1
    k.each do |k1|
      ng.ng_press(k1)
    end
  elsif d < 0
    k = ng.subtract(pressed_keys, p1)
    puts "release  #{k.join(', ')} : #{p1.join(', ')}"
    pressed_keys = p1
    k.each do |k1|
      ng.ng_release(k1)
    end
  end
end

kbd.start!
