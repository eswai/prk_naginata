# 薙刀式のRuby実装

require 'set'

class Naginata

  NG_KEYCODE = %i[
    NG_Q      NG_W      NG_E      NG_R      NG_T      NG_Y      NG_U      NG_I      NG_O      NG_P     
    NG_A      NG_S      NG_D      NG_F      NG_G      NG_H      NG_J      NG_K      NG_L      NG_SCOLON
    NG_Z      NG_X      NG_C      NG_V      NG_B      NG_N      NG_M      NG_COMMA  NG_DOT    NG_SLASH 
    KC_SFT   KC_SFT2
  ].freeze()

  NGDIC = [
    #  前置シフト      同時押し                        かな
    # [ Set[ :NG_SFT ], [ :NG_T                    ], [ :KC_LSFT[:KC_LEFT]                ]],
    # [ Set[ :NG_SFT ], [ :NG_Y                    ], [ :KC_LSFT[:KC_RIGHT]               ]],
    [ Set.new       , Set[ :NG_U                    ], [ :KC_BSPACE                        ]],
    [ Set.new       , Set[ :NG_SFT                  ], [ :KC_SPACE                         ]],
    [ Set.new       , Set[ :NG_M, :NG_V             ], [ :KC_ENTER                         ]],
    [ Set.new       , Set[ :NG_T                    ], [ :KC_LEFT                          ]],
    [ Set.new       , Set[ :NG_Y                    ], [ :KC_RIGHT                         ]],
    [ Set.new       , Set[ :NG_SCOLON               ], [ :KC_MINUS                         ]], # ー
    [ Set[ :NG_SFT ], Set[ :NG_V                    ], [ :KC_COMMA, :KC_ENTER              ]], # 、[Enter]
    [ Set[ :NG_SFT ], Set[ :NG_M                    ], [ :KC_DOT, :KC_ENTER                ]], # 。[Enter]Set

    [ Set.new       , Set[ :NG_J                    ], [ :KC_A                             ]], # あ
    [ Set.new       , Set[ :NG_K                    ], [ :KC_I                             ]], # い
    [ Set.new       , Set[ :NG_L                    ], [ :KC_U                             ]], # う
    [ Set[ :NG_SFT ], Set[ :NG_O                    ], [ :KC_E                             ]], # え
    [ Set[ :NG_SFT ], Set[ :NG_N                    ], [ :KC_O                             ]], # お
    [ Set.new       , Set[ :NG_F                    ], [ :KC_K, :KC_A                      ]], # か
    [ Set.new       , Set[ :NG_W                    ], [ :KC_K, :KC_I                      ]], # き
    [ Set.new       , Set[ :NG_H                    ], [ :KC_K, :KC_U                      ]], # く
    [ Set.new       , Set[ :NG_S                    ], [ :KC_K, :KC_E                      ]], # け
    [ Set.new       , Set[ :NG_V                    ], [ :KC_K, :KC_O                      ]], # こ
    [ Set[ :NG_SFT ], Set[ :NG_U                    ], [ :KC_S, :KC_A                      ]], # さ
    [ Set.new       , Set[ :NG_R                    ], [ :KC_S, :KC_I                      ]], # し
    [ Set.new       , Set[ :NG_O                    ], [ :KC_S, :KC_U                      ]], # す
    [ Set[ :NG_SFT ], Set[ :NG_A                    ], [ :KC_S, :KC_E                      ]], # せ
    [ Set.new       , Set[ :NG_B                    ], [ :KC_S, :KC_O                      ]], # そ
    [ Set.new       , Set[ :NG_N                    ], [ :KC_T, :KC_A                      ]], # た
    [ Set[ :NG_SFT ], Set[ :NG_G                    ], [ :KC_T, :KC_I                      ]], # ち
    [ Set[ :NG_SFT ], Set[ :NG_L                    ], [ :KC_T, :KC_U                      ]], # つ
    [ Set.new       , Set[ :NG_E                    ], [ :KC_T, :KC_E                      ]], # て
    [ Set.new       , Set[ :NG_D                    ], [ :KC_T, :KC_O                      ]], # と
    [ Set.new       , Set[ :NG_M                    ], [ :KC_N, :KC_A                      ]], # な
    [ Set[ :NG_SFT ], Set[ :NG_D                    ], [ :KC_N, :KC_I                      ]], # に
    [ Set[ :NG_SFT ], Set[ :NG_W                    ], [ :KC_N, :KC_U                      ]], # ぬ
    [ Set[ :NG_SFT ], Set[ :NG_R                    ], [ :KC_N, :KC_E                      ]], # ね
    [ Set[ :NG_SFT ], Set[ :NG_J                    ], [ :KC_N, :KC_O                      ]], # の
    [ Set.new       , Set[ :NG_C                    ], [ :KC_H, :KC_A                      ]], # は
    [ Set.new       , Set[ :NG_X                    ], [ :KC_H, :KC_I                      ]], # ひ
    [ Set[ :NG_SFT ], Set[ :NG_X                    ], [ :KC_H, :KC_I                      ]], # ひ
    [ Set[ :NG_SFT ], Set[ :NG_SCOLON               ], [ :KC_H, :KC_U                      ]], # ふ
    [ Set.new       , Set[ :NG_P                    ], [ :KC_H, :KC_E                      ]], # へ
    [ Set.new       , Set[ :NG_Z                    ], [ :KC_H, :KC_O                      ]], # ほ
    [ Set[ :NG_SFT ], Set[ :NG_Z                    ], [ :KC_H, :KC_O                      ]], # ほ
    [ Set[ :NG_SFT ], Set[ :NG_F                    ], [ :KC_M, :KC_A                      ]], # ま
    [ Set[ :NG_SFT ], Set[ :NG_B                    ], [ :KC_M, :KC_I                      ]], # み
    [ Set[ :NG_SFT ], Set[ :NG_COMMA                ], [ :KC_M, :KC_U                      ]], # む
    [ Set[ :NG_SFT ], Set[ :NG_S                    ], [ :KC_M, :KC_E                      ]], # め
    [ Set[ :NG_SFT ], Set[ :NG_K                    ], [ :KC_M, :KC_O                      ]], # も
    [ Set[ :NG_SFT ], Set[ :NG_H                    ], [ :KC_Y, :KC_A                      ]], # や
    [ Set[ :NG_SFT ], Set[ :NG_P                    ], [ :KC_Y, :KC_U                      ]], # ゆ
    [ Set[ :NG_SFT ], Set[ :NG_I                    ], [ :KC_Y, :KC_O                      ]], # よ
    [ Set.new       , Set[ :NG_DOT                  ], [ :KC_R, :KC_A                      ]], # ら
    [ Set[ :NG_SFT ], Set[ :NG_E                    ], [ :KC_R, :KC_I                      ]], # り
    [ Set.new       , Set[ :NG_I                    ], [ :KC_R, :KC_U                      ]], # る
    [ Set.new       , Set[ :NG_SLASH                ], [ :KC_R, :KC_E                      ]], # れ
    [ Set[ :NG_SFT ], Set[ :NG_SLASH                ], [ :KC_R, :KC_E                      ]], # れ
    [ Set.new       , Set[ :NG_A                    ], [ :KC_R, :KC_O                      ]], # ろ
    [ Set[ :NG_SFT ], Set[ :NG_DOT                  ], [ :KC_W, :KC_A                      ]], # わ
    [ Set[ :NG_SFT ], Set[ :NG_C                    ], [ :KC_W, :KC_O                      ]], # を
    [ Set.new       , Set[ :NG_COMMA                ], [ :KC_N, :KC_N                      ]], # ん
    [ Set.new       , Set[ :NG_Q                    ], [ :KC_V, :KC_U                      ]], # ゔ
    [ Set[ :NG_SFT ], Set[ :NG_Q                    ], [ :KC_V, :KC_U                      ]], # ゔ
    [ Set.new       , Set[ :NG_J, :NG_F             ], [ :KC_G, :KC_A                      ]], # が
    [ Set.new       , Set[ :NG_J, :NG_W             ], [ :KC_G, :KC_I                      ]], # ぎ
    [ Set.new       , Set[ :NG_F, :NG_H             ], [ :KC_G, :KC_U                      ]], # ぐ
    [ Set.new       , Set[ :NG_J, :NG_S             ], [ :KC_G, :KC_E                      ]], # げ
    [ Set.new       , Set[ :NG_J, :NG_V             ], [ :KC_G, :KC_O                      ]], # ご
    [ Set.new       , Set[ :NG_F, :NG_U             ], [ :KC_Z, :KC_A                      ]], # ざ
    [ Set.new       , Set[ :NG_J, :NG_R             ], [ :KC_Z, :KC_I                      ]], # じ
    [ Set.new       , Set[ :NG_F, :NG_O             ], [ :KC_Z, :KC_U                      ]], # ず
    [ Set.new       , Set[ :NG_J, :NG_A             ], [ :KC_Z, :KC_E                      ]], # ぜ
    [ Set.new       , Set[ :NG_J, :NG_B             ], [ :KC_Z, :KC_O                      ]], # ぞ
    [ Set.new       , Set[ :NG_F, :NG_N             ], [ :KC_D, :KC_A                      ]], # だ
    [ Set.new       , Set[ :NG_J, :NG_G             ], [ :KC_D, :KC_I                      ]], # ぢ
    [ Set.new       , Set[ :NG_F, :NG_L             ], [ :KC_D, :KC_U                      ]], # づ
    [ Set.new       , Set[ :NG_J, :NG_E             ], [ :KC_D, :KC_E                      ]], # で
    [ Set.new       , Set[ :NG_J, :NG_D             ], [ :KC_D, :KC_O                      ]], # ど
    [ Set.new       , Set[ :NG_J, :NG_C             ], [ :KC_B, :KC_A                      ]], # ば
    [ Set.new       , Set[ :NG_J, :NG_X             ], [ :KC_B, :KC_I                      ]], # び
    [ Set.new       , Set[ :NG_F, :NG_SCOLON        ], [ :KC_B, :KC_U                      ]], # ぶ
    [ Set.new       , Set[ :NG_F, :NG_P             ], [ :KC_B, :KC_E                      ]], # べ
    [ Set.new       , Set[ :NG_J, :NG_Z             ], [ :KC_B, :KC_O                      ]], # ぼ
    [ Set.new       , Set[ :NG_F, :NG_L             ], [ :KC_V, :KC_U                      ]], # ゔ
    [ Set.new       , Set[ :NG_M, :NG_C             ], [ :KC_P, :KC_A                      ]], # ぱ
    [ Set.new       , Set[ :NG_M, :NG_X             ], [ :KC_P, :KC_I                      ]], # ぴ
    [ Set.new       , Set[ :NG_V, :NG_SCOLON        ], [ :KC_P, :KC_U                      ]], # ぷ
    [ Set.new       , Set[ :NG_V, :NG_P             ], [ :KC_P, :KC_E                      ]], # ぺ
    [ Set.new       , Set[ :NG_M, :NG_Z             ], [ :KC_P, :KC_O                      ]], # ぽ
    [ Set.new       , Set[ :NG_Q, :NG_H             ], [ :KC_X, :KC_Y, :KC_A               ]], # ゃ
    [ Set.new       , Set[ :NG_Q, :NG_P             ], [ :KC_X, :KC_Y, :KC_U               ]], # ゅ
    [ Set.new       , Set[ :NG_Q, :NG_I             ], [ :KC_X, :KC_Y, :KC_O               ]], # ょ
    [ Set.new       , Set[ :NG_Q, :NG_J             ], [ :KC_X, :KC_A                      ]], # ぁ
    [ Set.new       , Set[ :NG_Q, :NG_K             ], [ :KC_X, :KC_I                      ]], # ぃ
    [ Set.new       , Set[ :NG_Q, :NG_L             ], [ :KC_X, :KC_U                      ]], # ぅ
    [ Set.new       , Set[ :NG_Q, :NG_O             ], [ :KC_X, :KC_E                      ]], # ぇ
    [ Set.new       , Set[ :NG_Q, :NG_N             ], [ :KC_X, :KC_O                      ]], # ぉ
    [ Set.new       , Set[ :NG_Q, :NG_DOT           ], [ :KC_X, :KC_W, :KC_A               ]], # ゎ
    [ Set.new       , Set[ :NG_G                    ], [ :KC_X, :KC_T, :KC_U               ]], # っ
    [ Set.new       , Set[ :NG_Q, :NG_S             ], [ :KC_X, :KC_K, :KC_E               ]], # ヶ
    [ Set.new       , Set[ :NG_Q, :NG_F             ], [ :KC_X, :KC_K, :KC_A               ]], # ヵ
    [ Set.new       , Set[ :NG_R, :NG_H             ], [ :KC_S, :KC_Y, :KC_A               ]], # しゃ
    [ Set.new       , Set[ :NG_R, :NG_P             ], [ :KC_S, :KC_Y, :KC_U               ]], # しゅ
    [ Set.new       , Set[ :NG_R, :NG_I             ], [ :KC_S, :KC_Y, :KC_O               ]], # しょ
    [ Set.new       , Set[ :NG_J, :NG_R, :NG_H      ], [ :KC_Z, :KC_Y, :KC_A               ]], # じゃ
    [ Set.new       , Set[ :NG_J, :NG_R, :NG_P      ], [ :KC_Z, :KC_Y, :KC_U               ]], # じゅ
    [ Set.new       , Set[ :NG_J, :NG_R, :NG_I      ], [ :KC_Z, :KC_Y, :KC_O               ]], # じょ
    [ Set.new       , Set[ :NG_W, :NG_H             ], [ :KC_K, :KC_Y, :KC_A               ]], # きゃ
    [ Set.new       , Set[ :NG_W, :NG_P             ], [ :KC_K, :KC_Y, :KC_U               ]], # きゅ
    [ Set.new       , Set[ :NG_W, :NG_I             ], [ :KC_K, :KC_Y, :KC_O               ]], # きょ
    [ Set.new       , Set[ :NG_J, :NG_W, :NG_H      ], [ :KC_G, :KC_Y, :KC_A               ]], # ぎゃ
    [ Set.new       , Set[ :NG_J, :NG_W, :NG_P      ], [ :KC_G, :KC_Y, :KC_U               ]], # ぎゅ
    [ Set.new       , Set[ :NG_J, :NG_W, :NG_I      ], [ :KC_G, :KC_Y, :KC_O               ]], # ぎょ
    [ Set.new       , Set[ :NG_G, :NG_H             ], [ :KC_T, :KC_Y, :KC_A               ]], # ちゃ
    [ Set.new       , Set[ :NG_G, :NG_P             ], [ :KC_T, :KC_Y, :KC_U               ]], # ちゅ
    [ Set.new       , Set[ :NG_G, :NG_I             ], [ :KC_T, :KC_Y, :KC_O               ]], # ちょ
    [ Set.new       , Set[ :NG_J, :NG_G, :NG_H      ], [ :KC_D, :KC_Y, :KC_A               ]], # ぢゃ
    [ Set.new       , Set[ :NG_J, :NG_G, :NG_P      ], [ :KC_D, :KC_Y, :KC_U               ]], # ぢゅ
    [ Set.new       , Set[ :NG_J, :NG_G, :NG_I      ], [ :KC_D, :KC_Y, :KC_O               ]], # ぢょ
    [ Set.new       , Set[ :NG_D, :NG_H             ], [ :KC_N, :KC_Y, :KC_A               ]], # にゃ
    [ Set.new       , Set[ :NG_D, :NG_P             ], [ :KC_N, :KC_Y, :KC_U               ]], # にゅ
    [ Set.new       , Set[ :NG_D, :NG_I             ], [ :KC_N, :KC_Y, :KC_O               ]], # にょ
    [ Set.new       , Set[ :NG_X, :NG_H             ], [ :KC_H, :KC_Y, :KC_A               ]], # ひゃ
    [ Set.new       , Set[ :NG_X, :NG_P             ], [ :KC_H, :KC_Y, :KC_U               ]], # ひゅ
    [ Set.new       , Set[ :NG_X, :NG_I             ], [ :KC_H, :KC_Y, :KC_O               ]], # ひょ
    [ Set.new       , Set[ :NG_J, :NG_X, :NG_H      ], [ :KC_B, :KC_Y, :KC_A               ]], # びゃ
    [ Set.new       , Set[ :NG_J, :NG_X, :NG_P      ], [ :KC_B, :KC_Y, :KC_U               ]], # びゅ
    [ Set.new       , Set[ :NG_J, :NG_X, :NG_I      ], [ :KC_B, :KC_Y, :KC_O               ]], # びょ
    [ Set.new       , Set[ :NG_M, :NG_X, :NG_H      ], [ :KC_P, :KC_Y, :KC_A               ]], # ぴゃ
    [ Set.new       , Set[ :NG_M, :NG_X, :NG_P      ], [ :KC_P, :KC_Y, :KC_U               ]], # ぴゅ
    [ Set.new       , Set[ :NG_M, :NG_X, :NG_I      ], [ :KC_P, :KC_Y, :KC_O               ]], # ぴょ
    [ Set.new       , Set[ :NG_B, :NG_H             ], [ :KC_M, :KC_Y, :KC_A               ]], # みゃ
    [ Set.new       , Set[ :NG_B, :NG_P             ], [ :KC_M, :KC_Y, :KC_U               ]], # みゅ
    [ Set.new       , Set[ :NG_B, :NG_I             ], [ :KC_M, :KC_Y, :KC_O               ]], # みょ
    [ Set.new       , Set[ :NG_E, :NG_H             ], [ :KC_R, :KC_Y, :KC_A               ]], # りゃ
    [ Set.new       , Set[ :NG_E, :NG_P             ], [ :KC_R, :KC_Y, :KC_U               ]], # りゅ
    [ Set.new       , Set[ :NG_E, :NG_I             ], [ :KC_R, :KC_Y, :KC_O               ]], # りょ
    [ Set.new       , Set[ :NG_M, :NG_E, :NG_K      ], [ :KC_T, :KC_H, :KC_I               ]], # てぃ
    [ Set.new       , Set[ :NG_M, :NG_E, :NG_P      ], [ :KC_T, :KC_E, :KC_X, :KC_Y, :KC_U ]], # てゅ
    [ Set.new       , Set[ :NG_J, :NG_E, :NG_K      ], [ :KC_D, :KC_H, :KC_I               ]], # でぃ
    [ Set.new       , Set[ :NG_J, :NG_E, :NG_P      ], [ :KC_D, :KC_H, :KC_U               ]], # でゅ
    [ Set.new       , Set[ :NG_M, :NG_D, :NG_L      ], [ :KC_T, :KC_O, :KC_X, :KC_U        ]], # とぅ
    [ Set.new       , Set[ :NG_J, :NG_D, :NG_L      ], [ :KC_D, :KC_O, :KC_X, :KC_U        ]], # どぅ
    [ Set.new       , Set[ :NG_M, :NG_R, :NG_O      ], [ :KC_S, :KC_Y, :KC_E               ]], # しぇ
    [ Set.new       , Set[ :NG_M, :NG_G, :NG_O      ], [ :KC_T, :KC_Y, :KC_E               ]], # ちぇ
    [ Set.new       , Set[ :NG_J, :NG_R, :NG_O      ], [ :KC_Z, :KC_Y, :KC_E               ]], # じぇ
    [ Set.new       , Set[ :NG_J, :NG_G, :NG_O      ], [ :KC_D, :KC_Y, :KC_E               ]], # ぢぇ
    [ Set.new       , Set[ :NG_V, :NG_SCOLON, :NG_J ], [ :KC_F, :KC_A                      ]], # ふぁ
    [ Set.new       , Set[ :NG_V, :NG_SCOLON, :NG_K ], [ :KC_F, :KC_I                      ]], # ふぃ
    [ Set.new       , Set[ :NG_V, :NG_SCOLON, :NG_O ], [ :KC_F, :KC_E                      ]], # ふぇ
    [ Set.new       , Set[ :NG_V, :NG_SCOLON, :NG_N ], [ :KC_F, :KC_O                      ]], # ふぉ
    [ Set.new       , Set[ :NG_V, :NG_SCOLON, :NG_P ], [ :KC_F, :KC_Y, :KC_U               ]], # ふゅ
    [ Set.new       , Set[ :NG_V, :NG_K, :NG_O      ], [ :KC_I, :KC_X, :KC_E               ]], # いぇ
    [ Set.new       , Set[ :NG_V, :NG_L, :NG_K      ], [ :KC_W, :KC_I                      ]], # うぃ
    [ Set.new       , Set[ :NG_V, :NG_L, :NG_O      ], [ :KC_W, :KC_E                      ]], # うぇ
    [ Set.new       , Set[ :NG_V, :NG_L, :NG_N      ], [ :KC_U, :KC_X, :KC_O               ]], # うぉ
    [ Set.new       , Set[ :NG_M, :NG_Q, :NG_J      ], [ :KC_V, :KC_A                      ]], # ゔぁ
    [ Set.new       , Set[ :NG_M, :NG_Q, :NG_K      ], [ :KC_V, :KC_I                      ]], # ゔぃ
    [ Set.new       , Set[ :NG_M, :NG_Q, :NG_O      ], [ :KC_V, :KC_E                      ]], # ゔぇ
    [ Set.new       , Set[ :NG_M, :NG_Q, :NG_N      ], [ :KC_V, :KC_O                      ]], # ゔぉ
    [ Set.new       , Set[ :NG_M, :NG_Q, :NG_P      ], [ :KC_V, :KC_U, :KC_X, :KC_Y, :KC_U ]], # ゔゅ
    [ Set.new       , Set[ :NG_V, :NG_H, :NG_J      ], [ :KC_K, :KC_U, :KC_X, :KC_A        ]], # くぁ
    [ Set.new       , Set[ :NG_V, :NG_H, :NG_K      ], [ :KC_K, :KC_U, :KC_X, :KC_I        ]], # くぃ
    [ Set.new       , Set[ :NG_V, :NG_H, :NG_O      ], [ :KC_K, :KC_U, :KC_X, :KC_E        ]], # くぇ
    [ Set.new       , Set[ :NG_V, :NG_H, :NG_N      ], [ :KC_K, :KC_U, :KC_X, :KC_O        ]], # くぉ
    [ Set.new       , Set[ :NG_V, :NG_H, :NG_DOT    ], [ :KC_K, :KC_U, :KC_X, :KC_W, :KC_A ]], # くゎ
    [ Set.new       , Set[ :NG_F, :NG_H, :NG_J      ], [ :KC_G, :KC_U, :KC_X, :KC_A        ]], # ぐぁ
    [ Set.new       , Set[ :NG_F, :NG_H, :NG_K      ], [ :KC_G, :KC_U, :KC_X, :KC_I        ]], # ぐぃ
    [ Set.new       , Set[ :NG_F, :NG_H, :NG_O      ], [ :KC_G, :KC_U, :KC_X, :KC_E        ]], # ぐぇ
    [ Set.new       , Set[ :NG_F, :NG_H, :NG_N      ], [ :KC_G, :KC_U, :KC_X, :KC_O        ]], # ぐぉ
    [ Set.new       , Set[ :NG_F, :NG_H, :NG_DOT    ], [ :KC_G, :KC_U, :KC_X, :KC_W, :KC_A ]], # ぐゎ
    [ Set.new       , Set[ :NG_V, :NG_L, :NG_J      ], [ :KC_T, :KC_S, :KC_A               ]], # つぁ

    [Set[ :NG_J, :NG_K ], Set[ :NG_D    ], [ :KC_QUES, :KC_ENTER                       ]], # ？[改行]
    [Set[ :NG_J, :NG_K ], Set[ :NG_C    ], [ :KC_EXLM, :KC_ENTER                       ]], # ！[改行]
  ].freeze()

  NGSHIFT1 = [
    Set[:NG_SFT], Set[:NG_SFT2], Set[:NG_D, :NG_F], Set[:NG_C, :NG_V], Set[:NG_J, :NG_K], Set[:NG_M, :NG_COMMA]
  ].freeze()

  NGSHIFT2 = [
    Set[:NG_D, :NG_F], Set[:NG_C, :NG_V], Set[:NG_J, :NG_K], Set[:NG_M, :NG_COMMA],
    Set[:NG_SFT], Set[:NG_SFT2], Set[:NG_F], Set[:NG_V], Set[:NG_J], Set[:NG_M]
  ].freeze()

  HENSHU = [
    Set[:NG_D, :NG_F], Set[:NG_C, :NG_V], Set[:NG_J, :NG_K], Set[:NG_M, :NG_COMMA]
  ].freeze()

  def initialize
    @pressed_keys = Set.new
    @nginput = []  # 未変換のキー [[:NG_M], [:NG_J, :NG_W]] (なぎ)のように、同時押しの組み合わせを2次元配列へ格納
  end

  def ng_press(kc)
    @pressed_keys << kc

    # 後置シフトはしない
    if [:NG_SFT, :NG_SFT2].include?(kc)
      @nginput << [kc]
    # 前のキーとの同時押しの可能性があるなら前に足す
    # 同じキー連打を除外
    # V, H, EでVHがロールオーバーすると「こくて」=[[V,H], [E]]になる。「こりゃ」は[[V],[H,E]]。
    elsif @nginput.length > 0 and @nginput[-1][-1] != kc and number_of_candidates(@nginput[-1] + [kc]) > 0
      @nginput[-1] = @nginput[-1] + [kc]
    # 前のキーと同時押しはない
    else
      @nginput << [kc]
      # @pressed_keys.delete_if{|a| a == :NG_SFT}
    end

    # 連続シフトする
    # がある　がる x (JIの組み合わせがあるからJがC/Oされる) strictモードを作る
    # あいあう　あいう x
    # ぎょあう　ぎょう x
    # どか どが x 先にFがc/oされてJが残される
    NGSHIFT2.each do |rs|
      rskc = rs.to_a + @nginput[-1]
      # rskc.append(kc)
      # じょじょ よを先に押すと連続シフトしない x
      # Falseにすると、がる が　がある になる x
      if !rs.include?(kc) and rs.subset?(@pressed_keys) and number_of_matches(rskc) > 0
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
    @pressed_keys.subtract([kc])

    # 全部キーを離したらバッファを全部吐き出す
    r = []
    if @pressed_keys.length == 0
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

    skc = Set.new(keys.map{it == :NG_SFT2 ? :NG_SFT : it})
    NGDIC.each do |k|
      if skc == k[0] | k[1]
        return k[2]
      end
    end
    # JIみたいにJIを含む同時押しはたくさんあるが、JIのみの同時押しがないとき
    # 最後の１キーを別に分けて変換する
    kl = keys.pop()
    ng_type(keys) + ng_type([kl])
  end

  def number_of_matches(keys)
    return 0 if keys.empty?

    noc = 0

    # skc = set(map(lambda x: :NG_SFT if x == :NG_SFT2 else x, keys))
    if [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length == 1
      noc = 1
    elsif [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length > 1
      skc = Set.new(keys[1..-1])
      NGDIC.each do |k|
        if k[0].include?(:NG_SFT) and skc == k[1]
          noc += 1
          if noc > 1
            break
          end
        end
      end
    else
      f = true
      HENSHU.each do |rs|
        if keys.length == 3 and Set.new(keys[0..1]) == rs
          NGDIC.each do |k|
            if k[0] == rs and Set.new([keys[2]]) == k[1]
              noc = 1
              f = false
              break
            end
          end
          break unless f
        end
      end
      if f
        skc = Set.new(keys)
        NGDIC.each do |k|
          if k[0].empty? and skc == k[1]
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
    return 0 if keys.empty?

    noc = 0

    if NGSHIFT1.include?(Set.new(keys))
      noc = 2
    elsif [:NG_SFT, :NG_SFT2].include?(keys[0]) and keys.length > 1
      skc = Set.new(keys[1..-1])
      NGDIC.each do |k|
        if k[0].include?(:NG_SFT) and skc.subset?(k[1])  # <=だけ違う
          noc += 1
          if noc > 1
            break
          end
        end
      end
    else
      f = true
      HENSHU.each do |rs|
        if keys.length == 3 and Set.new(keys[0..1]) == rs
          NGDIC.each do |k|
            if k[0] == rs and Set.new([keys[2]]) == k[1]
              noc = 1
              f = false
              break
            end
          end
          break unless f
        end
      end
      if f
        skc = Set.new(keys)
        NGDIC.each do |k|
          if k[0].empty? and skc.subset?(k[1])  # <=だけ違う
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

end
