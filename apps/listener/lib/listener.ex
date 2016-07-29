defmodule Listener do
  use Application

  def start(_type, _args) do
    Listener.Supervisor.start_link()
  end

end
