jetstreams = Jetstream.from("sample")
acc = Simulation.run(7, Shapes.shapes(), jetstreams, 2022)
IO.inspect(acc.height, label: "Height ")
