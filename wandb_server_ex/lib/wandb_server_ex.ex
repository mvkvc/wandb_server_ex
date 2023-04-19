defmodule WandbServerEx do
  def init(config, project, port \\ 5678, url \\ "http://127.0.0.1") do
    IO.puts("Initializing wandb run\n")

    HTTPoison.post!(
      "#{url}:#{port}/wandb/init",
      Poison.encode!(%{"config" => keys_to_strings(config), "project" => project}),
      [{"Content-Type", "application/json"}],
      timeout: :infinity
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
    IO.puts("Finishing wandb run\n")

    HTTPoison.post!(
      "#{url}:#{port}/wandb/finish",
      Poison.encode!(%{}),
      [{"Content-Type", "application/json"}],
      timeout: :infinity
    )
  end

  def grid_search(params, run_fn, project) do
    grid = generate_grid(params)

    Enum.map_with_index(grid, fn x, i ->
      IO.puts("Running grid item #{i + 1} of #{length(grid)}")
      WandbServerEx.init(x, project)
      run_fn.(x)
      WandbServerEx.finish()
    end)
  end

  def generate_grid(params \\ []) do
    Enum.reduce(params, [[]], fn {k, v}, acc ->
      Enum.flat_map(acc, fn x ->
        Enum.map(v, fn y -> [{String.to_atom(k), y} | x] end)
      end)
    end)
  end

  defp keys_to_strings(map) do
    Enum.into(map, %{}, fn {k, v} -> {to_string(k), v} end)
  end
end
