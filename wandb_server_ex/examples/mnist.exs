# # https://github.com/elixir-nx/axon/blob/efe1358a1566472af59a9bfed7eaa3e8423207fc/examples/vision/mnist.exs

Mix.install([
  {:wandb_server_ex, path: "../wandb_server_ex"},
  {:axon, "~> 0.5"},
  {:exla, "~> 0.5"},
  {:nx, "~> 0.5"},
  {:scidata, "~> 0.1"}
])

defmodule Mnist do
  require Axon

  @params %{
    "lr" => [0.1, 0.01, 0.001],
    "batch_size" => [16, 32, 64],
    "epochs" => [5, 10, 15]
  }

  def wandb_handler(%Axon.Loop.State{} = state) do
    out =
      for {name, metric} <- state.metrics, into: %{} do
        {name, metric |> Nx.to_number() |> Float.round(4)}
      end

    WandbServerEx.log(out, state.epoch)
    {:continue, state}
  end

  defp transform_images({bin, type, shape}, params) do
    bin
    |> Nx.from_binary(type)
    |> Nx.reshape({elem(shape, 0), 784})
    |> Nx.divide(255.0)
    |> Nx.to_batched(params[:batch_size])
    # Test split
    |> Enum.split(1750)
  end

  defp transform_labels({bin, type, _}, params) do
    bin
    |> Nx.from_binary(type)
    |> Nx.new_axis(-1)
    |> Nx.equal(Nx.tensor(Enum.to_list(0..9)))
    |> Nx.to_batched(params[:batch_size])
    # Test split
    |> Enum.split(1750)
  end

  defp build_model(input_shape) do
    Axon.input("input", shape: input_shape)
    |> Axon.dense(128, activation: :relu)
    |> Axon.dropout()
    |> Axon.dense(10, activation: :softmax)
  end

  defp train_model(model, train_images, train_labels, params) do
    model
    |> Axon.Loop.trainer(:categorical_cross_entropy, Axon.Optimizers.adamw(params[:lr]))
    |> Axon.Loop.metric(:accuracy, "Accuracy")
    |> Axon.Loop.handle_event(:epoch_completed, &wandb_handler/1)
    |> Axon.Loop.early_stop("Accuracy")
    |> Axon.Loop.run(Stream.zip(train_images, train_labels), %{},
      epochs: params[:epochs],
      compiler: EXLA
    )
  end

  defp test_model(model, model_state, test_images, test_labels) do
    model
    |> Axon.Loop.evaluator()
    |> Axon.Loop.metric(:accuracy, "Accuracy")
    |> Axon.Loop.run(Stream.zip(test_images, test_labels), model_state, compiler: EXLA)
  end

  def run(params) do
    {images, labels} = Scidata.MNIST.download()

    {train_images, test_images} = transform_images(images, params)
    {train_labels, test_labels} = transform_labels(labels, params)

    model = build_model({nil, 784}) |> IO.inspect()

    IO.write("\n\n Training Model \n\n")

    model_state =
      model
      |> train_model(train_images, train_labels, params)

    IO.write("\n\n Testing Model \n\n")

    model
    |> test_model(model_state, test_images, test_labels)

    IO.write("\n\n")
  end

  def grid_search() do
    WandbServerEx.grid_search(@params, &run/1, "mnisttest")
  end
end

Mnist.grid_search()
