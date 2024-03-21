open Core

let () =
  Dream.run @@ Dream.logger
  @@ Dream.router
       [
         Dream.get "/" (fun _ -> Dream.html "Hello");
         Dream.get "/echo/:word" (fun req ->
             Dream.html (Dream.param req "word"));
         Dream.get "/macros" (fun _ ->
             Dream.html (Float.to_string Oz.Macros.test_fn));
         Dream.get "/weight" (fun _ -> Dream.html Weight.html_weight);
         Dream.get "/static/**" (Dream.static "static");
       ]
