open! Core

let run () =
  let lines = In_channel.input_lines In_channel.stdin in
  let result_lines = Line_up_words.line_up_words lines in
  List.iter result_lines ~f:(printf "%s\n%!")
;;

let command =
  Command.basic
    ~summary:"Align words.  This implements line-up-words in Emacs."
    (Command.Param.return run)
;;

let () = Command_unix.run command
