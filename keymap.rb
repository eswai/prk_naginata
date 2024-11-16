# Initialize a Keyboard
puts "Starting my keyboard..."
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
      if NG_KEYCODE.include?(kc)
        r << kc
      end
    end
    r
  end
end

# array a - b
def subtract(a, b)
  r = []
  a.each do |a1|
    if !b.include?(a1)
      r << a1
    end
  end
  r
end

ngdic = [
  #  前置シフト      同時押し                        かな
  [[         ], [ :NG_U                    ], [ :KC_BSPACE                        ]],
  [[         ], [ :NG_SFT                  ], [ :KC_SPACE                         ]],
  [[         ], [ :NG_M, :NG_V             ], [ :KC_ENTER                         ]],
  [[         ], [ :NG_T                    ], [ :KC_LEFT                          ]],
  [[         ], [ :NG_Y                    ], [ :KC_RIGHT                         ]],
  # [[ :NG_SFT ], [ :NG_T                    ], [ :KC_LSFT[:KC_LEFT]                ]],
  # [[ :NG_SFT ], [ :NG_Y                    ], [ :KC_LSFT[:KC_RIGHT]               ]],
  [[         ], [ :NG_SCOLON               ], [ :KC_MINUS                         ]], # ー
  [[ :NG_SFT ], [ :NG_V                    ], [ :KC_COMMA, :KC_ENTER              ]], # 、[Enter]
  [[ :NG_SFT ], [ :NG_M                    ], [ :KC_DOT, :KC_ENTER                ]], # 。[Enter]

  [[         ], [ :NG_J                    ], [ :KC_A                             ]], # あ
  [[         ], [ :NG_K                    ], [ :KC_I                             ]], # い
  [[         ], [ :NG_L                    ], [ :KC_U                             ]], # う
  [[ :NG_SFT ], [ :NG_O                    ], [ :KC_E                             ]], # え
  [[ :NG_SFT ], [ :NG_N                    ], [ :KC_O                             ]], # お
  [[         ], [ :NG_F                    ], [ :KC_K, :KC_A                      ]], # か
  [[         ], [ :NG_W                    ], [ :KC_K, :KC_I                      ]], # き
  [[         ], [ :NG_H                    ], [ :KC_K, :KC_U                      ]], # く
  [[         ], [ :NG_S                    ], [ :KC_K, :KC_E                      ]], # け
  [[         ], [ :NG_V                    ], [ :KC_K, :KC_O                      ]], # こ
  [[ :NG_SFT ], [ :NG_U                    ], [ :KC_S, :KC_A                      ]], # さ
  [[         ], [ :NG_R                    ], [ :KC_S, :KC_I                      ]], # し
  [[         ], [ :NG_O                    ], [ :KC_S, :KC_U                      ]], # す
  [[ :NG_SFT ], [ :NG_A                    ], [ :KC_S, :KC_E                      ]], # せ
  [[         ], [ :NG_B                    ], [ :KC_S, :KC_O                      ]], # そ
  [[         ], [ :NG_N                    ], [ :KC_T, :KC_A                      ]], # た
  [[ :NG_SFT ], [ :NG_G                    ], [ :KC_T, :KC_I                      ]], # ち
  [[ :NG_SFT ], [ :NG_L                    ], [ :KC_T, :KC_U                      ]], # つ
  [[         ], [ :NG_E                    ], [ :KC_T, :KC_E                      ]], # て
  [[         ], [ :NG_D                    ], [ :KC_T, :KC_O                      ]], # と
  [[         ], [ :NG_M                    ], [ :KC_N, :KC_A                      ]], # な
  [[ :NG_SFT ], [ :NG_D                    ], [ :KC_N, :KC_I                      ]], # に
  [[ :NG_SFT ], [ :NG_W                    ], [ :KC_N, :KC_U                      ]], # ぬ
  [[ :NG_SFT ], [ :NG_R                    ], [ :KC_N, :KC_E                      ]], # ね
  [[ :NG_SFT ], [ :NG_J                    ], [ :KC_N, :KC_O                      ]], # の
  [[         ], [ :NG_C                    ], [ :KC_H, :KC_A                      ]], # は
  [[         ], [ :NG_X                    ], [ :KC_H, :KC_I                      ]], # ひ
  [[ :NG_SFT ], [ :NG_X                    ], [ :KC_H, :KC_I                      ]], # ひ
  [[ :NG_SFT ], [ :NG_SCOLON               ], [ :KC_H, :KC_U                      ]], # ふ
  [[         ], [ :NG_P                    ], [ :KC_H, :KC_E                      ]], # へ
  [[         ], [ :NG_Z                    ], [ :KC_H, :KC_O                      ]], # ほ
  [[ :NG_SFT ], [ :NG_Z                    ], [ :KC_H, :KC_O                      ]], # ほ
  [[ :NG_SFT ], [ :NG_F                    ], [ :KC_M, :KC_A                      ]], # ま
  [[ :NG_SFT ], [ :NG_B                    ], [ :KC_M, :KC_I                      ]], # み
  [[ :NG_SFT ], [ :NG_COMMA                ], [ :KC_M, :KC_U                      ]], # む
  [[ :NG_SFT ], [ :NG_S                    ], [ :KC_M, :KC_E                      ]], # め
  [[ :NG_SFT ], [ :NG_K                    ], [ :KC_M, :KC_O                      ]], # も
  [[ :NG_SFT ], [ :NG_H                    ], [ :KC_Y, :KC_A                      ]], # や
  [[ :NG_SFT ], [ :NG_P                    ], [ :KC_Y, :KC_U                      ]], # ゆ
  [[ :NG_SFT ], [ :NG_I                    ], [ :KC_Y, :KC_O                      ]], # よ
  [[         ], [ :NG_DOT                  ], [ :KC_R, :KC_A                      ]], # ら
  [[ :NG_SFT ], [ :NG_E                    ], [ :KC_R, :KC_I                      ]], # り
  [[         ], [ :NG_I                    ], [ :KC_R, :KC_U                      ]], # る
  [[         ], [ :NG_SLASH                ], [ :KC_R, :KC_E                      ]], # れ
  [[ :NG_SFT ], [ :NG_SLASH                ], [ :KC_R, :KC_E                      ]], # れ
  [[         ], [ :NG_A                    ], [ :KC_R, :KC_O                      ]], # ろ
  [[ :NG_SFT ], [ :NG_DOT                  ], [ :KC_W, :KC_A                      ]], # わ
  [[ :NG_SFT ], [ :NG_C                    ], [ :KC_W, :KC_O                      ]], # を
  [[         ], [ :NG_COMMA                ], [ :KC_N, :KC_N                      ]], # ん
  [[         ], [ :NG_Q                    ], [ :KC_V, :KC_U                      ]], # ゔ
  [[ :NG_SFT ], [ :NG_Q                    ], [ :KC_V, :KC_U                      ]], # ゔ
  [[         ], [ :NG_J, :NG_F             ], [ :KC_G, :KC_A                      ]], # が
  [[         ], [ :NG_J, :NG_W             ], [ :KC_G, :KC_I                      ]], # ぎ
  [[         ], [ :NG_F, :NG_H             ], [ :KC_G, :KC_U                      ]], # ぐ
  [[         ], [ :NG_J, :NG_S             ], [ :KC_G, :KC_E                      ]], # げ
  [[         ], [ :NG_J, :NG_V             ], [ :KC_G, :KC_O                      ]], # ご
  [[         ], [ :NG_F, :NG_U             ], [ :KC_Z, :KC_A                      ]], # ざ
  [[         ], [ :NG_J, :NG_R             ], [ :KC_Z, :KC_I                      ]], # じ
  [[         ], [ :NG_F, :NG_O             ], [ :KC_Z, :KC_U                      ]], # ず
  [[         ], [ :NG_J, :NG_A             ], [ :KC_Z, :KC_E                      ]], # ぜ
  [[         ], [ :NG_J, :NG_B             ], [ :KC_Z, :KC_O                      ]], # ぞ
  [[         ], [ :NG_F, :NG_N             ], [ :KC_D, :KC_A                      ]], # だ
  [[         ], [ :NG_J, :NG_G             ], [ :KC_D, :KC_I                      ]], # ぢ
  [[         ], [ :NG_F, :NG_L             ], [ :KC_D, :KC_U                      ]], # づ
  [[         ], [ :NG_J, :NG_E             ], [ :KC_D, :KC_E                      ]], # で
  [[         ], [ :NG_J, :NG_D             ], [ :KC_D, :KC_O                      ]], # ど
  [[         ], [ :NG_J, :NG_C             ], [ :KC_B, :KC_A                      ]], # ば
  [[         ], [ :NG_J, :NG_X             ], [ :KC_B, :KC_I                      ]], # び
  [[         ], [ :NG_F, :NG_SCOLON        ], [ :KC_B, :KC_U                      ]], # ぶ
  [[         ], [ :NG_F, :NG_P             ], [ :KC_B, :KC_E                      ]], # べ
  [[         ], [ :NG_J, :NG_Z             ], [ :KC_B, :KC_O                      ]], # ぼ
  [[         ], [ :NG_F, :NG_L             ], [ :KC_V, :KC_U                      ]], # ゔ
  [[         ], [ :NG_M, :NG_C             ], [ :KC_P, :KC_A                      ]], # ぱ
  [[         ], [ :NG_M, :NG_X             ], [ :KC_P, :KC_I                      ]], # ぴ
  [[         ], [ :NG_V, :NG_SCOLON        ], [ :KC_P, :KC_U                      ]], # ぷ
  [[         ], [ :NG_V, :NG_P             ], [ :KC_P, :KC_E                      ]], # ぺ
  [[         ], [ :NG_M, :NG_Z             ], [ :KC_P, :KC_O                      ]], # ぽ
  [[         ], [ :NG_Q, :NG_H             ], [ :KC_X, :KC_Y, :KC_A               ]], # ゃ
  [[         ], [ :NG_Q, :NG_P             ], [ :KC_X, :KC_Y, :KC_U               ]], # ゅ
  [[         ], [ :NG_Q, :NG_I             ], [ :KC_X, :KC_Y, :KC_O               ]], # ょ
  [[         ], [ :NG_Q, :NG_J             ], [ :KC_X, :KC_A                      ]], # ぁ
  [[         ], [ :NG_Q, :NG_K             ], [ :KC_X, :KC_I                      ]], # ぃ
  [[         ], [ :NG_Q, :NG_L             ], [ :KC_X, :KC_U                      ]], # ぅ
  [[         ], [ :NG_Q, :NG_O             ], [ :KC_X, :KC_E                      ]], # ぇ
  [[         ], [ :NG_Q, :NG_N             ], [ :KC_X, :KC_O                      ]], # ぉ
  [[         ], [ :NG_Q, :NG_DOT           ], [ :KC_X, :KC_W, :KC_A               ]], # ゎ
  [[         ], [ :NG_G                    ], [ :KC_X, :KC_T, :KC_U               ]], # っ
  [[         ], [ :NG_Q, :NG_S             ], [ :KC_X, :KC_K, :KC_E               ]], # ヶ
  [[         ], [ :NG_Q, :NG_F             ], [ :KC_X, :KC_K, :KC_A               ]], # ヵ
  [[         ], [ :NG_R, :NG_H             ], [ :KC_S, :KC_Y, :KC_A               ]], # しゃ
  [[         ], [ :NG_R, :NG_P             ], [ :KC_S, :KC_Y, :KC_U               ]], # しゅ
  [[         ], [ :NG_R, :NG_I             ], [ :KC_S, :KC_Y, :KC_O               ]], # しょ
  [[         ], [ :NG_J, :NG_R, :NG_H      ], [ :KC_Z, :KC_Y, :KC_A               ]], # じゃ
  [[         ], [ :NG_J, :NG_R, :NG_P      ], [ :KC_Z, :KC_Y, :KC_U               ]], # じゅ
  [[         ], [ :NG_J, :NG_R, :NG_I      ], [ :KC_Z, :KC_Y, :KC_O               ]], # じょ
  [[         ], [ :NG_W, :NG_H             ], [ :KC_K, :KC_Y, :KC_A               ]], # きゃ
  [[         ], [ :NG_W, :NG_P             ], [ :KC_K, :KC_Y, :KC_U               ]], # きゅ
  [[         ], [ :NG_W, :NG_I             ], [ :KC_K, :KC_Y, :KC_O               ]], # きょ
  [[         ], [ :NG_J, :NG_W, :NG_H      ], [ :KC_G, :KC_Y, :KC_A               ]], # ぎゃ
  [[         ], [ :NG_J, :NG_W, :NG_P      ], [ :KC_G, :KC_Y, :KC_U               ]], # ぎゅ
  [[         ], [ :NG_J, :NG_W, :NG_I      ], [ :KC_G, :KC_Y, :KC_O               ]], # ぎょ
  [[         ], [ :NG_G, :NG_H             ], [ :KC_T, :KC_Y, :KC_A               ]], # ちゃ
  [[         ], [ :NG_G, :NG_P             ], [ :KC_T, :KC_Y, :KC_U               ]], # ちゅ
  [[         ], [ :NG_G, :NG_I             ], [ :KC_T, :KC_Y, :KC_O               ]], # ちょ
  [[         ], [ :NG_J, :NG_G, :NG_H      ], [ :KC_D, :KC_Y, :KC_A               ]], # ぢゃ
  [[         ], [ :NG_J, :NG_G, :NG_P      ], [ :KC_D, :KC_Y, :KC_U               ]], # ぢゅ
  [[         ], [ :NG_J, :NG_G, :NG_I      ], [ :KC_D, :KC_Y, :KC_O               ]], # ぢょ
  [[         ], [ :NG_D, :NG_H             ], [ :KC_N, :KC_Y, :KC_A               ]], # にゃ
  [[         ], [ :NG_D, :NG_P             ], [ :KC_N, :KC_Y, :KC_U               ]], # にゅ
  [[         ], [ :NG_D, :NG_I             ], [ :KC_N, :KC_Y, :KC_O               ]], # にょ
  [[         ], [ :NG_X, :NG_H             ], [ :KC_H, :KC_Y, :KC_A               ]], # ひゃ
  [[         ], [ :NG_X, :NG_P             ], [ :KC_H, :KC_Y, :KC_U               ]], # ひゅ
  [[         ], [ :NG_X, :NG_I             ], [ :KC_H, :KC_Y, :KC_O               ]], # ひょ
  [[         ], [ :NG_J, :NG_X, :NG_H      ], [ :KC_B, :KC_Y, :KC_A               ]], # びゃ
  [[         ], [ :NG_J, :NG_X, :NG_P      ], [ :KC_B, :KC_Y, :KC_U               ]], # びゅ
  [[         ], [ :NG_J, :NG_X, :NG_I      ], [ :KC_B, :KC_Y, :KC_O               ]], # びょ
  [[         ], [ :NG_M, :NG_X, :NG_H      ], [ :KC_P, :KC_Y, :KC_A               ]], # ぴゃ
  [[         ], [ :NG_M, :NG_X, :NG_P      ], [ :KC_P, :KC_Y, :KC_U               ]], # ぴゅ
  [[         ], [ :NG_M, :NG_X, :NG_I      ], [ :KC_P, :KC_Y, :KC_O               ]], # ぴょ
  [[         ], [ :NG_B, :NG_H             ], [ :KC_M, :KC_Y, :KC_A               ]], # みゃ
  [[         ], [ :NG_B, :NG_P             ], [ :KC_M, :KC_Y, :KC_U               ]], # みゅ
  [[         ], [ :NG_B, :NG_I             ], [ :KC_M, :KC_Y, :KC_O               ]], # みょ
  [[         ], [ :NG_E, :NG_H             ], [ :KC_R, :KC_Y, :KC_A               ]], # りゃ
  [[         ], [ :NG_E, :NG_P             ], [ :KC_R, :KC_Y, :KC_U               ]], # りゅ
  [[         ], [ :NG_E, :NG_I             ], [ :KC_R, :KC_Y, :KC_O               ]], # りょ
  [[         ], [ :NG_M, :NG_E, :NG_K      ], [ :KC_T, :KC_H, :KC_I               ]], # てぃ
  [[         ], [ :NG_M, :NG_E, :NG_P      ], [ :KC_T, :KC_H, :KC_U               ]], # てゅ
  [[         ], [ :NG_J, :NG_E, :NG_K      ], [ :KC_D, :KC_H, :KC_I               ]], # でぃ
  [[         ], [ :NG_J, :NG_E, :NG_P      ], [ :KC_D, :KC_H, :KC_U               ]], # でゅ
  [[         ], [ :NG_M, :NG_D, :NG_L      ], [ :KC_T, :KC_O, :KC_X, :KC_U        ]], # とぅ
  [[         ], [ :NG_J, :NG_D, :NG_L      ], [ :KC_D, :KC_O, :KC_X, :KC_U        ]], # どぅ
  [[         ], [ :NG_M, :NG_R, :NG_O      ], [ :KC_S, :KC_Y, :KC_E               ]], # しぇ
  [[         ], [ :NG_M, :NG_G, :NG_O      ], [ :KC_T, :KC_Y, :KC_E               ]], # ちぇ
  [[         ], [ :NG_J, :NG_R, :NG_O      ], [ :KC_Z, :KC_Y, :KC_E               ]], # じぇ
  [[         ], [ :NG_J, :NG_G, :NG_O      ], [ :KC_D, :KC_Y, :KC_E               ]], # ぢぇ
  [[         ], [ :NG_V, :NG_SCOLON, :NG_J ], [ :KC_F, :KC_A                      ]], # ふぁ
  [[         ], [ :NG_V, :NG_SCOLON, :NG_K ], [ :KC_F, :KC_I                      ]], # ふぃ
  [[         ], [ :NG_V, :NG_SCOLON, :NG_O ], [ :KC_F, :KC_E                      ]], # ふぇ
  [[         ], [ :NG_V, :NG_SCOLON, :NG_N ], [ :KC_F, :KC_O                      ]], # ふぉ
  [[         ], [ :NG_V, :NG_SCOLON, :NG_P ], [ :KC_F, :KC_Y, :KC_U               ]], # ふゅ
  [[         ], [ :NG_V, :NG_K, :NG_O      ], [ :KC_I, :KC_X, :KC_E               ]], # いぇ
  [[         ], [ :NG_V, :NG_L, :NG_K      ], [ :KC_W, :KC_I                      ]], # うぃ
  [[         ], [ :NG_V, :NG_L, :NG_O      ], [ :KC_W, :KC_E                      ]], # うぇ
  [[         ], [ :NG_V, :NG_L, :NG_N      ], [ :KC_U, :KC_X, :KC_O               ]], # うぉ
  [[         ], [ :NG_M, :NG_Q, :NG_J      ], [ :KC_V, :KC_A                      ]], # ゔぁ
  [[         ], [ :NG_M, :NG_Q, :NG_K      ], [ :KC_V, :KC_I                      ]], # ゔぃ
  [[         ], [ :NG_M, :NG_Q, :NG_O      ], [ :KC_V, :KC_E                      ]], # ゔぇ
  [[         ], [ :NG_M, :NG_Q, :NG_N      ], [ :KC_V, :KC_O                      ]], # ゔぉ
  [[         ], [ :NG_M, :NG_Q, :NG_P      ], [ :KC_V, :KC_U, :KC_X, :KC_Y, :KC_U ]], # ゔゅ
  [[         ], [ :NG_V, :NG_H, :NG_J      ], [ :KC_K, :KC_U, :KC_X, :KC_A        ]], # くぁ
  [[         ], [ :NG_V, :NG_H, :NG_K      ], [ :KC_K, :KC_U, :KC_X, :KC_I        ]], # くぃ
  [[         ], [ :NG_V, :NG_H, :NG_O      ], [ :KC_K, :KC_U, :KC_X, :KC_E        ]], # くぇ
  [[         ], [ :NG_V, :NG_H, :NG_N      ], [ :KC_K, :KC_U, :KC_X, :KC_O        ]], # くぉ
  [[         ], [ :NG_V, :NG_H, :NG_DOT    ], [ :KC_K, :KC_U, :KC_X, :KC_W, :KC_A ]], # くゎ
  [[         ], [ :NG_F, :NG_H, :NG_J      ], [ :KC_G, :KC_U, :KC_X, :KC_A        ]], # ぐぁ
  [[         ], [ :NG_F, :NG_H, :NG_K      ], [ :KC_G, :KC_U, :KC_X, :KC_I        ]], # ぐぃ
  [[         ], [ :NG_F, :NG_H, :NG_O      ], [ :KC_G, :KC_U, :KC_X, :KC_E        ]], # ぐぇ
  [[         ], [ :NG_F, :NG_H, :NG_N      ], [ :KC_G, :KC_U, :KC_X, :KC_O        ]], # ぐぉ
  [[         ], [ :NG_F, :NG_H, :NG_DOT    ], [ :KC_G, :KC_U, :KC_X, :KC_W, :KC_A ]], # ぐゎ
  [[         ], [ :NG_V, :NG_L, :NG_J      ], [ :KC_T, :KC_S, :KC_A               ]], # つぁ

  [[ :NG_J, :NG_K    ], [ :NG_D    ], [ :KC_QUES, :KC_ENTER                       ]], # ？[改行]
  [[ :NG_J, :NG_K    ], [ :NG_C    ], [ :KC_EXLM, :KC_ENTER                       ]], # ！[改行]
]

