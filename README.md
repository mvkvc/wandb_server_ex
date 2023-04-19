# wandb_server_ex

Local W&B logging server along with client for Elixir.

Current MNIST example project at: https://wandb.ai/mvkvc/mnisttest?workspace=user-mvkvc.

## Usage

Run the server in the background (.env file expected to contain at least WANDB_ENTITY and WANDB_API_KEY):

```bash
docker run -it --rm --env-file .env --network host mvkvc/wandb_server:latest
```

Add the client to your project:

```elixir
  defp deps do
    [
        # ...
        {:wandb_server_ex, git: "https://github.com/mvkvc/wandb_server/elixir"}
    ]
  end
```

Add the following code to your Axon training code similar to the following:

```elixir
WandbServerEx.init(@config, "mnisttest")
# ...
def wandb_handler(%Axon.Loop.State{} = state) do
    WandbServerEx.log(state.metrics)
    {:continue, state}
end
# ...
defp train_model(model, train_images, train_labels, epochs) do
    model
    |> Axon.Loop.trainer(:categorical_cross_entropy, Axon.Optimizers.adamw(@config.lr))
    |> Axon.Loop.metric(:accuracy, "Accuracy")
    # !!!
    |> Axon.Loop.handle_event(:epoch_completed, &wandb_handler/1)
    # !!!
    |> Axon.Loop.run(Stream.zip(train_images, train_labels), %{}, epochs: epochs, compiler: EXLA)
end
# ...
WandbServerEx.finish()
```
