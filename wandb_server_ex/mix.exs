defmodule WandbServerEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :wandb_server_ex,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:poison, "~> 5.0"}
    ]
  end
end
