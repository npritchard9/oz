open Core

let handle_weight_form req =
  match%lwt Dream.form req with
  | `Ok [ ("weight", weight) ] -> Dream.html @@ sprintf "Weight: %s" weight
  | _ -> Dream.html "failed form"

let handle_meal_form req =
  match%lwt Dream.form req with
  | `Ok
      [
        ("cals", cals);
        ("carbs", carbs);
        ("desc", desc);
        ("fats", fats);
        ("protein", protein);
      ] ->
      Dream.html
        (sprintf "cals: %s, desc: %s, protein: %s, carbs: %s, fats: %s" cals
           desc protein carbs fats)
  | `Expired (_, _) -> Dream.html "expired"
  | `Wrong_session _ -> Dream.html "wrong session"
  | `Invalid_token _ -> Dream.html "invalid token"
  | `Missing_token _ -> Dream.html "missing token"
  | `Many_tokens _ -> Dream.html "many tokens"
  | `Wrong_content_type -> Dream.html "wrong content type"
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
         Dream.post "/weight" (fun req -> handle_weight_form req);
         Dream.get "/meal" (fun req -> Dream.html (Meal.html_meal req));
         Dream.post "/meal" (fun req -> handle_meal_form req);
         Dream.get "/static/**" (Dream.static "static");
       ]
