# elixir

In your training code include:

```elixir

WandbServerEx.init(config, project)

loop
|> Axon.Loop.handle_event(:iteration_completed, &WandbServerEx.log, every: 1)
|> Axon.Loop.run(data)

WandbServerEx.finish()
```
