# wandb_server_ex

Local W&B logging server along with client for Elixir.

Current MNIST example project at: <https://wandb.ai/mvkvc/mnisttest?workspace=user-mvkvc>.

## Usage

Run the server in the background (.env file expected to contain at least WANDB_ENTITY and WANDB_API_KEY):

```bash
docker run -it --rm --env-file .env --network host mvkvc/wandb_server:latest
```

See the example file `examples/mnist.exs` for the example associated with the above project.
