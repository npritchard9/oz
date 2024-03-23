open Core

let handle_form req =
  match%lwt Dream.form req with
  | `Ok [ ("weight", weight) ] -> Dream.html @@ sprintf "Weight: %s" weight
  | _ -> Dream.html "failed form"

let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html "Hello");
         Dream.get "/echo/:word" (fun req ->
             Dream.html (Dream.param req "word"));
         Dream.get "/macros" (fun _ ->
             Dream.html (Float.to_string Oz.Macros.test_fn));
         Dream.get "/weight" (fun req -> Dream.html (Weight.html_weight req));
         Dream.post "/weight" (fun req -> handle_form req);
         Dream.get "/static/**" (Dream.static "static");
       ]
