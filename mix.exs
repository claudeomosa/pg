defmodule PG.MixProject do
  use Mix.Project

  def project do
    [
      app: :pg,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {PG.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:csv, "~> 3.0"},
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 5.0"}
    ]
  end
end
