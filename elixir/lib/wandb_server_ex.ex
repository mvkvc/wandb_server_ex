defmodule WandbServerEx do
  def init(config, project, port \\ 5678, url \\ "http://127.0.0.1") do
    HTTPoison.post!(
      "#{url}:#{port}/wandb/init",
      Poison.encode!(%{"config" => keys_to_strings(config), "project" => project}),
      [{"Content-Type", "application/json"}]
    )
  end

  def log(metrics, step \\ nil, port \\ 5678, url \\ "http://127.0.0.1") do
    out =
      if step != nil do
        %{"metrics" => metrics, "step" => step}
      else
        %{"metrics" => metrics}
      end

    HTTPoison.post!(
      "#{url}:#{port}/wandb/log",
      Poison.encode!(out),
      [{"Content-Type", "application/json"}],
      timeout: :infinity
    )
  end

  def finish(port \\ 5678, url \\ "http://127.0.0.1") do
    HTTPoison.post!(
      "#{url}:#{port}/wandb/finish",
      Poison.encode!(%{}),
      [{"Content-Type", "application/json"}],
      timeout: :infinity
    )
  end

  defp keys_to_strings(map) do
    Enum.into(map, %{}, fn {k, v} -> {to_string(k), v} end)
  end
end
