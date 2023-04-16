# https://github.com/elixir-nx/axon/blob/efe1358a1566472af59a9bfed7eaa3e8423207fc/guides/training_and_evaluation/writing_custom_event_handlers.livemd

Mix.install([
  {:wandb_server_ex, path: ".."},
  {:axon, github: "elixir-nx/axon"},
  {:nx, "~> 0.3.0", github: "elixir-nx/nx", sparse: "nx", override: true}
])

import WandbServerEx

# TODO: Add model and optimizer params coming from config dict

model =
  Axon.input("data")
  |> Axon.dense(8)
  |> Axon.relu()
  |> Axon.dense(4)
  |> Axon.relu()
  |> Axon.dense(1)

loop =
  model
  |> Axon.Loop.trainer(:mean_squared_error, :sgd)
  |> Axon.Loop.handle_event(:epoch_completed, &wandb_handler/1)
  |> Axon.Loop.handle(:iteration_completed, &log_metrics/1, every: 50)

train_data =
  Stream.repeatedly(fn ->
    xs = Nx.random_normal({8, 1})
    ys = Nx.sin(xs)
    {xs, ys}
  end)

Axon.Loop.run(loop, train_data, %{}, epochs: 5, iterations: 100)
