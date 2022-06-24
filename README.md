# Credit Approval App

## Requirements and prerequisites

For a reproducible environment [asdf](https://asdf-vm.com/#/) should be installed.

```sh
# Install Erlang asdf plugin
asdf plugin-add erlang
# Install and use Erlang
asdf install erlang 25.0.1
asdf local erlang 25.0.1
# Install Elixir asdf plugin
asdf plugin-add elixir
# Install and use Elixir
asdf install elixir 1.13.4-otp-25
asdf local elixir 1.13.4-otp-25
# Install rebar and hex
mix local.rebar --force
mix local.hex --force

# Now let's run mix command to setup our app
mix setup
```

## Running the App

- To start your Phoenix server with `mix phx.server` or inside IEx with `iex -S mix phx.server`
- Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Tests

- Run tests with `mix test`