pressed_keys = []
nginput = []  # 未変換のキー [[:NG_M], [:NG_J, :NG_W]] (なぎ)のように、同時押しの組み合わせを2次元配列へ格納

def equal(a, b)
  if a.length != b.length
    return false
  end
  a.each do |a1|
    unless b.include?(a1)
      return false
    end
  end
  return true
end

# b is subset of a
def subset(a, b)
  if a.length < b.length
    return false
  end
  b.each do |b1|
    unless a.include?(b1)
      return false
    end
  end
  return true
end

# array b is subset of a
def aincludes?(a, b)
  a.each do |a1|
    if equal(a1, b)
      return true
    end
  end
  return false
end

def ng_press(kc)
  # 後置シフトはしない
  if [:NG_SFT, :NG_SFT2].include?(kc)
    nginput << [kc]
  # 前のキーとの同時押しの可能性があるなら前に足す
  # 同じキー連打を除外
  # V, H, EでVHがロールオーバーすると「こくて」=[[V,H], [E]]になる。「こりゃ」は[[V],[H,E]]。
  elsif nginput.length > 0 and nginput[-1][-1] != kc and number_of_candidates(nginput[-1] + [kc]) > 0
    nginput[-1] = nginput[-1] + [kc]
  # 前のキーと同時押しはない
  else
    nginput << [kc]
    # pressed_keys.discard(:NG_SFT)
  end

  # 連続シフトする
  # がある　がる x (JIの組み合わせがあるからJがC/Oされる) strictモードを作る
  # あいあう　あいう x
  # ぎょあう　ぎょう x
  # どか どが x 先にFがc/oされてJが残される
  [[:NG_D, :NG_F], [:NG_C, :NG_V], [:NG_J, :NG_K], [:NG_M, :NG_COMMA], [:NG_SFT], [:NG_SFT2], [:NG_F], [:NG_V], [:NG_J], [:NG_M]].each do |rs|
    rskc = rs + nginput[-1]
    # rskc.append(kc)
    # じょじょ よを先に押すと連続シフトしない x
    # Falseにすると、がる が　がある になる x
    if !rs.include?(kc) and subset(pressed_keys, rs) and number_of_matches(rskc) > 0
      nginput[-1] = rskc
      break
    end
  end

  if nginput.length > 1 or number_of_candidates(nginput[0]) == 1
    ng_type(nginput.shift)
  end

  return false
