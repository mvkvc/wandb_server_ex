defmodule WandbServerEx do
  alias Axon.Loop.State

  def wandb_handler(%State{} = state) do
    log(state.metrics)
  end

  def init(config, project, port \\ 5678, url \\ "http://127.0.0.1") do
    HTTPoison.post!(
      "#{url}:#{port}/wandb/init",
      Poison.encode!(%{"config" => config, "project" => project}),
      [{"Content-Type", "application/json"}]
    )
  end

  def log(metrics, step \\ nil, port \\ 5678, url \\ "http://127.0.0.1") do
    content = %{"metrics" => metrics}

    if step != nil do
      content = Map.put(content, "step", step)
    end

    HTTPoison.post!(
      "#{url}:#{port}/wandb/log",
      Poison.encode!(content),
      [{"Content-Type", "application/json"}]
    )
  end

  def finish(port \\ 5678, url \\ "http://127.0.0.1") do
    HTTPoison.post!(
      "#{url}:#{port}/wandb/finish",
      Poison.encode!(%{}),
      [{"Content-Type", "application/json"}]
    )
  end

  def fake_config do
    %{
      "batch_size" => :rand.uniform(32) + 32,
      "epochs" => :rand.uniform(15) + 5,
      "learning_rate" => :rand.uniform() * 0.001 + 0.001,
      "momentum" => :rand.uniform() * 0.1 + 0.9
    }
  end

  def fake_metrics do
    %{"loss" => :rand.uniform(), "accuracy" => :rand.uniform()}
  end
end
