open! Core
open Line_up_words

let test_line_up_words ~input ~expect =
  [%test_result: string list] (line_up_words input) ~expect
;;

let%test_unit _ =
  test_line_up_words
    ~input:[ "  | Foo of int"; "| Foooooo of string" ]
    ~expect:[ "| Foo     of int   "; "| Foooooo of string" ]
;;

let%test_unit _ =
  test_line_up_words
    ~input:
      [ "|                 Thing            of        bool"
      ; "  | Foo of int"
      ; ""
      ; "(* comments and blank lines should be ignored *)"
      ; "| Foooooo of string"
      ]
    ~expect:
      [ "| Thing   of bool  "
      ; "| Foo     of int   "
      ; ""
      ; "(* comments and blank lines should be ignored *)"
      ; "| Foooooo of string"
      ]
;;

let%test_unit _ =
  test_line_up_words
    ~input:[ "int : Int.t;"; "string : String.t;" ]
    ~expect:[ "int    : Int.t;   "; "string : String.t;" ]
;;

let%test_unit _ =
  test_line_up_words
    ~input:
      [ "foo.Bar.float <- 3.1415;"
      ; "barbaz.Qux.floatfloat <- 1.41;"
      ; "bangbangbang.Bang.foobar <- 2.7;"
      ]
    ~expect:
      [ "foo.Bar.float            <- 3.1415;"
      ; "barbaz.Qux.floatfloat    <- 1.41;  "
      ; "bangbangbang.Bang.foobar <- 2.7;   "
      ]
;;

let lines s = List.iter ~f:print_endline (line_up_words (String.split_lines s))

let%expect_test "don't insert new space after strings before commas" =
  lines
    {| [ "analyze", analyze_command
               ; "show",    show_command ] |};
  [%expect
    {|
    [ "analyze", analyze_command
    ; "show",    show_command ]
    |}]
;;

let%expect_test "strings get treated like symbols when binding to commas" =
  print_s
    [%sexp
      (Private.split_respecting_quotations {| [ "analyze", analyze_command |}
       : string list)];
  [%expect {| ("" [ "" "\"analyze\"," "" analyze_command "") |}];
  print_s
    [%sexp
      (Private.split_respecting_quotations {| [ analyze, analyze_command |} : string list)];
  [%expect {| ("" [ "" analyze, "" analyze_command "") |}]
;;

let%expect_test "don't insert new space after strings before semicolons" =
  lines
    {| f a b "c";
               f   b "c" "d"; |};
  [%expect
    {|
    f a b "c";
    f   b "c" "d";
    |}]
;;
