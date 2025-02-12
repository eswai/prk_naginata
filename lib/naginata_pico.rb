# 薙刀式のRuby実装（Setを使わず、配列と補助メソッドで集合演算を実現）

class Naginata

  NG_KEYCODE = %i[
    NG_Q      NG_W      NG_E      NG_R      NG_T      NG_Y      NG_U      NG_I      NG_O      NG_P     
    NG_A      NG_S      NG_D      NG_F      NG_G      NG_H      NG_J      NG_K      NG_L      NG_SCOLON
    NG_Z      NG_X      NG_C      NG_V      NG_B      NG_N      NG_M      NG_COMMA  NG_DOT    NG_SLASH 
    KC_SFT   KC_SFT2
  ].freeze

  # 定数内のSet表現を配列に置換
  NGDIC = [
    #  前置シフト      同時押し                        かな
    # [ [:NG_SFT], [:NG_T], [ :KC_LSFT[:KC_LEFT] ] ],
    # [ [:NG_SFT], [:NG_Y], [ :KC_LSFT[:KC_RIGHT] ] ],
    [ [         ], [ :NG_U                    ], [ :KC_BSPACE                        ] ],
    [ [         ], [ :NG_SFT                  ], [ :KC_SPACE                         ] ],
    [ [         ], [ :NG_M, :NG_V             ], [ :KC_ENTER                         ] ],
    [ [         ], [ :NG_T                    ], [ :KC_LEFT                          ] ],
    [ [         ], [ :NG_Y                    ], [ :KC_RIGHT                         ] ],
    [ [         ], [ :NG_SCOLON               ], [ :KC_MINUS                         ] ], # ー
    [ [ :NG_SFT ], [ :NG_V                    ], [ :KC_COMMA, :KC_ENTER              ] ], # 、[Enter]
    [ [ :NG_SFT ], [ :NG_M                    ], [ :KC_DOT, :KC_ENTER                ] ], # 。[Enter]

    [ [         ], [ :NG_J                    ], [ :KC_A                             ] ], # あ
    [ [         ], [ :NG_K                    ], [ :KC_I                             ] ], # い
    [ [         ], [ :NG_L                    ], [ :KC_U                             ] ], # う
    [ [ :NG_SFT ], [ :NG_O                    ], [ :KC_E                             ] ], # え
    [ [ :NG_SFT ], [ :NG_N                    ], [ :KC_O                             ] ], # お
    [ [         ], [ :NG_F                    ], [ :KC_K, :KC_A                      ] ], # か
    [ [         ], [ :NG_W                    ], [ :KC_K, :KC_I                      ] ], # き
    [ [         ], [ :NG_H                    ], [ :KC_K, :KC_U                      ] ], # く
    [ [         ], [ :NG_S                    ], [ :KC_K, :KC_E                      ] ], # け
    [ [         ], [ :NG_V                    ], [ :KC_K, :KC_O                      ] ], # こ
    [ [ :NG_SFT ], [ :NG_U                    ], [ :KC_S, :KC_A                      ] ], # さ
    [ [         ], [ :NG_R                    ], [ :KC_S, :KC_I                      ] ], # し
    [ [         ], [ :NG_O                    ], [ :KC_S, :KC_U                      ] ], # す
    [ [ :NG_SFT ], [ :NG_A                    ], [ :KC_S, :KC_E                      ] ], # せ
    [ [         ], [ :NG_B                    ], [ :KC_S, :KC_O                      ] ], # そ
    [ [         ], [ :NG_N                    ], [ :KC_T, :KC_A                      ] ], # た
    [ [ :NG_SFT ], [ :NG_G                    ], [ :KC_T, :KC_I                      ] ], # ち
    [ [ :NG_SFT ], [ :NG_L                    ], [ :KC_T, :KC_U                      ] ], # つ
    [ [         ], [ :NG_E                    ], [ :KC_T, :KC_E                      ] ], # て
    [ [         ], [ :NG_D                    ], [ :KC_T, :KC_O                      ] ], # と
    [ [         ], [ :NG_M                    ], [ :KC_N, :KC_A                      ] ], # な
    [ [ :NG_SFT ], [ :NG_D                    ], [ :KC_N, :KC_I                      ] ], # に
    [ [ :NG_SFT ], [ :NG_W                    ], [ :KC_N, :KC_U                      ] ], # ぬ
    [ [ :NG_SFT ], [ :NG_R                    ], [ :KC_N, :KC_E                      ] ], # ね
    [ [ :NG_SFT ], [ :NG_J                    ], [ :KC_N, :KC_O                      ] ], # の
    [ [         ], [ :NG_C                    ], [ :KC_H, :KC_A                      ] ], # は
    [ [         ], [ :NG_X                    ], [ :KC_H, :KC_I                      ] ], # ひ
    [ [ :NG_SFT ], [ :NG_X                    ], [ :KC_H, :KC_I                      ] ], # ひ
    [ [ :NG_SFT ], [ :NG_SCOLON               ], [ :KC_H, :KC_U                      ] ], # ふ
    [ [         ], [ :NG_P                    ], [ :KC_H, :KC_E                      ] ], # へ
    [ [         ], [ :NG_Z                    ], [ :KC_H, :KC_O                      ] ], # ほ
    [ [ :NG_SFT ], [ :NG_Z                    ], [ :KC_H, :KC_O                      ] ], # ほ
    [ [ :NG_SFT ], [ :NG_F                    ], [ :KC_M, :KC_A                      ] ], # ま
    [ [ :NG_SFT ], [ :NG_B                    ], [ :KC_M, :KC_I                      ] ], # み
    [ [ :NG_SFT ], [ :NG_COMMA                ], [ :KC_M, :KC_U                      ] ], # む
    [ [ :NG_SFT ], [ :NG_S                    ], [ :KC_M, :KC_E                      ] ], # め
    [ [ :NG_SFT ], [ :NG_K                    ], [ :KC_M, :KC_O                      ] ], # も
    [ [ :NG_SFT ], [ :NG_H                    ], [ :KC_Y, :KC_A                      ] ], # や
    [ [ :NG_SFT ], [ :NG_P                    ], [ :KC_Y, :KC_U                      ] ], # ゆ
    [ [ :NG_SFT ], [ :NG_I                    ], [ :KC_Y, :KC_O                      ] ], # よ
    [ [         ], [ :NG_DOT                  ], [ :KC_R, :KC_A                      ] ], # ら
    [ [ :NG_SFT ], [ :NG_E                    ], [ :KC_R, :KC_I                      ] ], # り
    [ [         ], [ :NG_I                    ], [ :KC_R, :KC_U                      ] ], # る
    [ [         ], [ :NG_SLASH                ], [ :KC_R, :KC_E                      ] ], # れ
    [ [ :NG_SFT ], [ :NG_SLASH                ], [ :KC_R, :KC_E                      ] ], # れ
    [ [         ], [ :NG_A                    ], [ :KC_R, :KC_O                      ] ], # ろ
    [ [ :NG_SFT ], [ :NG_DOT                  ], [ :KC_W, :KC_A                      ] ], # わ
    [ [ :NG_SFT ], [ :NG_C                    ], [ :KC_W, :KC_O                      ] ], # を
    [ [         ], [ :NG_COMMA                ], [ :KC_N, :KC_N                      ] ], # ん
    [ [         ], [ :NG_Q                    ], [ :KC_V, :KC_U                      ] ], # ゔ
    [ [ :NG_SFT ], [ :NG_Q                    ], [ :KC_V, :KC_U                      ] ], # ゔ
    [ [         ], [ :NG_J, :NG_F             ], [ :KC_G, :KC_A                      ] ], # が
    [ [         ], [ :NG_J, :NG_W             ], [ :KC_G, :KC_I                      ] ], # ぎ
    [ [         ], [ :NG_F, :NG_H             ], [ :KC_G, :KC_U                      ] ], # ぐ
    [ [         ], [ :NG_J, :NG_S             ], [ :KC_G, :KC_E                      ] ], # げ
    [ [         ], [ :NG_J, :NG_V             ], [ :KC_G, :KC_O                      ] ], # ご
    [ [         ], [ :NG_F, :NG_U             ], [ :KC_Z, :KC_A                      ] ], # ざ
    [ [         ], [ :NG_J, :NG_R             ], [ :KC_Z, :KC_I                      ] ], # じ
    [ [         ], [ :NG_F, :NG_O             ], [ :KC_Z, :KC_U                      ] ], # ず
    [ [         ], [ :NG_J, :NG_A             ], [ :KC_Z, :KC_E                      ] ], # ぜ
    [ [         ], [ :NG_J, :NG_B             ], [ :KC_Z, :KC_O                      ] ], # ぞ
    [ [         ], [ :NG_F, :NG_N             ], [ :KC_D, :KC_A                      ] ], # だ
    [ [         ], [ :NG_J, :NG_G             ], [ :KC_D, :KC_I                      ] ], # ぢ
    [ [         ], [ :NG_F, :NG_L             ], [ :KC_D, :KC_U                      ] ], # づ
    [ [         ], [ :NG_J, :NG_E             ], [ :KC_D, :KC_E                      ] ], # で
    [ [         ], [ :NG_J, :NG_D             ], [ :KC_D, :KC_O                      ] ], # ど
    [ [         ], [ :NG_J, :NG_C             ], [ :KC_B, :KC_A                      ] ], # ば
    [ [         ], [ :NG_J, :NG_X             ], [ :KC_B, :KC_I                      ] ], # び
    [ [         ], [ :NG_F, :NG_SCOLON        ], [ :KC_B, :KC_U                      ] ], # ぶ
    [ [         ], [ :NG_F, :NG_P             ], [ :KC_B, :KC_E                      ] ], # べ
    [ [         ], [ :NG_J, :NG_Z             ], [ :KC_B, :KC_O                      ] ], # ぼ
    [ [         ], [ :NG_F, :NG_L             ], [ :KC_V, :KC_U                      ] ], # ゔ
    [ [         ], [ :NG_M, :NG_C             ], [ :KC_P, :KC_A                      ] ], # ぱ
    [ [         ], [ :NG_M, :NG_X             ], [ :KC_P, :KC_I                      ] ], # ぴ
    [ [         ], [ :NG_V, :NG_SCOLON        ], [ :KC_P, :KC_U                      ] ], # ぷ
    [ [         ], [ :NG_V, :NG_P             ], [ :KC_P, :KC_E                      ] ], # ぺ
    [ [         ], [ :NG_M, :NG_Z             ], [ :KC_P, :KC_O                      ] ], # ぽ
    [ [         ], [ :NG_Q, :NG_H             ], [ :KC_X, :KC_Y, :KC_A               ] ], # ゃ
    [ [         ], [ :NG_Q, :NG_P             ], [ :KC_X, :KC_Y, :KC_U               ] ], # ゅ
    [ [         ], [ :NG_Q, :NG_I             ], [ :KC_X, :KC_Y, :KC_O               ] ], # ょ
    [ [         ], [ :NG_Q, :NG_J             ], [ :KC_X, :KC_A                      ] ], # ぁ
    [ [         ], [ :NG_Q, :NG_K             ], [ :KC_X, :KC_I                      ] ], # ぃ
    [ [         ], [ :NG_Q, :NG_L             ], [ :KC_X, :KC_U                      ] ], # ぅ
    [ [         ], [ :NG_Q, :NG_O             ], [ :KC_X, :KC_E                      ] ], # ぇ
    [ [         ], [ :NG_Q, :NG_N             ], [ :KC_X, :KC_O                      ] ], # ぉ
    [ [         ], [ :NG_Q, :NG_DOT           ], [ :KC_X, :KC_W, :KC_A               ] ], # ゎ
    [ [         ], [ :NG_G                    ], [ :KC_X, :KC_T, :KC_U               ] ], # っ
    [ [         ], [ :NG_Q, :NG_S             ], [ :KC_X, :KC_K, :KC_E               ] ], # ヶ
    [ [         ], [ :NG_Q, :NG_F             ], [ :KC_X, :KC_K, :KC_A               ] ], # ヵ
    [ [         ], [ :NG_R, :NG_H             ], [ :KC_S, :KC_Y, :KC_A               ] ], # しゃ
    [ [         ], [ :NG_R, :NG_P             ], [ :KC_S, :KC_Y, :KC_U               ] ], # しゅ
    [ [         ], [ :NG_R, :NG_I             ], [ :KC_S, :KC_Y, :KC_O               ] ], # しょ
    [ [         ], [ :NG_J, :NG_R, :NG_H      ], [ :KC_Z, :KC_Y, :KC_A               ] ], # じゃ
    [ [         ], [ :NG_J, :NG_R, :NG_P      ], [ :KC_Z, :KC_Y, :KC_U               ] ], # じゅ
    [ [         ], [ :NG_J, :NG_R, :NG_I      ], [ :KC_Z, :KC_Y, :KC_O               ] ], # じょ
    [ [         ], [ :NG_W, :NG_H             ], [ :KC_K, :KC_Y, :KC_A               ] ], # きゃ
    [ [         ], [ :NG_W, :NG_P             ], [ :KC_K, :KC_Y, :KC_U               ] ], # きゅ
    [ [         ], [ :NG_W, :NG_I             ], [ :KC_K, :KC_Y, :KC_O               ] ], # きょ
    [ [         ], [ :NG_J, :NG_W, :NG_H      ], [ :KC_G, :KC_Y, :KC_A               ] ], # ぎゃ
    [ [         ], [ :NG_J, :NG_W, :NG_P      ], [ :KC_G, :KC_Y, :KC_U               ] ], # ぎゅ
    [ [         ], [ :NG_J, :NG_W, :NG_I      ], [ :KC_G, :KC_Y, :KC_O               ] ], # ぎょ
    [ [         ], [ :NG_G, :NG_H             ], [ :KC_T, :KC_Y, :KC_A               ] ], # ちゃ
    [ [         ], [ :NG_G, :NG_P             ], [ :KC_T, :KC_Y, :KC_U               ] ], # ちゅ
    [ [         ], [ :NG_G, :NG_I             ], [ :KC_T, :KC_Y, :KC_O               ] ], # ちょ
    [ [         ], [ :NG_J, :NG_G, :NG_H      ], [ :KC_D, :KC_Y, :KC_A               ] ], # ぢゃ
    [ [         ], [ :NG_J, :NG_G, :NG_P      ], [ :KC_D, :KC_Y, :KC_U               ] ], # ぢゅ
    [ [         ], [ :NG_J, :NG_G, :NG_I      ], [ :KC_D, :KC_Y, :KC_O               ] ], # ぢょ
    [ [         ], [ :NG_D, :NG_H             ], [ :KC_N, :KC_Y, :KC_A               ] ], # にゃ
    [ [         ], [ :NG_D, :NG_P             ], [ :KC_N, :KC_Y, :KC_U               ] ], # にゅ
    [ [         ], [ :NG_D, :NG_I             ], [ :KC_N, :KC_Y, :KC_O               ] ], # にょ
    [ [         ], [ :NG_X, :NG_H             ], [ :KC_H, :KC_Y, :KC_A               ] ], # ひゃ
    [ [         ], [ :NG_X, :NG_P             ], [ :KC_H, :KC_Y, :KC_U               ] ], # ひゅ
    [ [         ], [ :NG_X, :NG_I             ], [ :KC_H, :KC_Y, :KC_O               ] ], # ひょ
    [ [         ], [ :NG_J, :NG_X, :NG_H      ], [ :KC_B, :KC_Y, :KC_A               ] ], # びゃ
    [ [         ], [ :NG_J, :NG_X, :NG_P      ], [ :KC_B, :KC_Y, :KC_U               ] ], # びゅ
    [ [         ], [ :NG_J, :NG_X, :NG_I      ], [ :KC_B, :KC_Y, :KC_O               ] ], # びょ
    [ [         ], [ :NG_M, :NG_X, :NG_H      ], [ :KC_P, :KC_Y, :KC_A               ] ], # ぴゃ
    [ [         ], [ :NG_M, :NG_X, :NG_P      ], [ :KC_P, :KC_Y, :KC_U               ] ], # ぴゅ
    [ [         ], [ :NG_M, :NG_X, :NG_I      ], [ :KC_P, :KC_Y, :KC_O               ] ], # ぴょ
    [ [         ], [ :NG_B, :NG_H             ], [ :KC_M, :KC_Y, :KC_A               ] ], # みゃ
    [ [         ], [ :NG_B, :NG_P             ], [ :KC_M, :KC_Y, :KC_U               ] ], # みゅ
    [ [         ], [ :NG_B, :NG_I             ], [ :KC_M, :KC_Y, :KC_O               ] ], # みょ
    [ [         ], [ :NG_E, :NG_H             ], [ :KC_R, :KC_Y, :KC_A               ] ], # りゃ
    [ [         ], [ :NG_E, :NG_P             ], [ :KC_R, :KC_Y, :KC_U               ] ], # りゅ
    [ [         ], [ :NG_E, :NG_I             ], [ :KC_R, :KC_Y, :KC_O               ] ], # りょ
    [ [         ], [ :NG_M, :NG_E, :NG_K      ], [ :KC_T, :KC_H, :KC_I               ] ], # てぃ
    [ [         ], [ :NG_M, :NG_E, :NG_P      ], [ :KC_T, :KC_E, :KC_X, :KC_Y, :KC_U ] ], # てゅ
    [ [         ], [ :NG_J, :NG_E, :NG_K      ], [ :KC_D, :KC_H, :KC_I               ] ], # でぃ
    [ [         ], [ :NG_J, :NG_E, :NG_P      ], [ :KC_D, :KC_H, :KC_U               ] ], # でゅ
    [ [         ], [ :NG_M, :NG_D, :NG_L      ], [ :KC_T, :KC_O, :KC_X, :KC_U        ] ], # とぅ
    [ [         ], [ :NG_J, :NG_D, :NG_L      ], [ :KC_D, :KC_O, :KC_X, :KC_U        ] ], # どぅ
    [ [         ], [ :NG_M, :NG_R, :NG_O      ], [ :KC_S, :KC_Y, :KC_E               ] ], # しぇ
    [ [         ], [ :NG_M, :NG_G, :NG_O      ], [ :KC_T, :KC_Y, :KC_E               ] ], # ちぇ
    [ [         ], [ :NG_J, :NG_R, :NG_O      ], [ :KC_Z, :KC_Y, :KC_E               ] ], # じぇ
    [ [         ], [ :NG_J, :NG_G, :NG_O      ], [ :KC_D, :KC_Y, :KC_E               ] ], # ぢぇ
    [ [         ], [ :NG_V, :NG_SCOLON, :NG_J ], [ :KC_F, :KC_A                      ] ], # ふぁ
    [ [         ], [ :NG_V, :NG_SCOLON, :NG_K ], [ :KC_F, :KC_I                      ] ], # ふぃ
    [ [         ], [ :NG_V, :NG_SCOLON, :NG_O ], [ :KC_F, :KC_E                      ] ], # ふぇ
    [ [         ], [ :NG_V, :NG_SCOLON, :NG_N ], [ :KC_F, :KC_O                      ] ], # ふぉ
    [ [         ], [ :NG_V, :NG_SCOLON, :NG_P ], [ :KC_F, :KC_Y, :KC_U               ] ], # ふゅ
    [ [         ], [ :NG_V, :NG_K, :NG_O      ], [ :KC_I, :KC_X, :KC_E               ] ], # いぇ
    [ [         ], [ :NG_V, :NG_L, :NG_K      ], [ :KC_W, :KC_I                      ] ], # うぃ
    [ [         ], [ :NG_V, :NG_L, :NG_O      ], [ :KC_W, :KC_E                      ] ], # うぇ
    [ [         ], [ :NG_V, :NG_L, :NG_N      ], [ :KC_U, :KC_X, :KC_O               ] ], # うぉ
    [ [         ], [ :NG_M, :NG_Q, :NG_J      ], [ :KC_V, :KC_A                      ] ], # ゔぁ
    [ [         ], [ :NG_M, :NG_Q, :NG_K      ], [ :KC_V, :KC_I                      ] ], # ゔぃ
    [ [         ], [ :NG_M, :NG_Q, :NG_O      ], [ :KC_V, :KC_E                      ] ], # ゔぇ
    [ [         ], [ :NG_M, :NG_Q, :NG_N      ], [ :KC_V, :KC_O                      ] ], # ゔぉ
    [ [         ], [ :NG_M, :NG_Q, :NG_P      ], [ :KC_V, :KC_U, :KC_X, :KC_Y, :KC_U ] ], # ゔゅ
    [ [         ], [ :NG_V, :NG_H, :NG_J      ], [ :KC_K, :KC_U, :KC_X, :KC_A        ] ], # くぁ
    [ [         ], [ :NG_V, :NG_H, :NG_K      ], [ :KC_K, :KC_U, :KC_X, :KC_I        ] ], # くぃ
    [ [         ], [ :NG_V, :NG_H, :NG_O      ], [ :KC_K, :KC_U, :KC_X, :KC_E        ] ], # くぇ
    [ [         ], [ :NG_V, :NG_H, :NG_N      ], [ :KC_K, :KC_U, :KC_X, :KC_O        ] ], # くぉ
    [ [         ], [ :NG_V, :NG_H, :NG_DOT    ], [ :KC_K, :KC_U, :KC_X, :KC_W, :KC_A ] ], # くゎ
    [ [         ], [ :NG_F, :NG_H, :NG_J      ], [ :KC_G, :KC_U, :KC_X, :KC_A        ] ], # ぐぁ
    [ [         ], [ :NG_F, :NG_H, :NG_K      ], [ :KC_G, :KC_U, :KC_X, :KC_I        ] ], # ぐぃ
    [ [         ], [ :NG_F, :NG_H, :NG_O      ], [ :KC_G, :KC_U, :KC_X, :KC_E        ] ], # ぐぇ
    [ [         ], [ :NG_F, :NG_H, :NG_N      ], [ :KC_G, :KC_U, :KC_X, :KC_O        ] ], # ぐぉ
    [ [         ], [ :NG_F, :NG_H, :NG_DOT    ], [ :KC_G, :KC_U, :KC_X, :KC_W, :KC_A ] ], # ぐゎ
    [ [         ], [ :NG_V, :NG_L, :NG_J      ], [ :KC_T, :KC_S, :KC_A               ] ], # つぁ

    [ [ :NG_J, :NG_K ], [ :NG_D ], [ :KC_QUES, :KC_ENTER ] ], # ？[改行]
    [ [ :NG_J, :NG_K ], [ :NG_C ], [ :KC_EXLM, :KC_ENTER ] ], # ！[改行]
  ].freeze

  NGSHIFT1 = [
    [:NG_SFT],
    [:NG_SFT2],
    [:NG_D, :NG_F],
    [:NG_C, :NG_V],
    [:NG_J, :NG_K],
    [:NG_M, :NG_COMMA]
  ].freeze

  NGSHIFT2 = [
    [:NG_D, :NG_F],
    [:NG_C, :NG_V],
    [:NG_J, :NG_K],
    [:NG_M, :NG_COMMA],
    [:NG_SFT],
    [:NG_SFT2],
    [:NG_F],
    [:NG_V],
    [:NG_J],
    [:NG_M]
  ].freeze

  HENSHU = [
    [:NG_D, :NG_F],
    [:NG_C, :NG_V],
    [:NG_J, :NG_K],
    [:NG_M, :NG_COMMA]
  ].freeze

  def initialize
    # @pressed_keys は重複を許さない配列として管理
    @pressed_keys = []
    @nginput = []  # 未変換のキー。例: [[:NG_M], [:NG_J, :NG_W]]（なぎ）のように同時押しの組み合わせを2次元配列で保持
  end

  def ng_press(kc)
    # Set#<< の代わりに、すでに含まれていなければ追加
    @pressed_keys.push(kc) unless @pressed_keys.include?(kc)

    if [:NG_SFT, :NG_SFT2].include?(kc)
      @nginput << [kc]
    # 前のキーとの同時押しの可能性があるなら前に足す
    elsif !@nginput.empty? and @nginput[-1][-1] != kc and number_of_candidates(@nginput[-1] + [kc]) > 0
      @nginput[-1] = @nginput[-1] + [kc]
    else
      @nginput << [kc]
    end

    NGSHIFT2.each do |rs|
      rskc = rs + @nginput[-1]
      # rs は配列になっているので、subset? は補助メソッドで判定
      if !rs.include?(kc) and subset?(rs, @pressed_keys) and number_of_matches(rskc) > 0
        @nginput[-1] = rskc
        break
      end
    end

    if @nginput.length > 1 or number_of_candidates(@nginput.first) == 1
      return ng_type(@nginput.shift)
    end

    return []
  end

  def ng_release(kc)
    # Set#subtract の代わりに delete で削除
    @pressed_keys.delete(kc)

    r = []
    # 全てのキーを離したらバッファを全て吐き出す
    if @pressed_keys.empty?
      while @nginput.length > 0
        r << ng_type(@nginput.shift)
      end
    else
      @nginput << []
      if @nginput.length > 1 or number_of_candidates(@nginput.first) == 1
        r << ng_type(@nginput.shift)
      end
    end

    return r.flatten
  end

  def ng_type(keys)
    return [] if keys.empty?

    if keys.length == 1 and keys[0] == :NG_SFT2
      return [:KC_ENTER]
    end

    # :NG_SFT2 を :NG_SFT に置換しつつ、配列を集合的に扱うために正規化（重複除去&ソート）する
    skc = normalize_and_sort(keys)
    NGDIC.each do |k|
      # k[0]とk[1]の和集合（配列同士の連結してuniq）と比較
      if array_set_equal?(skc, array_union(k[0], k[1]))
        return k[2]
      end
    end
    # 一致する候補がなければ、最後の1要素を分離して再帰的に変換する
    kl = keys.pop
    ng_type(keys) + ng_type([kl])
  end

  def number_of_matches(keys)
    return 0 if keys.empty?

    noc = 0

    if [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length == 1
      noc = 1
    elsif [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length > 1
      skc = (keys[1..-1]).uniq.sort
      NGDIC.each do |k|
        if k[0].include?(:NG_SFT) and array_set_equal?(skc, k[1])
          noc += 1
          break if noc > 1
        end
      end
    else
      f = true
      HENSHU.each do |rs|
        if keys.length == 3 and array_set_equal?(keys[0..1], rs)
          NGDIC.each do |k|
            if array_set_equal?([keys[2]], k[1])
              noc = 1
              f = false
              break
            end
          end
          break unless f
        end
      end
      if f
        skc = keys.uniq.sort
        NGDIC.each do |k|
          if k[0].empty? and array_set_equal?(skc, k[1])
            noc += 1
            break if noc > 1
          end
        end
      end
    end

    puts "NG num of matches #{noc}"
    return noc
  end

  def number_of_candidates(keys)
    return 0 if keys.empty?

    noc = 0

    if NGSHIFT1.any? { |s| array_set_equal?(s, keys) }
      noc = 2
    elsif [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length > 1
      skc = (keys[1..-1]).uniq.sort
      NGDIC.each do |k|
        if k[0].include?(:NG_SFT) and subset?(skc, k[1])
          noc += 1
          break if noc > 1
        end
      end
    else
      f = true
      HENSHU.each do |rs|
        if keys.length == 3 and array_set_equal?(keys[0..1], rs)
          NGDIC.each do |k|
            if array_set_equal?([keys[2]], k[1])
              noc = 1
              f = false
              break
            end
          end
          break unless f
        end
      end
      if f
        skc = keys.uniq.sort
        NGDIC.each do |k|
          if k[0].empty? and subset?(skc, k[1])
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

  private

  # 補助: 配列aとbの和集合（重複除去＆ソート）
  def array_union(a, b)
    (a + b).uniq.sort
  end

  # 補助: 配列を集合とみなし、等値かどうかを判定（順序は無視）
  def array_set_equal?(a, b)
    a.uniq.sort == b.uniq.sort
  end

  # 補助: 配列smallが配列bigの部分集合か判定
  def subset?(small, big)
    small.all? { |elem| big.include?(elem) }
  end

  # 補助: :NG_SFT2 を :NG_SFT に変換し、重複除去＆ソートして正規化
  def normalize_and_sort(keys)
    keys.map { |k| k == :NG_SFT2 ? :NG_SFT : k }.uniq.sort
  end

end