end

def ng_release(kc)
  # pressed_keys.discard(kc)

  # 全部キーを離したらバッファを全部吐き出す
  if pressed_keys.length == 0
    while nginput.length > 0
      ng_type(nginput.shift)
    end
  end

  return false
end

def ng_type(keys)
  if keys.length == 0
    return
  end

  if keys.length == 1 and keys[0] == :NG_SFT2
    kbd.send_key(:KC_ENTER)
    return
  end

  skc = keys.map{|x| x == :NG_SFT2 ? :NG_SFT : x}
  f = true
  ngdic.each do |k|
    if equal(skc, k[0] + k[1])
      kbd.send_key(k[2])
      f = false
      break
    end
  end
  # JIみたいにJIを含む同時押しはたくさんあるが、JIのみの同時押しがないとき
  # 最後の１キーを別に分けて変換する
  if f
    kl = keys.pop()
    ng_type(keys)
    ng_type([kl])
  end
end

def number_of_matches(keys)
  unless keys
    return 0
  end

  noc = 0

  # skc = set(map(lambda x: :NG_SFT if x == :NG_SFT2 else x, keys))
  if [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length == 1
    noc = 1
  elsif [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length > 1
    skc = keys[1...-1]
    ngdic.each do |k|
      if k[0].include?(:NG_SFT) and equal(skc, k[1])
        noc += 1
        if noc > 1
          break
        end
      end
    end
  else
    f = true
    [[:NG_D, :NG_F], [:NG_C, :NG_V], [:NG_J, :NG_K], [:NG_M, :NG_COMMA]].each do |rs|
      if keys.length == 3 and equal(keys[0...2], rs)
        ngdic.each do |k|
          if equal(k[0], rs) and equal(keys[2], k[1])
            noc = 1
            f = false
            break
          end
        end
        break unless f
      end
    end
    if f
      skc = keys
      ngdic.each do |k|
        if !k[0].empty? and equal(skc, k[1])
          noc += 1
          if noc > 1
            break
          end
        end
      end
    end
  end

  puts "NG num of matches #{noc}"
  return noc
end

def number_of_candidates(keys)
  unless keys
    return 0
  end

  noc = 0

  if aincludes?([[:NG_SFT], [:NG_SFT2], [:NG_D, :NG_F], [:NG_C, :NG_V], [:NG_J, :NG_K], [:NG_M, :NG_COMMA]], keys)
    noc = 2
  elsif [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length > 1
    skc = keys[1...-1]
    ngdic.each do |k|
      if k[0].include?(:NG_SFT) and subset(k[1], skc)  # <=だけ違う
        noc += 1
        if noc > 1
          break
        end
      end
    end
  else
    [[:NG_D, :NG_F], [:NG_C, :NG_V], [:NG_J, :NG_K], [:NG_M, :NG_COMMA]].each do |rs|
      if keys.length == 3 and equal(keys[0...2], rs)
        f = true
        ngdic.each do |k|
          if equal(k[0], rs) and equal([keys[2]], k[1])
            noc = 1
            f = false
            break
          end
        end
        break unless f
      end
    end
    if f
      skc = keys
      ngdic.each do |k|
        if !k[0].empty? and subset(k[1], skc)  # <=だけ違う
          # シェ、チェは２文字タイプしたらnoc = 1になるが、まだ２キーしか押してないので、早期確定してはいけない。
          if keys.length < k[1].length
            noc = 2
            break
          else
            noc += 1
            break if noc > 1
          end
        end
      end
    end
  end

  puts "NG num of candidates #{noc}"
  return noc
end

kbd.before_report do
  p1 = kbd.pressed_keys()
  d = p1.length - pressed_keys.length
  if d > 0
    k = subtract(p1, pressed_keys)
    puts "press    #{k.join(', ')} : #{p1.join(', ')}"
    pressed_keys = p1
    k.each do |k1|
      ng_press(k1)
    end
  elsif d < 0
    k = subtract(pressed_keys, p1)
    puts "release  #{k.join(', ')} : #{p1.join(', ')}"
    pressed_keys = p1
    k.each do |k1|
      ng_release(k1)
    end
  end
end

kbd.start!
