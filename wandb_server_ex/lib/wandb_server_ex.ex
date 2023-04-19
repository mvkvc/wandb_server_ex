defmodule WandbServerEx do
  def init(config, project, port \\ 5678, url \\ "http://127.0.0.1") do
    IO.puts("Initializing wandb run\n")

    url = url <> ":" <> to_string(port) <> "/wandb/init"
    body = Poison.encode!(%{"config" => config, "project" => project})
    headers = [{"Content-Type", "application/json"}]

    HTTPoison.post!(url, body, headers, timeout: :infinity)
  end

  def log(metrics, step \\ nil, port \\ 5678, url \\ "http://127.0.0.1") do
    url = url <> ":" <> to_string(port) <> "/wandb/log"
    body = %{"metrics" => metrics}
    body = if step != nil, do: Map.put(out, "step", step), else: out
    body = Poison.encode!(body)
    headers = [{"Content-Type", "application/json"}]

    HTTPoison.post!(url, body, headers, timeout: :infinity)
  end

  def finish(port \\ 5678, url \\ "http://127.0.0.1") do
    IO.puts("Finishing wandb run\n")

    url = url <> ":" <> to_string(port) <> "/wandb/finish"
    body = Poison.encode!(%{})
    headers = [{"Content-Type", "application/json"}]

    HTTPoison.post!(url, body, headers, timeout: :infinity)
  end

  def grid_search(params, run_fn, project) do
    grid = generate_grid(params)

    grid
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
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
end
