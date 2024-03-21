open Core

module DateTime = struct
  type t = { date : Date.t; time : Time_float.t }

  let create date time = { date; time }

  let now () =
    {
      date =
        Date.today
          ~zone:
            (Time_float.Zone.of_utc_offset_explicit_name ~name:"EST" ~hours:(-5));
      time = Time_float.now ();
    }
end

module Weight = struct
  type t = { value : float; dt : DateTime.t }

  let create ?(dt = None) value =
    match dt with
    | Some dt -> { value; dt }
    | _ -> { value; dt = DateTime.now () }

  let to_string w =
    sprintf "%s @ %s: Weight: %f" (Date.to_string w.dt.date)
      (Time_float.to_string_utc w.dt.time)
      w.value
end

let weight_test = Weight.create 190.0 |> Weight.to_string
